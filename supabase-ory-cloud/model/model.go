package model

import "time"

type (
	// URL struct is required for working with databases
	URL struct {
		ID        int64     `db:"id" json:"id"`
		URL       string    `db:"url" json:"url"`
		Hash      string    `db:"hash" json:"hash"`
		CreatedAt time.Time `db:"created_at" json:"created_at"`
		ExpiredAt time.Time `db:"expired_at" json:"expired_at"`
		OwnerID   string    `db:"owner_id" json:"owner_id"`
	}
	Stats struct {
		Hash  string `db:"hash" json:"hash"`
		Count int64  `db:"count" json:"count"`
	}
	Referer struct {
		ID      int64  `db:"id"`
		URLID   int64  `db:"url_id"`
		Referer string `db:"referer"`
	}
	User struct {
		FirstName    string
		LastName     string
		CreationDate string
		LastLogin    string
		Email        string
	}
	DefaultResponse struct {
		Message string `json:"message"`
	}
	Statistics struct{}
)
