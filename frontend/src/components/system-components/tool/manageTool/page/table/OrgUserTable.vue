<template>
  <div class="fit column justify-between">
    <!--  条件过滤  -->
    <div class="filter column full-width justify-between" style="padding-bottom:10px;">
      <div class="row justify-between">
        <div class="row ">
          <el-input class="opt" v-model="filter.account" style="width: 140px" size="large" placeholder="账号"/>
          <el-input class="opt" v-model="filter.name" style="width: 140px" size="large" placeholder="昵称"/>
          <el-select class="opt" v-model="filter.gender" label="状态" value-key="value"
                     size="large" style="width: 80px"
          >
            <el-option
                v-for="item in genderOptions"
                :key="item.value"
                :label="item.label"
                :value="item">
            </el-option>
          </el-select>
          <el-input class="opt" v-model="filter.phone" style="width: 140px" size="large" placeholder="手机"/>
          <el-input class="opt" v-model="filter.email" style="width: 240px" size="large" placeholder="邮箱"/>
        </div>
        <div>
          <el-button text size="large">
            <el-icon>
              <span class="icon iconfont jimu-chaxun"></span>
            </el-icon>
          </el-button>
        </div>
      </div>
    </div>
    <!--  表格数据  -->
    <div style="flex-grow: 1" class="full-width column justify-between">
      <el-table :data="users" border style="width: 100%;height: 90%">
        <el-table-column type="selection" width="55"/>
        <el-table-column fixed prop="account" label="账号" width="100px"/>
        <el-table-column prop="name" label="昵称" width="100">
          <template #default="scope">
            <div class="fit row">
              <q-chip style="height: 15px">
                <q-avatar>
                  <img :src="scope.row.picture">
                </q-avatar>
                {{ scope.row.name }}
              </q-chip>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="gender" label="性别" width="100px">
          <template #default="scope">
            {{ app.get('user', scope.row.gender)}}
          </template>
        </el-table-column>
        <el-table-column prop="phone" label="手机" width="200px"/>
        <el-table-column prop="email" label="邮箱" width="200px"/>
        <el-table-column fixed="right" label="操作" align="right" >
          <template #default="scope">
            <div class="row justify-end">
              <el-button link size="large" type="warning" @click="open(scope.row)">
                <el-icon>
                  <span class="icon iconfont jimu-quanxianguanli"></span>
                </el-icon>
              </el-button>
              <el-popconfirm title="确认删除?">
                <template #reference>
                  <el-button link size="large" type="danger">
                    <el-icon>
                      <span class="icon iconfont jimu-shanchu"></span>
                    </el-icon>
                  </el-button>
                </template>
              </el-popconfirm>
            </div>
          </template>
          <template #header class="fit">
            <div class="fit row reverse">
              <div class="full-height column justify-center">
                <el-button text type="danger" size="small">删除</el-button>
              </div>
            </div>
          </template>
        </el-table-column>
      </el-table>
      <div>
        <el-button class="mt-4" plain style="width: 100%">新增组织用户</el-button>
      </div>
    </div>
    <!--  分页组件  -->
    <div class="row justify-center" style="padding-top: 15px">
      <div class="column justify-center">
        <Pagination v-model:page="page" v-model:size="size" :total="count" @action="action"/>
      </div>
    </div>
    <UserRoleDialog v-model="flag" :user-info="userInfo" :org-id="orgId" title="用户权限配置"/>
  </div>
</template>

<script setup lang="ts">
import {useAppStore} from "@/store/app";
import {onMounted, ref, watch} from "vue";
import {getOrgUserList} from "@/components/system-components/tool/manageTool/manageRequest";
import {User} from "@/components/system-components/model/system";

const app = useAppStore()

const props = defineProps({
  orgId: {
    type: String,
    required: true
  }
})

const users = ref<User[]>([])
const flag = ref(false)
const userInfo = ref<User>({})
const filter = ref({
  account: '',
  name: '',
  gender: {
    value: 0,
    label: '男'
  },
  phone: '',
  email: '',
})

// 性别过滤条件
let genderOptions = [
  {value: 0, label: '男'},
  {value: 1, label: '女'},
]


const page = ref(1)
const size = ref(10)
const count = ref(0)

/*
* @description: 获取用户的授权信息,不能操作当前登录用户自己的信息
* */
function open(value: User) {
  if (!flag.value) {
    userInfo.value = value
    flag.value = true
    return
  }
  if (userInfo.value.id == value.id) {
    return;
  }
  // 切换打开的用户做一个延迟打开
  flag.value = false
  setTimeout(() => {
    userInfo.value = value
    flag.value = true
  }, 200)
}


/*
* @description: 加载当前组织下所有用户
* */
function load(page: number = 1, size: number =10) {
  getOrgUserList(props.orgId, page, size).then(data => {
    users.value = data.rows
    count.value = data.count
  })
}

/*
* @description: 翻页动作
* */
function action(page: number, size: number) {
  // 加载组织下所有角色
  load(page, size)
}

watch(() => props.orgId, (value) => {
  load()
})

onMounted(() => {
  load()
})

</script>


<style scoped>
.filter .opt {
  margin-right: 10px;
}
</style>

<style>
.el-tabs__content {
  height: 90%;
}

.el-tab-pane {
  height: 100%;
}
</style>