package app

import (
	"context"
	"embed"
	"fmt"
	"github.com/energye/systray"
	"github.com/gin-gonic/gin"
	"github.com/jimu-server/config"
	"github.com/jimu-server/logger"
	"github.com/jimu-server/web"
	"github.com/wailsapp/wails/v2/pkg/application"
	"github.com/wailsapp/wails/v2/pkg/options"
	"github.com/wailsapp/wails/v2/pkg/options/windows"
	"github.com/wailsapp/wails/v2/pkg/runtime"
	"go.uber.org/zap"
	"net/http"
)

// Window struct
type Window struct {
	ctx    context.Context
	server *http.Server
	*gin.Engine
	Option *options.App
	*application.Application
	Icon []byte
}

func InitApp(title string, icon []byte, assets embed.FS, configs ...Option) *Window {
	win := &Window{Engine: web.Engine, Icon: icon}
	configs = append([]Option{
		StartUpOption(win.Startup),
		ShutdownOption(win.Exit),
		TitleOption(title),
		BindOpting(win),
		AssetsEmbed(assets, NewFileLoader()),
	}, configs...)
	option := GetOption(configs...)
	win.Option = option
	return win
}

func (a *Window) Startup(ctx context.Context) {
	a.ctx = ctx
	// 开启服务器
	a.server = &http.Server{
		Addr:    fmt.Sprintf("%s%s", "0.0.0.0", config.Evn.App.Port),
		Handler: a,
	}
	// 运行服务器
	go func() {
		if err := a.server.ListenAndServe(); err != nil {
			logger.Logger.Warn(err.Error())
		}
	}()
	// 运行 Ollama
	go func() {

	}()
	// 运行任务托盘
	go func() {
		systray.Run(InitSystray(a), onExit)
	}()

}

func (a *Window) Refresh() {
	runtime.WindowReload(a.ctx)
}

func (a *Window) DevTool() {

}

func (a *Window) Exit(ctx context.Context) {
	// 关闭服务器
	if err := a.server.Close(); err != nil {
		logger.Logger.Error("close server error", zap.Error(err))
	}
	logger.Logger.Info("server shutdown")
	logger.Logger.Info("app shutdown")
}

func (a *Window) Theme(dark bool) {
	if dark {
		a.Option.Windows.Theme = windows.Dark
	} else {
		a.Option.Windows.Theme = windows.Light
	}
}
