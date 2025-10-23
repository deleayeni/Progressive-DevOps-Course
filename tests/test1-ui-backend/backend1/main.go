package main

import (
	"encoding/json" // For encoding data as JSON
	"fmt"
	"net/http"
	"os" // For reading environment variables
)

// A global variable used to store the counter value.
// Works for simple demos, but unsafe when accessed by multiple concurrent requests.
var counter int

// CounterResponse defines the JSON structure we send back to clients.
type CounterResponse struct {
	Value int `json:"value"`
}

func main() {
	// Handle GET /counter
	// This endpoint returns the current counter value as JSON.
	http.HandleFunc("/counter", func(w http.ResponseWriter, r *http.Request) {
		//Checks that the request method is GET (Go does not enforce this automatically)
		if r.Method != http.MethodGet {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
			return
		}

		// Tell the client that the response is JSON.
		w.Header().Set("Content-Type", "application/json")

		// Encode the current counter value as JSON and send it.
		json.NewEncoder(w).Encode(CounterResponse{Value: counter})
	})

	// Handle POST /counter/increment
	// This endpoint increments the counter and returns the new value.
	http.HandleFunc("/counter/increment", func(w http.ResponseWriter, r *http.Request) {
		// Only allow POST requests for this endpoint.
		if r.Method != http.MethodPost {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
			return
		}
		counter++
		// Send the updated value back as JSON.
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(CounterResponse{Value: counter})
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	
	fmt.Println("Server running on http://localhost:" + port)
	http.ListenAndServe(":"+port, nil)
}

// future : add thread safety