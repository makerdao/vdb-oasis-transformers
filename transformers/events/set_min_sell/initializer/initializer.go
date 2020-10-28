package initializer

import (
	"github.com/makerdao/vdb-oasis-transformers/transformers/events/set_min_sell"
	"github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vdb-transformer-utilities/pkg/shared"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
)

var EventTransformerInitializer event.TransformerInitializer = event.ConfiguredTransformer{
	Config:      shared.GetEventTransformerConfig(constants.SetMinSellTable, constants.SetMinSellSignature()),
	Transformer: set_min_sell.Transformer{},
}.NewTransformer
