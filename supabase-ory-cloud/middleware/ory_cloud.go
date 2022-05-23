package middleware

import (
	"fmt"
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
		fmt.Println(session, err)
		fmt.Println(session.Identity)
		if err != nil {
			fmt.Println(err)
			c.Redirect(http.StatusMovedPermanently, k.conf.UIURL)
			return
		}
		fmt.Println(session.Identity.Id)
		fmt.Println(session)
		c.Set(config.OwnerKey, session.Identity.Id)
		c.Next()
	}
}
func (k *oryCloudMiddleware) validateSession(r *http.Request) (*client.Session, error) {
	cookies := r.Header.Get("Cookie")
	resp, _, err := k.client.V0alpha2Api.ToSession(r.Context()).
		Cookie(cookies).
		Execute()
	return resp, err
}
