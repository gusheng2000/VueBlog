<template>
    <div class="mcontaner">
        <Header></Header>
        <div class="block">
            <el-timeline>

                <el-timeline-item :timestamp="blog.created" placement="top" v-for="blog in blogs">
                    <el-card>
                        <router-link :to="{name: 'BlogDetail', params: {blogId: blog.id}}"><h4>{{blog.title}}</h4></router-link>
                        <p>{{blog.desription}}</p>
                    </el-card>
                </el-timeline-item>

            </el-timeline>

            <el-pagination class="mPage"
                           background
                           :page-size="pageSize"
                           :current-page="currentPage"
                           layout="prev, pager, next"
                           :total="total"
                           @current-change="page"
            >
            </el-pagination>
        </div>


    </div>

</template>

<script>
    import Header from "@/components/Header";

    export default {
        name: "Blogs",
        components: {Header},
        data() {
            return {
                blogs: {},
                currentPage: 1,
                total: 0,
                pageSize: 2

            }

        },
        methods: {
            page(currentPage) {
                this.$axios.get("/blogs?currentPage=" + currentPage).then(res => {
                    console.log(res);
                    this.blogs = res.data.data.records
                    this.currentPage = res.data.data.current
                    this.total = res.data.data.total
                    this.pageSize = res.data.data.size

                })
            }
        },
        created() {
            this.page(1)
        }
    }
</script>

<style scoped>
    .mPage {
        margin: 0 auto;
        text-align: center;
    }
</style>