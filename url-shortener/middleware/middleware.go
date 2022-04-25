package middleware

import (
	"net/http"

	"github.com/gen1us2k/shorts/config"
	"github.com/gin-gonic/gin"
)

type (
	AuthMiddleware struct {
		config *config.ShortsConfig
	}
)

func NewAuthenticationMiddleware(c *config.ShortsConfig) *AuthMiddleware {
	return &AuthMiddleware{
		config: c,
	}
}
func (a *AuthMiddleware) AuthenticationMiddleware(c *gin.Context) {
	userID := c.Request.Header.Get("X-User")
	if userID == "" {
		c.Redirect(http.StatusMovedPermanently, a.config.UIURL)
		return
	}
	c.Set(config.OwnerKey, userID)
	c.Next()
}
