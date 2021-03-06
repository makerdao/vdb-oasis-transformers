package log_kill

import (
	"fmt"
	"math/big"
	"strconv"

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

func (Transformer) toEntities(contractAbi string, logs []core.EventLog) ([]LogKillEntity, error) {
	var entities []LogKillEntity
	for _, log := range logs {
		var entity LogKillEntity
		address := log.Log.Address
		abi, parseErr := eth.ParseAbi(contractAbi)
		if parseErr != nil {
			return nil, parseErr
		}

		contract := bind.NewBoundContract(address, abi, nil, nil, nil)
		unpackErr := contract.UnpackLog(&entity, "LogKill", log.Log)
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
		contractAddressId, contractAddressErr := repository.GetOrCreateAddress(db, entity.ContractAddress.Hex())
		if contractAddressErr != nil {
			return nil, shared.ErrCouldNotCreateFK(contractAddressErr)
		}

		makerAddressID, makerAddressErr := repository.GetOrCreateAddress(db, entity.Maker.Hex())
		if makerAddressErr != nil {
			return nil, shared.ErrCouldNotCreateFK(makerAddressErr)
		}

		payGemAddressId, payGemAddressErr := repository.GetOrCreateAddress(db, entity.PayGem.Hex())
		if payGemAddressErr != nil {
			return nil, shared.ErrCouldNotCreateFK(payGemAddressErr)
		}

		buyGemAddressId, buyGemAddressErr := repository.GetOrCreateAddress(db, entity.BuyGem.Hex())
		if buyGemAddressErr != nil {
			return nil, shared.ErrCouldNotCreateFK(buyGemAddressErr)
		}

		offerID := big.NewInt(0).SetBytes(entity.Id[:])

		model := event.InsertionModel{
			SchemaName: constants.OasisSchema,
			TableName:  constants.LogKillTable,
			OrderedColumns: []event.ColumnName{
				event.HeaderFK,
				event.LogFK,
				event.AddressFK,
				constants.OfferId,
				constants.PairColumn,
				constants.MakerColumn,
				constants.PayGemColumn,
				constants.BuyGemColumn,
				constants.PayAmtColumn,
				constants.BuyAmtColumn,
				constants.TimestampColumn,
			},
			ColumnValues: event.ColumnValues{
				event.HeaderFK:            entity.HeaderID,
				event.LogFK:               entity.LogID,
				event.AddressFK:           contractAddressId,
				constants.OfferId:         shared.BigIntToString(offerID),
				constants.PairColumn:      entity.Pair.Hex(),
				constants.MakerColumn:     makerAddressID,
				constants.PayGemColumn:    payGemAddressId,
				constants.BuyGemColumn:    buyGemAddressId,
				constants.PayAmtColumn:    shared.BigIntToString(entity.PayAmt),
				constants.BuyAmtColumn:    shared.BigIntToString(entity.BuyAmt),
				constants.TimestampColumn: strconv.FormatUint(entity.Timestamp, 10),
			},
		}
		models = append(models, model)
	}
	return models, nil
}
