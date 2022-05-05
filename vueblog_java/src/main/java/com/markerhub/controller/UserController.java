package com.markerhub.controller;


import com.markerhub.entity.User;
import com.markerhub.service.UserService;
import com.markerhub.common.lang.Result;
import lombok.experimental.Accessors;
import org.apache.shiro.authz.annotation.RequiresAuthentication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author sk
 * @since 2022-04-28
 */
@RestController
@RequestMapping("/user")

public class UserController {
    @Autowired
    private UserService userService;

    @RequiresAuthentication
    @GetMapping("/index")
    public Result demo(){
        User user = userService.getById(1L);
        return Result.succ(user);
    }


    @PostMapping("/save")
    public Result save(@Validated @RequestBody User user){
        return Result.succ(user);
    }
}
