package test_data

import (
	"io/ioutil"

	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"
)

func SetTestConfig() bool {
	logrus.SetOutput(ioutil.Discard)
	viper.SetConfigName("testing")
	viper.AddConfigPath("$GOPATH/src/github.com/makerdao/oasis-transformers/environments/")
	return true
}
