package database

import (
	"testing"

	"github.com/gen1us2k/shorts/config"
	"github.com/gen1us2k/shorts/model"
	"github.com/stretchr/testify/assert"
)

func TestPostgres(t *testing.T) {
	c, err := config.Parse()
	assert.NoError(t, err)
	p, err := NewPostgres(c)
	assert.NoError(t, err)
	u := model.URL{
		URL:     "https://thelootdistrict.com/pvphub/demon-hunter/havoc/",
		OwnerID: "0bdef0a0-0841-48ab-ad14-3b2b74b7237b",
	}
	url, err := p.ShortifyURL(u)
	assert.NoError(t, err)

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
	assert.Error(t, err)
}
