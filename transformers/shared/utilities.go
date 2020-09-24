package shared

import (
	"errors"
	"fmt"
	"math/big"

	"github.com/ethereum/go-ethereum/common"
	"github.com/makerdao/vulcanizedb/libraries/shared/constants"
)

var ErrInvalidIndex = func(index int) error {
	return errors.New(fmt.Sprintf("unsupported log data index: %d", index))
}

func BigIntToString(value *big.Int) string {
	result := value.String()
	if result == "<nil>" {
		return ""
	} else {
		return result
	}
}

func GetLogNoteArgumentAtIndex(index int, logData []byte) ([]byte, error) {
	indexOffset, err := getLogNoteArgumentIndexOffset(index)
	if err != nil {
		return nil, err
	}
	return getDataWithIndexOffset(indexOffset, logData), nil
}

func getLogNoteArgumentIndexOffset(index int) (int, error) {
	minArgIndex := 2
	maxArgIndex := 5
	if index < minArgIndex || index > maxArgIndex {
		return 0, ErrInvalidIndex(index)
	}
	offsets := map[int]int{2: 4, 3: 3, 4: 2, 5: 1}
	return offsets[index], nil
}

func getDataWithIndexOffset(offset int, logData []byte) []byte {
	zeroPaddedSignatureOffset := 28
	dataBegin := len(logData) - (offset * constants.DataItemLength) - zeroPaddedSignatureOffset
	dataEnd := len(logData) - ((offset - 1) * constants.DataItemLength) - zeroPaddedSignatureOffset
	return logData[dataBegin:dataEnd]
}

func ConvertUint256HexToBigInt(hex string) *big.Int {
	hexBytes := common.FromHex(hex)
	return big.NewInt(0).SetBytes(hexBytes)
}
