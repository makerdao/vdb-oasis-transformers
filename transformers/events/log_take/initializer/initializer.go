package initializer

import (
	"github.com/makerdao/vdb-oasis-transformers/transformers/events/log_take"
	"github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vdb-transformer-utilities/pkg/shared"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
)

var EventTransformerInitializer event.TransformerInitializer = event.ConfiguredTransformer{
	Config:      shared.GetEventTransformerConfig(constants.LogTakeTable, constants.LogTakeSignature()),
	Transformer: log_take.Transformer{},
}.NewTransformer
