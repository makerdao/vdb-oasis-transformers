package constants

import (
	"github.com/makerdao/vdb-transformer-utilities/pkg/shared/constants"
)

func OasisABI() string {
	return constants.GetABIFromContractsWithMatchingABI([]string{"OASIS_MATCHING_MARKET_ONE", "OASIS_MATCHING_MARKET_TWO"})
}

func OasisABI1_1() string {
	return constants.GetABIFromContractsWithMatchingABI([]string{"OASIS_MATCHING_MARKET_1_1"})
}
