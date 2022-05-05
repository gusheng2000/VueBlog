import Vue from 'vue'
import App from './App.vue'
import router from './router/index'
import store from './store'
import Element from"element-ui"
import axios from "axios";
import "element-ui/lib/theme-chalk/index.css"

import mavonEditor from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'
import "./permission"
Vue.use(mavonEditor)
Vue.use(Element)
// 允许携带cookie

import "./axios"

Vue.config.productionTip = false
Vue.prototype.$axios=axios

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
