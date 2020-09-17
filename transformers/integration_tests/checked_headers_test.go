package integration_tests

import (
	"github.com/makerdao/vdb-oasis-transformers/test_config"
	"github.com/makerdao/vulcanizedb/libraries/shared/test_data"
	. "github.com/onsi/ginkgo"
)

var _ = Describe("Oasis", func() {
	BeforeEach(func() {
		test_config.CleanTestDB(db)
	})

	It("has a proper checked headers setup in the oasis schema", func() {
		test_data.ExpectCheckedHeadersInThisSchema(db, "oasis")
	})
})
