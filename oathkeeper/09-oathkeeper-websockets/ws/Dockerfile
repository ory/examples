FROM golang as builder

RUN mkdir /build

ADD . /build

WORKDIR /build
RUN GOOS=linux GOARCH=amd64 go build -o ws main.go

FROM alpine
EXPOSE 8090

COPY --from=builder /build/ws /ws
COPY index.html /index.html
ENTRYPOINT ["/ws"]
