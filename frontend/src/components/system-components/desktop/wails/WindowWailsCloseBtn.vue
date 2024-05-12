<script setup lang="ts">
import {desktop_close} from "@/components/system-components/desktop/desktop";
import {useWailsStore} from "@/components/system-components/desktop/wails/wailsDesktop";

const desktop = useWailsStore();
</script>

<template>
  <q-btn dense square flat class="close-btn" icon="jimu-guanbi" @click.stop="desktop.desktop_exit"
         style="height: 100%;width: 43px;--wails-draggable:no-drag;font-size: 10px"/>
</template>

<style scoped>
.close-btn:hover {
  background: red;
  color: white;
}
</style>