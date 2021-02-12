package integration_tests

import (
	"github.com/ethereum/go-ethereum/common"
	"github.com/makerdao/vdb-oasis-transformers/test_config"
	"github.com/makerdao/vdb-oasis-transformers/transformers/events/log_unsorted_offer"
	oasisConstants "github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vdb-oasis-transformers/transformers/test_data"
	"github.com/makerdao/vdb-transformer-utilities/pkg/shared/constants"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
	"github.com/makerdao/vulcanizedb/libraries/shared/fetcher"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("LogUnsortedOffer Transformer", func() {
	logUnsortedOfferConfig := event.TransformerConfig{
		TransformerName:   oasisConstants.LogUnsortedOfferTable,
		ContractAddresses: test_data.OasisAddresses(),
		ContractAbi:       oasisConstants.OasisABI(),
		Topic:             oasisConstants.LogUnsortedOfferSignature(),
	}

	It("fetches and transforms a LogUnsortedOffer event for OASIS_MATCHING_MARKET_ONE contract", func() {
		blockNumber := int64(9243052)
		logUnsortedOfferConfig.StartingBlockNumber = blockNumber
		logUnsortedOfferConfig.EndingBlockNumber = blockNumber

		test_config.CleanTestDB(db)

		header, err := persistHeader(db, blockNumber, blockChain)
		Expect(err).NotTo(HaveOccurred())

		initializer := event.ConfiguredTransformer{
			Config:      logUnsortedOfferConfig,
			Transformer: log_unsorted_offer.Transformer{},
		}
		transformer := initializer.NewTransformer(db)

		oasisOneAddress := constants.GetContractAddress("OASIS_MATCHING_MARKET_ONE")
		logFetcher := fetcher.NewLogFetcher(blockChain)
		logs, err := logFetcher.FetchLogs(
			[]common.Address{common.HexToAddress(oasisOneAddress)},
			[]common.Hash{common.HexToHash(logUnsortedOfferConfig.Topic)},
			header)
		Expect(err).NotTo(HaveOccurred())

		eventLogs := test_data.CreateLogs(header.Id, logs, db)

		err = transformer.Execute(eventLogs)
		Expect(err).NotTo(HaveOccurred())

		var dbResult []string
		err = db.Select(&dbResult, `SELECT offer_id FROM oasis.log_unsorted_offer`)
		Expect(err).NotTo(HaveOccurred())

		Expect(dbResult).To(ConsistOf("717050"))
	})

	It("fetches and transforms a LogUnsortedOffer event for OASIS_MATCHING_MARKET_TWO contract", func() {
		blockNumber := int64(11731131)
		logUnsortedOfferConfig.StartingBlockNumber = blockNumber
		logUnsortedOfferConfig.EndingBlockNumber = blockNumber

		test_config.CleanTestDB(db)

		header, err := persistHeader(db, blockNumber, blockChain)
		Expect(err).NotTo(HaveOccurred())

		initializer := event.ConfiguredTransformer{
			Config:      logUnsortedOfferConfig,
			Transformer: log_unsorted_offer.Transformer{},
		}
		transformer := initializer.NewTransformer(db)

		oasisTwoAddress := constants.GetContractAddress("OASIS_MATCHING_MARKET_TWO")
		logFetcher := fetcher.NewLogFetcher(blockChain)
		logs, err := logFetcher.FetchLogs(
			[]common.Address{common.HexToAddress(oasisTwoAddress)},
			[]common.Hash{common.HexToHash(logUnsortedOfferConfig.Topic)},
			header)
		Expect(err).NotTo(HaveOccurred())

		eventLogs := test_data.CreateLogs(header.Id, logs, db)

		err = transformer.Execute(eventLogs)
		Expect(err).NotTo(HaveOccurred())

		var dbResult []string
		err = db.Select(&dbResult, `SELECT offer_id FROM oasis.log_unsorted_offer`)
		Expect(err).NotTo(HaveOccurred())

		Expect(dbResult).To(ConsistOf("423546"))
	})
})
