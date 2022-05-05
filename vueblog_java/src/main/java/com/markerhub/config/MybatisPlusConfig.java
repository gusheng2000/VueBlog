package com.markerhub.config;/**
 * @Author Tianshuo
 * @ClassName MybatisPlusConfig
 * @Description class function:
 * @Date 2022/4/28 13:30:01
 **/

import com.baomidou.mybatisplus.extension.plugins.PaginationInterceptor;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * @Author sc
 * @ClassName MybatisPlusConfig
 * @Description class function:
 * @Date 2022/4/28 13:30:01
 **/
@Configuration
@EnableTransactionManagement
@MapperScan("com.markerhub.mapper")
public class MybatisPlusConfig {
    @Bean
    public PaginationInterceptor paginationInterceptor() {
        PaginationInterceptor paginationInterceptor = new PaginationInterceptor();
        return paginationInterceptor;
    }
}
