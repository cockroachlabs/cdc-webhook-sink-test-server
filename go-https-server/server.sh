#!/bin/bash

rm -f key.pem cert.pem
yes | openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -subj '/CN=localhost'

if [[ $# -ge 1 ]]; then
    go run server.go $1
else
    go run server.go
fi
