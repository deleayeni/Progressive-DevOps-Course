package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
)

// Test GET /counter endpoint
func TestGetCounterHandler(t *testing.T) {
    // Arrange: Reset counter and create GET request
    counter = 5 // Set initial value
    req, err := http.NewRequest("GET", "/counter", nil)
    if err != nil {
        t.Fatal(err)
    }
    
    rr := httptest.NewRecorder()
    
    // Act: Call the actual handler function
    getCounterHandler(rr, req)
    
    // Assert: Check response
    if rr.Code != http.StatusOK {
        t.Errorf("Expected status 200, got %d", rr.Code)
    }
    
    // Check content type
    if rr.Header().Get("Content-Type") != "application/json" {
        t.Errorf("Expected content type 'application/json'")
    }
    
    // Check JSON response
    var response CounterResponse
    err = json.NewDecoder(rr.Body).Decode(&response)
    if err != nil {
        t.Fatalf("Failed to decode response: %v", err)
    }
    
    if response.Value != 5 {
        t.Errorf("Expected counter value 5, got %d", response.Value)
    }
}

// Test POST /counter/increment endpoint
func TestIncrementCounterHandler(t *testing.T) {
    // Arrange: Reset counter
    counter = 10
    req, err := http.NewRequest("POST", "/counter/increment", nil)
    if err != nil {
        t.Fatal(err)
    }
    
    rr := httptest.NewRecorder()
    
    // Act: Call the actual handler function
    incrementCounterHandler(rr, req)
    
    // Assert
    if rr.Code != http.StatusOK {
        t.Errorf("Expected status 200, got %d", rr.Code)
    }
    
    var response CounterResponse
    json.NewDecoder(rr.Body).Decode(&response)
    
    if response.Value != 11 {
        t.Errorf("Expected counter value 11, got %d", response.Value)
    }
}

// Test method validation
func TestGetCounterHandlerWrongMethod(t *testing.T) {
    counter = 0
    req, err := http.NewRequest("POST", "/counter", nil) // Wrong method
    if err != nil {
        t.Fatal(err)
    }
    
    rr := httptest.NewRecorder()
    
    // Act: Call the actual handler function with wrong method
    getCounterHandler(rr, req)
    
    if rr.Code != http.StatusMethodNotAllowed {
        t.Errorf("Expected status 405, got %d", rr.Code)
    }
}