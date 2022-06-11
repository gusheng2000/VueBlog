package com.markerhub.controller;

import cn.hutool.core.lang.Assert;
import cn.hutool.core.map.MapUtil;
import cn.hutool.crypto.SecureUtil;
import cn.hutool.crypto.digest.MD5;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.markerhub.common.dto.LoginDto;
import com.markerhub.common.lang.Result;
import com.markerhub.entity.User;
import com.markerhub.service.UserService;
import com.markerhub.util.JwtUtils;
import com.markerhub.util.MD5Utils;
import com.sun.org.apache.regexp.internal.RE;
import lombok.experimental.Accessors;
import lombok.extern.java.Log;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresAuthentication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;

/**
 * @Author sc
 * @ClassName AccountController
 * @Description class function:
 * @Date 2022/5/3 11:32:56
 **/
@RestController
@Accessors
public class AccountController {
    @Autowired
    UserService userService;
    @Autowired
    JwtUtils jwtUtils;

    @PostMapping("login")
    public Result login(@RequestBody LoginDto loginDto, HttpServletResponse response) {

        User user = userService.getOne(new QueryWrapper<User>().eq("username", loginDto.getUsername()));
        Assert.notNull(user, "用户不存在");
        if (!user.getPassword().equals(SecureUtil.md5(loginDto.getPassword()))) {
            return Result.fail("密码不正确!");
        }
        String token = jwtUtils.generateToken(user.getId());
        response.setHeader("authorization", token);
        response.setHeader("Access-control-Expose-Headers", "authorization");
        return Result.succ(MapUtil.builder()
                .put("id", user.getId())
                .put("username", user.getUsername())
                .put("avatar", user.getAvatar())
                .put("email", user.getEmail())
                .map()
        );
    }

    //注册用户
    @PutMapping("register")
    public Result register(@RequestBody User user) {
        System.out.println(user);
        String pwd = MD5Utils.string2MD5(user.getPassword());
        user.setPassword(pwd);
        boolean flag = userService.save(user);
        System.out.println(flag);
        return Result.succ("注册成功!");
    }

    //    注销登陆
    @RequiresAuthentication
    @GetMapping("logout")
    public Result logout(@RequestHeader("authorization") String auth) {
        System.out.println(auth);
        SecurityUtils.getSubject().logout();
        return Result.succ(null);
    }

    //查询用户名是否存在
    @GetMapping("isHaveUser")

    public Result selectByName(String username) {
        QueryWrapper<User> wrapper = new QueryWrapper<>();
        wrapper.eq("username", username);
        User one = userService.getOne(wrapper);
        if (one != null) {
            return Result.fail(600, "用户名已存在", null);
        } else {
            return Result.succ("用户名可用");
        }
    }


    //更新头像
    @PostMapping("avatar")
    public Result updateAvatar(String avatar, long userId) {

        User user = userService.getById(userId);
        user.setAvatar(avatar);
        boolean b = userService.updateById(user);
        if (b) {
            return Result.succ("头像修改成功");
        }else {
            return Result.fail("头像修改失败");
        }
    }
}
