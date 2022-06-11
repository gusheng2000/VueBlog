package com.markerhub.shiro;/**
 * @Author Tianshuo
 * @ClassName JwtFilter
 * @Description class function:
 * @Date 2022/5/1 15:59:18
 **/

import cn.hutool.json.JSONUtil;
import com.markerhub.util.JwtUtils;
import com.markerhub.common.lang.Result;
import io.jsonwebtoken.Claims;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.ExpiredCredentialsException;
import org.apache.shiro.web.filter.authc.AuthenticatingFilter;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @Author sc
 * @ClassName JwtFilter
 * @Description class function:
 * @Date 2022/5/1 15:59:18
 **/
@Component
public class JwtFilter extends AuthenticatingFilter {
    @Autowired
    JwtUtils jwtUtils;

    @Override
    protected AuthenticationToken createToken(ServletRequest servletRequest, ServletResponse servletResponse) throws Exception {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        String jwt = request.getHeader("authorization");
        if (StringUtils.isEmpty(jwt)) {
            return null;
        }
        return new JwtToken(jwt);
    }

    @Override
    protected boolean onAccessDenied(ServletRequest servletRequest, ServletResponse servletResponse) throws Exception {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        String jwt = request.getHeader("authorization");
        if (StringUtils.isEmpty(jwt)) {
            return true;
        } else {
            //校验jwt
            Claims cliaim = jwtUtils.getClaimByToken(jwt);
            if (cliaim == null || jwtUtils.isTokenExpired(cliaim.getExpiration())) {
                throw new ExpiredCredentialsException("token已失效请从新登陆");
            }
            //执行登陆
            return executeLogin(servletRequest, servletResponse);
        }
    }

    @Override
    protected boolean onLoginFailure(AuthenticationToken token, AuthenticationException e, ServletRequest request, ServletResponse response) {
        HttpServletResponse response1 = (HttpServletResponse) response;

        Throwable throwable = e.getCause() == null ? e : e.getCause();
        Result fail = Result.fail(throwable.getMessage());

        String s = JSONUtil.toJsonStr(fail);
        try {
            response1.getWriter().write(s);
        } catch (IOException ioException) {

        }
        return false;
    }

    @Override
    protected boolean preHandle(ServletRequest request, ServletResponse response) throws Exception {
//        HttpServletRequest request1 = WebUtils.toHttp(request);
//        HttpServletResponse httpServletResponse = WebUtils.toHttp(response);
//        httpServletResponse.setHeader("Access-Control-Allow-Origin", request1.getHeader("Origin"));
//        httpServletResponse.setHeader("Access-Control-Allow-Methods", "GET,POST,OPTIONS,PUT,DELETE");
//        httpServletResponse.setHeader("Access-Control-Allow-Headers", request1.getHeader("Access-control-Allow-Headers"));
//        if (request1.getMethod().equals(RequestMethod.OPTIONS.name())) {
//            httpServletResponse.setStatus(HttpStatus.OK.value());
//        }
//        HttpServletRequest request1 = WebUtils.toHttp(request);
//        HttpServletResponse httpServletResponse = WebUtils.toHttp(response);
//        httpServletResponse.setHeader("Access-Control-Allow-Origin",request1.getHeader("Origin"));
//        httpServletResponse.setHeader("Access-Control-Allow-Methods","GET,POST,OPTIONS,PUT,DELETE");
//        httpServletResponse.setHeader("Access-Control-Allow-Headers","Origin, X-Requested-With, content-Type, Accept, Authorization");
//        httpServletResponse.setHeader("Access-Control-Allow-Credentials","true");

//        if (request1.getMethod().equals(RequestMethod.OPTIONS.name())){
//            httpServletResponse.setStatus(HttpStatus.OK.value());
//        }



        HttpServletRequest request1 = WebUtils.toHttp(request);
        HttpServletResponse httpServletResponse = WebUtils.toHttp(response);
        httpServletResponse.setHeader("Access-Control-Allow-Origin",request1.getHeader("Origin"));
        httpServletResponse.setHeader("Access-Control-Allow-Methods","GET,POST,OPTIONS,PUT,DELETE");
        httpServletResponse.setHeader("Access-Control-Allow-Headers","Origin, X-Requested-With, content-Type, Accept, Authorization");
//        httpServletResponse.setHeader("Access-Control-Allow-Credentials","true");


        if (request1.getMethod().equals(RequestMethod.OPTIONS.name())){
            httpServletResponse.setStatus(HttpStatus.OK.value());
        }


        return super.preHandle(request, response);
    }
}
