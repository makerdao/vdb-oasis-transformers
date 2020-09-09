package shared

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestLogMinSell(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Shared Utility Suite")
}
