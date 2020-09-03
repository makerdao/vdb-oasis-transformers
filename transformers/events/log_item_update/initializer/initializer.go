package initializer

import (
	"github.com/makerdao/oasis-transformers/transformers/events/log_item_update"
	"github.com/makerdao/oasis-transformers/transformers/shared"
	"github.com/makerdao/oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
)

var EventTransformerInitializer event.TransformerInitializer = event.ConfiguredTransformer{
	Config:      shared.GetEventTransformerConfig(constants.LogItemUpdateTable, constants.LogItemUpdateSignature()),
	Transformer: log_item_update.Transformer{},
}.NewTransformer
