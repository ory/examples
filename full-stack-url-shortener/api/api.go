package api

import (
	"database/sql"
	"log"
	"net/http"

	"github.com/davecgh/go-spew/spew"
	"github.com/gen1us2k/shorts/config"
	"github.com/gen1us2k/shorts/database"
	"github.com/gen1us2k/shorts/middleware"
	"github.com/gen1us2k/shorts/model"
	"github.com/gin-gonic/gin"
)

type (
	// Server struct implements HTTP API used for service
	Server struct {
		r      *gin.Engine
		config *config.ShortsConfig
		db     database.WriteDatabase
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
	}
	s.initRoutes()
	return s, nil
}
func (s *Server) initRoutes() {
	authMiddleware := middleware.NewAuthenticationMiddleware(s.config)
	s.r.GET("/u/:hash", s.showURL)

	// The only kratos thing would be here
	userAPI := s.r.Group("/api/")
	userAPI.Use(authMiddleware.AuthenticationMiddleware)
	userAPI.POST("/url", s.shortifyURL)
	userAPI.GET("/url", s.listURLs)
	userAPI.DELETE("/url/:hash", s.deleteURL)

	// TODO: Implement RBAC here
	analyticsAPI := s.r.Group("/analytics")
	analyticsAPI.GET("/url", s.getURLStats)

}
func (s *Server) getURLStats(c *gin.Context) {

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
	spew.Dump(c.Request.Header)
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
	c.JSON(http.StatusOK, u)
}

// Start starts http server
func (s *Server) Start() error {
	return s.r.Run(s.config.BindAddr)
}
