// This is the entry point for any Go program.
// Go programs are organized in packages. The "main" package is special — it tells Go to build an executable program (not a library)
package main

// - "fmt" is used for formatted I/O (printing to terminal or writing to response).
// - "net/http" is the standard HTTP server and client implementation.
import (
	"fmt"
	"net/http"
)

func main() {
	// http.HandleFunc registers a function to handle requests to the given route ("/").
	// You're passing a function (a closure) as an argument — functions are first-class citizens in Go.
	// This handler will run every time someone visits http://localhost:8080/
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// 'w' is an http.ResponseWriter — an interface that lets you write an HTTP response.
		// 'r' is a pointer to an http.Request — it contains all the details of the incoming request (headers, method, URL, etc.)
		fmt.Fprintln(w, "Hello, world!")
	})

	// http.ListenAndServe starts the HTTP server on port 8080.
	// The second argument (nil) means we’re using the default multiplexer (mux) to route requests.

	// This function returns an error if the server fails to start, which should be handled in real apps.
	// Learn: Go doesn't use exceptions — errors are values and should be checked explicitly.
	fmt.Println("Server running on http://localhost:8080")
	http.ListenAndServe(":8080", nil)
}
