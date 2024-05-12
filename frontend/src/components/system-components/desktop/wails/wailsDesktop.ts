import {
    WindowCenter,
    WindowHide,
    WindowIsMinimised,
    WindowMinimise,
    WindowSetDarkTheme,
    WindowSetLightTheme,
    WindowSetMaxSize,
    WindowSetMinSize,
    WindowSetSize,
    WindowShow,
    WindowToggleMaximise,
    WindowUnminimise
} from "../../../../../wailsjs/runtime";
import {defineStore} from "pinia";
import {Refresh, Theme} from "../../../../../wailsjs/go/app/Window";


export const useWailsStore = defineStore('wails-desktop', {
    state: () => {
        return {}
    },
    persist: true,
    getters: {},
    actions: {
        desktop_light() {
            WindowSetLightTheme()
            Theme(false)
        },
        desktop_dark() {
            WindowSetDarkTheme()
            Theme(true)
        },
        desktop_hide() {
            WindowHide()
        },
        desktop_show() {
            WindowShow()
        },
        async desktop_login() {
            WindowSetMaxSize(0, 0)
            WindowSetMinSize(1024, 600)
            await WindowSetSize(1024, 600)
            setTimeout(() => {
                WindowCenter()
                this.desktop_show()
            }, 500)

        },
        async desktop_logout() {
            WindowSetMinSize(360, 400)
            WindowSetMaxSize(360, 400)
            await WindowSetSize(360, 400)
            setTimeout(() => {
                WindowCenter()
                this.desktop_show()
            }, 500)
        },
        desktop_minimize() {
            WindowIsMinimised().then(flag => {
                if (flag) {
                    WindowUnminimise()
                } else {
                    WindowMinimise()
                }
            })
        },
        desktop_exit() {
            WindowHide()
        },
        async desktop_refresh() {
            await Refresh()
        },
        desktop_toggle() {
            WindowToggleMaximise()
        }
    }
})
