drop table if exists app_dictionary;
create table app_dictionary
(
    id          int generated by default as identity primary key,
    type        varchar(30),
    status      int         not null,
    name        varchar(30) not null,
    create_time timestamp(0) default now()
);

comment on table app_dictionary is '字典表';
comment on column app_dictionary.type is '字典类别';
comment on column app_dictionary.status is '字典状态值';
comment on column app_dictionary.name is '字典名称';
comment on column app_dictionary.create_time is '创建时间';


-- 消息表
drop table if exists app_notify;
create table app_notify
(
    id          varchar(30) primary key,
    pub_id      varchar(30)  not null,
    sub_id      varchar(30)  not null,
    title       varchar(50)  not null,
    msg_type    int          default 0,
    text        varchar(500) not null,
    status      int          default 0,
    del         int          default 0,
    create_time timestamp(0) default now(),
    update_time timestamp(0) default now()
);
comment on table app_notify is '消息通知表';
comment on column app_notify.pub_id is '生产者';
comment on column app_notify.sub_id is '消费者';
comment on column app_notify.title is '消息标题';
comment on column app_notify.msg_type is '消息类型 1:info 2:success 3:warning 4:error';
comment on column app_notify.text is '消息文本';
comment on column app_notify.status is '消息状态 0:已处理 1:未处理';
comment on column app_notify.del is '软删除';
comment on column app_notify.create_time is '创建时间';
comment on column app_notify.update_time is '处理时间';



drop table if exists app_user;
create table if not exists app_user
(
    id          varchar(30) primary key,
    name        varchar(50)  not null,
    account     varchar(50)  not null unique,
    phone       varchar(11)  not null default '',
    email       varchar(100) not null default '',
    password    varchar(100) not null default '',
    picture     varchar(500) not null default '',
    gender      int          not null default 0,
    age         int          not null default 0,
    create_time timestamp(0)          default now() not null
);
create index user_account_key on app_user (account);
create index user_phone_key on app_user (phone);
create index user_email_key on app_user (email);
create index ape on app_user (account, phone, email);
comment on table app_user is '系统的账号表 ';
comment on column app_user.account is '用户注册账号 对应 ';
comment on column app_user.name is '用户昵称 ';
comment on column app_user.picture is '用户头像 ';
comment on column app_user.password is '用户密码';
comment on column app_user.gender is '性别';
comment on column app_user.age is '年龄';
comment on column app_user.phone is '手机';
comment on column app_user.email is '邮箱';
comment on column app_user.create_time is '创建时间';

-- 组织
drop table if exists app_org;
create table app_org
(
    id          varchar(30) primary key,
    pid         varchar(30),
    name        varchar(30),
    create_time timestamp(0) not null default now()
);

comment on table app_org is '组织表 ';
comment on column app_org.pid is '上级组织 ';
comment on column app_org.name is '用户昵称 ';
comment on column app_org.create_time is '创建时间';


-- 角色
drop table if exists app_role;
create table app_role
(
    id          varchar(30) primary key,
    name        varchar(30),
    role_key    varchar(50)  not null,
    create_time timestamp(0) not null default now()
);

comment on table app_role is '角色 ';
comment on column app_role.name is '角色名称 ';
comment on column app_role.role_key is '角色标识符 ';
comment on column app_role.create_time is '创建时间';


-- 用户分配组织
drop table if exists app_org_user;
create table app_org_user
(
    id           varchar(30) primary key,
    org_id       varchar(30)  not null,
    user_id      varchar(30)  not null,
    first_choice bool         not null default false,
    create_time  timestamp(0) not null default now()
);
comment on table app_org_user is '用户组织关系表 ';
comment on column app_org_user.org_id is '组织id';
comment on column app_org_user.user_id is '用户id ';
comment on column app_org_user.first_choice is '当前组织是否为首选组织';
comment on column app_org_user.create_time is '创建时间';

-- 初始化组织角色
drop table if exists app_org_role;
create table app_org_role
(
    id          varchar(30) primary key,
    org_id      varchar(30)  not null,
    role_id     varchar(50)  not null,
    create_time timestamp(0) not null default now()
);
comment on table app_org_role is '组织角色表';
comment on column app_org_role.org_id is '角色所属组织id';
comment on column app_org_role.role_id is '角色id ';
comment on column app_org_role.create_time is '创建时间';

drop table if exists app_org_user_role;
create table app_org_user_role
(
    id           varchar(30) primary key,
    org_id       varchar(30)  not null,
    user_id      varchar(30)  not null,
    role_id      varchar(50)  not null,
    first_choice bool         not null default false,
    create_time  timestamp(0) not null default now()
);
comment on table app_org_user_role is '组织用户角色分配表';
comment on column app_org_user_role.org_id is '角色所属组织id';
comment on column app_org_user_role.role_id is '角色id ';
comment on column app_org_user_role.user_id is '用户id ';
comment on column app_org_user_role.first_choice is '是否用户首选角色';
comment on column app_org_user_role.create_time is '创建时间';

-- 工具栏
drop table if exists app_tool;
create table app_tool
(
    id          varchar(30) primary key,
    name        varchar(100) not null,
    router_name varchar(50)  not null,
    icon        varchar(100) not null,
    component   varchar(100) not null,
    btn         varchar(100) not null,
    type        int          not null,
    ws          varchar(200) not null,
    pull        varchar(100) not null,
    path        varchar(200) not null,
    tip         varchar(100) not null,
    position    int          not null
);
comment on table app_tool is '周边工具栏表';
comment on column app_tool.name is '工具名';
comment on column app_tool.router_name is '路由名称,并且不能重复';
comment on column app_tool.icon is '图标';
comment on column app_tool.component is '工具对应窗口组件';
comment on column app_tool.btn is '工具对应按钮';
comment on column app_tool.type is '工具类型,1路由工具,2工具窗口工具(对应没有 path路径,component对应则是工具展示的窗口组件)';
comment on column app_tool.ws is '消息推送接口';
comment on column app_tool.pull is '消息拉取接口';
comment on column app_tool.path is '工具基础路径 工具栏下的所有路由都应该基于此 /{name}';
comment on column app_tool.tip is '提示语,一般填写工具名称';
comment on column app_tool.position is '工具按钮位置信息 1:左侧 2:右侧';

-- 初始化系统路由
drop table if exists app_router;
create table app_router
(
    id          varchar(30) primary key,
    pid         varchar(30)           default '0',
    title       varchar(100)          default '',
    name        varchar(100)          default '',
    icon        varchar(100)          default '',
    component   varchar(200)          default '',
    path        varchar(100)          default '',
    remark      varchar(500)          default '',
    status      bool                  default true,
    sort        int,
    tool_id     varchar(30)           default 0,
    create_time timestamp(0) not null default now()
);
comment on table app_router is '系统路由表';
comment on column app_router.pid is '父节点';
comment on column app_router.name is '菜单标题 ';
comment on column app_router.icon is '组件图标';
comment on column app_router.component is '组件名称,组件基于前端根路径的路径信息';
comment on column app_router.path is '路由路径(注册路由时候的注册路径)';
comment on column app_router.remark is '备注信息';
comment on column app_router.status is '菜单启用状态 0:未启用 1:启用';
comment on column app_router.sort is '排序字段';
comment on column app_router.tool_id is '菜单所属工具栏';
comment on column app_router.create_time is '创建时间';


-- 功能表
drop table if exists app_fun;
create table app_fun
(
    id          varchar(30) primary key,
    method      varchar(10),
    name        varchar(100),
    path        varchar(100),
    status      boolean               default true,
    create_time timestamp(0) not null default now()
);

comment on table app_fun is '功能路由表';
comment on column app_fun.method is '接口类型';
comment on column app_fun.name is '功能名称';
comment on column app_fun.path is '功能路径';
comment on column app_fun.status is '菜单启用状态 0:未启用 1:启用';


drop table if exists app_org_role_router_auth;
create table app_org_role_router_auth
(
    id          varchar(30) primary key,
    org_id      varchar(30)  not null,
    role_id     varchar(30)  not null,
    tool_id     varchar(30)  not null,
    router_id   varchar(30)  not null,
    create_time timestamp(0) not null default now()
);
comment on table app_org_role_router_auth is '角色对应工具栏授权的路由表';
comment on column app_org_role_router_auth.org_id is '组织id';
comment on column app_org_role_router_auth.role_id is '角色id';
comment on column app_org_role_router_auth.tool_id is '工具栏id';
comment on column app_org_role_router_auth.router_id is '路由id';


drop table if exists app_org_role_tool_auth;
create table app_org_role_tool_auth
(
    id          varchar(30) primary key,
    org_id      varchar(30)  not null,
    role_id     varchar(30)  not null,
    tool_id     varchar(30)  not null,
    create_time timestamp(0) not null default now()
);
comment on table app_org_role_tool_auth is '角色对应的工具栏授权';
comment on column app_org_role_tool_auth.org_id is '组织id';
comment on column app_org_role_tool_auth.role_id is '角色id';
comment on column app_org_role_tool_auth.tool_id is '工具栏id';

drop table if exists app_org_role_fun_auth;
create table app_org_role_fun_auth
(
    id          varchar(30) primary key,
    role_id     varchar(30)  not null,
    fun_id      varchar(30)  not null,
    create_time timestamp(0) not null default now()
);
comment on table app_org_role_fun_auth is '角色对应的功能授权';
comment on column app_org_role_fun_auth.role_id is '角色id';
comment on column app_org_role_fun_auth.fun_id is '功能id';


drop table if exists app_org_user_role_tool_auth;
create table app_org_user_role_tool_auth
(
    id          varchar(30) primary key,
    user_id     varchar(30)  not null,
    role_id     varchar(30)  not null,
    org_id      varchar(30)  not null,
    tool_id     varchar(30)  not null,
    create_time timestamp(0) not null default now()
);
comment on table app_org_user_role_tool_auth is '组织-用户-角色-工具栏授权表';
comment on column app_org_user_role_tool_auth.org_id is '组织id';
comment on column app_org_user_role_tool_auth.user_id is '用户id';
comment on column app_org_user_role_tool_auth.role_id is '角色id';
comment on column app_org_user_role_tool_auth.tool_id is '工具栏id';


drop table if exists app_org_user_role_router_auth;
create table app_org_user_role_router_auth
(
    id          varchar(30) primary key,
    org_id      varchar(30)  not null,
    user_id     varchar(30)  not null,
    role_id     varchar(30)  not null,
    tool_id     varchar(30)  not null,
    router_id   varchar(30)  not null,
    create_time timestamp(0) not null default now()
);
comment on table app_org_user_role_router_auth is '组织-用户-角色-工具栏-路由授权表';
comment on column app_org_user_role_router_auth.org_id is '组织id';
comment on column app_org_user_role_router_auth.user_id is '用户id';
comment on column app_org_user_role_router_auth.role_id is '角色id';
comment on column app_org_user_role_router_auth.tool_id is '工具栏id';
comment on column app_org_user_role_router_auth.router_id is '路由id';



drop table if exists app_org_user_role_fun_auth;
create table app_org_user_role_fun_auth
(
    id          varchar(30) primary key,
    user_id     varchar(30)  not null,
    role_id     varchar(30)  not null,
    org_id      varchar(30)  not null,
    fun_id      varchar(30)  not null,
    create_time timestamp(0) not null default now()
);

drop table if exists app_setting;
create table app_setting
(
    id          varchar(30) primary key,
    pid         varchar(30)  not null,
    name        varchar(100) not null,
    value       varchar(500) not null,
    setting     json                  default '{}',
    create_time timestamp(0) not null default now()
);
comment on table app_setting is 'gpt 会话表';
comment on column app_setting.id is '设置id';
comment on column app_setting.name is '设置项名';
comment on column app_setting.value is '设置项展示组件名';
comment on column app_setting.setting is '设置属性值';

drop table if exists app_chat_conversation;
create table app_chat_conversation
(
    id          varchar(30) primary key,
    picture     varchar(500) not null default '',
    user_id     varchar(30)  not null,
    title       varchar(100) not null,
    last_model  varchar(30)           default '',
    last_msg    text                  default '',
    last_time   timestamp(0) not null default now(),
    create_time timestamp(0) not null default now()
);

comment on table app_chat_conversation is 'gpt 会话表';
comment on column app_chat_conversation.picture is '会话头像';
comment on column app_chat_conversation.user_id is '接收者id:一般是用户id';
comment on column app_chat_conversation.last_model is '最后一次消息的模型id';
comment on column app_chat_conversation.last_msg is '最后一次消息的内容';
comment on column app_chat_conversation.last_time is '最后一次消息的时间';
comment on column app_chat_conversation.title is '会话标题';


drop table if exists app_chat_message;
create table app_chat_message
(
    id              varchar(30) primary key,
    conversation_id varchar(30)  not null,
    message_id      varchar(30)  not null,
    user_id         varchar(30)  not null,
    model_id        varchar(30)  not null,
    picture         varchar(100) not null,
    role            varchar(30)  not null,
    content         text,
    create_time     timestamp(0) not null default now()
);

comment on table app_chat_message is 'gpt 会话消息表';
comment on column app_chat_message.user_id is '所属用户';
comment on column app_chat_message.message_id is '标识当前消息相关回复的消息id,对于用户发送的消息,回复的消息应该是gpt的消息id,若是首次消息则为消息主键本身';
comment on column app_chat_message.model_id is '模型id,当前消息产生于那个模型';
comment on column app_chat_message.picture is '消息头像,消息角色所属头像';
comment on column app_chat_message.conversation_id is '消息所属会话';
comment on column app_chat_message.role is '消息角色 :user[用户] or assistant[助手]';
comment on column app_chat_message.content is '消息内容';
comment on column app_chat_message.create_time is '消息时间';


drop table if exists app_chat_model;
create table app_chat_model
(
    id            varchar(30) primary key,
    pid           varchar(30)  not null,
    user_id       varchar(30)  not null,
    name          varchar(100) not null,
    model         varchar(100) not null,
    picture       varchar(100) not null,
    size          varchar(50)  not null,
    digest        varchar(100)          default '',
    model_details json                  default '{}',
    is_download   boolean               default false,
    create_time   timestamp(0) not null default now()
);
create index model_key on app_chat_model (model);
comment on table app_chat_model is 'ollama 内置模型';
comment on column app_chat_model.user_id is '所属用户';
comment on column app_chat_model.pid is '父模型,内置模型的 pid==id';
comment on column app_chat_model.name is '名称,显示名称';
comment on column app_chat_model.model is '模型名,一版是调用模型传参';
comment on column app_chat_model.picture is '图标';
comment on column app_chat_model.size is '模型大小';
comment on column app_chat_model.is_download is '是否下载';

drop table if exists app_chat_knowledge_file;
create table app_chat_knowledge_file
(
    id          varchar(30) primary key,
    pid         varchar(30)  not null,
    user_id     varchar(30)  not null,
    file_name   varchar(100) not null,
    file_path   varchar(100) not null,
    file_type   int          not null,
    create_time timestamp(0) not null default now()
);
comment on table app_chat_knowledge_file is '知识库文件';
comment on column app_chat_knowledge_file.id is '知识库id';
comment on column app_chat_knowledge_file.pid is '上级';
comment on column app_chat_knowledge_file.file_name is '文件名';
comment on column app_chat_knowledge_file.file_path is '文件路径';
comment on column app_chat_knowledge_file.file_type is '文件类型';
comment on column app_chat_knowledge_file.create_time is '创建时间';

drop table if exists app_chat_knowledge_instance;
create table app_chat_knowledge_instance
(
    id                    varchar(30) primary key,
    user_id               varchar(30)  not null,
    knowledge_name        varchar(500) not null default '[]',
    knowledge_files       json         not null default '[]',
    knowledge_description varchar(500) not null default '',
    knowledge_type        int          not null default 0,
    create_time           timestamp(0) not null default now()
);
comment on table app_chat_knowledge_instance is '知识库实例';
comment on column app_chat_knowledge_instance.user_id is '所属用户';
comment on column app_chat_knowledge_instance.knowledge_name is '知识库名称';
comment on column app_chat_knowledge_instance.knowledge_description is '知识库描述';
comment on column app_chat_knowledge_instance.knowledge_files is '知识库文件列表';
comment on column app_chat_knowledge_instance.create_time is '创建时间';
comment on column app_chat_knowledge_instance.knowledge_type is '知识库类型;区分系统预置,和用户创建';

