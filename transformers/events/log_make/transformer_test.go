package log_make_test

import (
	"github.com/ethereum/go-ethereum/common"
	"github.com/makerdao/vdb-oasis-transformers/test_config"
	"github.com/makerdao/vdb-oasis-transformers/transformers/events/log_make"
	"github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vdb-oasis-transformers/transformers/test_data"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
	"github.com/makerdao/vulcanizedb/libraries/shared/repository"
	"github.com/makerdao/vulcanizedb/pkg/core"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("LogMake Transformer", func() {
	var (
		transformer = log_make.Transformer{}
		db          = test_config.NewTestDB(test_config.NewTestNode())
	)

	BeforeEach(func() {
		test_config.CleanTestDB(db)
	})

	It("converts a raw log to a LogMake model", func() {
		models, err := transformer.ToModels(constants.OasisABI(), []core.EventLog{test_data.LogMakeEventLog}, db)
		Expect(err).NotTo(HaveOccurred())

		expectedModel := test_data.LogMakeModel()
		test_data.AssignAddressID(test_data.LogMakeEventLog, expectedModel, db)
		makerID, makerErr := repository.GetOrCreateAddress(db, common.HexToAddress(test_data.LogMakeEventLog.Log.Topics[3].Hex()).Hex())
		Expect(makerErr).NotTo(HaveOccurred())
		expectedModel.ColumnValues[constants.MakerColumn] = makerID
		payGemID, payGemErr := repository.GetOrCreateAddress(db, test_data.LogMakePayGemAddress.Hex())
		Expect(payGemErr).NotTo(HaveOccurred())
		expectedModel.ColumnValues[constants.PayGemColumn] = payGemID
		buyGemID, buyGemErr := repository.GetOrCreateAddress(db, test_data.LogMakeBuyGemAddress.Hex())
		Expect(buyGemErr).NotTo(HaveOccurred())
		expectedModel.ColumnValues[constants.BuyGemColumn] = buyGemID

		Expect(models).To(Equal([]event.InsertionModel{expectedModel}))
	})

	It("returns an error if converting log to entity fails", func() {
		_, err := transformer.ToModels("error abi", []core.EventLog{test_data.LogMakeEventLog}, db)

		Expect(err).To(HaveOccurred())
	})
})
