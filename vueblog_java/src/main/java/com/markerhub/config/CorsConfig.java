package com.markerhub.config;/**
 * @Author Tianshuo
 * @ClassName CorsConfig
 * @Description class function:
 * @Date 2022/5/3 10:56:41
 **/

/**
 * @Author sc
 * @ClassName CorsConfig
 * @Description class function:
 * @Date 2022/5/3 10:56:41
 **/

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * 解决跨域问题
 */
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "HEAD", "POST", "PUT", "DELETE", "OPTIONS")
                .allowCredentials(true)
                .maxAge(3600)
                .allowedHeaders("*");
    }
}

