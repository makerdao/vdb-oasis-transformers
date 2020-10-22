FROM golang:1.15.2-buster as builder

RUN apt-get update && \
    apt-get install -y make git g++ linux-headers-amd64

ARG VDB_VERSION=prod

ENV GO111MODULE on

WORKDIR /go/src/github.com/makerdao/vdb-oasis-transformers
ADD . .

WORKDIR /go/src/github.com/makerdao
RUN git clone https://github.com/makerdao/vulcanizedb.git
WORKDIR /go/src/github.com/makerdao/vulcanizedb
RUN git checkout $VDB_VERSION
RUN go build
RUN go get -tags='no_mysql no_sqlite3 no_mssql no_redshift' github.com/pressly/goose/cmd/goose@v2.7.0-rc5

# build oasis with local vdb
WORKDIR /go/src/github.com/makerdao/vdb-oasis-transformers
RUN go mod edit -replace=github.com/makerdao/vulcanizedb=/go/src/github.com/makerdao/vulcanizedb/
RUN make plugin PACKAGE=github.com/makerdao/vdb-oasis-transformers \
    TARGET_LOCATION=$GOPATH/src/github.com/makerdao/vdb-oasis-transformers/plugins/execute/transformerExporter.go \
    OUTPUT_LOCATION=$GOPATH/src/github.com/makerdao/vdb-oasis-transformers/plugins/transformerExporter.so

# app container
FROM golang:1.15.2-buster
WORKDIR /go/src/github.com/makerdao/vulcanizedb

# add certificates for node requests via https
# bash for wait-for-it
RUN apt-get update \
        && apt-get update -y \
        && apt-get install -y \
        ca-certificates \
        postgresql-client \
        bash \
        busybox \
        && update-ca-certificates 2>/dev/null || true

ARG CONFIG_FILE=environments/oasisTransformers.toml

# Direct logs to stdout for docker log driver
RUN ln -sf /dev/stdout /go/src/github.com/makerdao/vulcanizedb/vulcanizedb.log

# keep binaries immutable
COPY --from=builder /go/src/github.com/makerdao/vulcanizedb .
COPY --from=builder /go/src/github.com/makerdao/vdb-oasis-transformers/$CONFIG_FILE config.toml
COPY --from=builder /go/src/github.com/makerdao/vdb-oasis-transformers/dockerfiles/execute/startup_script.sh .
COPY --from=builder /go/src/github.com/makerdao/vdb-oasis-transformers/db/migrations db/vdb-oasis-transformers/migrations/
COPY --from=builder /go/src/github.com/makerdao/vdb-oasis-transformers/plugins/transformerExporter.so plugins/transformerExporter.so
COPY --from=builder /go/bin/goose goose
COPY --from=builder /go/src/github.com/makerdao/vdb-oasis-transformers/dockerfiles/wait-for-it.sh .
COPY --from=builder /go/src/github.com/makerdao/vdb-oasis-transformers/dockerfiles/execute/run_migrations.sh .

HEALTHCHECK CMD grep -q "event watcher starting" /tmp/execute_health_check 

# need to execute with a shell to access env variables
CMD ["./startup_script.sh"]
