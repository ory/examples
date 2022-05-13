package api

import (
	"database/sql"
	"log"
	"net/http"

	"github.com/gen1us2k/shorts/auth"
	"github.com/gen1us2k/shorts/config"
	"github.com/gen1us2k/shorts/database"
	"github.com/gen1us2k/shorts/middleware"
	"github.com/gen1us2k/shorts/model"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

type (
	// Server struct implements HTTP API used for service
	Server struct {
		r      *gin.Engine
		config *config.ShortsConfig
		db     database.WriteDatabase
		keto   *auth.Keto
	}
)

// New initializes API by given config
func New(c *config.ShortsConfig) (*Server, error) {

	db, err := database.CreateStorage(c)
	if err != nil {
		return nil, err
	}
	s := &Server{
		r:      gin.Default(),
		config: c,
		db:     db,
		keto:   auth.NewKeto(c),
	}
	s.initRoutes()
	return s, nil
}
func (s *Server) initRoutes() {
	config := cors.DefaultConfig()
	config.AllowOrigins = []string{"http://127.0.0.1:4000"}
	config.AllowCredentials = true
	config.AllowMethods = []string{"GET", "POST", "OPTIONS"}
	oryCloudMiddleware := middleware.NewMiddleware(s.config)
	s.r.Use(cors.New(config))
	s.r.GET("/u/:hash", s.showURL)

	// The only kratos thing would be here
	userAPI := s.r.Group("/api/")
	userAPI.Use(oryCloudMiddleware.Session())
	userAPI.POST("/url", s.shortifyURL)
	userAPI.GET("/url", s.listURLs)
	userAPI.DELETE("/url/:hash", s.deleteURL)

	// TODO: Implement RBAC here
	analyticsAPI := s.r.Group("/analytics")
	analyticsAPI.Use(oryCloudMiddleware.Session())
	analyticsAPI.GET("/url/:hash", s.getURLStats)

}
func (s *Server) getURLStats(c *gin.Context) {
	ownerID, ok := c.Get(config.OwnerKey)
	if !ok {
		c.JSON(http.StatusUnauthorized, &model.DefaultResponse{
			Message: "Unauthorized",
		})
		return
	}
	hash := c.Param("hash")
	if !s.keto.CheckAccess(hash, ownerID.(string)) {
		c.JSON(http.StatusUnauthorized, &model.DefaultResponse{
			Message: "You don't have access to the requested resource",
		})
		return
	}
	stats, err := s.db.GetStats(hash)
	if err != nil {
		c.JSON(http.StatusUnauthorized, &model.DefaultResponse{
			Message: "error querying database",
		})
		return
	}
	c.JSON(http.StatusOK, &stats)

}
func (s *Server) deleteURL(c *gin.Context) {
	hash := c.Param("hash")
	ownerID, ok := c.Get(config.OwnerKey)
	if !ok {
		c.JSON(http.StatusUnauthorized, &model.DefaultResponse{
			Message: "Unauthorized",
		})
	}
	u, err := s.db.GetURLByHash(hash)
	if err != nil {
		c.JSON(http.StatusInternalServerError, &model.DefaultResponse{
			Message: "error querying database",
		})
		return
	}
	if u.OwnerID != ownerID {
		c.JSON(http.StatusForbidden, &model.DefaultResponse{
			Message: "you can't delete this item",
		})
		return
	}
	if err := s.db.DeleteURL(u); err != nil {
		c.JSON(http.StatusInternalServerError, &model.DefaultResponse{
			Message: "error querying database",
		})
		return
	}
	c.JSON(http.StatusOK, &model.DefaultResponse{
		Message: "deleted",
	})
}

func (s *Server) showURL(c *gin.Context) {
	hash := c.Param("hash")
	u, err := s.db.GetURLByHash(hash)
	if err != nil {
		c.JSON(http.StatusInternalServerError, &model.DefaultResponse{
			Message: "error querying database",
		})
		return
	}
	referer := ""
	if len(c.Request.Header["Referer"]) > 0 {
		referer = c.Request.Header["Referer"][0]
	}
	ref := model.Referer{
		URLID:   u.ID,
		Referer: referer,
	}
	if err := s.db.StoreView(ref); err != nil {
		c.JSON(http.StatusInternalServerError, &model.DefaultResponse{
			Message: "error querying database",
		})
		return
	}
	c.Redirect(http.StatusMovedPermanently, u.URL)
}
func (s *Server) listURLs(c *gin.Context) {
	ownerID, ok := c.Get(config.OwnerKey)
	if !ok {
		c.JSON(http.StatusUnauthorized, &model.DefaultResponse{
			Message: "Unauthorized",
		})
	}
	urls, err := s.db.ListURLs(ownerID.(string))
	if err != nil && err != sql.ErrNoRows {

		c.JSON(http.StatusInternalServerError, &model.DefaultResponse{
			Message: "error querying database",
		})
		return
	}
	c.JSON(http.StatusOK, urls)
}

func (s *Server) shortifyURL(c *gin.Context) {
	ownerID, ok := c.Get(config.OwnerKey)
	if !ok {
		c.JSON(http.StatusUnauthorized, &model.DefaultResponse{
			Message: "Unauthorized",
		})
	}
	var url model.URL
	if err := c.ShouldBindJSON(&url); err != nil {
		c.JSON(http.StatusBadRequest, &model.DefaultResponse{
			Message: "failed parse json",
		})
		return
	}
	url.OwnerID = ownerID.(string)
	u, err := s.db.ShortifyURL(url)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, &model.DefaultResponse{
			Message: "failed to create short version",
		})
		return
	}
	if err := s.keto.GrantAccess(u.Hash, ownerID.(string)); err != nil {
		c.JSON(http.StatusInternalServerError, &model.DefaultResponse{
			Message: "failed to create short version",
		})
		return
	}

	c.JSON(http.StatusOK, u)
}

// Start starts http server
func (s *Server) Start() error {
	return s.r.Run(s.config.BindAddr)
}
