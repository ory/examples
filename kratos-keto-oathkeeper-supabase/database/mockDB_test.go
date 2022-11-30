// Copyright © 2022 Ory Corp
// SPDX-License-Identifier: Apache-2.0

package database_test

import (
	"testing"

	"github.com/gen1us2k/shorts/config"
	"github.com/gen1us2k/shorts/database"
	"github.com/gen1us2k/shorts/model"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
)

const (
	URLLEN = 32
)

func TestMock(t *testing.T) {
	c, err := config.Parse()
	assert.NoError(t, err)

	p := database.NewMockDB(c)
	u := model.URL{
		URL:     database.RandStringBytes(URLLEN),
		OwnerID: uuid.NewString(),
	}

	url, err := p.ShortifyURL(u)
	assert.NoError(t, err)
	assert.NotEmpty(t, url.Hash)

	assert.Equal(t, u.URL, url.URL)
	assert.Equal(t, u.OwnerID, url.OwnerID)
	assert.NotEmpty(t, url.Hash)

	u, err = p.GetURLByHash(url.Hash)
	assert.NoError(t, err)
	assert.Equal(t, u, url)

	urls, err := p.ListURLs(u.OwnerID)
	assert.NoError(t, err)
	assert.Equal(t, 1, len(urls))
	assert.Equal(t, u, urls[0])

	err = p.DeleteURL(u)
	assert.NoError(t, err)

	_, err = p.GetURLByHash(u.Hash)
	assert.Nil(t, err)
}
