package main

import (
	"server/routes"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

var checkconn *grpc.ClientConn
var writeconn *grpc.ClientConn
var err error

func GetConfig() *routes.Config {
	checkconn, err = grpc.Dial("127.0.0.1:4466", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		panic(err.Error())
	}
	writeconn, err = grpc.Dial("127.0.0.1:4467", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		panic("Encountered error: " + err.Error())
	}
	return &routes.Config{
		CheckConn: checkconn,
		WriteConn: writeconn,
	}
}
