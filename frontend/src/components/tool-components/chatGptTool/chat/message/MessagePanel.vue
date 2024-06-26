<template>
  <div style="height: 100%;overflow: hidden">
    <!-- 用户头像及其在线状态 -->
    <q-toolbar style="height: 10%;width: 100%;border-bottom: rgba(140,147,157,0.34) 1px solid">
      <div class="row" style="margin-left: 10px;height: 100%">
        <div class="column justify-center" style="margin-left: 5px">
          <div class="row">
            <div style="margin-left: 5px;margin-right:10px;user-select: none;">
              {{ ctx.CurrentChat.Current.Conversation.title }}
            </div>
          </div>
        </div>
      </div>
      <q-space/>
      <MessageHeaderBar/>
    </q-toolbar>
    <div style="height:89%;overflow-x: hidden;">
      <q-scroll-area ref="scrollAreaRef" id="messageScrollArea" class="fit" :visible="false"
                     style="overflow-x: hidden;">
        <!-- 更具实际布局对照,消息大于多少条时切换到 -->
        <q-infinite-scroll v-if="ctx.CurrentChat.messageList.length>10" :visible="false" :offset="0" reverse
                           style="width: 100%"
                           @load="loadMessage">
          <template v-for="(item,index) in ctx.CurrentChat.messageList">
            <chat-message :message="item" :index="index"/>
          </template>
          <template v-slot:loading>
            <div class="row justify-center q-my-md">
              <q-spinner-ios color="primary" size="20px"/>
            </div>
          </template>
        </q-infinite-scroll>
        <!-- 不显示滚动加载消息操作 -->
        <div v-else>
          <template v-for="(item,index) in ctx.CurrentChat.messageList">
            <chat-message :message="item" :index="index"/>
          </template>
        </div>
      </q-scroll-area>
    </div>
  </div>
</template>


<script setup lang="ts">
import {onUnmounted, ref, watch} from "vue";
import emitter from "@/plugins/event";
import {MessageObserver, ScrollMove, SendActionScroll} from "@/plugins/evenKey";
import {useThemeStore} from "@/store/theme";
import {useGptStore} from "@/components/tool-components/chatGptTool/chat/store/gpt";
import {MessageType} from "@/components/tool-components/chatGptTool/chat/model/chat";
import {updateTheme} from "@/components/tool-components/chatGptTool/chat/style/update";
import MenuItem from "@/components/system-components/widget/MenuItem.vue";
import OllamaModelSelect from "@/components/tool-components/chatGptTool/widget/OllamaModelSelect.vue";
import KnowledgeFileManage from "@/components/tool-components/chatGptTool/widget/knowledge/KnowledgeFileManage.vue";
import MessageHeaderBar from "@/components/tool-components/chatGptTool/chat/message/MessageHeaderBar.vue";
import ChatMessage from "@/components/tool-components/chatGptTool/chat/message/ChatMessage.vue";

const scrollAreaRef = ref()
const ctx = useGptStore()
const fileManageFlag = ref(false)
const ollamaCreateFlag = ref(false)
defineExpose({
  MoveScrollBottom,
})

function loadMessage(index, done) {
  setTimeout(async () => {
    // await ctx.GetMessageHistory()
    done()
  }, 500)

}

function isMessage(id: MessageType): boolean {
  /*  switch (id) {
      case MessageType.FriendAdded:
        return false
    }*/
  return true
}


/*
* @description: 移动滚动条到最底部
* */
function MoveScrollBottom() {
  move_scroll_bottom()

  // 处理大量消息的动态渲染,第一次滚动到底部会不完整,需要补偿一次滚动
  setTimeout(() => {
    move_scroll_bottom()
  }, 1000)
}

function move_scroll_bottom() {
  if (scrollAreaRef.value) {
    let percentage = scrollAreaRef.value.getScrollPercentage();
    if (percentage.top <= 1) {
      let scrollTarget = scrollAreaRef.value.getScrollTarget()
      let height = scrollTarget.scrollHeight
      scrollAreaRef.value.setScrollPosition('vertical', height)
    }

  }
}

/*
* @description: 接收消息触发消息滚动
* */
function MoveScroll() {
  if (ctx.ui.showChat) {
    setTimeout(() => {
      // 获取当前滚动条所处位置的比例
      let percentage = scrollAreaRef.value.getScrollPercentage();
      if (percentage.top > 0.6) {
        let scrollTarget = scrollAreaRef.value.getScrollTarget()
        let height = scrollTarget.scrollHeight
        scrollAreaRef.value.setScrollPosition('vertical', height)
      }
    }, 200)
  }
}

/*
* @description 发送消息触发 消息面板消息滚动
* */
function SendActionMoveScroll() {
  // 必须延迟跟新,否则 api 无法感知到 ui 高度变化
  setTimeout(() => {
    let scrollTarget = scrollAreaRef.value.getScrollTarget()
    let height = scrollTarget.scrollHeight
    scrollAreaRef.value.setScrollPosition('vertical', height)
  }, 100)
}

let first = false
let options = {
  root: document.getElementById("messageScrollArea"),
};
let observer = null

function beginObserver() {
  // 当前消息数量 小于50条数据不需要进行优化,不执行元素观察优化
  if (ctx.CurrentChat.messageList.length < 50) {
    return
  }
  // 创建元素观察器
  if (observer != null) {
    observer.disconnect()
  }
  observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      let perId = ((entry.target.previousSibling) as HTMLElement).id
      let id = entry.target.id
      let nextId = ((entry.target.nextSibling) as HTMLElement).id
      if (entry.isIntersecting) {
        if (entry.target.previousSibling) {
          if (!ctx.view.includes(perId)) {
            ctx.view.push(perId)
          }
        }
        if (entry.target.nextSibling) {
          if (!ctx.view.includes(nextId)) {
            ctx.view.push(nextId)
          }
        }
        if (!ctx.view.includes(id)) {
          ctx.view.push(id)
        }
      } else {
        // 元素离开可视区域,可显示数量超过一定数量就随机删除显示数据
        if (ctx.view.length > 15) {
          ctx.view.splice(0, ctx.view.length - 10)
        }
      }
    });
  }, options);

  let elements = document.querySelectorAll('.message-entity');
  elements.forEach(element => {
    observer.observe(element)
  })
}

const theme = useThemeStore()
setTimeout(() => {
  updateTheme(theme.dark)
}, 500)
watch(() => theme.dark, (value) => {
  updateTheme(value)
})

emitter.on(MessageObserver, beginObserver)
emitter.on(ScrollMove, MoveScroll)
emitter.on(SendActionScroll, SendActionMoveScroll)

onUnmounted(() => {
  emitter.off(ScrollMove, MoveScroll)
  emitter.off(SendActionScroll, SendActionMoveScroll)
})


</script>

<style scoped>

</style>