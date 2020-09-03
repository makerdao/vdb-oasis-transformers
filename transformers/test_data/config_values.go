package test_data

import (
	"github.com/ethereum/go-ethereum/common"
	"github.com/makerdao/oasis-transformers/transformers/shared/constants"
)

func OasisAddresses() []string {
	var addressesResult []string
	oasisAddresses := constants.GetContractAddresses([]string{"OASIS_MATCHING_MARKET_ONE", "OASIS_MATCHING_MARKET_TWO"})

	for _, address := range oasisAddresses {
		addressesResult = append(addressesResult, checksum(address))
	}
	return addressesResult
}

func checksum(addressString string) string {
	return common.HexToAddress(addressString).Hex()
}
