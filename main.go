package main

import (
	"embed"
	"github.com/jimu-server/assistant-desktop/app"
	_ "github.com/jimu-server/gpt"
	"github.com/jimu-server/logger"
	_ "github.com/jimu-server/mq"
	_ "github.com/jimu-server/notify"
	_ "github.com/jimu-server/org"
	_ "github.com/jimu-server/oss"
	_ "github.com/jimu-server/pay"
	"github.com/wailsapp/wails/v2/pkg/application"
)

//go:embed all:frontend/dist
var assets embed.FS

//go:embed build/windows/icon.ico
var icon []byte

func main() {
	win := app.InitApp("assistant", icon, assets)
	win.Application = application.NewWithOptions(win.Option)
	if err := win.Application.Run(); err != nil {
		logger.Logger.Error(err.Error())
	}
}
