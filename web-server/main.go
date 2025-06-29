package main

import (
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		code := r.URL.Query().Get("code")
		state := r.URL.Query().Get("state")
		if code == "" {
			http.Error(w, "Missing code parameter", http.StatusBadRequest)
			return
		}
		if state == "" {
			http.Error(w, "Missing state parameter", http.StatusBadRequest)
			return
		}
		// write the code and state to a file.

		w.Write([]byte("Success!"))
	})
	http.ListenAndServe(":3055", nil)
}
