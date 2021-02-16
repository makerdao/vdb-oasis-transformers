package integration_tests

import (
	"sort"

	"github.com/ethereum/go-ethereum/common"
	"github.com/makerdao/vdb-oasis-transformers/test_config"
	"github.com/makerdao/vdb-oasis-transformers/transformers/events/log_make"
	oasisConstants "github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vdb-oasis-transformers/transformers/test_data"
	"github.com/makerdao/vdb-transformer-utilities/pkg/shared/constants"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
	"github.com/makerdao/vulcanizedb/libraries/shared/fetcher"
	"github.com/makerdao/vulcanizedb/libraries/shared/repository"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("LogMake Transformer", func() {
	config := event.TransformerConfig{
		TransformerName:   oasisConstants.LogMakeTable,
		ContractAddresses: test_data.OasisAddresses(),
		ContractAbi:       oasisConstants.OasisABI(),
		Topic:             oasisConstants.LogMakeSignature(),
	}

	It("fetches and transforms a LogMake event for OASIS_MATCHING_MARKET_ONE contract", func() {
		blockNumber := int64(9440386)
		config.StartingBlockNumber = blockNumber
		config.EndingBlockNumber = blockNumber

		test_config.CleanTestDB(db)

		header, err := persistHeader(db, blockNumber, blockChain)
		Expect(err).NotTo(HaveOccurred())

		initializer := event.ConfiguredTransformer{
			Config:      config,
			Transformer: log_make.Transformer{},
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

		var dbResults []logMakeModel
		err = db.Select(&dbResults, `SELECT offer_id, pair, maker, pay_gem, buy_gem, pay_amt, buy_amt, timestamp, address_id from oasis.log_make`)
		Expect(err).NotTo(HaveOccurred())

		expectedAddressID, addressErr := repository.GetOrCreateAddress(db, oasisOneAddress)
		Expect(addressErr).NotTo(HaveOccurred())
		expectedMakerID, makerErr := repository.GetOrCreateAddress(db, "0x6Ff7D252627D35B8eb02607c8F27ACDB18032718")
		Expect(makerErr).NotTo(HaveOccurred())
		expectedPayGemID, payGemErr := repository.GetOrCreateAddress(db, "0x6B175474E89094C44Da98b954EedeAC495271d0F")
		Expect(payGemErr).NotTo(HaveOccurred())
		expectedBuyGemID, buyGemErr := repository.GetOrCreateAddress(db, "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2")
		Expect(buyGemErr).NotTo(HaveOccurred())

		Expect(len(dbResults)).To(Equal(2))
		sort.Sort(byOfferID(dbResults))
		dbResult := dbResults[0]
		Expect(dbResult.OfferID).To(Equal("811645"))
		Expect(dbResult.Pair).To(Equal("0x7bda8b27e891f9687bd6d3312ab3f4f458e2cc91916429d721d617df7ac29fb8"))
		Expect(dbResult.Maker).To(Equal(expectedMakerID))
		Expect(dbResult.PayGem).To(Equal(expectedPayGemID))
		Expect(dbResult.BuyGem).To(Equal(expectedBuyGemID))
		Expect(dbResult.PayAmt).To(Equal("67707612000000000000000"))
		Expect(dbResult.BuyAmt).To(Equal("307650000000000000000"))
		Expect(dbResult.Timestamp).To(Equal("1581142121"))
		Expect(dbResult.AddressID).To(Equal(expectedAddressID))
	})

	It("fetches and transforms a LogMake event for OASIS_MATCHING_MARKET_TWO contract", func() {
		blockNumber := int64(9866954)
		config.StartingBlockNumber = blockNumber
		config.EndingBlockNumber = blockNumber

		test_config.CleanTestDB(db)

		header, err := persistHeader(db, blockNumber, blockChain)
		Expect(err).NotTo(HaveOccurred())

		initializer := event.ConfiguredTransformer{
			Config:      config,
			Transformer: log_make.Transformer{},
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

		var dbResults []logMakeModel
		err = db.Select(&dbResults, `SELECT offer_id, pair, maker, pay_gem, buy_gem, pay_amt, buy_amt, timestamp, address_id from oasis.log_make`)
		Expect(err).NotTo(HaveOccurred())

		Expect(len(dbResults)).To(Equal(1))
		dbResult := dbResults[0]
		expectedAddressID, addressErr := repository.GetOrCreateAddress(db, oasisTwoAddress)
		Expect(addressErr).NotTo(HaveOccurred())
		expectedMakerID, makerErr := repository.GetOrCreateAddress(db, "0xbAEaFc49d8e3a636d61df1F14fd45b97c7018020")
		Expect(makerErr).NotTo(HaveOccurred())
		expectedPayGemID, payGemErr := repository.GetOrCreateAddress(db, "0x6B175474E89094C44Da98b954EedeAC495271d0F")
		Expect(payGemErr).NotTo(HaveOccurred())
		expectedBuyGemID, buyGemErr := repository.GetOrCreateAddress(db, "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2")
		Expect(buyGemErr).NotTo(HaveOccurred())

		Expect(dbResult.OfferID).To(Equal("247773"))
		Expect(dbResult.Pair).To(Equal("0x7bda8b27e891f9687bd6d3312ab3f4f458e2cc91916429d721d617df7ac29fb8"))
		Expect(dbResult.Maker).To(Equal(expectedMakerID))
		Expect(dbResult.PayGem).To(Equal(expectedPayGemID))
		Expect(dbResult.BuyGem).To(Equal(expectedBuyGemID))
		Expect(dbResult.PayAmt).To(Equal("3323372775780000000000"))
		Expect(dbResult.BuyAmt).To(Equal("21889900000000000000"))
		Expect(dbResult.Timestamp).To(Equal("1586819716"))
		Expect(dbResult.AddressID).To(Equal(expectedAddressID))
	})

	It("fetches and transforms a LogMake event for OASIS_MATCHING_MARKET_1_1 contract", func() {
		blockNumber := int64(11843426)
		config.StartingBlockNumber = blockNumber
		config.EndingBlockNumber = blockNumber

		test_config.CleanTestDB(db)

		header, err := persistHeader(db, blockNumber, blockChain)
		Expect(err).NotTo(HaveOccurred())

		initializer := event.ConfiguredTransformer{
			Config:      config,
			Transformer: log_make.Transformer{},
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

		var dbResults []logMakeModel
		err = db.Select(&dbResults, `SELECT offer_id, pair, maker, pay_gem, buy_gem, pay_amt, buy_amt, timestamp, address_id from oasis.log_make`)
		Expect(err).NotTo(HaveOccurred())

		Expect(len(dbResults)).To(Equal(1))
		dbResult := dbResults[0]
		expectedAddressID, addressErr := repository.GetOrCreateAddress(db, oasis11Address)
		Expect(addressErr).NotTo(HaveOccurred())
		expectedMakerID, makerErr := repository.GetOrCreateAddress(db, "0xd8e749e457fcd1918c9a589bfaa87db9f8e154d6")
		Expect(makerErr).NotTo(HaveOccurred())
		expectedPayGemID, payGemErr := repository.GetOrCreateAddress(db, "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2")
		Expect(payGemErr).NotTo(HaveOccurred())
		expectedBuyGemID, buyGemErr := repository.GetOrCreateAddress(db, "0x6b175474e89094c44da98b954eedeac495271d0f")
		Expect(buyGemErr).NotTo(HaveOccurred())

		Expect(dbResult.OfferID).To(Equal("21"))
		Expect(dbResult.Pair).To(Equal("0xcdd6659bca20e2b28ea10ead902280762ac8977c84459a152f90e561d50edf8c"))
		Expect(dbResult.Maker).To(Equal(expectedMakerID))
		Expect(dbResult.PayGem).To(Equal(expectedPayGemID))
		Expect(dbResult.BuyGem).To(Equal(expectedBuyGemID))
		Expect(dbResult.PayAmt).To(Equal("1600000000000000000000"))
		Expect(dbResult.BuyAmt).To(Equal("3104000000000000000000000"))
		Expect(dbResult.Timestamp).To(Equal("1613154292"))
		Expect(dbResult.AddressID).To(Equal(expectedAddressID))
	})
})

type logMakeModel struct {
	OfferID   string `db:"offer_id"`
	Pair      string
	Maker     int64
	PayGem    int64  `db:"pay_gem"`
	BuyGem    int64  `db:"buy_gem"`
	PayAmt    string `db:"pay_amt"`
	BuyAmt    string `db:"buy_amt"`
	Timestamp string
	AddressID int64 `db:"address_id"`
}

type byOfferID []logMakeModel

func (b byOfferID) Len() int           { return len(b) }
func (b byOfferID) Less(i, j int) bool { return b[i].OfferID < b[j].OfferID }
func (b byOfferID) Swap(i, j int)      { b[i], b[j] = b[j], b[i] }
