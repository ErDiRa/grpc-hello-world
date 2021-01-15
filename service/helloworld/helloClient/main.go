package main

import (
	"context"
	"fmt"
	"log"

	"google.golang.org/grpc"
	helloworld "stefan.grpc/helloworld/domain"
)

func main() {
	fmt.Println("Hello client started")

	opts := grpc.WithInsecure()
	cc, err := grpc.Dial("0.0.0.0:50051", opts)
	if err != nil {
		log.Fatal(err)
	}
	defer cc.Close()

	client := helloworld.NewHelloServiceClient(cc)
	request := &helloworld.HelloRequest{Name: "Jeremy"}

	resp, err := client.Hello(context.Background(), request)
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	fmt.Printf("Receive response => [%v]", resp.Greeting)
}
