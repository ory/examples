package api

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
)

type (
	Transport struct {
		Token string
	}
	Client struct {
		client *http.Client
		url    string
	}
)

func (t Transport) RoundTrip(req *http.Request) (*http.Response, error) {
	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", t.Token))
	req.Header.Set("Content-type", "application/json")
	return http.DefaultTransport.RoundTrip(req)
}

func (t *Transport) Client() *http.Client {
	return &http.Client{Transport: t}
}

func NewClient(url, token string) *Client {
	return &Client{
		client: &http.Client{Transport: Transport{Token: token}},
		url:    url,
	}
}

func (c *Client) CreateSubreddit(r Subreddit) error {
	data, err := json.Marshal(r)
	if err != nil {
		return err
	}
	req, err := http.NewRequest(
		http.MethodPost,
		fmt.Sprintf("%s/subreddits", c.url),
		bytes.NewBuffer(data),
	)
	_, err = c.client.Do(req)
	return err
}
func (c *Client) GetSubreddits() ([]Subreddit, error) {
	var r SubredditResponse
	resp, err := c.client.Get(fmt.Sprintf("%s/subreddits", c.url))
	if err != nil {
		return r.Results, err
	}
	if err := json.NewDecoder(resp.Body).Decode(&r); err != nil {
		return r.Results, err
	}
	return r.Results, nil
}
