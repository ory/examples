package database

import (
	"github.com/gen1us2k/shorts/config"
	"github.com/gen1us2k/shorts/model"
)

type (
	// WriteDatabase represents interface for
	// a database layer with write permissions. For Analytics you need to implement
	// Analytics interface
	WriteDatabase interface {
		// ShortifyURL makes a short version of URL.
		ShortifyURL(model.URL) (model.URL, error)
		// ListURLs returns all created urls by user
		ListURLs(string) ([]model.URL, error)
		// GetURLByHash returns an URL created by given hash
		GetURLByHash(string) (model.URL, error)
		// StoreView saves an URL view to the database
		StoreView(model.Referer) error
		// DeleteURL deletes URL
		DeleteURL(model.URL) error
		GetStats(string) (model.Stats, error)
	}
	// Analytics interface required for analytics
	// for Write API you need to implement WriteDatabase interface
	Analytics interface {
		Statistics(model.URL) (model.Statistics, error)
		GetStats(string) (model.Stats, error)
	}
)

// CreateStorage creates a storage by given configuration
func CreateStorage(c *config.ShortsConfig) (WriteDatabase, error) {
	if c.DatabaseProvider == config.ProviderPostgres {
		return NewPostgres(c)
	}
	if c.DatabaseProvider == config.ProviderSupabase {
		return NewSupabase(c)
	}
	return NewPostgres(c)
}
