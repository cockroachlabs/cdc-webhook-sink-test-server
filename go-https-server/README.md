# HTTPS Basic Test Server

Requires: Go

## Instructions

Run `server.sh` with an optional port number as the first argument. If no port is provided, `3000` will be used.

```
$ chmod +x ./server.sh
$ ./server.sh <port>
```

This will create a self-signed TLS certificate and key, and store them in the current directory. Then, it runs `server.go` (Go must be installed) and creates an HTTPS server using the certificate and key. Messages received by the HTTPS server will be printed to stdout.
