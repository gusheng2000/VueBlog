<template>
    <div class="m-content">
        <h2>欢迎来到SC博客</h2>
        <div class="block">
            <el-avatar :size="80" :src="user.avatar"></el-avatar>
            <div>{{user.username}}</div>
        </div>

        <div class="maction" >
            <span> <el-link href="/blogs">主页</el-link></span>
            <el-divider direction="vertical"></el-divider>
            <span> <el-link type="success" href="/blog/add">发表</el-link></span>

            <span v-show="haslogin"> <el-divider direction="vertical"></el-divider> <el-link  type="danger"  @click="uploadImg">
               头像</el-link></span>

            <el-divider direction="vertical"></el-divider>
            <span v-show="!haslogin"> <el-link type="info" href="/login">登陆</el-link></span>

            <span v-show="haslogin"> <el-link type="danger" @click="logout">退出</el-link></span>
        </div>
        <div>

            <el-dialog
                    title="上传你的头像"
                    :visible.sync="isShow"
                    width="50%"
                    >
                <div>
                    <el-upload
                            class="upload-demo"
                            drag
                            name="file"
                            :headers="header"
                            action="http://150.158.81.243:8081/savePicture"
                            :on-success="uploadOK"
                            multiple>
                        <i class="el-icon-upload"></i>
                        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
                        <div class="el-upload__tip" slot="tip">只能上传jpg/png文件，且不超过500kb</div>
                    </el-upload>
                </div>
            </el-dialog>
        </div>


    </div>


</template>

<script>
    export default {
        name: "Header",
        data() {
            return {
                header: {'auth': '2C88CB2140E3DFB8666686765EF17A4F'},
                isShow: false,
                user: {
                    username: '请先登录',
                    avatar: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
                },
                haslogin: false
            }
        },
        methods: {
            //修改头像
            uploadOK(res){
                console.log(res);
                this.user.avatar=res.data
                this.isShow=false

                let img=res
                this.$axios.post('/avatar?userId='+this.$store.getters.getUser.id+"&avatar="+res.data)
                    .then(res=>{
                        console.log(res);
                        this.$message.success(res.data.msg)
                        let user = this.$store.getters.getUser;
                        user.avatar=img.data
                        this.$store.commit('SET_USERINFO',user)
                    })
            },
            uploadImg() {
                    this.isShow=true
            },
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
        /*background-color: #cbd8fa;*/
    }

    .maction {
        margin: 10px 0px;
        padding: 10px 0px;
    }
</style>