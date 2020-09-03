BIN = $(GOPATH)/bin
BASE = $(GOPATH)/src/$(PACKAGE)
PKGS = go list ./... | grep -v "^vendor/"

# Tools
## Testing library
GINKGO = $(BIN)/ginkgo
$(BIN)/ginkgo:
	go get -u github.com/onsi/ginkgo/ginkgo

## Migration tool
GOOSE = $(BIN)/goose
$(BIN)/goose:
	go get -u -d github.com/pressly/goose/cmd/goose
	go build -tags='no_mysql no_sqlite' -o $(BIN)/goose github.com/pressly/goose/cmd/goose

## Source linter
LINT = $(BIN)/golint
$(BIN)/golint:
	go get -u golang.org/x/lint/golint

#Test
TEST_DB = vulcanize_testing
TEST_CONNECT_STRING = postgresql://localhost:5432/$(TEST_DB)?sslmode=disable

.PHONY: test
test: | $(GINKGO) $(LINT)
	go vet ./...
	go fmt ./...
	dropdb --if-exists $(TEST_DB)
	createdb $(TEST_DB)
	cd db/migrations;\
		$(GOOSE) postgres "$(TEST_CONNECT_STRING)" up
	cd db/migrations/;\
		$(GOOSE) postgres "$(TEST_CONNECT_STRING)" reset
	make migrate NAME=$(TEST_DB)
	$(GINKGO) -r --skipPackage=integration_tests,integration

## Apply all migrations not already run
.PHONY: migrate
migrate: $(GOOSE) checkdbvars
	cd db/migrations;\
	  $(GOOSE) postgres "$(CONNECT_STRING)" up
	pg_dump -O -s $(CONNECT_STRING) > db/schema.sql

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

