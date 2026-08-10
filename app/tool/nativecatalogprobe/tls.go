package main

import "crypto/tls"

type tlsConfig struct {
	serverName string
}

func (c tlsConfig) config() *tls.Config {
	return &tls.Config{MinVersion: tls.VersionTLS12, ServerName: c.serverName}
}
