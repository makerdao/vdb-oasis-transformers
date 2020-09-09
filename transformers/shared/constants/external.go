package constants

import (
	"fmt"
	"math"

	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"
)

var initialized = false

func initConfig() {
	if initialized {
		return
	}

	if err := viper.ReadInConfig(); err == nil {
		logrus.Info("Using config file:", viper.ConfigFileUsed())
	} else {
		panic(fmt.Sprintf("Could not find environment file: %v", err))
	}
	initialized = true
}

// Get the addresses for multiple contracts from config
func GetContractAddresses(contractNames []string) (addresses []string) {
	if len(contractNames) < 1 {
		logrus.Fatalf("No contracts supplied")
	}
	initConfig()
	for _, contractName := range contractNames {
		addresses = append(addresses, GetContractAddress(contractName))
	}
	return
}

func GetContractAddress(contract string) string {
	return getEnvironmentString("contract." + contract + ".address")
}

func getEnvironmentString(key string) string {
	initConfig()
	value := viper.GetString(key)
	if value == "" {
		logrus.Fatalf("No environment configuration variable set for key: \"%v\"", key)
	}
	return value
}

/* Returns all contract config names from transformer configuration:
[exporter.vow_file]
	path = "transformers/events/vow_file/initializer"
	type = "eth_event"
	repository = "github.com/makerdao/vdb-oasis-transformers"
	migrations = "db/migrations"
	contracts = ["MCD_VOW"]   <----
	rank = "0"
*/
func GetTransformerContractNames(transformerLabel string) []string {
	initConfig()
	configKey := "exporter." + transformerLabel + ".contracts"
	contracts := viper.GetStringSlice(configKey)
	if len(contracts) == 0 {
		logrus.Fatalf("No contracts configured for transformer: \"%v\"", transformerLabel)
	}
	return contracts
}

// GetFirstABI returns the ABI from the first contract in a collection in config
func GetFirstABI(contractNames []string) string {
	if len(contractNames) < 1 {
		logrus.Fatalf("No contracts to get ABI for")
	}
	initConfig()
	return getContractABI(contractNames[0])
}

func getContractABI(contractName string) string {
	configKey := "contract." + contractName + ".abi"
	contractABI := viper.GetString(configKey)
	if contractABI == "" {
		logrus.Fatalf("No ABI configured for contract: \"%v\"", contractName)
	}
	return contractABI
}

// Get the minimum deployment block for multiple contracts from config
func GetMinDeploymentBlock(contractNames []string) int64 {
	if len(contractNames) < 1 {
		logrus.Fatalf("No contracts supplied")
	}
	initConfig()
	minBlock := int64(math.MaxInt64)
	for _, c := range contractNames {
		deployed := getDeploymentBlock(c)
		if deployed < minBlock {
			minBlock = deployed
		}
	}
	return minBlock
}

func getDeploymentBlock(contractName string) int64 {
	configKey := "contract." + contractName + ".deployed"
	value := viper.GetInt64(configKey)
	if value == -1 {
		logrus.Infof("No deployment block configured for contract \"%v\", defaulting to 0.", contractName)
		return 0
	}
	return value
}
