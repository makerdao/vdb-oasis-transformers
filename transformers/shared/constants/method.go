package constants

import (
	"fmt"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/makerdao/vulcanizedb/pkg/eth"
	"github.com/sirupsen/logrus"
	"strings"
)

func getSolidityFunctionSignature(abi, name string) string {
	parsedAbi, _ := eth.ParseAbi(abi)

	if method, ok := parsedAbi.Methods[name]; ok {
		return method.Sig
	} else if event, ok := parsedAbi.Events[name]; ok {
		return getEventSignature(event)
	}
	panic("Error: could not get Solidity method signature for: " + name)
}

func OasisABI() string {
	return GetABIFromContractsWithMatchingABI([]string{"OASIS_MATCHING_MARKET_ONE", "OASIS_MATCHING_MARKET_TWO"})
}

// GetABIFromContractsWithMatchingABI gets the ABI for multiple contracts from config
// Makes sure the ABI matches for all, since a single transformer may run against many contracts.
func GetABIFromContractsWithMatchingABI(contractNames []string) string {
	if len(contractNames) < 1 {
		logrus.Fatalf("No contracts to get ABI for")
	}
	initConfig()
	contractABI := getContractABI(contractNames[0])
	parsedABI, parseErr := eth.ParseAbi(contractABI)
	if parseErr != nil {
		panic(fmt.Sprintf("unable to parse ABI for %s", contractNames[0]))
	}
	for _, contractName := range contractNames[1:] {
		nextABI := getContractABI(contractName)
		nextParsedABI, nextParseErr := eth.ParseAbi(nextABI)
		if nextParseErr != nil {
			panic(fmt.Sprintf("unable to parse ABI for %s", contractName))
		}
		if !parsedABIsAreEqual(parsedABI, nextParsedABI) {
			panic(fmt.Sprintf("ABIs don't match for contracts: %s", contractNames))
		}
	}
	return contractABI
}

func parsedABIsAreEqual(a, b abi.ABI) bool {
	if a.Constructor.String() != b.Constructor.String() {
		return false
	}
OuterMethods:
	for ak, av := range a.Methods {
		for bk, bv := range b.Methods {
			if ak == bk && av.String() == bv.String() {
				continue OuterMethods
			}
		}
		return false
	}
OuterEvents:
	for ak, av := range a.Events {
		for bk, bv := range b.Events {
			if ak == bk && av.String() == bv.String() {
				continue OuterEvents
			}
		}
		return false
	}
	return true
}

func getEventSignature(event abi.Event) string {
	types := make([]string, len(event.Inputs))
	for i, input := range event.Inputs {
		types[i] = input.Type.String()
		i++
	}

	return fmt.Sprintf("%v(%v)", event.Name, strings.Join(types, ","))
}
