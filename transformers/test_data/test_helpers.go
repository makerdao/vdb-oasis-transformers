package test_data

import (
	"bytes"
	"encoding/gob"

	"github.com/ethereum/go-ethereum/core/types"
	"github.com/makerdao/vdb-oasis-transformers/transformers/shared/constants"
	"github.com/makerdao/vulcanizedb/libraries/shared/factories/event"
	"github.com/makerdao/vulcanizedb/libraries/shared/repository"
	"github.com/makerdao/vulcanizedb/libraries/shared/test_data"
	"github.com/makerdao/vulcanizedb/pkg/core"
	"github.com/makerdao/vulcanizedb/pkg/datastore/postgres"
	"github.com/makerdao/vulcanizedb/pkg/datastore/postgres/repositories"
	. "github.com/onsi/gomega"
)

// Returns a deep copy of the given model, so tests aren't getting the same map/slice references
func CopyModel(model event.InsertionModel) event.InsertionModel {
	buf := new(bytes.Buffer)
	encoder := gob.NewEncoder(buf)
	encErr := encoder.Encode(model)
	Expect(encErr).NotTo(HaveOccurred())

	var newModel event.InsertionModel
	decoder := gob.NewDecoder(buf)
	decErr := decoder.Decode(&newModel)
	Expect(decErr).NotTo(HaveOccurred())
	return newModel
}

func AssignMessageSenderID(log core.EventLog, insertionModel event.InsertionModel, db *postgres.DB) {
	Expect(len(log.Log.Topics)).Should(BeNumerically(">=", 2))
	msgSenderID, msgSenderErr := repository.GetOrCreateAddress(db, log.Log.Topics[1].Hex())
	Expect(msgSenderErr).NotTo(HaveOccurred())
	insertionModel.ColumnValues[constants.MsgSenderColumn] = msgSenderID
}

func AssignAddressID(log core.EventLog, insertionModel event.InsertionModel, db *postgres.DB) {
	addressID, addressIDErr := repository.GetOrCreateAddress(db, log.Log.Address.Hex())
	Expect(addressIDErr).NotTo(HaveOccurred())
	insertionModel.ColumnValues[event.AddressFK] = addressID
}

func CreateLogs(headerID int64, logs []types.Log, db *postgres.DB) []core.EventLog {
	headerRepo := repositories.NewHeaderRepository(db)
	for _, log := range logs {
		test_data.CreateMatchingTx(log, headerID, headerRepo)
	}
	eventLogRepository := repositories.NewEventLogRepository(db)
	insertLogsErr := eventLogRepository.CreateEventLogs(headerID, logs)
	Expect(insertLogsErr).NotTo(HaveOccurred())

	logCount := getLogCount(db)
	eventLogs, getLogsErr := eventLogRepository.GetUntransformedEventLogs(0, logCount)
	Expect(getLogsErr).NotTo(HaveOccurred())
	var results []core.EventLog
	for _, EventLog := range eventLogs {
		for _, log := range logs {
			if EventLog.Log.BlockNumber == log.BlockNumber && EventLog.Log.TxIndex == log.TxIndex && EventLog.Log.Index == log.Index {
				results = append(results, EventLog)
			}
		}
	}
	return results
}

func getLogCount(db *postgres.DB) int {
	var logCount int
	logCountErr := db.Get(&logCount, `SELECT count(*) from public.event_logs`)
	Expect(logCountErr).NotTo(HaveOccurred())

	return logCount
}
