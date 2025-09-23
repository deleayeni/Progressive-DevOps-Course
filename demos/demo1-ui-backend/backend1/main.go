package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"sync"
)

// shared counter with thread-safety
var counter int
var mu sync.Mutex

// response struct for JSON
type CounterResponse struct {
	Value int `json:"value"`
}

func main() {
	mux := http.NewServeMux()

	// GET /counter
	mux.HandleFunc("/counter", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodGet {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
			return
		}

		mu.Lock()
		defer mu.Unlock()

		resp := CounterResponse{Value: counter}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(resp)
	})

	// POST /counter/increment
	mux.HandleFunc("/counter/increment", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
			return
		}

		mu.Lock()
		counter++
		resp := CounterResponse{Value: counter}
		mu.Unlock()

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(resp)
	})

	// port from env or default
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	fmt.Println("Server running on http://localhost:" + port)
	http.ListenAndServe(":"+port, mux)
}
