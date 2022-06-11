<template>
    <div>
        <el-container>
            <el-header>
                <img class="mlogo" src="https://markerhub.com/dist/images/logo/markerhub-logo.png" alt="">
            </el-header>
            <el-main>
                <el-form :model="ruleForm" status-icon :rules="rules" ref="ruleForm" label-width="100px"
                       itemtype=""  class="demo-ruleForm">

                    <el-form-item label="用户名" prop="username">
                        <el-input type="text" v-model="ruleForm.username" autocomplete="off"
                                  ></el-input>
                    </el-form-item>

                    <el-form-item label="密码" prop="password">
                        <el-input type="password" v-model="ruleForm.password" autocomplete="off"></el-input>
                    </el-form-item>
                    <el-form-item label="确认密码" prop="checkPass">
                        <el-input type="password" v-model="ruleForm.checkPass" autocomplete="off"></el-input>
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" @click="submitForm('ruleForm')">提交</el-button>
                        <el-button @click="resetForm('ruleForm')">重置</el-button>
                    </el-form-item>
                </el-form>
            </el-main>
        </el-container>

    </div>

</template>

<script>
    export default {
        name: "Register",
        data() {
            var checkUsername = (rule, value, callback) => {
                if (!value) {
                    return callback(new Error('用户名不能为空'));
                }
            };
            var validatePass = (rule, value, callback) => {
                if (value === '') {
                    callback(new Error('请输入密码'));
                } else {
                    if (this.ruleForm.checkPass !== '') {
                        this.$refs.ruleForm.validateField('checkPass');
                    }
                    callback();
                }
            };
            var validatePass2 = (rule, value, callback) => {
                if (value === '') {
                    callback(new Error('请再次输入密码'));
                } else if (value !== this.ruleForm.password) {
                    callback(new Error('两次输入密码不一致!'));
                } else {
                    callback();
                }
            };
            return {
                ruleForm: {
                    username: '',
                    password: '',
                    checkPass: '',
                },
                rules: {
                    password: [
                        {validator: validatePass, trigger: 'blur'},

                    ],
                    checkPass: [
                        {validator: validatePass2, trigger: 'blur'}
                    ],
                    username: [
                        {min: 3, max: 10, message: '长度在 3 到 5 个字符', trigger: 'blur'}
                    ]
                }
            };
        },
        methods: {
            isExisting() {
                this.$axios.get('/isHaveUser', {
                    params: {
                        username: this.ruleForm.username,
                    }
                }).then(res=>{
                    console.log(res)
                })
            },
            submitForm(formName) {
                this.$refs[formName].validate((valid) => {
                    if (valid) {

                        //用户名是否已存在
                        this.$axios.get('/isHaveUser', {
                            params: {
                                username: this.ruleForm.username,
                            }
                        }).then(res=>{
                            //用户名不存在请求注册借口
                            console.log(_this.ruleForm.password)
                            this.$axios.put('/register',_this.ruleForm).then(res => {
                                console.log(res.data);
                                this.$router.push("/login")
                                this.$message.success(res.data.data)
                            })
                        })
                        let _this =this
                    } else {
                        console.log('error submit!!');
                        return false;
                    }
                });
            },

            resetForm(formName) {
                this.$refs[formName].resetFields();
            }
        }
    }
</script>

<style scoped>
    .el-header, .el-footer {
        background-color: #B3C0D1;
        color: #333;
        text-align: center;
        line-height: 60px;
    }

    .mlogo {
        height: 50%;
        margin-top: 10px;
    }

    .demo-ruleForm {
        max-width: 500px;
        margin: 0 auto;
    }
</style>