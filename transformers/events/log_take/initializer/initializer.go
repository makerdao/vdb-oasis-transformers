package initializer

import (
	"github.com/makerdao/oasis-transformers/transformers/events/log_take"
	"github.com/makerdao/oasis-transformers/transformers/shared"
	"github.com/makerdao/oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
)

var EventTransformerInitializer event.TransformerInitializer = event.ConfiguredTransformer{
	Config:      shared.GetEventTransformerConfig(constants.LogTakeTable, constants.LogTakeSignature()),
	Transformer: log_take.Transformer{},
}.NewTransformer
