package routes

import (
	"context"
	"server/models"

	"github.com/gin-gonic/gin"
	rts "github.com/ory/keto/proto/ory/keto/relation_tuples/v1alpha2"

	"google.golang.org/grpc"
)

type Config struct {
	CheckConn *grpc.ClientConn
	WriteConn *grpc.ClientConn
}


func NewConfig(check, write *grpc.ClientConn) *Config {
	return &Config{
		CheckConn: check,
		WriteConn: write,
	}
}

func (config *Config) WriteHandler(c *gin.Context) {
	client := rts.NewWriteServiceClient(config.WriteConn)
	data := &models.Relation{}

	c.BindJSON(data)
	_, err := client.TransactRelationTuples(context.Background(), &rts.TransactRelationTuplesRequest{
		RelationTupleDeltas: []*rts.RelationTupleDelta{
			{
				Action: rts.RelationTupleDelta_ACTION_INSERT,
				RelationTuple: &rts.RelationTuple{
					Namespace: "messages",
					Object:    data.Object,
					Relation:  data.Relation,
					Subject:   rts.NewSubjectID(data.Subject),
				},
			},
		},
	})
	if err != nil {
		c.JSON(500, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(200, gin.H{
		"message": "Successfully created permission tuple",
	})
}

func (config *Config) CheckHandler(c *gin.Context) {
	client := rts.NewCheckServiceClient(config.CheckConn)
	data := &models.Relation{}
	c.BindJSON(data)
	res, err := client.Check(context.Background(), &rts.CheckRequest{
		Namespace: "messages",
		Object:    data.Object,
		Relation:  data.Relation,
		Subject:   rts.NewSubjectID(data.Subject),
	})
	if err != nil {
		c.JSON(500, gin.H{
			"error": err.Error(),
		})
		return
	}
	if res.Allowed {
		c.JSON(200, gin.H{
			"allowed": true,
		})
		return
	}
	c.JSON(200, gin.H{
		"allowed": false,
	})
}


func (config *Config) DeleteHandler(c *gin.Context) {
	client := rts.NewWriteServiceClient(config.WriteConn)
	data := &models.Relation{}

	c.BindJSON(data)
	_, err := client.TransactRelationTuples(context.Background(), &rts.TransactRelationTuplesRequest{
		RelationTupleDeltas: []*rts.RelationTupleDelta{
			{
				RelationTuple: &rts.RelationTuple{
					Namespace: "messages",
					Object:    data.Object,
					Relation:  data.Relation,
					Subject:   rts.NewSubjectID(data.Subject),
				},
				Action: rts.RelationTupleDelta_ACTION_DELETE,
			},
		},
	})
	if err != nil {
		c.JSON(500, gin.H{
			"message": err.Error(),
		})
		return
	}
	c.JSON(200, gin.H{
		"message": "Successfully deleted permission tuple",
	})
}
