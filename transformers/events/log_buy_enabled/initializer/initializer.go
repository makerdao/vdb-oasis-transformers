package initializer

import (
	"github.com/makerdao/oasis-transformers/transformers/events/log_buy_enabled"
	"github.com/makerdao/oasis-transformers/transformers/shared"
	"github.com/makerdao/oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
)

var EventTransformerInitializer event.TransformerInitializer = event.ConfiguredTransformer{
	Config:      shared.GetEventTransformerConfig(constants.LogBuyEnabledTable, constants.LogBuyEnabledSignature()),
	Transformer: log_buy_enabled.Transformer{},
}.NewTransformer
