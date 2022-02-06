package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
)

func main() {
	port := flag.Int("port", 8080, "port")
	flag.Parse()
	if flag.NArg() != 1 {
		log.Fatalf("Usage: fs [--port=8080] /path")
	}
	path := flag.Arg(0)
	log.Printf("Serving %s on port %d", path, *port)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", *port), http.FileServer(http.Dir(path))))
}
