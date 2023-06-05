// Copyright © 2022 Ory Corp
// SPDX-License-Identifier: Apache-2.0

package database

import (
	"time"

	_ "github.com/lib/pq"

	"github.com/gen1us2k/shorts/config"
	"github.com/gen1us2k/shorts/model"
)

const (
	URLLEN = 8
)

type ID = string
type URLStore = []model.URL
type URLViewStore = []model.Referer

type URLStorage = map[ID]URLStore
type URLViewStorage = map[int64]URLViewStore

type mockDB struct {
	WriteDatabase
	config config.ShortsConfig
	urls   URLStorage
	views  URLViewStorage
}

// NewmockDB creates new instance of database layer
func NewMockDB(c *config.ShortsConfig) mockDB {
	db := mockDB{
		urls:  make(URLStorage),
		views: make(URLViewStorage)}

	return db
}

// ShortifyURL generates short hash code of url and stores it in the database
func (p *mockDB) ShortifyURL(u model.URL) (model.URL, error) {

	u.Hash = generateSHA1(u.URL)
	u.ExpiredAt = time.Now().AddDate(0, 1, -1)

	p.urls[u.OwnerID] = append(p.urls[u.OwnerID], u)
	return u, nil
}

// ListURLs returns all urls created by user
func (p *mockDB) ListURLs(ownerID string) ([]model.URL, error) {
	return p.urls[ownerID], nil
}

// DeleteURL deletes URL
func (p *mockDB) DeleteURL(url model.URL) error {
	p.urls[url.OwnerID] = make([]model.URL, 0)
	return nil
}

// StoreView stores view
func (p *mockDB) StoreView(ref model.Referer) error {
	p.views[ref.ID] = append(p.views[ref.ID], ref)
	return nil
}

// GetURLByHash returns URL from the database by given hash
// This is a very expensive time complexity is O(M*N)
func (p *mockDB) GetURLByHash(hash string) (model.URL, error) {
	var url model.URL

	for _, user := range p.urls {
		for _, u := range user {
			if u.Hash == hash {
				url = u
				break
			}
		}
	}
	return url, nil
}
