package constants

import (
	"github.com/makerdao/vdb-transformer-utilities/pkg/shared/constants"
)

func LogBumpSignature() string       { return constants.GetEventTopicZero(logBumpEvent()) }
func LogBuyEnabledSignature() string { return constants.GetEventTopicZero(logBuyEnabledEvent()) }
func LogDeleteSignature() string     { return constants.GetEventTopicZero(logDeleteEvent()) }
func LogInsertSignature() string     { return constants.GetEventTopicZero(logInsertEvent()) }
func LogItemUpdateSignature() string { return constants.GetEventTopicZero(logItemUpdateEvent()) }
func LogKillSignature() string       { return constants.GetEventTopicZero(logKillEvent()) }
func LogMakeSignature() string       { return constants.GetEventTopicZero(logMakeEvent()) }
func LogMatchingEnabledSignature() string {
	return constants.GetEventTopicZero(logMatchingEnabledEvent())
}
func LogMinSellSignature() string       { return constants.GetEventTopicZero(logMinSellEvent()) }
func LogSortedOfferSignature() string   { return constants.GetEventTopicZero(logSortedOfferMethod()) }
func LogTakeSignature() string          { return constants.GetEventTopicZero(logTakeEvent()) }
func LogTradeSignature() string         { return constants.GetEventTopicZero(logTradeEvent()) }
func LogUnsortedOfferSignature() string { return constants.GetEventTopicZero(logUnsortedOfferMethod()) }
func SetMinSellSignature() string       { return getLogNoteTopicZero(setMinSellMethod()) }

func getLogNoteTopicZero(solidityFunctionSignature string) string {
	rawSignature := constants.GetEventTopicZero(solidityFunctionSignature)
	return "0x" + rawSignature[2:10] + "00000000000000000000000000000000000000000000000000000000"
}

func logBumpEvent() string { return constants.GetSolidityFunctionSignature(OasisABI(), "LogBump") }
func logBuyEnabledEvent() string {
	return constants.GetSolidityFunctionSignature(OasisABI(), "LogBuyEnabled")
}
func logDeleteEvent() string { return constants.GetSolidityFunctionSignature(OasisABI(), "LogDelete") }
func logInsertEvent() string { return constants.GetSolidityFunctionSignature(OasisABI(), "LogInsert") }
func logItemUpdateEvent() string {
	return constants.GetSolidityFunctionSignature(OasisABI(), "LogItemUpdate")
}
func logKillEvent() string { return constants.GetSolidityFunctionSignature(OasisABI(), "LogKill") }
func logMakeEvent() string { return constants.GetSolidityFunctionSignature(OasisABI(), "LogMake") }
func logMatchingEnabledEvent() string {
	return constants.GetSolidityFunctionSignature(OasisABI(), "LogMatchingEnabled")
}
func logMinSellEvent() string {
	return constants.GetSolidityFunctionSignature(OasisABI(), "LogMinSell")
}
func logSortedOfferMethod() string {
	return constants.GetSolidityFunctionSignature(OasisABI(), "LogSortedOffer")
}
func logTakeEvent() string  { return constants.GetSolidityFunctionSignature(OasisABI(), "LogTake") }
func logTradeEvent() string { return constants.GetSolidityFunctionSignature(OasisABI(), "LogTrade") }
func logUnsortedOfferMethod() string {
	return constants.GetSolidityFunctionSignature(OasisABI(), "LogUnsortedOffer")
}
func setMinSellMethod() string {
	return constants.GetSolidityFunctionSignature(OasisABI(), "setMinSell")
}
