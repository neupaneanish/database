package main

import (
	"log/slog"
	"os"

	"neupaneanish.com.np/database/internal"
)

func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
	env, envErr := internal.LoadEnv()
	if envErr != nil {
		logger.Error("ENVIRONMENT", "error", envErr)
		os.Exit(1)
	}
	if err := internal.NewService(env); err != nil {
		logger.Error("SERVICE", "error", err)
	}
}
