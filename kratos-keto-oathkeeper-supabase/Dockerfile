FROM golang as builder

RUN mkdir /build

ADD . /build

WORKDIR /build
RUN GOOS=linux GOARCH=amd64 go build -o shorts cmd/shorts/main.go

FROM alpine
EXPOSE 8090

COPY --from=builder /build/shorts /shorts
ENTRYPOINT ["/shorts"]
