package log_insert_test

import (
	"github.com/makerdao/vdb-oasis-transformers/test_config"
	"github.com/makerdao/vdb-oasis-transformers/transformers/events/log_insert"
	"github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vdb-oasis-transformers/transformers/test_data"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
	"github.com/makerdao/vulcanizedb/libraries/shared/repository"
	"github.com/makerdao/vulcanizedb/pkg/core"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("LogInsert Transformer", func() {
	var (
		transformer = log_insert.Transformer{}
		db          = test_config.NewTestDB(test_config.NewTestNode())
	)

	BeforeEach(func() {
		test_config.CleanTestDB(db)
	})

	It("converts a raw log to a LogInsert model", func() {
		models, err := transformer.ToModels(constants.OasisABI(), []core.EventLog{test_data.LogInsertEventLog}, db)
		Expect(err).NotTo(HaveOccurred())

		expectedModel := test_data.LogInsertModel()
		test_data.AssignAddressID(test_data.LogInsertEventLog, expectedModel, db)

		keeperID, keeperErr := repository.GetOrCreateAddress(db, test_data.LogInsertKeeperAddress.Hex())
		Expect(keeperErr).NotTo(HaveOccurred())
		expectedModel.ColumnValues[constants.KeeperColumn] = keeperID

		Expect(models).To(Equal([]event.InsertionModel{expectedModel}))
	})

	It("returns an error if converting log to entity fails", func() {
		_, err := transformer.ToModels("error abi", []core.EventLog{test_data.LogInsertEventLog}, db)

		Expect(err).To(HaveOccurred())
	})
})
