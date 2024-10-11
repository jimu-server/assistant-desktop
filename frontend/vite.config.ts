// @ts-ignore
import {defineConfig, loadEnv} from 'vite'
// @ts-ignore
import vue from '@vitejs/plugin-vue'
// @ts-ignore
import {quasar, transformAssetUrls} from '@quasar/vite-plugin'

import electron from "vite-plugin-electron";
import {notBundle} from 'vite-plugin-electron/plugin'
// @ts-ignore
import renderer from 'vite-plugin-electron-renderer'

import {rmSync} from 'node:fs'
// @ts-ignore
import pkg from './package.json'
import VueDevTools from 'vite-plugin-vue-devtools'


// CKEditor
import {createRequire} from 'node:module';
import {URL} from 'node:url';
import ckeditor5 from '@ckeditor/vite-plugin-ckeditor5';
// @ts-ignore
import vueJsx from '@vitejs/plugin-vue-jsx'


import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'
import path from "path";
import {univerPlugin} from "@univerjs/vite-plugin";

const require = createRequire(import.meta.url);
// https://vitejs.dev/config/
export default defineConfig(({command, mode}) => {
  const isServe = command === 'serve'
  const isBuild = command === 'build'
  const sourcemap = isServe || !!process.env.VSCODE_DEBUG
  const env = loadEnv(mode, process.cwd());
  return {
    resolve: {
      alias: {
        "@": path.join(__dirname, "src"),
      },
    },
    plugins: [
      // AutoImport({
      //   resolvers: [ElementPlusResolver()],
      // }),
      // Components({
      //   resolvers: [ElementPlusResolver()],
      //   // directoryAsNamespace: true,
      // }),
      ckeditor5({theme: require.resolve('@ckeditor/ckeditor5-theme-lark')}),
      vue({
        template: {transformAssetUrls}
      }),
      quasar({
        sassVariables: 'src/quasar-variables.sass',
        runMode: 'web-client',
      }),
      univerPlugin(),
      renderer(),
    ],
    server: {
      host: true,
      // 跨域设置允许
      cors: true,
      // 如果端口已占用直接退出
      strictPort: true,
    },
  }
})
