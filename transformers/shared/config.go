package shared

import (
	"github.com/makerdao/oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
)

// Creates a transformer config by pulling values from configuration environment
func GetEventTransformerConfig(transformerLabel, signature string) event.TransformerConfig {
	contractNames := constants.GetTransformerContractNames(transformerLabel)
	return event.TransformerConfig{
		TransformerName:     transformerLabel,
		ContractAddresses:   constants.GetContractAddresses(contractNames),
		ContractAbi:         constants.GetFirstABI(contractNames),
		Topic:               signature,
		StartingBlockNumber: constants.GetMinDeploymentBlock(contractNames),
		EndingBlockNumber:   -1, // TODO Generalise endingBlockNumber
	}
}
