import Vue from "vue";
import App from "./App"
import axios from "axios";
import Element from "element-ui"
import store from "./store/";
import router from "@/router";


//前置url
axios.defaults.baseURL = "http://localhost:8081"

//前置拦截
axios.interceptors.request.use(config => {
    return config
})


//后置拦截
axios.interceptors.response.use(response => {
        let res = response.data
        // console.log("===============")
        // console.log(res);
        // console.log("===============")
        if (res.code === 100||res.code===200) {
            return response
        } else if (res.code === 600) {
            Element.Message.error(res.msg, {duration: 3});
            return Promise.reject(response.data.msg)
        } else {
            Element.Message.error('账号或者密码错误,请从新输入!', {duration: 3});
            return Promise.reject(response.data.msg)
        }

    },

    error => {
        console.log(error);
        if (error.response.data) {
            error.message = error.response.data.msg
        }
        if (error.code === 401) {
            store.commit("REMOVE_INFO")
            router.push("/login")
        }
        Element.Message.error(error.message, {duration: 3});
        return Promise.reject(error.message)
    }
)