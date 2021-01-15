package main

import (
	"context"
	"fmt"
	"log"
	"net"

	"google.golang.org/grpc"
	helloworld "stefan.grpc/helloworld/domain"
)

type server struct {
	helloworld.HelloServiceServer
}

func (*server) Hello(ctx context.Context, request *helloworld.HelloRequest) (*helloworld.HelloResponse, error) {
	name := request.Name
	response := &helloworld.HelloResponse{
		Greeting: "Hello " + name,
	}
	return response, nil
}

func main() {
	address := "0.0.0.0:50051"
	lis, err := net.Listen("tcp", address)
	if err != nil {
		log.Fatalf("Error %v", err)
	}
	fmt.Printf("Server is listening on %v ...", address)

	s := grpc.NewServer()
	helloworld.RegisterHelloServiceServer(s, &server{})

	s.Serve(lis)
}
