package log_item_update

import (
	"fmt"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vdb-transformer-utilities/pkg/shared"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
	"github.com/makerdao/vulcanizedb/libraries/shared/repository"
	"github.com/makerdao/vulcanizedb/pkg/core"
	"github.com/makerdao/vulcanizedb/pkg/datastore/postgres"
	"github.com/makerdao/vulcanizedb/pkg/eth"
)

type Transformer struct{}

func (Transformer) toEntities(contractAbi string, logs []core.EventLog) ([]LogItemUpdateEntity, error) {
	var entities []LogItemUpdateEntity
	for _, log := range logs {
		var entity LogItemUpdateEntity
		address := log.Log.Address
		abi, parseErr := eth.ParseAbi(contractAbi)
		if parseErr != nil {
			return nil, parseErr
		}

		contract := bind.NewBoundContract(address, abi, nil, nil, nil)
		unpackErr := contract.UnpackLog(&entity, "LogItemUpdate", log.Log)
		if unpackErr != nil {
			return nil, unpackErr
		}

		entity.HeaderID = log.HeaderID
		entity.LogID = log.ID
		entity.ContractAddress = address
		entities = append(entities, entity)
	}

	return entities, nil
}

func (t Transformer) ToModels(abi string, logs []core.EventLog, db *postgres.DB) ([]event.InsertionModel, error) {
	entities, entityErr := t.toEntities(abi, logs)
	if entityErr != nil {
		return nil, fmt.Errorf("transformer couldn't convert logs to entities: %v", entityErr)
	}
	var models []event.InsertionModel
	for _, logItemUpdateEntity := range entities {
		addressId, addressErr := repository.GetOrCreateAddress(db, logItemUpdateEntity.ContractAddress.Hex())
		if addressErr != nil {
			return nil, shared.ErrCouldNotCreateFK(addressErr)
		}
		model := event.InsertionModel{
			SchemaName: constants.OasisSchema,
			TableName:  constants.LogItemUpdateTable,
			OrderedColumns: []event.ColumnName{
				event.HeaderFK, event.LogFK, event.AddressFK, constants.OfferId,
			},
			ColumnValues: event.ColumnValues{
				event.HeaderFK:    logItemUpdateEntity.HeaderID,
				event.LogFK:       logItemUpdateEntity.LogID,
				event.AddressFK:   addressId,
				constants.OfferId: shared.BigIntToString(logItemUpdateEntity.Id),
			},
		}
		models = append(models, model)
	}
	return models, nil
}
