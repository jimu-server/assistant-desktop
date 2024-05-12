<template>
  <div ref="tray" class="column justify-end fit">
    <q-list dense>
      <MenuItem icon="jimu-exit" text="退出" @click="desktop_exit"/>
    </q-list>
  </div>
</template>

<script setup lang="ts">


import {onMounted, ref} from "vue";
import MenuItem from "@/components/system-components/widget/MenuItem.vue";
import {desktop_exit} from "@/components/system-components/desktop/desktop";

const tray = ref()

function keepTray(event) {

}

// 菜单失去焦点时候隐藏

onMounted(() => {

})

</script>


<style scoped>

</style>