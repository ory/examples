package main

import (
	"context"
	"fmt"
	"log"

	rts "github.com/ory/keto/proto/ory/keto/relation_tuples/v1alpha2"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

func initiate() {
	conn, err := grpc.Dial("127.0.0.1:4467", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("Encountered error: " + err.Error())
	}

	client := rts.NewWriteServiceClient(conn)

	_, err = client.TransactRelationTuples(context.Background(), &rts.TransactRelationTuplesRequest{
		RelationTupleDeltas: []*rts.RelationTupleDelta{
			{
				Action: rts.RelationTupleDelta_ACTION_INSERT,
				RelationTuple: &rts.RelationTuple{
					Namespace: "messages",
					Object:    "admin",
					Relation:  "owner",
					Subject:   rts.NewSubjectID("vijeyash@gmail.com"),
				},
			},
			{
				Action: rts.RelationTupleDelta_ACTION_INSERT,

				RelationTuple: &rts.RelationTuple{

					Namespace: "messages",
					Object:    "admin",
					Relation:  "view",
					Subject:   rts.NewSubjectSet("messages", "admin", "owner"),
				},
			},
			{
				Action: rts.RelationTupleDelta_ACTION_INSERT,

				RelationTuple: &rts.RelationTuple{

					Namespace: "messages",
					Object:    "homepage",
					Relation:  "view",
					Subject:   rts.NewSubjectSet("messages", "admin", "owner"),
				},
			},
		},
	})
	if err != nil {
		log.Fatalf("Encountered error: " + err.Error())
	}

	fmt.Println("Successfully created tuple")

}
