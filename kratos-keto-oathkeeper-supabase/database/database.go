// Copyright © 2022 Ory Corp
// SPDX-License-Identifier: Apache-2.0

package database

import (
	"math/rand"

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
	}
	// Analytics interface required for analytics
	// for Write API you need to implement WriteDatabase interface
	Analytics interface {
		Statistics(model.URL) (model.Statistics, error)
	}
)

// CreateStorage creates a storage by given configuration
func CreateStorage(c *config.ShortsConfig) (WriteDatabase, error) {
	switch c.DatabaseProvider {
	case config.ProviderMock:
		db := NewMockDB(c)
		return &db, nil

	case config.ProviderPostgres:
		return NewPostgres(c)

	case config.ProviderSupabase:
		return NewSupabase(c)

	default:
		db := NewMockDB(c)
		return &db, nil
	}
}

const letterBytes = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

// RandStringBytes - generates a random byte string of a given length to simulate an URL
func RandStringBytes(n int) string {
	b := make([]byte, n)
	for i := range b {
		b[i] = letterBytes[rand.Intn(len(letterBytes))]
	}
	return string(b)
}
