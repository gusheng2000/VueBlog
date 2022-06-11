package com.markerhub.controller;

import cn.hutool.core.lang.Assert;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.markerhub.common.lang.Result;
import com.markerhub.entity.Blog;
import com.markerhub.service.BlogService;
import com.markerhub.util.ShiroUtil;
import org.apache.shiro.authz.annotation.RequiresAuthentication;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;

/**
 * 前端控制器
 * @author sk
 * @since 2022-04-28
 */
@CrossOrigin
@RestController
public class BlogController {
    @Autowired
    BlogService blogService;
    @GetMapping("/blogs")
    public Result list(@RequestParam(defaultValue = "1") Integer currentPage) {
        Page page = new Page(currentPage, 5);
        IPage pageData = blogService.page(page, new QueryWrapper<Blog>().orderByDesc("created"));
        return Result.succ(pageData);
    }


    //查询博客
    @GetMapping("/blog/{id}")
    public Result dateil(@PathVariable(name = "id") Long id) {
        Blog blog = blogService.getById(id);
        Assert.notNull(blog, "博客已删除");
        return Result.succ(blog);
    }


    //删除blog
    @DeleteMapping("/blog/{id}")
    public Result daleteBlogById(@PathVariable(name = "id") Long id) {

        boolean b = blogService.removeById(id);
        Assert.isTrue(b, "系统错误,删除失败!");
        return Result.succ("删除成功!");
    }

    @RequiresAuthentication
    @PostMapping("/blog/edit")
    public Result edit(@Validated @RequestBody Blog blog) {
        Blog temp = null;
        if (blog.getId() != null) {
            temp = blogService.getById(blog.getId());
            //只能自己编辑字的博客
            Assert.isTrue(temp.getUserId() == ShiroUtil.getProfile().getId(), "没有权限编辑");
        } else {
            temp = new Blog();
            temp.setUserId(ShiroUtil.getProfile().getId());
            temp.setCreated(LocalDateTime.now());
            temp.setStatus(0);
        }
        //复制bean内容
        BeanUtils.copyProperties(blog, temp, "id", "userId", "created", "status");
        blogService.saveOrUpdate(temp);
        return Result.succ(null);
    }

}
