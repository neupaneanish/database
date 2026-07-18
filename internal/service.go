package internal

import (
	"fmt"

	authenticationFS "neupaneanish.com.np/database/authentication/migrations"
	portfolioFS "neupaneanish.com.np/database/portfolio/migrations"
)

func NewService(env *Env) error {
	switch env.Service {
	case Authentication:
		if err := runMigrations(env.URL, authenticationFS.FS); err != nil {
			return err
		}
	case Portfolio:
		if err := runMigrations(env.URL, portfolioFS.FS); err != nil {
			return err
		}
	default:
		return fmt.Errorf("ENVIRONMENT must be %s or %s", Authentication, Portfolio)
	}
	return nil
}
