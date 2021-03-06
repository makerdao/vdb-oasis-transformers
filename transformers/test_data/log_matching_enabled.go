package test_data

import (
	"math/rand"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/common/hexutil"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
	"github.com/makerdao/vulcanizedb/pkg/core"
	"github.com/makerdao/vulcanizedb/pkg/fakes"
)

var (
	logMatchingEnabledRawLog = types.Log{
		Address:     common.HexToAddress(OasisAddresses()[0]),
		Topics:      []common.Hash{common.HexToHash(constants.LogMatchingEnabledSignature())},
		Data:        hexutil.MustDecode("0x0000000000000000000000000000000000000000000000000000000000000001"),
		BlockNumber: 9824070,
		TxHash:      common.HexToHash("0x6aef663b8483d1183faf1efee4501c27182c8496c1cb1615868af5cd324d2028"),
		TxIndex:     0,
		BlockHash:   fakes.FakeHash,
		Index:       0,
		Removed:     false,
	}

	LogMatchingEnabledEventLog = core.EventLog{
		ID:          rand.Int63(),
		HeaderID:    rand.Int63(),
		Log:         logMatchingEnabledRawLog,
		Transformed: false,
	}

	logMatchingEnabledModel = event.InsertionModel{
		SchemaName: constants.OasisSchema,
		TableName:  constants.LogMatchingEnabledTable,
		OrderedColumns: []event.ColumnName{
			event.HeaderFK, event.LogFK, event.AddressFK, constants.IsEnabled,
		},
		ColumnValues: event.ColumnValues{
			event.HeaderFK:      LogMatchingEnabledEventLog.HeaderID,
			event.LogFK:         LogMatchingEnabledEventLog.ID,
			constants.IsEnabled: true,
		},
	}
)

func LogMatchingEnabledModel() event.InsertionModel { return CopyModel(logMatchingEnabledModel) }
