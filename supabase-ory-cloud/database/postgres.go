package database

import (
	"time"
	// This import required to support postgres compatibility for the database
	_ "github.com/lib/pq"

	"github.com/gen1us2k/shorts/config"
	"github.com/gen1us2k/shorts/model"
	"github.com/jmoiron/sqlx"
)

// Postgres enables support of PostgreSQL database as storage backend
type Postgres struct {
	WriteDatabase
	Analytics
	config *config.ShortsConfig
	conn   *sqlx.DB
}

// NewPostgres creates new instance of database layer
func NewPostgres(c *config.ShortsConfig) (*Postgres, error) {
	db, err := sqlx.Open("postgres", c.DSN)
	if err != nil {
		return nil, err
	}
	return &Postgres{conn: db, config: c}, nil
}

// ShortifyURL generates short hash code of url and stores it in the database
func (p *Postgres) ShortifyURL(u model.URL) (model.URL, error) {
	var url model.URL
	tx, err := p.conn.Beginx()
	if err != nil {
		return url, err
	}
	u.Hash = generateHash(p.config.URLLength)
	u.ExpiredAt = time.Now().AddDate(0, 1, -1) // FIXME: Make this configurable
	err = tx.Get(
		&url,
		"INSERT INTO url (url, hash, expired_at, owner_id) VALUES($1, $2, $3, $4) RETURNING id, url, hash, created_at, expired_at, owner_id",
		u.URL, u.Hash, u.ExpiredAt, u.OwnerID,
	)
	if err != nil {
		tx.Rollback()
		return url, err
	}
	tx.Commit()

	return url, nil
}

// ListURLs returns all urls created by user
func (p *Postgres) ListURLs(ownerID string) ([]model.URL, error) {
	urls := []model.URL{}
	err := p.conn.Select(&urls, "SELECT * FROM url WHERE owner_id=$1", ownerID)
	return urls, err
}

// DeleteURL deletes URL
func (p *Postgres) DeleteURL(url model.URL) error {
	_, err := p.conn.Exec("DELETE FROM url WHERE id=$1", url.ID)
	return err
}

// StoreView stores view
func (p *Postgres) StoreView(ref model.Referer) error {
	tx, err := p.conn.Begin()
	if err != nil {
		return err
	}
	_, err = tx.Exec("INSERT INTO url_view (referer, url_id) VALUES ($1, $2)", ref.Referer, ref.URLID)
	if err != nil {
		tx.Rollback()
		return err
	}

	return tx.Commit()
}

func (p *Postgres) GetStats(hash string) (model.Stats, error) {
	var stat model.Stats
	err := p.conn.Get(&stat, "SELECT hash, count(*) FROM url_view u join url on u.url_id=url.id where url.hash=$1 GROUP BY url.hash", hash)
	return stat, err
}

// GetURLByHash returns URL from the database by given hash
func (p *Postgres) GetURLByHash(hash string) (model.URL, error) {
	var url model.URL
	err := p.conn.Get(&url, "SELECT * FROM url WHERE hash=$1", hash)
	return url, err
}
