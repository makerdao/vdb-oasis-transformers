package constants

import (
	"github.com/ethereum/go-ethereum/crypto"
)

func LogBumpSignature() string            { return getEventTopicZero(logBumpEvent()) }
func LogBuyEnabledSignature() string      { return getEventTopicZero(logBuyEnabledEvent()) }
func LogDeleteSignature() string          { return getEventTopicZero(logDeleteEvent()) }
func LogInsertSignature() string          { return getEventTopicZero(logInsertEvent()) }
func LogItemUpdateSignature() string      { return getEventTopicZero(logItemUpdateEvent()) }
func LogKillSignature() string            { return getEventTopicZero(logKillEvent()) }
func LogMakeSignature() string            { return getEventTopicZero(logMakeEvent()) }
func LogMatchingEnabledSignature() string { return getEventTopicZero(logMatchingEnabledEvent()) }
func LogMinSellSignature() string         { return getEventTopicZero(logMinSellEvent()) }
func LogSortedOfferSignature() string     { return getEventTopicZero(logSortedOfferMethod()) }
func LogTakeSignature() string            { return getEventTopicZero(logTakeEvent()) }
func LogTradeSignature() string           { return getEventTopicZero(logTradeEvent()) }
func LogUnsortedOfferSignature() string   { return getEventTopicZero(logUnsortedOfferMethod()) }
func SetMinSellSignature() string         { return getLogNoteTopicZero(setMinSellMethod()) }

func getEventTopicZero(solidityEventSignature string) string {
	eventSignature := []byte(solidityEventSignature)
	hash := crypto.Keccak256Hash(eventSignature)
	return hash.Hex()
}

func getLogNoteTopicZero(solidityFunctionSignature string) string {
	rawSignature := getEventTopicZero(solidityFunctionSignature)
	return "0x" + rawSignature[2:10] + "00000000000000000000000000000000000000000000000000000000"
}

func logBumpEvent() string       { return getSolidityFunctionSignature(OasisABI(), "LogBump") }
func logBuyEnabledEvent() string { return getSolidityFunctionSignature(OasisABI(), "LogBuyEnabled") }
func logDeleteEvent() string     { return getSolidityFunctionSignature(OasisABI(), "LogDelete") }
func logInsertEvent() string     { return getSolidityFunctionSignature(OasisABI(), "LogInsert") }
func logItemUpdateEvent() string { return getSolidityFunctionSignature(OasisABI(), "LogItemUpdate") }
func logKillEvent() string       { return getSolidityFunctionSignature(OasisABI(), "LogKill") }
func logMakeEvent() string       { return getSolidityFunctionSignature(OasisABI(), "LogMake") }
func logMatchingEnabledEvent() string {
	return getSolidityFunctionSignature(OasisABI(), "LogMatchingEnabled")
}
func logMinSellEvent() string      { return getSolidityFunctionSignature(OasisABI(), "LogMinSell") }
func logSortedOfferMethod() string { return getSolidityFunctionSignature(OasisABI(), "LogSortedOffer") }
func logTakeEvent() string         { return getSolidityFunctionSignature(OasisABI(), "LogTake") }
func logTradeEvent() string        { return getSolidityFunctionSignature(OasisABI(), "LogTrade") }
func logUnsortedOfferMethod() string {
	return getSolidityFunctionSignature(OasisABI(), "LogUnsortedOffer")
}
func setMinSellMethod() string { return getSolidityFunctionSignature(OasisABI(), "setMinSell") }
