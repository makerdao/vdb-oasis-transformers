FROM makerdao/vdb-builder:latest as builder

ARG VDB_VERSION=prod

WORKDIR /go/src/github.com/makerdao/vdb-oasis-transformers
COPY . .

WORKDIR /go/src/github.com/makerdao
RUN git clone https://github.com/makerdao/vulcanizedb.git
WORKDIR /go/src/github.com/makerdao/vulcanizedb
RUN git checkout $VDB_VERSION
RUN go build

# build oasis with local vdb
WORKDIR /go/src/github.com/makerdao/vdb-oasis-transformers
RUN go mod edit -replace=github.com/makerdao/vulcanizedb=/go/src/github.com/makerdao/vulcanizedb/
RUN make plugin PACKAGE=github.com/makerdao/vdb-oasis-transformers \
    TARGET_LOCATION=$GOPATH/src/github.com/makerdao/vdb-oasis-transformers/plugins/execute/transformerExporter.go \
    OUTPUT_LOCATION=$GOPATH/src/github.com/makerdao/vdb-oasis-transformers/plugins/transformerExporter.so

# app container
FROM makerdao/vdb-runner:latest
WORKDIR /go/src/github.com/makerdao/vulcanizedb

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
