BIN = $(GOPATH)/bin
BASE = $(GOPATH)/src/$(PACKAGE)
PKGS = go list ./... | grep -v "^vendor/"

# Tools
## Testing library
GINKGO = $(BIN)/ginkgo
$(BIN)/ginkgo:
	go get -u github.com/onsi/ginkgo/ginkgo

## Migration tool
GOOSE = go run -tags='no_mysql no_sqlite3 no_mssql no_redshift' github.com/pressly/goose/cmd/goose

## Source linter
LINT = $(BIN)/golint
$(BIN)/golint:
	go get -u golang.org/x/lint/golint

.PHONY: installtools
installtools: | $(LINT) $(GINKGO)
	echo "Installing tools"

#Test
TEST_DB = vulcanize_testing
TEST_CONNECT_STRING = postgresql://localhost:5432/$(TEST_DB)?sslmode=disable

.PHONY: test
test: | $(GINKGO) $(LINT)
	go vet ./...
	go fmt ./...
	dropdb --if-exists $(TEST_DB)
	createdb $(TEST_DB)
	psql -q $(TEST_DB) < test_data/vulcanize_schema.sql
	make migrate NAME=$(TEST_DB)
	make reset NAME=$(TEST_DB)
	make migrate NAME=$(TEST_DB)
	$(GINKGO) -r --skipPackage=integration_tests,integration

.PHONY: integrationtest
integrationtest: | $(GINKGO) $(LINT)
	go vet ./...
	go fmt ./...
	dropdb --if-exists $(TEST_DB)
	createdb $(TEST_DB)
	psql -q $(TEST_DB) < test_data/vulcanize_schema.sql
	make migrate NAME=$(TEST_DB)
	make reset NAME=$(TEST_DB)
	make migrate NAME=$(TEST_DB)
	$(GINKGO) -r transformers/integration_tests/

vdb-oasis-transformers:
	go build

# Build is really "clean/rebuild"
.PHONY: build
build:
	- rm vdb-oasis-transformers
	go fmt ./...
	go build

#Database
HOST_NAME = localhost
PORT = 5432
NAME =
CONNECT_STRING=postgresql://$(HOST_NAME):$(PORT)/$(NAME)?sslmode=disable

# Parameter checks
## Check that DB variables are provided
.PHONY: checkdbvars
checkdbvars:
	test -n "$(HOST_NAME)" # $$HOST_NAME
	test -n "$(PORT)" # $$PORT
	test -n "$(NAME)" # $$NAME
	@echo $(CONNECT_STRING)

## Check that the migration variable (id/timestamp) is provided
.PHONY: checkmigration
checkmigration:
	test -n "$(MIGRATION)" # $$MIGRATION

## Check that the migration name is provided
.PHONY: checkmigname
checkmigname:
	test -n "$(NAME)" # $$NAME

# Migration operations
## Rollback the last migration
.PHONY: rollback
rollback: checkdbvars
	cd db/migrations;\
	  $(GOOSE) -table "oasis.goose_db_version" postgres "$(CONNECT_STRING)" down
	pg_dump -n 'oasis' -n -s $(CONNECT_STRING) > db/schema.sql

## Rollback to a select migration (id/timestamp)
.PHONY: rollback_to
rollback_to: checkmigration checkdbvars
	cd db/migrations;\
	  $(GOOSE) -table "oasis.goose_db_version" postgres "$(CONNECT_STRING)" down-to "$(MIGRATION)"

## Apply all migrations not already run
.PHONY: migrate
migrate: checkdbvars
	psql $(NAME) -c 'CREATE SCHEMA IF NOT EXISTS oasis;'
	cd db/migrations;\
	  $(GOOSE) -table "oasis.goose_db_version" postgres "$(CONNECT_STRING)" up
	pg_dump -n 'oasis' -O -s $(CONNECT_STRING) > db/schema.sql

.PHONY: reset
reset: checkdbvars
	cd db/migrations/;\
		$(GOOSE) -table "oasis.goose_db_version" postgres "$(CONNECT_STRING)" reset
	pg_dump -n 'oasis' -O -s $(CONNECT_STRING) > db/schema.sql
	psql $(NAME) -c 'DROP SCHEMA oasis CASCADE;'

## Create a new migration file
.PHONY: new_migration
new_migration: checkmigname
	cd db/migrations;\
	  $(GOOSE) create $(NAME) sql

## Check which migrations are applied at the moment
.PHONY: migration_status
migration_status: checkdbvars
	cd db/migrations;\
	  $(GOOSE) -table oasis.goose_db_version postgres "$(CONNECT_STRING)" status

# Import a psql schema to the database
.PHONY: import
import:
	test -n "$(NAME)" # $$NAME
	psql $(NAME) < db/schema.sql

# Update vulcanizedb version
.PHONY: update_vulcanize
update_vulcanize:
	test -n "$(BRANCH)" # $$BRANCH
	go get github.com/makerdao/vulcanizedb@$(BRANCH)
	wget https://raw.githubusercontent.com/makerdao/vulcanizedb/$(BRANCH)/db/schema.sql --output-document=test_data/vulcanize_schema.sql

# Build plugin
.PHONY: plugin
plugin:
	go build -buildmode=plugin -o $(OUTPUT_LOCATION) $(TARGET_LOCATION)

# Docker actions
# Build any docker image in dockerfiles
.PHONY: dockerbuild
dockerbuild:
	test -n "$(IMAGE)" # $$IMAGE
	docker build -t $(IMAGE) -f dockerfiles/$(IMAGE)/Dockerfile .
