package internal

import (
	"embed"
	"errors"
	"fmt"

	"github.com/golang-migrate/migrate/v4"
	// Migration driver.
	_ "github.com/golang-migrate/migrate/v4/database/postgres"
	"github.com/golang-migrate/migrate/v4/source/iofs"
)

func runMigrations(url string, fs embed.FS) error {
	d, iErr := iofs.New(fs, ".")
	if iErr != nil {
		return fmt.Errorf("failed to create iofs driver: %w", iErr)
	}

	m, mErr := migrate.NewWithSourceInstance("iofs", d, url)
	if mErr != nil {
		return fmt.Errorf("failed to initialize migrate: %w", mErr)
	}
	if uErr := m.Up(); uErr != nil {
		if errors.Is(uErr, migrate.ErrNoChange) {
			return nil
		}
		return fmt.Errorf("migrations failed: %w", uErr)
	}

	return nil
}
