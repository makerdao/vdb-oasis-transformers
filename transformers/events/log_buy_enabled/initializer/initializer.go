package initializer

import (
	"github.com/makerdao/vdb-oasis-transformers/transformers/events/log_buy_enabled"
	"github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vdb-transformer-utilities/pkg/shared"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
)

var EventTransformerInitializer event.TransformerInitializer = event.ConfiguredTransformer{
	Config:      shared.GetEventTransformerConfig(constants.LogBuyEnabledTable, constants.LogBuyEnabledSignature()),
	Transformer: log_buy_enabled.Transformer{},
}.NewTransformer
