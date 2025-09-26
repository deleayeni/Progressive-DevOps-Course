package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	// Create a new HTTP multiplexer (router)
	mux := http.NewServeMux()

	// Health check endpoint
	mux.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)      // respond with HTTP 200
		fmt.Fprintln(w, "ok")             // respond body
	})

	// Get port from environment variable, fallback to 8080
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Log startup info
	fmt.Println("Server running on http://localhost:" + port)

	// Start the server with the mux
	err := http.ListenAndServe(":"+port, mux)
	if err != nil {
		fmt.Println("Error starting server:", err)
	}
}
