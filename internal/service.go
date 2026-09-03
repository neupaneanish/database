package internal

import (
	"fmt"

	authentication "neupaneanish.com.np/database/authentication/migrations"
	profile "neupaneanish.com.np/database/profile/migrations"
)

func NewService(env *Env) error {
	switch env.Service {
	case Authentication:
		if err := runMigrations(env.URL, authentication.FS); err != nil {
			return err
		}
	case Profile:
		if err := runMigrations(env.URL, profile.FS); err != nil {
			return err
		}
	default:
		return fmt.Errorf("ENVIRONMENT must be %s or %s", Authentication, Profile)
	}
	return nil
}
