package app

import (
	_ "embed"
	"github.com/energye/systray"
	"github.com/wailsapp/wails/v2/pkg/runtime"
)

func InitSystray(win *Window) func() {
	return func() {
		systray.SetIcon(win.Icon)
		systray.SetTitle("assistant")
		mQuit := systray.AddMenuItem("退出", "")
		systray.SetOnRClick(func(menu systray.IMenu) {
			if err := menu.ShowMenu(); err != nil {
				return
			}
		})

		systray.SetOnDClick(func(menu systray.IMenu) {
			runtime.WindowShow(win.ctx)
		})

		mQuit.Click(func() {
			win.Quit()
			systray.Quit()
		})
	}
}

func onExit() {
	// clean up here
}
