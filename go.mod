module github.com/makerdao/vdb-oasis-transformers

go 1.14

require (
	github.com/ethereum/go-ethereum v1.9.21
	github.com/inconshreveable/mousetrap v1.0.0 // indirect
	github.com/makerdao/vulcanizedb v0.0.15-rc.1.0.20200918180306-840fe560616a
	github.com/onsi/ginkgo v1.14.0
	github.com/onsi/gomega v1.10.1
	github.com/sirupsen/logrus v1.7.0
	github.com/spf13/viper v1.3.2
	github.com/stretchr/objx v0.1.1 // indirect
)

replace github.com/ethereum/go-ethereum => github.com/makerdao/go-ethereum v1.9.21-rc1

replace github.com/makerdao/vulcanizedb => ../vulcanizedb
