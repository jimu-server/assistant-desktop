package main

import (
	"context"
	"fmt"
	"github.com/energye/systray"
	"github.com/gin-gonic/gin"
	"github.com/jimu-server/config"
	"github.com/jimu-server/logger"
	"github.com/jimu-server/web"
	"github.com/wailsapp/wails/v2/pkg/application"
	"github.com/wailsapp/wails/v2/pkg/options/windows"
	"github.com/wailsapp/wails/v2/pkg/runtime"
	"go.uber.org/zap"
	"net/http"
	"os"
	"strings"
)

type FileLoader struct {
	http.Handler
}

func NewFileLoader() *FileLoader {
	return &FileLoader{}
}

func (h *FileLoader) ServeHTTP(res http.ResponseWriter, req *http.Request) {
	var err error
	requestedFilename := strings.TrimPrefix(req.URL.Path, "/")
	fileData, err := os.ReadFile(requestedFilename)
	if err != nil {
		res.WriteHeader(http.StatusBadRequest)
		res.Write([]byte(fmt.Sprintf("Could not load file %s", requestedFilename)))
	}

	res.Write(fileData)
}

// App struct
type App struct {
	ctx    context.Context
	server *http.Server
	engine *gin.Engine
	*application.Application
}

func NewApp() *App {
	return &App{
		engine: web.Engine,
	}
}

func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
	// 开启服务器
	a.server = &http.Server{
		Addr:    fmt.Sprintf("%s%s", "0.0.0.0", config.Evn.App.Port),
		Handler: app.engine,
	}
	// 运行服务器
	go func() {
		if err := a.server.ListenAndServe(); err != nil {
			logger.Logger.Warn(err.Error())
		}
	}()
	// 运行任务托盘
	go func() {
		systray.Run(InitSystray(a), onExit)
	}()
}

func (a *App) Refresh() {
	runtime.WindowReload(a.ctx)
}

func (a *App) DevTool() {
	opt.Debug.OpenInspectorOnStartup = !opt.Debug.OpenInspectorOnStartup
}
func (a *App) Resize(flag bool) {
	opt.DisableResize = flag
}

func (a *App) exit(ctx context.Context) {
	// 关闭服务器
	if err := a.server.Close(); err != nil {
		logger.Logger.Error("close server error", zap.Error(err))
	}
	logger.Logger.Info("server shutdown")
	logger.Logger.Info("app shutdown")
}

func (a *App) Theme(dark bool) {
	if dark {
		opt.Windows.Theme = windows.Dark
	} else {
		opt.Windows.Theme = windows.Light
	}
}
