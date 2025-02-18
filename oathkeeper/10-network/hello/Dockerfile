FROM golang:1.17-alpine

WORKDIR /build

COPY go.mod ./
COPY go.sum ./

RUN go mod download

COPY *.go ./

RUN GOOS=linux GOARCH=amd64 go build -o /hello main.go

CMD ["/hello"]