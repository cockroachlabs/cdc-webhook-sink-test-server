package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strconv"
)

const (
	CertPath string = "cert.pem"
	KeyPath  string = "key.pem"
)

func main() {
	port := 3000
	if len(os.Args) >= 2 {
		var err error
		port, err = strconv.Atoi(os.Args[1])
		if err != nil {
			panic(err)
		}
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		b, err := ioutil.ReadAll(r.Body)
		if err != nil {
			panic(err)
		}
		log.Printf("%s", b)
	})
	log.Printf("starting server on port %d", port)
	log.Fatal(http.ListenAndServeTLS(fmt.Sprintf(":%d", port), CertPath, KeyPath, nil))
}
