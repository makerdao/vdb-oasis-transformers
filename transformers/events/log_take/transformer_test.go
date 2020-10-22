package log_take_test

import (
	"github.com/ethereum/go-ethereum/common"
	"github.com/makerdao/vdb-oasis-transformers/test_config"
	"github.com/makerdao/vdb-oasis-transformers/transformers/events/log_take"
	"github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vdb-oasis-transformers/transformers/test_data"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
	"github.com/makerdao/vulcanizedb/libraries/shared/repository"
	"github.com/makerdao/vulcanizedb/pkg/core"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("LogTake Transformer", func() {
	var (
		transformer = log_take.Transformer{}
		db          = test_config.NewTestDB(test_config.NewTestNode())
	)

	BeforeEach(func() {
		test_config.CleanTestDB(db)
	})

	It("converts a raw log to a LogTake model", func() {
		models, err := transformer.ToModels(constants.OasisABI(), []core.EventLog{test_data.LogTakeEventLog}, db)
		Expect(err).NotTo(HaveOccurred())

		expectedModel := test_data.LogTakeModel()
		test_data.AssignAddressID(test_data.LogTakeEventLog, expectedModel, db)
		makerID, makerErr := repository.GetOrCreateAddress(db, common.HexToAddress(test_data.LogTakeEventLog.Log.Topics[2].Hex()).Hex())
		Expect(makerErr).NotTo(HaveOccurred())
		takerID, takerErr := repository.GetOrCreateAddress(db, common.HexToAddress(test_data.LogTakeEventLog.Log.Topics[3].Hex()).Hex())
		Expect(takerErr).NotTo(HaveOccurred())
		payGemID, payGemErr := repository.GetOrCreateAddress(db, test_data.LogTakePayGemAddress.Hex())
		Expect(payGemErr).NotTo(HaveOccurred())
		buyGemID, buyGemErr := repository.GetOrCreateAddress(db, test_data.LogTakeBuyGemAddress.Hex())
		Expect(buyGemErr).NotTo(HaveOccurred())

		expectedModel.ColumnValues[constants.MakerColumn] = makerID
		expectedModel.ColumnValues[constants.TakerColumn] = takerID
		expectedModel.ColumnValues[constants.PayGemColumn] = payGemID
		expectedModel.ColumnValues[constants.BuyGemColumn] = buyGemID

		Expect(models).To(Equal([]event.InsertionModel{expectedModel}))
	})

	It("returns an error if converting log to entity fails", func() {
		_, err := transformer.ToModels("error abi", []core.EventLog{test_data.LogTakeEventLog}, db)

		Expect(err).To(HaveOccurred())
	})
})
