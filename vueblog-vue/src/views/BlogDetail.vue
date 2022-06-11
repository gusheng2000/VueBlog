<template>
    <div>
        <Header></Header>
        <div class="mblog">
            <h2>{{blog.title}}</h2>
            <div v-if="ownBlog">
                <el-link  >
                    <router-link type="" :to="{name: 'BlogEdit',params: {blogId: blog.id}}">
                        <el-button  icon="el-icon-edit" size="mini" type="warning">编辑</el-button></router-link>
                </el-link>

                <el-popconfirm

                        confirm-button-text='确认'
                        cancel-button-text='取消'
                        icon="el-icon-info"
                        icon-color="red"
                        title="是否确认删除?"
                        @confirm="deleteBlog"
                >
                    <el-button  size="mini" slot="reference"  style="margin-left: 20px" type="danger" icon="el-icon-delete">删除</el-button>

                </el-popconfirm>
            </div>

            <el-divider></el-divider>
            <div class="markdown-body" v-html="blog.content"></div>
        </div>
    </div>

</template>

<script>
    import Header from "../components/Header"
    import "github-markdown-css/github-markdown.css"
    export default {
        name: "BlogDetail",
        components: {Header},
        data() {
            return {
                blog: {
                    id: '',
                    title: "haha",
                    content: "其实吧"
                },
                ownBlog:false
            }
        },
        methods: {
          deleteBlog(){
              console.log(this.blog.id);
              this.$axios.delete("/blog/"+this.blog.id).then(res=>{
                  // console.log(res);
                  if (res.data.code===100){
                     this.$message.success("删除成功!")
                      setTimeout(
                          OK=>{
                              this.$router.push("/blogs")
                          },
                          1000
                      )
                  }
              })
          }
        },
        created() {
            const blogId = this.$route.params.blogId
            // console.log(blogId);
            if (blogId) {
                this.$axios.get("/blog/" + blogId).then(res => {
                    const blog = res.data.data
                    this.blog.id = blog.id
                    this.blog.title = blog.title
                    // this.blog.desription=blog.desription
                    var MardownIt=require("markdown-it");
                    let it = new MardownIt();
                    let result = it.render(blog.content);
                    this.blog.content = result;
                    //判断博客创作者与当前登陆者是不是一个人
                    this.ownBlog=(blog.userId===this.$store.getters.getUser.id);
                })
            }
        }
    }
</script>

<style scoped>
    .mblog {
        box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
        width: 100%;
        min-height: 700px;
    }
</style>