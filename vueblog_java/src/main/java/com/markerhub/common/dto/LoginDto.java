package com.markerhub.common.dto;/**
 * @Author Tianshuo
 * @ClassName LoginDtd
 * @Description class function:
 * @Date 2022/5/3 11:35:15
 **/

import cn.hutool.crypto.SecureUtil;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import java.util.Date;

/**
 * @Author sc
 * @ClassName LoginDtd
 * @Description class function:
 * @Date 2022/5/3 11:35:15
 **/
@Data
public class LoginDto {

    @NotBlank(message = "昵称不能为空")
    private String username;
    @NotBlank(message = "密码不能为空")
    private String password;
    private Date lastLogin;

}
