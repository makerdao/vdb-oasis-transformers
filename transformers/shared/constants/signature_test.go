package constants_test

import (
	"github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("", func() {
	It("generates oasis log bump signature", func() {
		Expect(constants.LogBumpSignature()).To(Equal("0x70a14c213064359ede031fd2a1645a11ce2ec825ffe6ab5cfb5b160c3ef4d0a2"))
	})

	It("generates oasis log buy enabled signature", func() {
		Expect(constants.LogBuyEnabledSignature()).To(Equal("0x7089e4f0bcc948f9f723a361590c32d9c2284da7ab1981b1249ad2edb9f953c1"))
	})

	It("generates oasis log delete signature", func() {
		Expect(constants.LogDeleteSignature()).To(Equal("0xcb9d6176c6aac6478ebb9a2754cdce22a944de29ed1f2642f8613884eba4b40c"))
	})

	It("generates oasis log insert signature", func() {
		Expect(constants.LogInsertSignature()).To(Equal("0x6d5c16212bdea16850dce4d9fa2314c446bd30ce84700d9c36c7677c6d283940"))
	})

	It("generates oasis log item update signature", func() {
		Expect(constants.LogItemUpdateSignature()).To(Equal("0xa2c251311b1a7a475913900a2a73dc9789a21b04bc737e050bbc506dd4eb3488"))
	})

	It("generates oasis log kill signature", func() {
		Expect(constants.LogKillSignature()).To(Equal("0x9577941d28fff863bfbee4694a6a4a56fb09e169619189d2eaa750b5b4819995"))
	})

	It("generates oasis log make signature", func() {
		Expect(constants.LogMakeSignature()).To(Equal("0x773ff502687307abfa024ac9f62f9752a0d210dac2ffd9a29e38e12e2ea82c82"))
	})

	It("generates oasis log matching enabled signature", func() {
		Expect(constants.LogMatchingEnabledSignature()).To(Equal("0xea11e00ec1642be9b494019b756440e2c57dbe9e59242c4f9c64ce33fb4f41d9"))
	})

	It("generates oasis log minsell signature", func() {
		Expect(constants.LogMinSellSignature()).To(Equal("0xc28d56449b0bb31e64ee7487e061f57a2e72aea8019d810832f26dda099823d0"))
	})

	It("generates oasis log sorted offer signature", func() {
		Expect(constants.LogSortedOfferSignature()).To(Equal("0x20fb9bad86c18f7e22e8065258790d9416a7d2df8ff05f80f82c46d38b925acd"))
	})

	It("generates oasis log take signature", func() {
		Expect(constants.LogTakeSignature()).To(Equal("0x3383e3357c77fd2e3a4b30deea81179bc70a795d053d14d5b7f2f01d0fd4596f"))
	})

	It("generates oasis log trade signature", func() {
		Expect(constants.LogTradeSignature()).To(Equal("0x819e390338feffe95e2de57172d6faf337853dfd15c7a09a32d76f7fd2443875"))
	})

	It("generates oasis log unsorted offer signature", func() {
		Expect(constants.LogUnsortedOfferSignature()).To(Equal("0x8173832a493e0a3989e521458e55bfe9feac9f9b675a94e100b9d5a85f814862"))
	})

	It("generates setMinSell signature", func() {
		Expect(constants.SetMinSellSignature()).To(Equal("0xbf7c734e00000000000000000000000000000000000000000000000000000000"))
	})
})
