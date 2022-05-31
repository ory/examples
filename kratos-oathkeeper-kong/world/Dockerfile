FROM golang as builder

RUN mkdir /build

ADD . /build

WORKDIR /build
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o world main.go

FROM alpine
EXPOSE 8090

COPY --from=builder /build/world /world
ENTRYPOINT ["/world"]
