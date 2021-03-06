package integration_tests

import (
	"sort"

	"github.com/ethereum/go-ethereum/common"
	"github.com/makerdao/vdb-oasis-transformers/test_config"
	"github.com/makerdao/vdb-oasis-transformers/transformers/events/log_min_sell"
	oasisConstants "github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vdb-oasis-transformers/transformers/test_data"
	"github.com/makerdao/vdb-transformer-utilities/pkg/shared/constants"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
	"github.com/makerdao/vulcanizedb/libraries/shared/fetcher"
	"github.com/makerdao/vulcanizedb/libraries/shared/repository"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("LogMinSell Transformer", func() {
	config := event.TransformerConfig{
		TransformerName:   oasisConstants.LogMinSellTable,
		ContractAddresses: test_data.OasisAddresses(),
		ContractAbi:       oasisConstants.OasisABI(),
		Topic:             oasisConstants.LogMinSellSignature(),
	}

	It("fetches and transforms a LogMinSell event for OASIS_MATCHING_MARKET_ONE contract", func() {
		blockNumber := int64(8944595)
		config.StartingBlockNumber = blockNumber
		config.EndingBlockNumber = blockNumber

		test_config.CleanTestDB(db)

		header, err := persistHeader(db, blockNumber, blockChain)
		Expect(err).NotTo(HaveOccurred())

		initializer := event.ConfiguredTransformer{
			Config:      config,
			Transformer: log_min_sell.Transformer{},
		}
		transformer := initializer.NewTransformer(db)

		oasis_one_address := constants.GetContractAddress("OASIS_MATCHING_MARKET_ONE")
		logFetcher := fetcher.NewLogFetcher(blockChain)
		logs, err := logFetcher.FetchLogs(
			[]common.Address{common.HexToAddress(oasis_one_address)},
			[]common.Hash{common.HexToHash(config.Topic)},
			header)
		Expect(err).NotTo(HaveOccurred())

		eventLogs := test_data.CreateLogs(header.Id, logs, db)

		err = transformer.Execute(eventLogs)
		Expect(err).NotTo(HaveOccurred())

		var dbResults []logMinSellModel
		err = db.Select(&dbResults, `SELECT pay_gem, min_amount, address_id from oasis.log_min_sell`)
		Expect(err).NotTo(HaveOccurred())

		expectedAddressID, addressErr := repository.GetOrCreateAddress(db, oasis_one_address)
		Expect(addressErr).NotTo(HaveOccurred())
		expectedPayGemID, payGemErr := repository.GetOrCreateAddress(db, "0x6B175474E89094C44Da98b954EedeAC495271d0F")
		Expect(payGemErr).NotTo(HaveOccurred())

		Expect(len(dbResults)).To(Equal(1))
		dbResult := dbResults[0]
		Expect(dbResult.PayGem).To(Equal(expectedPayGemID))
		Expect(dbResult.MinAmount).To(Equal("2000000000000000000"))
		Expect(dbResult.AddressID).To(Equal(expectedAddressID))
	})

	It("fetches and transforms a LogMinSell event for OASIS_MATCHING_MARKET_TWO contract", func() {
		blockNumber := int64(9604711)
		config.StartingBlockNumber = blockNumber
		config.EndingBlockNumber = blockNumber

		test_config.CleanTestDB(db)

		header, err := persistHeader(db, blockNumber, blockChain)
		Expect(err).NotTo(HaveOccurred())

		initializer := event.ConfiguredTransformer{
			Config:      config,
			Transformer: log_min_sell.Transformer{},
		}
		transformer := initializer.NewTransformer(db)

		oasisTwoAddress := constants.GetContractAddress("OASIS_MATCHING_MARKET_TWO")
		logFetcher := fetcher.NewLogFetcher(blockChain)
		logs, err := logFetcher.FetchLogs(
			[]common.Address{common.HexToAddress(oasisTwoAddress)},
			[]common.Hash{common.HexToHash(config.Topic)},
			header)
		Expect(err).NotTo(HaveOccurred())

		eventLogs := test_data.CreateLogs(header.Id, logs, db)

		err = transformer.Execute(eventLogs)
		Expect(err).NotTo(HaveOccurred())

		var dbResults []logMinSellModel
		err = db.Select(&dbResults, `SELECT pay_gem, min_amount, address_id from oasis.log_min_sell`)
		Expect(err).NotTo(HaveOccurred())

		expectedAddressID, addressErr := repository.GetOrCreateAddress(db, oasisTwoAddress)
		Expect(addressErr).NotTo(HaveOccurred())
		expectedPayGemID, payGemErr := repository.GetOrCreateAddress(db, "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599")
		Expect(payGemErr).NotTo(HaveOccurred())

		Expect(len(dbResults)).To(Equal(2))
		sort.Sort(byMinAmount(dbResults))
		dbResult := dbResults[0]
		Expect(dbResult.PayGem).To(Equal(expectedPayGemID))
		Expect(dbResult.MinAmount).To(Equal("21786"))
		Expect(dbResult.AddressID).To(Equal(expectedAddressID))
	})

	It("fetches and transforms a LogMinSell event for OASIS_MATCHING_MARKET_1_1 contract", func() {
		blockNumber := int64(11752276)
		config.StartingBlockNumber = blockNumber
		config.EndingBlockNumber = blockNumber

		test_config.CleanTestDB(db)

		header, err := persistHeader(db, blockNumber, blockChain)
		Expect(err).NotTo(HaveOccurred())

		initializer := event.ConfiguredTransformer{
			Config:      config,
			Transformer: log_min_sell.Transformer{},
		}
		transformer := initializer.NewTransformer(db)

		oasis11Address := constants.GetContractAddress("OASIS_MATCHING_MARKET_1_1")
		logFetcher := fetcher.NewLogFetcher(blockChain)
		logs, err := logFetcher.FetchLogs(
			[]common.Address{common.HexToAddress(oasis11Address)},
			[]common.Hash{common.HexToHash(config.Topic)},
			header)
		Expect(err).NotTo(HaveOccurred())

		eventLogs := test_data.CreateLogs(header.Id, logs, db)

		err = transformer.Execute(eventLogs)
		Expect(err).NotTo(HaveOccurred())

		var dbResults []logMinSellModel
		err = db.Select(&dbResults, `SELECT pay_gem, min_amount, address_id from oasis.log_min_sell`)
		Expect(err).NotTo(HaveOccurred())

		expectedAddressID, addressErr := repository.GetOrCreateAddress(db, oasis11Address)
		Expect(addressErr).NotTo(HaveOccurred())
		expectedPayGemID, payGemErr := repository.GetOrCreateAddress(db, "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2")
		Expect(payGemErr).NotTo(HaveOccurred())

		Expect(len(dbResults)).To(Equal(1))
		sort.Sort(byMinAmount(dbResults))
		dbResult := dbResults[0]
		Expect(dbResult.PayGem).To(Equal(expectedPayGemID))
		Expect(dbResult.MinAmount).To(Equal("72503306920913261"))
		Expect(dbResult.AddressID).To(Equal(expectedAddressID))
	})
})

type logMinSellModel struct {
	PayGem    int64  `db:"pay_gem"`
	MinAmount string `db:"min_amount"`
	AddressID int64  `db:"address_id"`
}

type byMinAmount []logMinSellModel

func (b byMinAmount) Len() int           { return len(b) }
func (b byMinAmount) Less(i, j int) bool { return b[i].MinAmount < b[j].MinAmount }
func (b byMinAmount) Swap(i, j int)      { b[i], b[j] = b[j], b[i] }
