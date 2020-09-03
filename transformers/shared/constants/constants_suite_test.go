package constants_test

import (
	"github.com/makerdao/oasis-transformers/transformers/test_data"
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestConstants(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Constants Suite")
}

// Because tests in this package depend on reading values from config, it is necessary to setup a config file to
// be used in such lookups
var configSet = test_data.SetTestConfig()
