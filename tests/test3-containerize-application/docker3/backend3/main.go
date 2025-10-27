package main

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"os"

	"github.com/jackc/pgx/v5"
	"github.com/joho/godotenv"
)

// CounterResponse defines the JSON structure returned to clients.
// Example response: { "value": 5 }
type CounterResponse struct {
	Value int `json:"value"`
}

// db is our global database connection.
// In production you’d usually use a connection pool, but here a single
// connection is enough for learning purposes.
var db *pgx.Conn

func main() {
	// 1. Load environment variables from .env file (for local dev).
	// Example .env:
	// DATABASE_URL=postgres://postgres:secret@localhost:5432/appdb?sslmode=disable
	// PORT=8080
	if err := godotenv.Load("../../../.env"); err != nil {
		log.Println("No .env file found, falling back to system environment variables")
	}

	// 2. Read database connection string from environment.
	dsn := os.Getenv("DATABASE_URL")
	if dsn == "" {
		log.Fatal("❌ DATABASE_URL environment variable not set")
	}

	// 3. Connect to Postgres using pgx.
	var err error
	db, err = pgx.Connect(context.Background(), dsn)
	if err != nil {
		log.Fatalf("Unable to connect to database: %v\n", err)
	}
	defer db.Close(context.Background())
	log.Println("Connected to Postgres")

	// 4. Create the counters table if it doesn't exist
	_, err = db.Exec(context.Background(),
		`CREATE TABLE IF NOT EXISTS counters (
			id INTEGER PRIMARY KEY,
			value INTEGER NOT NULL
		)`)
	if err != nil {
		log.Fatalf("Failed to create counters table: %v\n", err)
	}

	// 5. Ensure the counters table has at least one row with id=1.
	// This way our GET/POST endpoints always have something to work with.
	_, err = db.Exec(context.Background(),
		`INSERT INTO counters (id, value) VALUES (1, 0)
		 ON CONFLICT (id) DO NOTHING;`)
	if err != nil {
		log.Fatalf("Failed to initialize counters table: %v\n", err)
	}

	// 5. Register HTTP routes.
	http.HandleFunc("/counter", getCounterHandler)
	http.HandleFunc("/counter/increment", incrementCounterHandler)

	// 6. Read server port from environment (default: 8080).
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// 7. Start the HTTP server.
	log.Printf("Server running at http://localhost:%s\n", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}

// getCounterHandler handles GET /counter.
// It queries the database and returns the current counter value as JSON.
func getCounterHandler(w http.ResponseWriter, r *http.Request) {
    // Add CORS headers
    w.Header().Set("Access-Control-Allow-Origin", "*")
    w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
    w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
    
    if r.Method == http.MethodOptions {
        return // Handle preflight requests
    }
    
    if r.Method != http.MethodGet {
        http.Error(w, "Method not allowed, use GET", http.StatusMethodNotAllowed)
        return
    }

    var value int
    err := db.QueryRow(context.Background(),
        "SELECT value FROM counters WHERE id=1").Scan(&value)
    if err != nil {
        http.Error(w, "DB query failed: "+err.Error(), http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(CounterResponse{Value: value})
}

func incrementCounterHandler(w http.ResponseWriter, r *http.Request) {
    // Add CORS headers
    w.Header().Set("Access-Control-Allow-Origin", "*")
    w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
    w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
    
    if r.Method == http.MethodOptions {
        return // Handle preflight requests
    }
    
    if r.Method != http.MethodPost {
        http.Error(w, "Method not allowed, use POST", http.StatusMethodNotAllowed)
        return
    }

    var value int
    err := db.QueryRow(context.Background(),
        "UPDATE counters SET value = value + 1 WHERE id=1 RETURNING value").Scan(&value)
    if err != nil {
        http.Error(w, "DB update failed: "+err.Error(), http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(CounterResponse{Value: value})
}
