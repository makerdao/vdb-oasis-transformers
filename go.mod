module github.com/makerdao/vdb-oasis-transformers

go 1.15

require (
	github.com/ethereum/go-ethereum v1.10.8
	github.com/makerdao/vdb-transformer-utilities v0.0.1
	github.com/makerdao/vulcanizedb v0.1.2
	github.com/onsi/ginkgo v1.14.1
	github.com/onsi/gomega v1.10.2
	github.com/sirupsen/logrus v1.7.0
	github.com/spf13/viper v1.7.1
)

replace github.com/ethereum/go-ethereum => github.com/makerdao/go-ethereum v1.10.8-vdb-go-ethereum
