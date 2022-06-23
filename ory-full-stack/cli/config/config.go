package config

import "github.com/kelseyhightower/envconfig"

// CLIConfig stores configuration of the CLI command
type CLIConfig struct {
	DiscoveryURL string `envconfig:"DISCOVERY_URL" default:"http://127.0.0.1:4444/.well-known/openid-configuration"`
	ClientID     string `envconfig:"CLIENT_ID" default:"uJOuTEhECdJyjOUdPGCeekMgYLT90r5C"`
	ClientSecret string `envconfig:"CLIENT_SECRET" default:"6aFJ9sxajhNneXfa-U4hwEmzxE"`
	APIURL       string `envconfig:"API_URL" default:"http://127.0.0.1:5001/api/v1"`
	SkipTLS      bool   `envconfig:"SKIP_TLS" default:"true"`
}

// Parse parses environment variables and returns
// the CLIConfig
func Parse() (*CLIConfig, error) {
	var c CLIConfig
	err := envconfig.Process("", &c)
	return &c, err
}
