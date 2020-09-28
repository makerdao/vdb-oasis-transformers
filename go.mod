module github.com/makerdao/vdb-oasis-transformers

go 1.15

require (
	github.com/ethereum/go-ethereum v1.9.21
	github.com/makerdao/vulcanizedb v0.0.15-rc.1.0.20200929150240-775fa162b520
	github.com/onsi/ginkgo v1.14.0
	github.com/onsi/gomega v1.10.1
	github.com/sirupsen/logrus v1.2.0
	github.com/spf13/viper v1.3.2
)

replace github.com/ethereum/go-ethereum => github.com/makerdao/go-ethereum v1.9.21-rc1
