package main

import (
	"database/sql"
	"log"

	"github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	_ "github.com/lib/pq"
)

func main() {
	db, err := sql.Open("postgres", "postgres://shorts:notsecureatall@localhost:5432/shorts?sslmode=disable")
	if err != nil {
		log.Fatal("failed open connection", err)
	}
	driver, err := postgres.WithInstance(db, &postgres.Config{})
	if err != nil {
		log.Fatal("failed create instance", err)
	}

	m, err := migrate.NewWithDatabaseInstance(
		"file:////Users/gen1us2k/src/shorts/migrations",
		"postgres", driver)
	if err != nil {
		log.Fatal("failed create migration object", err)
	}
	log.Fatal(m.Up())
}
