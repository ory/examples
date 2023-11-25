package main

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func init() {
	initiate()
}
func main() {
	r := gin.Default()
	config := cors.DefaultConfig()
	config.AllowAllOrigins = true
	r.Use(cors.New(config))

	app := GetConfig()

	r.POST("/writerelation", app.WriteHandler)
	r.POST("/checkrelation", app.CheckHandler)
	r.POST("deleterelation", app.DeleteHandler)
	r.Run(":4000")
}
