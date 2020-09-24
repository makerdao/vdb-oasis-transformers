// This is a plugin generated to export the configured transformer initializers

package main

import (
	log_bump "github.com/makerdao/vdb-oasis-transformers/transformers/events/log_bump/initializer"
	log_buy_enabled "github.com/makerdao/vdb-oasis-transformers/transformers/events/log_buy_enabled/initializer"
	log_delete "github.com/makerdao/vdb-oasis-transformers/transformers/events/log_delete/initializer"
	log_insert "github.com/makerdao/vdb-oasis-transformers/transformers/events/log_insert/initializer"
	log_item_update "github.com/makerdao/vdb-oasis-transformers/transformers/events/log_item_update/initializer"
	log_kill "github.com/makerdao/vdb-oasis-transformers/transformers/events/log_kill/initializer"
	log_make "github.com/makerdao/vdb-oasis-transformers/transformers/events/log_make/initializer"
	log_matching_enabled "github.com/makerdao/vdb-oasis-transformers/transformers/events/log_matching_enabled/initializer"
	log_min_sell "github.com/makerdao/vdb-oasis-transformers/transformers/events/log_min_sell/initializer"
	log_sorted_offer "github.com/makerdao/vdb-oasis-transformers/transformers/events/log_sorted_offer/initializer"
	log_take "github.com/makerdao/vdb-oasis-transformers/transformers/events/log_take/initializer"
	log_trade "github.com/makerdao/vdb-oasis-transformers/transformers/events/log_trade/initializer"
	log_unsorted_offer "github.com/makerdao/vdb-oasis-transformers/transformers/events/log_unsorted_offer/initializer"
	set_min_sell "github.com/makerdao/vdb-oasis-transformers/transformers/events/set_min_sell/initializer"
	event "github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
	storage "github.com/makerdao/vulcanizedb/libraries/shared/factories/storage"
	interface1 "github.com/makerdao/vulcanizedb/libraries/shared/transformer"
)

type exporter string

var Exporter exporter

func (e exporter) Export() ([]event.TransformerInitializer, []storage.TransformerInitializer, []interface1.ContractTransformerInitializer) {
	return []event.TransformerInitializer{log_item_update.EventTransformerInitializer, log_min_sell.EventTransformerInitializer, log_sorted_offer.EventTransformerInitializer, log_unsorted_offer.EventTransformerInitializer, log_matching_enabled.EventTransformerInitializer, log_bump.EventTransformerInitializer, log_insert.EventTransformerInitializer, log_kill.EventTransformerInitializer, log_make.EventTransformerInitializer, log_delete.EventTransformerInitializer, log_take.EventTransformerInitializer, log_trade.EventTransformerInitializer, log_buy_enabled.EventTransformerInitializer, set_min_sell.EventTransformerInitializer}, []storage.TransformerInitializer{}, []interface1.ContractTransformerInitializer{}
}
