package integration_tests

import (
	"github.com/ethereum/go-ethereum/common"
	"github.com/makerdao/vdb-oasis-transformers/test_config"
	"github.com/makerdao/vdb-oasis-transformers/transformers/events/log_take"
	oasisConstants "github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vdb-oasis-transformers/transformers/test_data"
	"github.com/makerdao/vdb-transformer-utilities/pkg/shared/constants"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
	"github.com/makerdao/vulcanizedb/libraries/shared/fetcher"
	"github.com/makerdao/vulcanizedb/libraries/shared/repository"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("LogTake Transformer", func() {
	config := event.TransformerConfig{
		TransformerName:   oasisConstants.LogTakeTable,
		ContractAddresses: test_data.OasisAddresses(),
		ContractAbi:       oasisConstants.OasisABI(),
		Topic:             oasisConstants.LogTakeSignature(),
	}

	It("fetches and transforms a LogTake event for OASIS_MATCHING_MARKET_ONE contract", func() {
		blockNumber := int64(9439641)
		config.StartingBlockNumber = blockNumber
		config.EndingBlockNumber = blockNumber

		test_config.CleanTestDB(db)

		header, err := persistHeader(db, blockNumber, blockChain)
		Expect(err).NotTo(HaveOccurred())

		initializer := event.ConfiguredTransformer{
			Config:      config,
			Transformer: log_take.Transformer{},
		}
		transformer := initializer.NewTransformer(db)

		oasisOneAddress := constants.GetContractAddress("OASIS_MATCHING_MARKET_ONE")
		logFetcher := fetcher.NewLogFetcher(blockChain)
		logs, err := logFetcher.FetchLogs(
			[]common.Address{common.HexToAddress(oasisOneAddress)},
			[]common.Hash{common.HexToHash(config.Topic)},
			header)
		Expect(err).NotTo(HaveOccurred())

		eventLogs := test_data.CreateLogs(header.Id, logs, db)

		err = transformer.Execute(eventLogs)
		Expect(err).NotTo(HaveOccurred())

		var dbResults []logTakeModel
		err = db.Select(&dbResults, `SELECT offer_id, pair, maker, pay_gem, buy_gem, taker, take_amt, give_amt, timestamp, address_id from oasis.log_take`)
		Expect(err).NotTo(HaveOccurred())

		expectedAddressID, addressErr := repository.GetOrCreateAddress(db, oasisOneAddress)
		Expect(addressErr).NotTo(HaveOccurred())
		expectedMakerID, makerErr := repository.GetOrCreateAddress(db, "0x6ff7d252627d35b8eb02607c8f27acdb18032718")
		Expect(makerErr).NotTo(HaveOccurred())
		expectedPayGemID, payGemErr := repository.GetOrCreateAddress(db, "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2")
		Expect(payGemErr).NotTo(HaveOccurred())
		expectedBuyGemID, buyGemErr := repository.GetOrCreateAddress(db, "0x6b175474e89094c44da98b954eedeac495271d0f")
		Expect(buyGemErr).NotTo(HaveOccurred())
		expectedTakerID, takerErr := repository.GetOrCreateAddress(db, "0x3a32292c53bf42b6317334392bf0272da2983252")
		Expect(takerErr).NotTo(HaveOccurred())

		Expect(len(dbResults)).To(Equal(1))
		Expect(dbResults[0].OfferID).To(Equal("811605"))
		Expect(dbResults[0].Pair).To(Equal("0xcdd6659bca20e2b28ea10ead902280762ac8977c84459a152f90e561d50edf8c"))
		Expect(dbResults[0].Maker).To(Equal(expectedMakerID))
		Expect(dbResults[0].PayGem).To(Equal(expectedPayGemID))
		Expect(dbResults[0].BuyGem).To(Equal(expectedBuyGemID))
		Expect(dbResults[0].Taker).To(Equal(expectedTakerID))
		Expect(dbResults[0].TakeAmt).To(Equal("4590000000000000000"))
		Expect(dbResults[0].GiveAmt).To(Equal("999288900000000000000"))
		Expect(dbResults[0].Timestamp).To(Equal("1581132367"))
		Expect(dbResults[0].AddressID).To(Equal(expectedAddressID))
	})

	It("fetches and transforms a LogTake event for OASIS_MATCHING_MARKET_TWO contract", func() {
		blockNumber := int64(9879598)
		config.StartingBlockNumber = blockNumber
		config.EndingBlockNumber = blockNumber

		test_config.CleanTestDB(db)

		header, err := persistHeader(db, blockNumber, blockChain)
		Expect(err).NotTo(HaveOccurred())

		initializer := event.ConfiguredTransformer{
			Config:      config,
			Transformer: log_take.Transformer{},
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

		var dbResults []logTakeModel
		err = db.Select(&dbResults, `SELECT offer_id, pair, maker, pay_gem, buy_gem, taker, take_amt, give_amt, timestamp, address_id from oasis.log_take`)
		Expect(err).NotTo(HaveOccurred())

		Expect(len(dbResults)).To(Equal(1))
		expectedAddressID, addressErr := repository.GetOrCreateAddress(db, oasisTwoAddress)
		Expect(addressErr).NotTo(HaveOccurred())
		expectedMakerID, makerErr := repository.GetOrCreateAddress(db, "0xd62824c0a9f7d12a2e3b9674fbbfc63e5db4c5a0")
		Expect(makerErr).NotTo(HaveOccurred())
		expectedPayGemID, payGemErr := repository.GetOrCreateAddress(db, "0x6b175474e89094c44da98b954eedeac495271d0f")
		Expect(payGemErr).NotTo(HaveOccurred())
		expectedBuyGemID, buyGemErr := repository.GetOrCreateAddress(db, "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48")
		Expect(buyGemErr).NotTo(HaveOccurred())
		expectedTakerID, takerErr := repository.GetOrCreateAddress(db, "0x591e9f22e2e925a5febbbf9da7e7a632e877fe5c")
		Expect(takerErr).NotTo(HaveOccurred())

		Expect(dbResults[0].OfferID).To(Equal("252088"))
		Expect(dbResults[0].Pair).To(Equal("0xd257ccbe93e550a27236e8cc4971336f6cd2d53037ad567f10fbcc28df6a1eb1"))
		Expect(dbResults[0].Maker).To(Equal(expectedMakerID))
		Expect(dbResults[0].PayGem).To(Equal(expectedPayGemID))
		Expect(dbResults[0].BuyGem).To(Equal(expectedBuyGemID))
		Expect(dbResults[0].Taker).To(Equal(expectedTakerID))
		Expect(dbResults[0].TakeAmt).To(Equal("1200482945186968700163"))
		Expect(dbResults[0].GiveAmt).To(Equal("1222691879"))
		Expect(dbResults[0].Timestamp).To(Equal("1586988012"))
		Expect(dbResults[0].AddressID).To(Equal(expectedAddressID))
	})

	It("fetches and transforms a LogTake event for OASIS_MATCHING_MARKET_1_1 contract", func() {
		blockNumber := int64(11835227)
		config.StartingBlockNumber = blockNumber
		config.EndingBlockNumber = blockNumber

		test_config.CleanTestDB(db)

		header, err := persistHeader(db, blockNumber, blockChain)
		Expect(err).NotTo(HaveOccurred())

		initializer := event.ConfiguredTransformer{
			Config:      config,
			Transformer: log_take.Transformer{},
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

		var dbResults []logTakeModel
		err = db.Select(&dbResults, `SELECT offer_id, pair, maker, pay_gem, buy_gem, taker, take_amt, give_amt, timestamp, address_id from oasis.log_take`)
		Expect(err).NotTo(HaveOccurred())

		Expect(len(dbResults)).To(Equal(1))
		expectedAddressID, addressErr := repository.GetOrCreateAddress(db, oasis11Address)
		Expect(addressErr).NotTo(HaveOccurred())
		expectedMakerID, makerErr := repository.GetOrCreateAddress(db, "0xd8e749e457fcd1918c9a589bfaa87db9f8e154d6")
		Expect(makerErr).NotTo(HaveOccurred())
		expectedPayGemID, payGemErr := repository.GetOrCreateAddress(db, "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2")
		Expect(payGemErr).NotTo(HaveOccurred())
		expectedBuyGemID, buyGemErr := repository.GetOrCreateAddress(db, "0x6b175474e89094c44da98b954eedeac495271d0f")
		Expect(buyGemErr).NotTo(HaveOccurred())
		expectedTakerID, takerErr := repository.GetOrCreateAddress(db, "0x979eee182f8fbd22bcc21f218637a2b993708cbf")
		Expect(takerErr).NotTo(HaveOccurred())

		Expect(dbResults[0].OfferID).To(Equal("15"))
		Expect(dbResults[0].Pair).To(Equal("0xcdd6659bca20e2b28ea10ead902280762ac8977c84459a152f90e561d50edf8c"))
		Expect(dbResults[0].Maker).To(Equal(expectedMakerID))
		Expect(dbResults[0].PayGem).To(Equal(expectedPayGemID))
		Expect(dbResults[0].BuyGem).To(Equal(expectedBuyGemID))
		Expect(dbResults[0].Taker).To(Equal(expectedTakerID))
		Expect(dbResults[0].TakeAmt).To(Equal("544799176107106076"))
		Expect(dbResults[0].GiveAmt).To(Equal("1057999999999999999592"))
		Expect(dbResults[0].Timestamp).To(Equal("1613046148"))
		Expect(dbResults[0].AddressID).To(Equal(expectedAddressID))
	})
})

type logTakeModel struct {
	OfferID   string `db:"offer_id"`
	Pair      string
	Maker     int64
	PayGem    int64 `db:"pay_gem"`
	BuyGem    int64 `db:"buy_gem"`
	Taker     int64
	TakeAmt   string `db:"take_amt"`
	GiveAmt   string `db:"give_amt"`
	Timestamp string
	AddressID int64 `db:"address_id"`
}
