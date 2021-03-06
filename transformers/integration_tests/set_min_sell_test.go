package integration_tests

import (
	"sort"

	"github.com/ethereum/go-ethereum/common"
	"github.com/makerdao/vdb-oasis-transformers/test_config"
	"github.com/makerdao/vdb-oasis-transformers/transformers/events/set_min_sell"
	oasisConstants "github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vdb-oasis-transformers/transformers/test_data"
	"github.com/makerdao/vdb-transformer-utilities/pkg/shared/constants"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
	"github.com/makerdao/vulcanizedb/libraries/shared/fetcher"
	"github.com/makerdao/vulcanizedb/libraries/shared/repository"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("SetMinSell Transformer", func() {
	config := event.TransformerConfig{
		TransformerName:   oasisConstants.SetMinSellTable,
		ContractAddresses: test_data.OasisAddresses(),
		ContractAbi:       oasisConstants.OasisABI(),
		Topic:             oasisConstants.SetMinSellSignature(),
	}

	It("fetches and transforms a SetMinSell note event for OASIS_MATCHING_MARKET_ONE contract", func() {
		blockNumber := int64(8944595)
		config.StartingBlockNumber = blockNumber
		config.EndingBlockNumber = blockNumber

		test_config.CleanTestDB(db)

		header, err := persistHeader(db, blockNumber, blockChain)
		Expect(err).NotTo(HaveOccurred())

		initializer := event.ConfiguredTransformer{
			Config:      config,
			Transformer: set_min_sell.Transformer{},
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

		var dbResults []setMinSellModel
		err = db.Select(&dbResults, `SELECT pay_gem, dust, msg_sender, address_id from oasis.set_min_sell`)
		Expect(err).NotTo(HaveOccurred())

		expectedAddressID, addressErr := repository.GetOrCreateAddress(db, oasis_one_address)
		Expect(addressErr).NotTo(HaveOccurred())
		expectedPayGemID, payGemErr := repository.GetOrCreateAddress(db, "0x6B175474E89094C44Da98b954EedeAC495271d0F")
		Expect(payGemErr).NotTo(HaveOccurred())
		expectedMsgSenderID, msgSenderErr := repository.GetOrCreateAddress(db, "0xdb33dfd3d61308c33c63209845dad3e6bfb2c674")
		Expect(msgSenderErr).NotTo(HaveOccurred())

		Expect(len(dbResults)).To(Equal(1))
		dbResult := dbResults[0]
		Expect(dbResult.PayGem).To(Equal(expectedPayGemID))
		Expect(dbResult.MsgSender).To(Equal(expectedMsgSenderID))
		Expect(dbResult.Dust).To(Equal("2000000000000000000"))
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
			Transformer: set_min_sell.Transformer{},
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

		var dbResults []setMinSellModel
		err = db.Select(&dbResults, `SELECT pay_gem, dust, msg_sender, address_id from oasis.set_min_sell`)
		Expect(err).NotTo(HaveOccurred())

		expectedAddressID, addressErr := repository.GetOrCreateAddress(db, oasisTwoAddress)
		Expect(addressErr).NotTo(HaveOccurred())
		expectedPayGemID, payGemErr := repository.GetOrCreateAddress(db, "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599")
		Expect(payGemErr).NotTo(HaveOccurred())
		expectedMsgSenderID, msgSenderErr := repository.GetOrCreateAddress(db, "0xdb33dfd3d61308c33c63209845dad3e6bfb2c674")
		Expect(msgSenderErr).NotTo(HaveOccurred())

		Expect(len(dbResults)).To(Equal(2))
		sort.Sort(byDust(dbResults))
		dbResult := dbResults[0]
		Expect(dbResult.PayGem).To(Equal(expectedPayGemID))
		Expect(dbResult.MsgSender).To(Equal(expectedMsgSenderID))
		Expect(dbResult.Dust).To(Equal("21786"))
		Expect(dbResult.AddressID).To(Equal(expectedAddressID))
	})
})

type setMinSellModel struct {
	PayGem    int64  `db:"pay_gem"`
	MsgSender int64  `db:"msg_sender"`
	Dust      string `db:"dust"`
	AddressID int64  `db:"address_id"`
}

type byDust []setMinSellModel

func (b byDust) Len() int           { return len(b) }
func (b byDust) Less(i, j int) bool { return b[i].Dust < b[j].Dust }
func (b byDust) Swap(i, j int)      { b[i], b[j] = b[j], b[i] }
