package initializer

import (
	"github.com/makerdao/vdb-oasis-transformers/transformers/events/log_make"
	"github.com/makerdao/vdb-oasis-transformers/transformers/shared"
	"github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
)

var EventTransformerInitializer event.TransformerInitializer = event.ConfiguredTransformer{
	Config:      shared.GetEventTransformerConfig(constants.LogMakeTable, constants.LogMakeSignature()),
	Transformer: log_make.Transformer{},
}.NewTransformer
