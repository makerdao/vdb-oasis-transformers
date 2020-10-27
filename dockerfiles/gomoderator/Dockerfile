FROM makerdao/vdb-builder:latest as builder

ARG VDB_VERSION=prod
ENV GO111MODULE on

WORKDIR /go/src/github.com/makerdao
RUN git clone https://github.com/makerdao/vulcanizedb.git
WORKDIR /go/src/github.com/makerdao/vulcanizedb
RUN git checkout $VDB_VERSION
RUN go build
WORKDIR /go/src/github.com/makerdao/vdb-oasis-transformers
COPY . .

# app container
FROM golang:alpine
WORKDIR /go/src/github.com/makerdao/vulcanizedb

# add python to run gomoderator
RUN apk add --no-cache python3

# get access to go.mod files in directories
COPY --from=builder /go/src/github.com/makerdao/vulcanizedb .
COPY --from=builder /go/src/github.com/makerdao/vdb-oasis-transformers/go.mod ./oasis-transformers/go.mod

RUN python3 scripts/gomoderator.py ./ oasis-transformers/
