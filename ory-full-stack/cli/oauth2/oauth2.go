package oauth2

import (
	"cli/config"
	"context"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"net/url"
	"time"

	"github.com/fatih/color"
	"github.com/skratchdot/open-golang/open"
	"golang.org/x/oauth2"
)

type (
	Oauth2 struct {
		oauth2Config *oauth2.Config
		config       *config.CLIConfig
		token        *oauth2.Token
		srv          *http.Server
		shut         chan struct{}
	}
	Discovery struct {
		AuthURL  string `json:"authorization_endpoint"`
		TokenURL string `json:"token_endpoint"`
	}
)

var letters = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

func NewOauth2(config *config.CLIConfig) (*Oauth2, error) {
	resp, err := http.Get(config.DiscoveryURL)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	var d Discovery
	err = json.NewDecoder(resp.Body).Decode(&d)
	if err != nil {
		return nil, err
	}
	o := &Oauth2{
		oauth2Config: &oauth2.Config{
			ClientID:     config.ClientID,
			ClientSecret: config.ClientSecret,
			Scopes:       []string{"openid", "offline"},
			Endpoint: oauth2.Endpoint{
				AuthURL:  d.AuthURL,
				TokenURL: d.TokenURL,
			},
			RedirectURL: "http://127.0.0.1:9999/oauth/callback",
		},
		config: config,
		shut:   make(chan struct{}),
	}
	o.initHTTPServer()
	return o, nil
}

func (o *Oauth2) initHTTPServer() {
	srv := &http.Server{Addr: ":9999"}
	http.HandleFunc("/oauth/callback", o.callbackHandler)
	o.srv = srv
}

func (o *Oauth2) Authenticate() {
	url := o.oauth2Config.AuthCodeURL(o.generateState(), oauth2.AccessTypeOffline)
	open.Run(url)
	o.startHTTPServer()
}

func (o *Oauth2) GetToken() *oauth2.Token {
	return o.token
}

func (o *Oauth2) generateState() string {
	n := 32 // length of string
	b := make([]rune, n)
	for i := range b {
		b[i] = letters[rand.Intn(len(letters))]
	}
	return string(b)
}

func (o *Oauth2) startHTTPServer() {
	go func() {
		<-o.shut
		d := time.Now().Add(5 * time.Second)
		ctx, cancel := context.WithDeadline(context.Background(), d)
		defer cancel()
		if err := o.srv.Shutdown(ctx); err != nil {
			log.Printf(color.RedString("Auth server could not shutdown gracefully: %v"), err)
		}
	}()
	if err := o.srv.ListenAndServe(); err != http.ErrServerClosed {
		log.Fatalf("ListenAndServe(): %v", err)
	}
}

func (o *Oauth2) callbackHandler(w http.ResponseWriter, r *http.Request) {
	parts, err := url.ParseQuery(r.URL.RawQuery)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(w, "Failed parsing query")
		return
	}
	if len(parts["code"]) == 0 {
		w.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(w, "code param is required")
		return
	}
	tr := &http.Transport{
		TLSClientConfig: &tls.Config{
			InsecureSkipVerify: o.config.SkipTLS,
		},
	}
	client := &http.Client{Transport: tr}
	ctx := context.WithValue(context.Background(), oauth2.HTTPClient, client)
	token, err := o.oauth2Config.Exchange(ctx, parts["code"][0])
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(w, "failed exchanging a token")
		return
	}
	o.token = token
	successPage := `
		<div style="height:100px; width:100%!; display:flex; flex-direction: column; justify-content: center; align-items:center; background-color:#2ecc71; color:white; font-size:22"><div>Success!</div></div>
		<p style="margin-top:20px; font-size:18; text-align:center">You are authenticated, you can now return to the program. Please, close the window</p>
		`

	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, successPage)
	o.shut <- struct{}{}
}
