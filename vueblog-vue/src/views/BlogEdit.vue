<template>
    <div>
        <Header></Header>
        <div class="m_context">
            <el-form :model="ruleForm" :rules="rules" ref="ruleForm" label-width="100px" class="demo-ruleForm">
                <el-form-item label="标题" prop="title">
                    <el-input v-model="ruleForm.title"></el-input>
                </el-form-item>

                <el-form-item label="摘要" prop="decription">
                    <el-input type="textarea" v-model="ruleForm.desription"></el-input>
                </el-form-item>
                <el-form-item label="内容" prop="content">
                </el-form-item>
                <mavon-editor v-model="ruleForm.content"></mavon-editor>
                <el-form-item>
                    <el-button type="primary" @click="submitForm('ruleForm')">立即创建</el-button>
                    <el-button @click="resetForm('ruleForm')">重置</el-button>
                </el-form-item>
            </el-form>
        </div>
    </div>
</template>

<script>
    import Header from "../components/Header"

    export default {
        name: "BlogEdit",
        components: {Header},
        data() {
            return {
                ruleForm: {
                    id: '',
                    title: '',
                    desription: '',
                    content: '',

                },
                rules: {
                    title: [
                        {required: true, message: '请输入标题', trigger: 'blur'},
                        {min: 3, max: 25, message: '长度在 3 到 25 个字符', trigger: 'blur'}
                    ],
                    description: [
                        {required: true, message: '请输入摘要', trigger: 'change'}
                    ],
                    content: [
                        {required: true, message: '请输入内容', trigger: 'change'}
                    ],
                }
            };
        },
        methods: {
            submitForm(formName) {

                this.$refs[formName].validate((valid) => {
                    if (valid) {
                        alert('submit!');
                        this.$axios.post("/blog/edit", this.ruleForm, {
                            headers: {
                                "authorization": localStorage.getItem("token")
                            },
                        }).then(res => {
                            console.log(res)
                            this.$alert('操作成功', '提示', {
                                confirmButtonText: '确定',
                                callback: action => {
                                    this.$router.push("/blogs")
                                }
                            });
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
        created() {
            const blogId = this.$route.params.blogId
            console.log(blogId);
            if (blogId){
                this.$axios.get("/blog/"+blogId).then(res=>{
                    const blog=res.data.data
                    this.ruleForm.id=blog.id
                    this.ruleForm.title=blog.title
                    this.ruleForm.desription=blog.desription
                    this.ruleForm.content=blog.content
                })
            }
        }
    }
</script>

<style scoped>
    .m_context {
        margin: 0 auto;
        text-align: center;
    }

</style>