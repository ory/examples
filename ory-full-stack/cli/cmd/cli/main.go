package main

import (
	"cli/api"
	"cli/config"
	"cli/oauth2"
	"fmt"
	"log"
)

func main() {
	c, err := config.Parse()
	if err != nil {
		log.Fatal(err)
	}
	o, err := oauth2.NewOauth2(c)
	if err != nil {
		log.Fatal(err)
	}
	o.Authenticate()
	token := o.GetToken()

	client := api.NewClient(c.APIURL, token.AccessToken)

	if err := client.CreateSubreddit(api.Subreddit{
		Name:        "Software Design",
		Description: "Something meaningful",
		Status:      1,
	}); err != nil {
		log.Fatal(err)
	}
	fmt.Println("Reddit Created")
	reddits, err := client.GetSubreddits()
	if err != nil {
		log.Fatal(err)
	}
	for _, reddit := range reddits {
		fmt.Println(reddit.Name)
	}

}
