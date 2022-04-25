package main

import (
	"log"

	"github.com/gen1us2k/shorts/api"
	"github.com/gen1us2k/shorts/config"
)

func main() {
	c, err := config.Parse()
	if err != nil {
		log.Fatal(err)
	}
	api, err := api.New(c)
	if err != nil {
		log.Fatal(err)
	}
	api.Start()
}
