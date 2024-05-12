<script setup lang="ts">
import {WindowToggleMaximise} from "../../../../wailsjs/runtime";
</script>

<template>
  <q-btn dense square flat class="window-minimize" icon="jimu-window-maximize"
         :ripple="false" style="height: 100%;width: 43px;--wails-draggable:no-drag;"/>
</template>

<style scoped>

.window-minimize {

}

.window-minimize:hover {
  background-color: rgba(0, 0, 0, 0.1);
}

</style>