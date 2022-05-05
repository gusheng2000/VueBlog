package com.markerhub.util;/**
 * @Author Tianshuo
 * @ClassName ShiroUtil
 * @Description class function:
 * @Date 2022/5/3 12:48:49
 **/

import com.markerhub.shiro.AccountProfile;
import org.apache.shiro.SecurityUtils;

/**
 * @Author sc
 * @ClassName ShiroUtil
 * @Description class function:
 * @Date 2022/5/3 12:48:49
 **/
public class ShiroUtil {
    public static AccountProfile getProfile(){
    return (AccountProfile) SecurityUtils.getSubject().getPrincipal();
    }

}
