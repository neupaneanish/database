package internal

import (
	"fmt"
	"net"
	"net/url"
	"os"
	"strconv"
	"strings"
)

const (
	Authentication = "authentication"
	Portfolio      = "portfolio"
)

type Env struct {
	Service string
	URL     string
}

func LoadEnv() (*Env, error) {
	dbURL, dbURLErr := newDatabaseURL()
	if dbURLErr != nil {
		return nil, dbURLErr
	}
	service := os.Getenv("SERVICE")
	return &Env{
		Service: service,
		URL:     dbURL,
	}, nil
}

func validateEnv(key string) (string, error) {
	env := os.Getenv(key)
	value := strings.TrimSpace(env)
	if value == "" {
		return "", fmt.Errorf("%s is missing", key)
	}
	return value, nil
}

func validateDefaultEnv(key string, def string) string {
	env := os.Getenv(key)
	value := strings.TrimSpace(env)
	if value == "" {
		return def
	}
	return value
}

func validatePort(key, def string) (string, error) {
	port := validateDefaultEnv(key, def)
	value, valueErr := strconv.Atoi(port)
	if valueErr != nil || value < 80 || value > 65535 {
		return "", fmt.Errorf("%s must be between 80  and 65535", key)
	}
	return port, nil
}

func validateBoolEnv(key string, def bool) bool {
	env := os.Getenv(key)
	value := strings.TrimSpace(env)
	if value == "" {
		return def
	}
	val, err := strconv.ParseBool(value)
	if err != nil {
		return def
	}
	return val
}

func newDatabaseURL() (string, error) {
	databaseHost, databaseHostErr := validateEnv("DATABASE_HOST")
	if databaseHostErr != nil {
		return "", databaseHostErr
	}

	databaseName, databaseErr := validateEnv("DATABASE_NAME")
	if databaseErr != nil {
		return "", databaseErr
	}

	databaseUser, databaseUsernameErr := validateEnv("DATABASE_USER")
	if databaseUsernameErr != nil {
		return "", databaseUsernameErr
	}

	databasePassword, databasePasswordErr := validateEnv("DATABASE_PASSWORD")
	if databasePasswordErr != nil {
		return "", databasePasswordErr
	}

	databasePort, databasePortErr := validatePort("DATABASE_PORT", "5432")
	if databasePortErr != nil {
		return "", databasePortErr
	}

	databaseSSL := validateBoolEnv("DATABASE_SSL", true)
	sslMode := "require"
	if !databaseSSL {
		sslMode = "disable"
	}

	hostPort := net.JoinHostPort(databaseHost, databasePort)

	dbURL := url.URL{
		Scheme:   "postgres",
		User:     url.UserPassword(databaseUser, databasePassword),
		Host:     hostPort,
		Path:     databaseName,
		RawQuery: "sslmode=" + sslMode,
	}

	return dbURL.String(), nil
}
