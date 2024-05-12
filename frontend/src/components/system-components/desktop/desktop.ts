import {
    WindowCenter,
    WindowHide,
    WindowIsMinimised,
    WindowMinimise,
    WindowSetMaxSize,
    WindowSetMinSize,
    WindowSetSize,
    WindowShow,
    WindowToggleMaximise,
    WindowUnminimise
} from "../../../../wailsjs/runtime";
import {useAppStore} from "@/store/app";
import pinia from "@/pinia";
import {DevTool, Refresh, Resize} from "../../../../wailsjs/go/main/App";
import {defineStore} from "pinia";


export const useDesktopStore = defineStore('desktop', {
    state: () => {
        return {}
    },
    persist: true,
    getters: {},
    actions: {}
})

export function desktop_hide() {
    WindowHide()
}

export function desktop_show() {
    WindowShow()
}

export async function desktop_login() {
    WindowSetMinSize(1024, 600)
    WindowSetMaxSize(0, 0)
    await WindowSetSize(1024, 600)
    await Resize(true)
    setTimeout(() => {
        WindowCenter()
        desktop_show()
    }, 500)

}

export async function desktop_logout() {
    WindowSetMinSize(360, 400)
    WindowSetMaxSize(360, 400)
    await WindowSetSize(360, 400)
    setTimeout(() => {
        WindowCenter()
        desktop_show()
    }, 500)
}

export function desktop_minimize() {
    WindowIsMinimised().then(flag => {
        if (flag) {
            WindowUnminimise()
        } else {
            WindowMinimise()
        }
    })
}

export async function desktop_close() {
    WindowHide()
}

export async function WindowToggleMaximises() {
    WindowToggleMaximise()
    setTimeout(() => {
        let byId = document.getElementById("page-view");
        if (byId) {
            const app = useAppStore(pinia)
            app.ui.page.height = byId.style.minHeight
        }
    }, 200)
}

export async function desktop_exit() {
    WindowHide()
}


export async function desktop_open_dev() {
    await DevTool()
}


export async function desktop_refresh() {
    await Refresh()
}