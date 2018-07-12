all:
	go build --race
protoc-go:
	protoc --go_out=plugins=grpc:. grpc.proto
