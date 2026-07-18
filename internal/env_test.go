package internal_test

import (
	"crypto/rand"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"neupaneanish.com.np/database/internal"
)

func TestLoadEnv(t *testing.T) {

	t.Run("Success", func(t *testing.T) {
		os.Clearenv()
		t.Setenv("DATABASE_HOST", "127.0.0.1")
		t.Setenv("DATABASE_NAME", "postgres")
		t.Setenv("DATABASE_USER", "postgres")
		t.Setenv("DATABASE_PASSWORD", "postgres")

		env, envErr := internal.LoadEnv()
		require.NoError(t, envErr)
		assert.NotNil(t, env)
	})

	t.Run("Default Environment", func(t *testing.T) {
		os.Clearenv()
		t.Setenv("DATABASE_HOST", "127.0.0.1")
		t.Setenv("DATABASE_NAME", "postgres")
		t.Setenv("DATABASE_USER", "postgres")
		t.Setenv("DATABASE_PASSWORD", "postgres")

		t.Run("Invalid Database PORT", func(t *testing.T) {
			t.Setenv("DATABASE_PORT", "79")
			pEnv, pEnvErr := internal.LoadEnv()
			require.Error(t, pEnvErr)
			assert.Nil(t, pEnv)
		})

		t.Run("Invalid Database PORT Number", func(t *testing.T) {
			t.Setenv("DATABASE_PORT", "ABCD")
			pEnv, pEnvErr := internal.LoadEnv()
			require.Error(t, pEnvErr)
			assert.Nil(t, pEnv)
		})

		t.Run("Database SSL False", func(t *testing.T) {
			t.Setenv("DATABASE_SSL", "False")
			pEnv, pEnvErr := internal.LoadEnv()
			require.NoError(t, pEnvErr)
			assert.NotNil(t, pEnv)
		})

		t.Run("Database SSL Invalid", func(t *testing.T) {
			t.Setenv("DATABASE_SSL", "ABCD")
			pEnv, pEnvErr := internal.LoadEnv()
			require.NoError(t, pEnvErr)
			assert.NotNil(t, pEnv)
		})
	})

	t.Run("Missing Required Environment", func(t *testing.T) {
		os.Clearenv()

		requiredVariables := []string{
			"DATABASE_HOST",
			"DATABASE_NAME",
			"DATABASE_USER",
			"DATABASE_PASSWORD",
		}

		for _, v := range requiredVariables {
			t.Run("Missing "+v, func(t *testing.T) {
				for _, all := range requiredVariables {
					t.Setenv(all, rand.Text())
				}

				_ = os.Unsetenv(v)

				env, err := internal.LoadEnv()
				require.Error(t, err)
				assert.Nil(t, env)
				assert.Contains(t, err.Error(), v)
			})
		}
	})
}
