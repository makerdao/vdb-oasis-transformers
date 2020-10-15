package log_make

import (
	"fmt"
	"math/big"
	"strconv"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/makerdao/vdb-oasis-transformers/transformers/shared"
	"github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
	"github.com/makerdao/vulcanizedb/libraries/shared/repository"
	"github.com/makerdao/vulcanizedb/pkg/core"
	"github.com/makerdao/vulcanizedb/pkg/datastore/postgres"
	"github.com/makerdao/vulcanizedb/pkg/eth"
)

type Transformer struct{}

func (Transformer) toEntities(contractAbi string, logs []core.EventLog) ([]LogMakeEntity, error) {
	var entities []LogMakeEntity
	for _, log := range logs {
		var entity LogMakeEntity
		address := log.Log.Address
		abi, parseErr := eth.ParseAbi(contractAbi)
		if parseErr != nil {
			return nil, parseErr
		}

		contract := bind.NewBoundContract(address, abi, nil, nil, nil)
		unpackErr := contract.UnpackLog(&entity, "LogMake", log.Log)
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
	for _, entity := range entities {
		addressID, addressErr := repository.GetOrCreateAddress(db, entity.ContractAddress.Hex())
		if addressErr != nil {
			return nil, shared.ErrCouldNotCreateFK(addressErr)
		}
		makerID, oasisErr := repository.GetOrCreateAddress(db, entity.Maker.Hex())
		if oasisErr != nil {
			return nil, shared.ErrCouldNotCreateFK(oasisErr)
		}
		payGemID, payGemErr := repository.GetOrCreateAddress(db, entity.PayGem.Hex())
		if payGemErr != nil {
			return nil, shared.ErrCouldNotCreateFK(payGemErr)
		}
		buyGemID, buyGemErr := repository.GetOrCreateAddress(db, entity.BuyGem.Hex())
		if buyGemErr != nil {
			return nil, shared.ErrCouldNotCreateFK(buyGemErr)
		}
		offerID := big.NewInt(0).SetBytes(entity.Id[:])
		model := event.InsertionModel{
			SchemaName: constants.OasisSchema,
			TableName:  constants.LogMakeTable,
			OrderedColumns: []event.ColumnName{
				event.HeaderFK, event.LogFK, event.AddressFK, constants.OfferId, constants.PairColumn,
				constants.MakerColumn, constants.PayGemColumn, constants.BuyGemColumn, constants.PayAmtColumn,
				constants.BuyAmtColumn, constants.TimestampColumn,
			},
			ColumnValues: event.ColumnValues{
				event.HeaderFK:            entity.HeaderID,
				event.LogFK:               entity.LogID,
				event.AddressFK:           addressID,
				constants.OfferId:         shared.BigIntToString(offerID),
				constants.PairColumn:      entity.Pair.Hex(),
				constants.MakerColumn:     makerID,
				constants.PayGemColumn:    payGemID,
				constants.BuyGemColumn:    buyGemID,
				constants.PayAmtColumn:    shared.BigIntToString(entity.PayAmt),
				constants.BuyAmtColumn:    shared.BigIntToString(entity.BuyAmt),
				constants.TimestampColumn: strconv.FormatUint(entity.Timestamp, 10),
			},
		}
		models = append(models, model)
	}
	return models, nil
}
