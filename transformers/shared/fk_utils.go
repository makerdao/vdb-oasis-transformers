package shared

import (
	"github.com/makerdao/vulcanizedb/libraries/shared/repository"
	"github.com/makerdao/vulcanizedb/pkg/datastore/postgres"
)

func GetOrCreateAddress(address string, db *postgres.DB) (int64, error) {
	return repository.GetOrCreateAddress(db, address)
}
