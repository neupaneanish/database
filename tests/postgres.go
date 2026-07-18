package tests

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/testcontainers/testcontainers-go"
	"github.com/testcontainers/testcontainers-go/modules/postgres"
	"github.com/testcontainers/testcontainers-go/wait"
)

const (
	pgContextTimeout = 60 * time.Second
	occurrence       = 2
)

type Database struct {
	Host string
	Port string
}

func Postgres(dbNames []string) (*Database, func(), error) {
	ctx, cancel := context.WithTimeout(context.Background(), pgContextTimeout)
	container, err := postgres.Run(
		ctx,
		"postgres:18-alpine3.23",
		postgres.WithDatabase("postgres"),
		postgres.WithUsername("postgres"),
		postgres.WithPassword("postgres"),
		testcontainers.WithWaitStrategy(
			wait.ForLog("database system is ready to accept connections").
				WithOccurrence(occurrence).
				WithStartupTimeout(pgContextTimeout),
		),
	)
	if err != nil {
		cancel()
		return nil, nil, err
	}

	if container == nil {
		cancel()
		return nil, nil, errors.New("no container without error")
	}

	for _, dbName := range dbNames {
		cmd := []string{"psql", "-U", "postgres", "-c", fmt.Sprintf("CREATE DATABASE %s;", dbName)}
		exec, _, execErr := container.Exec(ctx, cmd)
		if execErr != nil {
			cancel()
			return nil, nil, execErr
		}
		if exec != 0 {
			cancel()
			return nil, nil, fmt.Errorf("database command for %s exited with code %d", dbName, exec)
		}
	}

	host, hostErr := container.Host(ctx)
	if hostErr != nil {
		cancel()
		return nil, nil, hostErr
	}

	port, portErr := container.MappedPort(ctx, "5432/tcp")
	if portErr != nil {
		cancel()
		return nil, nil, portErr
	}

	cleanup := func() {
		shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), pgContextTimeout)
		defer shutdownCancel()
		_ = container.Terminate(shutdownCtx)
		cancel()
	}

	return &Database{
		Host: host,
		Port: port.Port(),
	}, cleanup, nil
}
