// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

package middleware

import (
	"net/http"

	"github.com/gen1us2k/shorts/config"
	"github.com/gin-gonic/gin"
	client "github.com/ory/kratos-client-go"
)

type oryCloudMiddleware struct {
	client *client.APIClient
	conf   *config.ShortsConfig
}

func NewMiddleware(c *config.ShortsConfig) *oryCloudMiddleware {
	configuration := client.NewConfiguration()
	configuration.Servers = []client.ServerConfiguration{
		{
			URL: c.KratosAPIURL,
		},
	}
	return &oryCloudMiddleware{
		client: client.NewAPIClient(configuration),
		conf:   c,
	}
}
func (k *oryCloudMiddleware) Session() gin.HandlerFunc {
	return func(c *gin.Context) {
		session, err := k.validateSession(c.Request)
		if err != nil {
			c.Redirect(http.StatusMovedPermanently, k.conf.UIURL)
			return
		}
		c.Set(config.OwnerKey, session.Identity.Id)
		c.Next()
	}
}
func (k *oryCloudMiddleware) validateSession(r *http.Request) (*client.Session, error) {
	// This is simplified version of passing cookies
	//
	// On the other hand you can use
	// r.Cookie.Get("ory_session_projectid") and pass it
	// to ToSession function
	cookies := r.Header.Get("Cookie")
	sess, _, err := k.client.V0alpha2Api.ToSession(r.Context()).
		Cookie(cookies).
		Execute()
	return sess, err
}
