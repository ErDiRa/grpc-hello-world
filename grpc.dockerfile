# note: we cannot currently use the alpine package, as this is not compatible
# with protoc
FROM golang:1.15.0


# ADD SSH CLIENT TO CONNECT TO GIT REPOSITORIES VIA SSH AND CUSTOM KEYS
# RUN apk add --no-cache openssh-client
RUN apt-get update && apt-get install unzip

# CREATE A TEMPORARY DIRECTORY
RUN mkdir /tmp/proto

# DOWNLOAD THE PROTOC GENERATOR
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/protoc-3.14.0-linux-x86_64.zip -O /tmp/proto/protoc.zip

# EXTRACT THE PROTOC GENERATOR AND COPY IT TO THE REQUIRED DIRECTORIES
RUN cd /tmp/proto && \
	unzip /tmp/proto/protoc.zip && \
	mv /tmp/proto/bin/protoc /usr/local/bin/protoc && \
	mv /tmp/proto/include/google /usr/local/include/google

# INSTALL THE PROTOBUF LIBRARY
WORKDIR /tmp
RUN git clone https://github.com/golang/protobuf.git && \
	cd protobuf/proto && \
	git checkout v1.4.3 && go install . && \
	cd /tmp && rm -rf protobuf

# INSTALL THE PROTOC GENERATOR FOR GOLANG
RUN git clone https://github.com/protocolbuffers/protobuf-go.git && \
	cd protobuf-go/cmd/protoc-gen-go && \
	git checkout v1.25.0 && go install . && \
	cd /tmp && rm -rf protobuf-go

# INSTALL GRCP PACKAGE FOR GRPC-SERVICES
RUN git clone https://github.com/grpc/grpc-go.git && \
	cd grpc-go/cmd/protoc-gen-go-grpc && \
	git checkout v1.35.0 && go install . && \
	cd /tmp && rm -rf grpc-go


# SYMLINK THE APPLICATION DIRECTORY INTO THE GOLANG SOURCE, WATCH FOR CHANGES
# AND AUTOMATICALLY REBUILD THE APPLICATION
WORKDIR /service
CMD ["tail", "-f", "/dev/null"]
