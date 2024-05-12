// @ts-ignore
import {defineConfig} from 'vite'
// @ts-ignore
import vue from '@vitejs/plugin-vue'
// @ts-ignore
import {quasar, transformAssetUrls} from '@quasar/vite-plugin'
// @ts-ignore
import renderer from 'vite-plugin-electron-renderer'

import {rmSync} from 'node:fs'
// @ts-ignore
import pkg from './package.json'


// CKEditor
import {createRequire} from 'node:module';
import {URL} from 'node:url';
import ckeditor5 from '@ckeditor/vite-plugin-ckeditor5';
// @ts-ignore
import vueJsx from '@vitejs/plugin-vue-jsx'


import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import {ElementPlusResolver} from 'unplugin-vue-components/resolvers'
import path from "path";

const require = createRequire(import.meta.url);
// https://vitejs.dev/config/
export default defineConfig(({command}) => {
    rmSync('dist-electron', {recursive: true, force: true})

    const isServe = command === 'serve'
    const isBuild = command === 'build'
    const sourcemap = isServe || !!process.env.VSCODE_DEBUG

    return {
        resolve: {
            alias: {
                "@": path.join(__dirname, "src"),
            },
        },
        plugins: [
            AutoImport({
                resolvers: [ElementPlusResolver()],
            }),
            Components({
                resolvers: [ElementPlusResolver()],
                // directoryAsNamespace: true,
            }),
            ckeditor5({theme: require.resolve('@ckeditor/ckeditor5-theme-lark')}),
            vue({
                template: {transformAssetUrls}
            }),
            quasar({
                sassVariables: 'src/quasar-variables.sass',
                runMode: 'web-client',
            }),
        ],
        server: process.env.VSCODE_DEBUG && (() => {
            const url = new URL(pkg.debug.env.VITE_DEV_SERVER_URL)
            return {
                host: url.hostname,
                port: +url.port,
                hmr: true
            }
        })(),
        clearScreen: false,
        build: {
            sourcemap: false,
            cssCodeSplit: true,
            chunkSizeWarningLimit: 500,
            terserOptions: {
                compress: {
                    drop_console: true,
                    drop_debugger: true,
                },
            },
        }
    }
})
