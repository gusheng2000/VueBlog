## Vue前端页面开发

### 1、前言

接下来，我们来完成vueblog前端的部分功能。可能会使用的到技术如下：

- vue
- element-ui
- axios
- mavon-editor
- markdown-it
- github-markdown-css

本项目实践需要一点点vue的基础，希望你对vue的一些指令有所了解，这样我们讲解起来就简单多了哈。

### 2、项目演示

我们先来看下我们需要完成的项目长什么样子，考虑到很多同学的样式的掌握程度不够，所以我尽量使用了element-ui的原生组件的样式来完成整个博客的界面。不多说，直接上图：

在线体验：[https://markerhub.com:8083](https://markerhub.com:8083/)

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/068bbd1dcddb40b79c54b02cc5516dfd.png)

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/c1fe32b559cf4b39a2be26b3990b884a.png)

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/b66dbd5169fd4f8f94109aa1bd65f48f.png)

### 3、环境准备

万丈高楼平地起，我们下面一步一步来完成，首先我们安装vue的环境，我实践的环境是windows 10哈。

1、首先我们上node.js官网(https://nodejs.org/zh-cn/)，下载最新的长期版本，直接运行安装完成之后，我们就已经具备了node和npm的环境啦。

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/5a30fecdf00d47619f99e4d15ed5c983.png)

安装完成之后检查下版本信息：

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/babbc453e8c94bf2b413d370e8ad8989.png)

2、接下来，我们安装vue的环境

```plain
# 安装淘宝npm
npm install -g cnpm --registry=https://registry.npm.taobao.org
# vue-cli 安装依赖包
cnpm install --g vue-cli
```

### 4、新建项目

```plain
# 打开vue的可视化管理工具界面
vue ui
```

上面我们分别安装了淘宝npm，cnpm是为了提高我们安装依赖的速度。vue ui是[@vue](https://github.com/vue)/cli3.0增加一个可视化项目管理工具，可以运行项目、打包项目，检查等操作。对于初学者来说，可以少记一些命令，哈哈。
3、创建vueblog-vue项目

运行vue ui之后，会为我们打开一个[http://localhost:8080](http://localhost:8080/) 的页面：

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/154ae9db3c0c4d9e9218bc74da7cddec.png)

然后切换到【创建】，注意创建的目录最好是和你运行vue ui同一级。这样方便管理和切换。然后点击按钮【在此创建新羡慕】

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/9e5178bc47cf406fa6a982032fb4e25d.png)

下一步中，项目文件夹中输入项目名称“vueblog-vue”，其他不用改，点击下一步，选择【手动】，再点击下一步，如图点击按钮，勾选上路由Router、状态管理Vuex，去掉js的校验。

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/b6d1d354fa3942458212ca24ed8316d4.png)

下一步中，也选上【Use history mode for router】，点击创建项目，然后弹窗中选择按钮【创建项目，不保存预设】，就进入项目创建啦。

稍等片刻之后，项目就初始化完成了。上面的步骤中，我们创建了一个vue项目，并且安装了Router、Vuex。这样我们后面就可以直接使用。

我们来看下整个vueblog-vue的项目结构

```plain
├── README.md            项目介绍
├── index.html           入口页面
├── build              构建脚本目录
│  ├── build-server.js         运行本地构建服务器，可以访问构建后的页面
│  ├── build.js            生产环境构建脚本
│  ├── dev-client.js          开发服务器热重载脚本，主要用来实现开发阶段的页面自动刷新
│  ├── dev-server.js          运行本地开发服务器
│  ├── utils.js            构建相关工具方法
│  ├── webpack.base.conf.js      wabpack基础配置
│  ├── webpack.dev.conf.js       wabpack开发环境配置
│  └── webpack.prod.conf.js      wabpack生产环境配置
├── config             项目配置
│  ├── dev.env.js           开发环境变量
│  ├── index.js            项目配置文件
│  ├── prod.env.js           生产环境变量
│  └── test.env.js           测试环境变量
├── mock              mock数据目录
│  └── hello.js
├── package.json          npm包配置文件，里面定义了项目的npm脚本，依赖包等信息
├── src               源码目录 
│  ├── main.js             入口js文件
│  ├── app.vue             根组件
│  ├── components           公共组件目录
│  │  └── title.vue
│  ├── assets             资源目录，这里的资源会被wabpack构建
│  │  └── images
│  │    └── logo.png
│  ├── routes             前端路由
│  │  └── index.js
│  ├── store              应用级数据（state）状态管理
│  │  └── index.js
│  └── views              页面目录
│    ├── hello.vue
│    └── notfound.vue
├── static             纯静态资源，不会被wabpack构建。
└── test              测试文件目录（unit&e2e）
  └── unit              单元测试
    ├── index.js            入口脚本
    ├── karma.conf.js          karma配置文件
    └── specs              单测case目录
      └── Hello.spec.js
```

### 5、安装element-ui

接下来我们引入element-ui组件（[https://element.eleme.cn](https://element.eleme.cn/#/zh-CN/component/installation)），这样我们就可以获得好看的vue组件，开发好看的博客界面。

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/b98ecc8a8cd84e3bbbe382424d25ad27.png)

命令很简单：

```plain
# 切换到项目根目录
cd vueblog-vue
# 安装element-ui
cnpm install element-ui --save
```

然后我们打开项目src目录下的main.js，引入element-ui依赖。

```plain
import Element from 'element-ui'
import "element-ui/lib/theme-chalk/index.css"
Vue.use(Element)
```

这样我们就可以愉快得在官网上选择组件复制代码到我们项目中直接使用啦。

### 6、安装axios

接下来，我们来安装axios（http://www.axios-js.com/），axios是一个基于 promise 的 HTTP 库，这样我们进行前后端对接的时候，使用这个工具可以提高我们的开发效率。

安装命令：

```sh
cnpm install axios --save
```

然后同样我们在main.js中全局引入axios。

```shell
import axios from 'axios'
Vue.prototype.$axios = axios //
```

组件中，我们就可以通过this.$axios.get()来发起我们的请求了哈。

### 7、页面路由

接下来，我们先定义好路由和页面，因为我们只是做一个简单的博客项目，页面比较少，所以我们可以直接先定义好，然后在慢慢开发，这样需要用到链接的地方我们就可以直接可以使用：

我们在views文件夹下定义几个页面：

- BlogDetail.vue（博客详情页）
- BlogEdit.vue（编辑博客）
- Blogs.vue（博客列表）
- Login.vue（登录页面）

然后再路由中心配置：

- router\index.js

```js
import Vue from 'vue'
import VueRouter from 'vue-router'
import Login from '../views/Login.vue'
import BlogDetail from '../views/BlogDetail.vue'
import BlogEdit from '../views/BlogEdit.vue'
Vue.use(VueRouter)
const routes = [
  {
    path: '/',
    name: 'Index',
    redirect: { name: 'Blogs' }
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/blogs',
    name: 'Blogs',
    // 懒加载
    component: () => import('../views/Blogs.vue')
  },
  {
    path: '/blog/add', // 注意放在 path: '/blog/:blogId'之前
    name: 'BlogAdd',
    meta: {
      requireAuth: true
    },
    component: BlogEdit
  },
  {
    path: '/blog/:blogId',
    name: 'BlogDetail',
    component: BlogDetail
  },
  {
    path: '/blog/:blogId/edit',
    name: 'BlogEdit',
    meta: {
      requireAuth: true
    },
    component: BlogEdit
  }
];
const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})
export default router
```

接下来我们去开发我们的页面。其中，带有meta：requireAuth: true说明是需要登录字后才能访问的受限资源，后面我们路由权限拦截时候会用到。

### 8、登录页面

接下来，我们来搞一个登陆页面，表单组件我们直接在element-ui的官网上找就行了，登陆页面就两个输入框和一个提交按钮，相对简单，然后我们最好带页面的js校验。emmm，我直接贴代码了~~

- views/Login.vue

```js
<template>
  <div>
    <el-container>
      <el-header>
        <router-link to="/blogs">
        <img src="https://www.markerhub.com/dist/images/logo/markerhub-logo.png"
             style="height: 60%; margin-top: 10px;">
        </router-link>
      </el-header>
      <el-main>
        <el-form :model="ruleForm" status-icon :rules="rules" ref="ruleForm" label-width="100px"
                 class="demo-ruleForm">
          <el-form-item label="用户名" prop="username">
            <el-input type="text" maxlength="12" v-model="ruleForm.username"></el-input>
          </el-form-item>
          <el-form-item label="密码" prop="password">
            <el-input type="password" v-model="ruleForm.password" autocomplete="off"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="submitForm('ruleForm')">登录</el-button>
            <el-button @click="resetForm('ruleForm')">重置</el-button>
          </el-form-item>
        </el-form>
      </el-main>
    </el-container>
  </div>
</template>

  export default {
    name: 'Login',
    data() {
      var validatePass = (rule, value, callback) => {
        if (value === '') {
          callback(new Error('请输入密码'));
        } else {
          callback();
        }
      };
      return {
        ruleForm: {
          password: '111111',
          username: 'markerhub'
        },
        rules: {
          password: [
            {validator: validatePass, trigger: 'blur'}
          ],
          username: [
            {required: true, message: '请输入用户名', trigger: 'blur'},
            {min: 3, max: 12, message: '长度在 3 到 12 个字符', trigger: 'blur'}
          ]
        }
      };
    },
    methods: {
      submitForm(formName) {
        const _this = this
        this.$refs[formName].validate((valid) => {
          if (valid) {
            // 提交逻辑
            this.$axios.post('http://localhost:8081/login', this.ruleForm).then((res)=>{
              const token = res.headers['authorization']
              _this.$store.commit('SET_TOKEN', token)
              _this.$store.commit('SET_USERINFO', res.data.data)
              _this.$router.push("/blogs")
            })
          } else {
            console.log('error submit!!');
            return false;
          }
        });
      },
      resetForm(formName) {
        this.$refs[formName].resetFields();
      }
    },
    mounted() {
      this.$notify({
        title: '看这里：',
        message: '关注公众号：MarkerHub，回复【vueblog】，领取项目资料与源码',
        duration: 1500
      });
    }
  }
```

找不到啥好的方式讲解了，之后先贴代码，然后再讲解。
上面代码中，其实主要做了两件事情

1、表单校验

2、登录按钮的点击登录事件

表单校验规则还好，比较固定写法，查一下element-ui的组件就知道了，我们来分析一下发起登录之后的代码：

```plain
const token = res.headers['authorization']
_this.$store.commit('SET_TOKEN', token)
_this.$store.commit('SET_USERINFO', res.data.data)
_this.$router.push("/blogs")
```

从返回的结果请求头中获取到token的信息，然后使用store提交token和用户信息的状态。完成操作之后，我们调整到了/blogs路由，即博客列表页面。

#### token的状态同步

所以在store/index.js中，代码是这样的：

```js
import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)
export default new Vuex.Store({
  state: {
    token: '',
    userInfo: JSON.parse(sessionStorage.getItem("userInfo"))
  },
  mutations: {
    SET_TOKEN: (state, token) => {
      state.token = token
      localStorage.setItem("token", token)
    },
    SET_USERINFO: (state, userInfo) => {
      state.userInfo = userInfo
      sessionStorage.setItem("userInfo", JSON.stringify(userInfo))
    },
    REMOVE_INFO: (state) => {
      localStorage.setItem("token", '')
      sessionStorage.setItem("userInfo", JSON.stringify(''))
      state.userInfo = {}
    }
  },
  getters: {
    getUser: state => {
      return state.userInfo
    }
  },
  actions: {},
  modules: {}
})
```

存储token，我们用的是localStorage，存储用户信息，我们用的是sessionStorage。毕竟用户信息我们不需要长久保存，保存了token信息，我们随时都可以初始化用户信息。当然了因为本项目是个比较简单的项目，考虑到初学者，所以很多相对复杂的封装和功能我没有做，当然了，学了这个项目之后，自己想再继续深入，完成可以自行学习和改造哈。

#### 定义全局axios拦截器

点击登录按钮发起登录请求，成功时候返回了数据，如果是密码错误，我们是不是也应该弹窗消息提示。为了让这个错误弹窗能运用到所有的地方，所以我对axios做了个后置拦截器，就是返回数据时候，如果结果的code或者status不正常，那么我对应弹窗提示。

在src目录下创建一个文件axios.js（与main.js同级），定义axios的拦截：

```js
import axios from 'axios'
import Element from "element-ui";
import store from "./store";
import router from "./router";
axios.defaults.baseURL='http://localhost:8081'
axios.interceptors.request.use(config => {
  console.log("前置拦截")
  // 可以统一设置请求头
  return config
})
axios.interceptors.response.use(response => {
    const res = response.data;
    console.log("后置拦截")
    // 当结果的code是否为200的情况
    if (res.code === 200) {
      return response
    } else {
      // 弹窗异常信息
      Element.Message({
        message: response.data.msg,
        type: 'error',
        duration: 2 * 1000
      })
      // 直接拒绝往下面返回结果信息
      return Promise.reject(response.data.msg)
    }
  },
  error => {
    console.log('err' + error)// for debug
    if(error.response.data) {
      error.message = error.response.data.msg
    }
    // 根据请求状态觉得是否登录或者提示其他
    if (error.response.status === 401) {
      store.commit('REMOVE_INFO');
      router.push({
        path: '/login'
      });
      error.message = '请重新登录';
    }
    if (error.response.status === 403) {
      error.message = '权限不足，无法访问';
    }
    Element.Message({
      message: error.message,
      type: 'error',
      duration: 3 * 1000
    })
    return Promise.reject(error)
  })
```

前置拦截，其实可以统一为所有需要权限的请求装配上header的token信息，这样不需要在使用是再配置，我的小项目比较小，所以，还是免了吧~

然后再main.js中导入axios.js

```plain
import './axios.js' // 请求拦截
```

后端因为返回的实体是Result，succ时候code为200，fail时候返回的是400，所以可以根据这里判断结果是否是正常的。另外权限不足时候可以通过请求结果的状态码来判断结果是否正常。这里都做了简单的处理。

登录异常时候的效果如下：

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/84587fc9e3444debacf84ccc726f4058.png)

### 9、博客列表

登录完成之后直接进入博客列表页面，然后加载博客列表的数据渲染出来。同时页面头部我们需要把用户的信息展示出来，因为很多地方都用到这个模块，所以我们把页面头部的用户信息单独抽取出来作为一个组件。

#### 头部用户信息

那么，我们先来完成头部的用户信息，应该包含三部分信息：id，头像、用户名，而这些信息我们是在登录之后就已经存在了sessionStorage。因此，我们可以通过store的getters获取到用户信息。

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/6d33d6a010324a91a48537e975a4b1a0.png)

看起来不是很复杂，我们贴出代码：

- components\Header.vue

```js
<template>
  <div class="m-content">
    <h3>欢迎来到MarkerHub的博客</h3>
    <div class="block">
      <el-avatar :size="50" :src="user.avatar"></el-avatar>
      <div>{{ user.username }}</div>
    </div>
    <div class="maction">
      <el-link href="/blogs">主页</el-link>
      <el-divider direction="vertical"></el-divider>
      <span>
          <el-link type="success" href="/blog/add" :disabled="!hasLogin">发表文章</el-link>
        </span>
      <el-divider direction="vertical"></el-divider>
      <span v-show="!hasLogin">
          <el-link type="primary" href="/login">登陆</el-link>
        </span>
      <span v-show="hasLogin">
          <el-link type="danger" @click="logout">退出</el-link>
        </span>
    </div>
  </div>
</template>

  export default {
    name: "Header",
    data() {
      return {
        hasLogin: false,
        user: {
          username: '请先登录',
          avatar: "https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png"
        },
        blogs: {},
        currentPage: 1,
        total: 0
      }
    },
    methods: {
      logout() {
        const _this = this
        this.$axios.get('http://localhost:8081/logout', {
          headers: {
            "Authorization": localStorage.getItem("token")
          }
        }).then((res) => {
          _this.$store.commit('REMOVE_INFO')
          _this.$router.push('/login')
        });
      }
    },
    created() {
      if(this.$store.getters.getUser.username) {
        this.user.username = this.$store.getters.getUser.username
        this.user.avatar = this.$store.getters.getUser.avatar
        this.hasLogin = true
      }
    }
  }
```

上面代码created()中初始化用户的信息，通过hasLogin的状态来控制登录和退出按钮的切换，以及发表文章链接的disabled，这样用户的信息就能展示出来了。
然后这里有个退出按钮，在methods中有个logout()方法，逻辑比较简单，直接访问/logout，因为之前axios.js中我们已经设置axios请求的baseURL，所以这里我们不再需要链接的前缀了哈。因为是登录之后才能访问的受限资源，所以在header中带上了Authorization。返回结果清楚store中的用户信息和token信息，跳转到登录页面。

然后需要头部用户信息的页面只需要几个步骤：

```plain
import Header from "@/components/Header";
data() {
  components: {Header}
}
# 然后模板中调用组件
<Header></Header>
```

#### 博客分页

接下来就是列表页面，需要做分页，列表我们在element-ui中直接使用**时间线**组件来作为我们的列表样式，还是挺好看的。还有我们的分页组件。

需要几部分信息：

- 分页信息
- 博客列表内容，包括id、标题、摘要、创建时间
- views\Blogs.vue

```js
<template>
  <div class="m-container">
    <Header></Header>
    <div class="block">
      <el-timeline>
        <el-timeline-item v-bind:timestamp="blog.created" placement="top" v-for="blog in blogs">
          <el-card>
            <h4><router-link :to="{name: 'BlogDetail', params: {blogId: blog.id}}">{{blog.title}}</router-link></h4>
            <p>{{blog.description}}</p>
          </el-card>
        </el-timeline-item>
      </el-timeline>

    </div>
    <el-pagination class="mpage"
      background
      layout="prev, pager, next"
      :current-page=currentPage
      :page-size=pageSize
      @current-change=page
      :total="total">
    </el-pagination>
  </div>
</template>

  import Header from "@/components/Header";
  export default {
    name: "Blogs",
    components: {Header},
    data() {
      return {
        blogs: {},
        currentPage: 1,
        total: 0,
        pageSize: 5
      }
    },
    methods: {
      page(currentPage) {
        const _this = this
        this.$axios.get('http://localhost:8081/blogs?currentPage=' + currentPage).then((res) => {
          console.log(res.data.data.records)
          _this.blogs = res.data.data.records
          _this.currentPage = res.data.data.current
          _this.total = res.data.data.total
          _this.pageSize = res.data.data.size
        })
      }
    },
    mounted () {
      this.page(1);
    }
  }
```

data()中直接定义博客列表blogs、以及一些分页信息。methods()中定义分页的调用接口page（currentPage），参数是需要调整的页码currentPage，得到结果之后直接赋值即可。然后初始化时候，直接在mounted()方法中调用第一页this.page(1)。完美。使用element-ui组件就是简单快捷哈哈！
注意标题这里我们添加了链接，使用的是<router-link>标签。

### 10、博客编辑（发表）

我们点击发表博客链接调整到/blog/add页面，这里我们需要用到一个markdown编辑器，在vue组件中，比较好用的是mavon-editor，那么我们直接使用哈。先来安装mavon-editor相关组件：

#### 安装mavon-editor

基于Vue的markdown编辑器mavon-editor

```plain
cnpm install mavon-editor --save
```

然后在main.js中全局注册：

```javascript
// 全局注册
import Vue from 'vue'
import mavonEditor from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'
// use
Vue.use(mavonEditor)
```

ok，那么我们去定义我们的博客表单：

```js
<template>
  <div class="m-container">
    <Header></Header>
    <div class="m-content">
      <el-form ref="editForm" status-icon :model="editForm" :rules="rules" label-width="80px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="editForm.title"></el-input>
        </el-form-item>
        <el-form-item label="摘要" prop="description">
          <el-input type="textarea" v-model="editForm.description"></el-input>
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <mavon-editor v-model="editForm.content"/>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm()">立即创建</el-button>
          <el-button>取消</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

  import Header from "@/components/Header";
  export default {
    name: "BlogEdit",
    components: {Header},
    data() {
      return {
        editForm: {
          id: null,
          title: '',
          description: '',
          content: ''
        },
        rules: {
          title: [
            {required: true, message: '请输入标题', trigger: 'blur'},
            {min: 3, max: 50, message: '长度在 3 到 50 个字符', trigger: 'blur'}
          ],
          description: [
            {required: true, message: '请输入摘要', trigger: 'blur'}
          ]
        }
      }
    },
    created() {
      const blogId = this.$route.params.blogId
      const _this = this
      if(blogId) {
        this.$axios.get('/blog/' + blogId).then((res) => {
          const blog = res.data.data
          _this.editForm.id = blog.id
          _this.editForm.title = blog.title
          _this.editForm.description = blog.description
          _this.editForm.content = blog.content
        });
      }
    },
    methods: {
      submitForm() {
        const _this = this
        this.$refs.editForm.validate((valid) => {
          if (valid) {
            this.$axios.post('/blog/edit', this.editForm, {
              headers: {
                "Authorization": localStorage.getItem("token")
              }
            }).then((res) => {
              _this.$alert('操作成功', '提示', {
                confirmButtonText: '确定',
                callback: action => {
                  _this.$router.push("/blogs")
                }
              });
            });
          } else {
            console.log('error submit!!');
            return false;
          }
        })
      }
    }
  }
```

逻辑依然简单，校验表单，然后点击按钮提交表单，注意头部加上Authorization信息，返回结果弹窗提示操作成功，然后跳转到博客列表页面。emm，和写ajax没啥区别。熟悉一下vue的一些指令使用即可。
然后因为编辑和添加是同一个页面，所以有了create()方法，比如从编辑连接/blog/7/edit中获取blogId为7的这个id。然后回显博客信息。获取方式是const blogId = this.$route.params.blogId。

对了，mavon-editor因为已经全局注册，所以我们直接使用组件即可：

```plain
<mavon-editor v-model="editForm.content"/>
```

效果如下：
![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/61c514b1b68c4cf1b07a87b51eacd8bf.png)

### 11、博客详情

博客详情中需要回显博客信息，然后有个问题就是，后端传过来的是博客内容是markdown格式的内容，我们需要进行渲染然后显示出来，这里我们使用一个插件markdown-it，用于解析md文档，然后导入github-markdown-c，所谓md的样式。

方法如下：

```plain
# 用于解析md文档
cnpm install markdown-it --save
# md样式
cnpm install github-markdown-css
```

然后就可以在需要渲染的地方使用：

- views\BlogDetail.vue

```js
<template>
  <div class="m-container">
    <Header></Header>
    <div class="mblog">
      <h2>{{ blog.title }}</h2>
      <el-link icon="el-icon-edit" v-if="ownBlog"><router-link :to="{name: 'BlogEdit', params: {blogId: blog.id}}">编辑</router-link></el-link>
      <el-divider></el-divider>
      <div class="content markdown-body" v-html="blog.content"></div>
    </div>
  </div>
</template>

  import 'github-markdown-css/github-markdown.css' // 然后添加样式markdown-body
  import Header from "@/components/Header";
  export default {
    name: "BlogDetail",
    components: {
      Header
    },
    data() {
      return {
        blog: {
          userId: null,
          title: "",
          description: "",
          content: ""
        },
        ownBlog: false
      }
    },
    methods: {
      getBlog() {
        const blogId = this.$route.params.blogId
        const _this = this
        this.$axios.get('/blog/' + blogId).then((res) => {
          console.log(res)
          console.log(res.data.data)
          _this.blog = res.data.data
          var MarkdownIt = require('markdown-it'),
            md = new MarkdownIt();
          var result = md.render(_this.blog.content);
          _this.blog.content = result
          // 判断是否是自己的文章，能否编辑
          _this.ownBlog =  (_this.blog.userId === _this.$store.getters.getUser.id)
        });
      }
    },
    created() {
      this.getBlog()
    }
  }
```

具体逻辑还是挺简单，初始化create()方法中调用getBlog()方法，请求博客详情接口，返回的博客详情content通过markdown-it工具进行渲染。

再导入样式：

```plain
import 'github-markdown.css'
```

然后在content的div中添加class为markdown-body即可哈。
效果如下：

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/7244e11b1cbe456daf043f815b9877f8.png)

另外标题下添加了个小小的编辑按钮，通过ownBlog （判断博文作者与登录用户是否同一人）来判断按钮是否显示出来。

### 12、路由权限拦截

页面已经开发完毕之后，我们来控制一下哪些页面是需要登录之后才能跳转的，如果未登录访问就直接重定向到登录页面，因此我们在src目录下定义一个js文件：

- src\permission.js

```js
import router from "./router";
// 路由判断登录 根据路由配置文件的参数
router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requireAuth)) { // 判断该路由是否需要登录权限
    const token = localStorage.getItem("token")
    console.log("------------" + token)
    if (token) { // 判断当前的token是否存在 ； 登录存入的token
      if (to.path === '/login') {
      } else {
        next()
      }
    } else {
      next({
        path: '/login'
      })
    }
  } else {
    next()
  }
})
```

通过之前我们再定义页面路由时候的的meta信息，指定requireAuth: true，需要登录才能访问，因此这里我们在每次路由之前（router.beforeEach）判断token的状态，觉得是否需要跳转到登录页面。

```js
{
  path: '/blog/add', // 注意放在 path: '/blog/:blogId'之前
  name: 'BlogAdd',
  meta: {
    requireAuth: true
  },
  component: BlogEdit
}
```

然后我们再main.js中import我们的permission.js

```js
import './permission.js' // 路由拦截
```

### 13、前端总结

ok，基本所有页面就已经开发完毕啦，css样式信息我未贴出来，大家直接上github上clone下来查看。

## 项目大总结

好啦，项目先到这里，花了3天半录制了一套对应的视频，记得去看，给我三连哇。

项目代码：https://github.com/MarkerHub/vueblog

项目视频：https://www.bilibili.com/video/BV1PQ4y1P7hZ/