package app

import (
	"context"
	"embed"
	"github.com/wailsapp/wails/v2/pkg/options"
	"github.com/wailsapp/wails/v2/pkg/options/assetserver"
	"github.com/wailsapp/wails/v2/pkg/options/windows"
	"net/http"
)

type Option func(config *options.App)

func GetOption(option ...Option) *options.App {
	opt := &options.App{
		Title:         "assistant",
		Width:         360,
		Height:        400,
		DisableResize: false,
		Frameless:     true,
		AssetServer: &assetserver.Options{
			Handler: NewFileLoader(),
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
	for _, o := range option {
		o(opt)
	}
	return opt
}

func BindOpting(value any) Option {
	return func(config *options.App) {
		config.Bind = append(config.Bind, value)
	}
}

func StartUpOption(star func(ctx context.Context)) Option {
	return func(config *options.App) {
		config.OnStartup = star
	}
}

func ShutdownOption(exit func(ctx context.Context)) Option {
	return func(config *options.App) {
		config.OnShutdown = exit
	}
}

func AssetsEmbed(assets embed.FS, handle http.Handler) Option {
	return func(config *options.App) {
		config.AssetServer = &assetserver.Options{
			Assets:  assets,
			Handler: handle,
		}
	}
}

func TitleOption(title string) Option {
	return func(config *options.App) {
		config.Title = title
	}
}
