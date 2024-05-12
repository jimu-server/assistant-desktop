package main

import (
	"embed"
	_ "github.com/jimu-server/gpt"
	"github.com/jimu-server/logger"
	_ "github.com/jimu-server/mq"
	_ "github.com/jimu-server/notify"
	_ "github.com/jimu-server/org"
	_ "github.com/jimu-server/oss"
	_ "github.com/jimu-server/pay"
	"github.com/wailsapp/wails/v2/pkg/application"
	"github.com/wailsapp/wails/v2/pkg/options"
	"github.com/wailsapp/wails/v2/pkg/options/assetserver"
	"github.com/wailsapp/wails/v2/pkg/options/windows"
)

//go:embed all:frontend/dist
var assets embed.FS
var app *App
var opt *options.App

func main() {
	app = NewApp()
	opt = &options.App{
		Title:  "assistant",
		Width:  360,
		Height: 400,
		//MinHeight: 400,
		//MinWidth:  360,
		//MaxHeight: 400,
		//MaxWidth:  360,
		DisableResize: false,
		Frameless:     true,
		AssetServer: &assetserver.Options{
			Assets:  assets,
			Handler: NewFileLoader(),
		},
		OnStartup:  app.startup,
		OnShutdown: app.exit,
		Bind: []interface{}{
			app,
		},
		Windows: &windows.Options{
			WebviewGpuIsDisabled: true,
			WebviewIsTransparent: true,
			WindowIsTranslucent:  true,
			Theme:                windows.SystemDefault,
			BackdropType:         windows.Auto,
		},
		Logger: log,
		Debug:  options.Debug{OpenInspectorOnStartup: true},
	}
	app.Application = application.NewWithOptions(opt)
	if err := app.Application.Run(); err != nil {
		logger.Logger.Error(err.Error())
	}
}
