package log_kill_test

import (
	"github.com/makerdao/vdb-oasis-transformers/test_config"
	"github.com/makerdao/vdb-oasis-transformers/transformers/events/log_kill"
	"github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vdb-oasis-transformers/transformers/test_data"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
	"github.com/makerdao/vulcanizedb/libraries/shared/repository"
	"github.com/makerdao/vulcanizedb/pkg/core"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("LogKill Transformer", func() {
	var (
		transformer = log_kill.Transformer{}
		db          = test_config.NewTestDB(test_config.NewTestNode())
	)

	BeforeEach(func() {
		test_config.CleanTestDB(db)
	})

	It("converts a raw log to a LogKill model", func() {
		models, err := transformer.ToModels(constants.OasisABI(), []core.EventLog{test_data.LogKillEventLog}, db)
		Expect(err).NotTo(HaveOccurred())

		expectedModel := test_data.LogKillModel()
		test_data.AssignAddressID(test_data.LogKillEventLog, expectedModel, db)
		makerAddressId, makerAddressErr := repository.GetOrCreateAddress(db, test_data.LogKillEventLog.Log.Topics[3].Hex())
		Expect(makerAddressErr).NotTo(HaveOccurred())
		payGemAddressId, payGemAddressErr := repository.GetOrCreateAddress(db, test_data.PayGemAddress.Hex())
		Expect(payGemAddressErr).NotTo(HaveOccurred())
		buyGemAddressId, buyGemAddressErr := repository.GetOrCreateAddress(db, test_data.BuyGemAddress.Hex())
		Expect(buyGemAddressErr).NotTo(HaveOccurred())

		expectedModel.ColumnValues[constants.MakerColumn] = makerAddressId
		expectedModel.ColumnValues[constants.PayGemColumn] = payGemAddressId
		expectedModel.ColumnValues[constants.BuyGemColumn] = buyGemAddressId

		Expect(models).To(Equal([]event.InsertionModel{expectedModel}))
	})

	It("returns an error if converting log to entity fails", func() {
		_, err := transformer.ToModels("error abi", []core.EventLog{test_data.LogKillEventLog}, db)

		Expect(err).To(HaveOccurred())
	})
})
