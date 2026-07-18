package internal_test

import (
	"os"
	"testing"

	"github.com/stretchr/testify/require"
	"neupaneanish.com.np/database/internal"
	"neupaneanish.com.np/database/tests"
)

func setupEnv(t *testing.T, postgres *tests.Database, name string) {
	t.Helper()
	os.Clearenv()
	t.Setenv("SERVICE", name)
	t.Setenv("DATABASE_HOST", postgres.Host)
	t.Setenv("DATABASE_NAME", name)
	t.Setenv("DATABASE_USER", "postgres")
	t.Setenv("DATABASE_PASSWORD", "postgres")
	t.Setenv("DATABASE_PORT", postgres.Port)
	t.Setenv("DATABASE_SSL", "False")
}

func TestNewService(t *testing.T) {
	databases := []string{internal.Authentication, internal.Portfolio}
	postgres, cleanup, postgresErr := tests.Postgres(databases)

	require.NoError(t, postgresErr)

	t.Run("Invalid URL Authentication", func(t *testing.T) {
		env := &internal.Env{
			Service: internal.Authentication,
			URL:     "postgres://localhost:5432/database",
		}
		err := internal.NewService(env)
		require.Error(t, err)
	})

	t.Run("Invalid URL portfolio", func(t *testing.T) {
		env := &internal.Env{
			Service: internal.Portfolio,
			URL:     "postgres://localhost:5432/database",
		}
		err := internal.NewService(env)
		require.Error(t, err)
	})

	t.Run("Empty Database Service", func(t *testing.T) {
		setupEnv(t, postgres, internal.Authentication)
		_ = os.Unsetenv("SERVICE")
		env, envErr := internal.LoadEnv()
		require.NoError(t, envErr)
		err := internal.NewService(env)
		require.Error(t, err)
	})

	t.Run("Authentication", func(t *testing.T) {
		setupEnv(t, postgres, internal.Authentication)
		env, envErr := internal.LoadEnv()
		require.NoError(t, envErr)
		err := internal.NewService(env)
		require.NoError(t, err)

		t.Run("Remigrate", func(t *testing.T) {
			re := internal.NewService(env)
			require.NoError(t, re)
		})
	})

	t.Run("Portfolio", func(t *testing.T) {
		setupEnv(t, postgres, internal.Portfolio)
		env, envErr := internal.LoadEnv()
		require.NoError(t, envErr)
		err := internal.NewService(env)
		require.NoError(t, err)

		t.Run("Remigrate", func(t *testing.T) {
			re := internal.NewService(env)
			require.NoError(t, re)
		})
	})

	t.Cleanup(func() {
		cleanup()
	})
}
