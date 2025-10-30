package main

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/jackc/pgx/v5"
)

func TestBackendToDatabaseIntegration(t *testing.T) {
    // 1. Connect to database (already running from docker-compose)
    dsn := "postgres://postgres:secret@localhost:5433/appdb?sslmode=disable"
    testDB, err := pgx.Connect(context.Background(), dsn)
    if err != nil {
        t.Skip("Database not running, skipping integration test")
    }
    
    // 2. Set global db variable (handlers use this!)
    db = testDB
    defer db.Close(context.Background())
    
    // 3. Reset counter to 0 in database
    testDB.Exec(context.Background(), 
        "INSERT INTO counters (id, value) VALUES (1, 0) ON CONFLICT (id) DO UPDATE SET value = 0")
    
    // 4. Call increment handler
    req, _ := http.NewRequest("POST", "/counter/increment", nil)
    rr := httptest.NewRecorder()
    incrementCounterHandler(rr, req)  // This writes to database!
    
    // 5. Read directly from database to verify
    var dbValue int
    testDB.QueryRow(context.Background(), 
        "SELECT value FROM counters WHERE id=1").Scan(&dbValue)
    
    // 6. Assert: Database should show 1
    if dbValue != 1 {
        t.Errorf("Expected database value 1, got %d", dbValue)
    }
}