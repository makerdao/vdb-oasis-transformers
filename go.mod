module github.com/makerdao/vdb-oasis-transformers

go 1.15

require (
	github.com/ethereum/go-ethereum v1.9.25
	github.com/makerdao/vdb-transformer-utilities v0.0.0-20201021185605-2af87288ff1b
	github.com/makerdao/vulcanizedb v0.1.1-0.20210805161603-596acd52e7ee
	github.com/onsi/ginkgo v1.14.1
	github.com/onsi/gomega v1.10.2
	github.com/sirupsen/logrus v1.7.0
	github.com/spf13/viper v1.7.1
)

replace github.com/ethereum/go-ethereum => github.com/makerdao/go-ethereum v1.10.6-vdb-go-ethereum
