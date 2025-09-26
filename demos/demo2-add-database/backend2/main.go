package main

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"os"

	"github.com/jackc/pgx/v5"
	"github.com/joho/godotenv"
)

var db *pgx.Conn // global DB connection

type CounterResponse struct {
	Value int `json:"value"`
}

func main() {
	// Load env
	godotenv.Load("../../../.env")
	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		fmt.Println("❌ DATABASE_URL not set")
		os.Exit(1)
	}

	// Connect to Postgres
	var err error
	db, err = pgx.Connect(context.Background(), dbURL)
	if err != nil {
		fmt.Println("❌ Unable to connect to database:", err)
		os.Exit(1)
	}
	defer db.Close(context.Background())
	fmt.Println("✅ Connected to Postgres")

	// Ensure there’s at least one row in counters
	_, err = db.Exec(context.Background(),
		`INSERT INTO counters (id, value) VALUES (1, 0)
		 ON CONFLICT (id) DO NOTHING;`)
	if err != nil {
		fmt.Println("❌ Failed to initialize counters table:", err)
		os.Exit(1)
	}

	// Router
	mux := http.NewServeMux()

	// GET /counter
	mux.HandleFunc("/counter", func(w http.ResponseWriter, r *http.Request) {
		var value int
		err := db.QueryRow(context.Background(),
			"SELECT value FROM counters WHERE id=1").Scan(&value)
		if err != nil {
			http.Error(w, "DB query failed: "+err.Error(), http.StatusInternalServerError)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(CounterResponse{Value: value})
	})

	// POST /counter/increment
	mux.HandleFunc("/counter/increment", func(w http.ResponseWriter, r *http.Request) {
		var value int
		err := db.QueryRow(context.Background(),
			"UPDATE counters SET value = value + 1 WHERE id=1 RETURNING value").Scan(&value)
		if err != nil {
			http.Error(w, "DB update failed: "+err.Error(), http.StatusInternalServerError)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(CounterResponse{Value: value})
	})

	// Port
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	fmt.Println("🚀 Server running on http://localhost:" + port)
	http.ListenAndServe(":"+port, mux)
}
