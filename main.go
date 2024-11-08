package main

import (
	"fmt"
	"log"
	"net/http"

	cowsay "github.com/Code-Hex/Neo-cowsay/v2"
)

func handleCowsay(w http.ResponseWriter, r *http.Request) {
	// Get message from query parameter, default to "Hello!"
	message := r.URL.Query().Get("message")
	if message == "" {
		message = "Hello World!"
	}

	// Create a new cow
	cow, err := cowsay.Say(
		message,
		cowsay.Random(),
	)
	if err != nil {
		http.Error(w, "Error generating cowsay", http.StatusInternalServerError)
		return
	}

	// Set content type to plain text
	w.Header().Set("Content-Type", "text/plain")
	fmt.Fprint(w, cow)
}

func main() {
	// Register handler for /cowsay endpoint
	http.HandleFunc("/cowsay", handleCowsay)

	// Start server
	fmt.Println("Server starting on :8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}
