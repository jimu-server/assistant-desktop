<template>
  <div class="notify fit">
    <q-scroll-area class="fit" :visible="false">
      <q-list class="fit">
        <q-expansion-item v-for="item in notify.list" :key="item.id" :label="item.title" :label-lines="1">
          <!--          <template v-slot:header>
                      <div class="ellipsis">
                        {{ item.title }}
                      </div>
                    </template>-->
        </q-expansion-item>
      </q-list>
    </q-scroll-area>
  </div>
</template>

<script setup lang="ts">
import {onMounted, ref} from "vue";
import {getAllNotify} from "@/components/system-components/tool/notifyTool/notifyRequest";

import {useNotifyStore} from "@/store/tool/notify";

const init = ref()

const notify = useNotifyStore()


</script>


<style scoped>

</style>