package main

import (
	_ "embed"
	"github.com/energye/systray"
	"github.com/wailsapp/wails/v2/pkg/runtime"
)

//go:embed build/windows/icon.ico
var icon []byte

func InitSystray(app *App) func() {
	return func() {
		systray.SetIcon(icon)
		systray.SetTitle("assistant")
		mQuit := systray.AddMenuItem("退出", "")
		systray.SetOnRClick(func(menu systray.IMenu) {
			if err := menu.ShowMenu(); err != nil {
				return
			}
		})

		systray.SetOnDClick(func(menu systray.IMenu) {
			runtime.WindowShow(app.ctx)
		})

		mQuit.Click(func() {
			app.Quit()
			systray.Quit()
		})
	}
}

func onExit() {
	// clean up here
}
