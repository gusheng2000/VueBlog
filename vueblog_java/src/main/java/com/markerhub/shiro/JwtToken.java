package com.markerhub.shiro;

import org.apache.shiro.authc.AuthenticationToken;

/**


/**
 * @Author sc
 * @ClassName JwtToken
 * @Description class function:
 * @Date 2022/5/1 21:32:28
 **/
public class JwtToken implements AuthenticationToken {

    private String token;

    public JwtToken() {
    }

    public JwtToken(String token) {
        this.token = token;
    }

    @Override
    public Object getPrincipal() {
        return this.token;
    }

    @Override
    public Object getCredentials() {
        return this.token;
    }
}
