package main

import (
	"log"
	"net/http"
	"os"
	"sync"
)

func mustGetenv(key string) string {
	value := os.Getenv(key)
	if value == "" {
		log.Fatal("Environment variable " + key + " is not set")
	}
	return value
}

func main() {
	var wg sync.WaitGroup
	wg.Add(1)
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
		if state != os.Getenv("STATE_STRING") {
			http.Error(w, "Invalid state parameter", http.StatusBadRequest)
			return
		}
		resp, err := http.Post("https://todoist.com/oauth/access_token?client_id="+mustGetenv("CLIENT_ID")+"&client_secret="+mustGetenv("CLIENT_SECRET")+"&code="+code, "application/x-www-form-urlencoded", nil)
		if err != nil {
			http.Error(w, "Failed to get access token: "+err.Error(), http.StatusInternalServerError)
			return
		}
		if resp.StatusCode >= 400 {
			http.Error(w, "Failed to get access token: "+resp.Status, resp.StatusCode)
			return
		}

		w.Write([]byte("Webhooks initialized!"))
		wg.Done()
	})
	go http.ListenAndServe(":3055", nil)
	wg.Wait()
}
