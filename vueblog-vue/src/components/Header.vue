<template>
    <div class="m-content">
        <h3>欢迎来到markerhub博客</h3>
        <div class="block">
            <el-avatar :size="50" :src="user.avatar"></el-avatar>
            <div>{{user.username}}</div>
        </div>

        <div class="maction">
            <span> <el-link href="/blogs">主页</el-link></span>
            <el-divider direction="vertical"></el-divider>
            <span> <el-link type="success" href="/blog/add">发表</el-link></span>
            <el-divider direction="vertical"></el-divider>
            <span v-show="!haslogin"> <el-link type="info" href="/login">登陆</el-link></span>
            <span v-show="haslogin"> <el-link type="danger" @click="logout">退出</el-link></span>
        </div>
    </div>
</template>

<script>
    export default {
        name: "Header",
        data() {
            return {
                user: {
                    username: '请先登录',
                    avatar: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
                },
                haslogin: false
            }
        },
        methods: {
            logout() {
                this.$axios.get("/logout", {
                    headers: {
                        "authorization": localStorage.getItem("token")
                    }
                }).then(res => {
                    console.log(this)
                    this.$store.commit("REMOVE_INFO")
                    this.$router.push("/login")
                })
            }
        },
        created() {
            if (this.$store.getters.getUser) {
                this.user.username = this.$store.getters.getUser.username
                this.user.avatar = this.$store.getters.getUser.avatar
                this.haslogin = true
            }
        }
    }
</script>

<style scoped>
    .m-content {
        max-width: 960px;
        margin: 0 auto;
        text-align: center;
    }

    .maction {
        margin: 10px 0px;
    }
</style>