package app

import (
	"context"
	"github.com/jimu-server/logger"
	"github.com/wailsapp/wails/v2/pkg/runtime"
	"go.uber.org/zap"
)

var log Log
var skip = 1

func init() {
	log = Log{
		logger: logger.Logger.WithOptions(zap.AddCallerSkip(skip)),
	}
}

type Log struct {
	logger *zap.Logger
}

// Print level logging. Works like Sprintf.
func (l Log) Print(message string) {
	runtime.LogPrint(context.Background(), message)
}

// Trace level logging. Works like Sprintf.
func (l Log) Trace(message string) {
	runtime.LogTrace(context.Background(), message)
}

// Debug level logging. Works like Sprintf.
func (l Log) Debug(message string) {
	l.logger.Debug(message)
}

// Info level logging. Works like Sprintf.
func (l Log) Info(message string) {
	l.logger.Info(message)
}

// Warning level logging. Works like Sprintf.
func (l Log) Warning(message string) {
	l.logger.Warn(message)
}

// Error level logging. Works like Sprintf.
func (l Log) Error(message string) {
	l.logger.Error(message)
}

// Fatal level logging. Works like Sprintf.
func (l Log) Fatal(message string) {
	l.logger.Fatal(message)
}
