package com.markerhub.shiro;/**
 * @Author Tianshuo
 * @ClassName AccountProfile
 * @Description class function:
 * @Date 2022/5/1 22:37:59
 **/

import lombok.Data;

/**
 * @Author sc
 * @ClassName AccountProfile
 * @Description class function:
 * @Date 2022/5/1 22:37:59
 **/
@Data
public class AccountProfile {
    private Long id;

    private String username;

    private String avatar;

    private String email;
}
