/*
 Navicat Premium Data Transfer

 Source Server         : mysql8
 Source Server Type    : MySQL
 Source Server Version : 80029
 Source Host           : localhost:3307
 Source Schema         : vueblog

 Target Server Type    : MySQL
 Target Server Version : 80029
 File Encoding         : 65001

 Date: 04/05/2022 22:08:20
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for m_blog
-- ----------------------------
DROP TABLE IF EXISTS `m_blog`;
CREATE TABLE `m_blog`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `desription` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `created` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `status` tinyint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of m_blog
-- ----------------------------
INSERT INTO `m_blog` VALUES (1, 1, '石冲最帅', '阿塞于噶', '# SpringMVC 笔记\n\nSpringMVC是基于MVC处理模式的web框架，分离了 控制器 - 模型对象 - 过滤器 以及处理程序对象\n\nSpringMVC的工作流程:\n\n1. 客户端通过浏览器发出请求，通过web.xml的配置调用DispatcherServlet ( 核心处理器 ) 接收请求，并将请求交给处理器映射器处理\n2. 映射器 ( BeanNameUrlHandlerMapping ) 通过请求的url地址解析出映射关系，查找是否有符合规则的Bean，然后将映射关系返还给核心处理器，由核心处理器将映射关系交给映射器\n   3. 适配器 ( SimpleControllerHandlerAdapter ) 核心处理器，底层使用了instanceOf技术，主要是判断对应映射关系的Bean是否继承了Controller接口，符合则调用对应的Bean执行对应逻辑，并将结果返还给适配器，然后返还给核心处理器\n3. 核心处理器调用视图解析器（ViewResolver）适配器返还的结果进行解析，解析为View返还给处理器\n4. 核心处理器调用View将模型数据渲染为视图\n5. 核心处理器向客户端做出响应\n\n> 在使用 springmvc 之前需要在 maven 中引入目标依赖：\n\n~~~xml\n<dependency>\n	<groupId>org.springframework</groupId>\n	<artifactId>spring-webmvc</artifactId>\n	<version>5.1.5.RELEASE</version>\n</dependency>\n~~~\n\n笔记将基于 springmvc 5.1.5 记录\n\n## MVC的两种实现方式\n\n### XML配置MVC\n\n> 配置 web.xml \n\n在 web.xml 中配置 mvc 的 DispatcherServlet 的映射路径为 **/** ( 所有请求 )，让所有请求都交给 mvc 核心控制器进行处理\n\n~~~xml\n<servlet>\n    <servlet-name>springmvc</servlet-name>\n    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>\n	<!-- init-param标签用来指定mvc所需要的配置文件 -->\n    <init-param>\n        <param-name>contextConfigLocation</param-name>\n        <param-value>classpath:springmvc.xml</param-value>\n    </init-param>\n</servlet>\n<servlet-mapping>\n    <servlet-name>springmvc</servlet-name>\n    <url-pattern>/</url-pattern>\n</servlet-mapping>\n~~~\n\n在配置 web.xml 的时候可以不用配置 init-param ，他会默认的去 WEB-INF 目录下找配置文件，这时候文件名必须是 `servlet-name` 标签内的值，且后面必须加上-servlet，例如 springmvc-servlet.xml\n\n\n\n>配置 springmvc\n\n定义了映射器及适配器，将自己书写的实现了Controller的控制器类装配在Bean中，映射器和适配器是可以省略不写的，他有自己的默认配置，如果写了其中的一个，那么建议另一个一定要写上\n\n~~~xml\n<!--处理映射关系-->\n<bean class=\"org.springframework.web.servlet.handler.BeanNameUrlHandlerMapping\" />\n<!--适配器-->\n<bean class=\"org.springframework.web.servlet.mvc.SimpleControllerHandlerAdapter\" />\n~~~\n\n \n\n> 编写控制器类\n\n控制器就是 mvc 为我们封装好的 web 中的 servlet 类，他可以接收客户端发来的请求，省去了我们在 web 开发中较为麻烦的 web.xml 配置等等。\n\n~~~java\n@Override\npublic ModelAndView handleRequest(HttpServletRequest request,HttpServletResponse response) throws Exception {\n    ModelAndView model = new ModelAndView();\n    System.out.println(\"控制器被成功执行\");\n    model.addObject(\"message\", \"con1 goto index.jsp\");\n    model.setViewName(\"index.jsp\");\n    return model;\n}\n~~~\n\n- ModelAndView 类：\n  - 用来负责 mvc 中主要的逻辑，其中 setViewName 方法经过视图解析器后就是转发的目标路径\n  - addObject 方法就类似 request 中的 setAttribute 方法\n\n\n\n### 注解配置MVC\n\n注解配置 springmvc 相比配置文件来说更为简单，建议重新开个项目来写\n\n> 重写配置文件\n\n~~~xml\n<!-- 开启注解配置mvc -->\n<mvc:annotation-driven></mvc:annotation-driven>\n<!-- scan扫描注解所在的包 -->\n<context:component-scan base-package=\"club.hanzhe.web\" />\n<bean class=\"org.springframework.web.servlet.view.InternalResourceViewResolver\">\n	<property name=\"prefix\" value=\"/\" />\n	<property name=\"suffix\" value=\".jsp\" />\n</bean>\n~~~\n\n> 控制器类代码：\n\n~~~java\n@Controller\npublic class Con1 {\n    @RequestMapping(\"/main\")\n    public String method01() throws Exception {\n        System.out.println(\"mvc function run\");\n        return \"index\";\n    }\n}\n~~~\n\n1. 使用了 `@Controller` 注解，表明当前类是控制器类。\n2. 每个方法上都可以使用 `@RequestMapping` 来指定目标访问路径\n\n \n\n## MVC 的视图解析器\n\n在每个控制器中会返回 ModelAndView 的实例，这些返回的实例会被视图解析器接受并解析处理，setViewName 会被解析为路径拼接到视图解析器中，addObject 中的数据会被封装到目标路径的 request 域中\n\n视图解析器配置中的配置及最常用的两个属性\n\n- prefix：是解析视图名称后拼接在前面的前缀，**/** 代表目标视图在根目录\n- suffix：是解析视图名称后拼接在后面的后缀，.jsp 代表解析后为 jsp 视图\n\n~~~xml\n<bean class=\"org.springframework.web.servlet.view.InternalResourceViewResolver\">\n    <property name=\"prefix\" value=\"/\" />\n    <property name=\"suffix\" value=\".jsp\" />\n</bean>\n~~~\n\n\n\n## 请求参数绑定\n\n### 简单类型绑定\n\n想要什么名字，什么类型的参数，直接写在处理请求的方法的参数列表中即可，需要注意的是，变量名要与请求参数表单的 name 值相同\n\n例如：localhost:8080/Day01/1.action?user=abc\n\n这时表单传来的数据中 name 为 user，代码如下：\n\n~~~java\n@RequestMapping(\"1\") // 简单参数绑定，变量名需要与表单的name相同\npublic void test1( String user ) {\n    // 打印测试\n    System.out.println(\"user = \" + user);\n}   \n~~~\n\n如果参数列表和提交的表单的 name 不同，需要使用注解获取指定 name 的值\n\n~~~java\n// 请求地址： localhost:8080/username=zhang\n@ResponseBody\n@RequestMapping(\"/test\")\npublic String test( @RequestParam(\"username\")String name ){\n    return \"获取到的值：\" + name;\n}\n~~~\n\n', '2022-05-11 13:11:12', 0);
INSERT INTO `m_blog` VALUES (11, 1, '3333333333333333333', '更新描述', NULL, '2022-05-03 16:53:42', 0);
INSERT INTO `m_blog` VALUES (12, 1, '3333333333333333333', '更新描述', '我修改了12', '2022-05-03 16:54:08', 0);
INSERT INTO `m_blog` VALUES (13, 1, '3333333333333333333', '更新描述', '测试内容测试内容测试内容测试内容测试内容', '2022-05-03 16:58:31', 0);
INSERT INTO `m_blog` VALUES (14, 1, '25+65+52', '撒扥阿塞', '扥赛安抚', '2022-05-10 16:20:22', 0);
INSERT INTO `m_blog` VALUES (15, 1, 'dasd', 'asdsa', 'asdasdsad', '2022-05-04 17:24:00', 0);
INSERT INTO `m_blog` VALUES (16, 1, '中国大赛', '爱大赛阿塞赛奥发赛分', '而各扔二个人~~> 中划线~~', '2022-05-04 17:25:05', 0);
INSERT INTO `m_blog` VALUES (17, 1, '奥赛啊岁', '爱大赛', 'sdfsdf', '2022-05-04 17:31:10', 0);
INSERT INTO `m_blog` VALUES (18, 1, 'asdawd', 'dasd', 'asdsadsadsad', '2022-05-04 17:31:56', 0);
INSERT INTO `m_blog` VALUES (19, 1, '壤塘根', '跟横放', '::: hljs-right\n\n~居右~\n\n:::\n', '2022-05-04 18:09:36', 0);
INSERT INTO `m_blog` VALUES (20, 1, 'iuh9h', '跟赛发动', 'dsfsdf', '2022-05-04 21:44:26', 0);

-- ----------------------------
-- Table structure for m_user
-- ----------------------------
DROP TABLE IF EXISTS `m_user`;
CREATE TABLE `m_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `email` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `password` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `status` int NOT NULL,
  `created` datetime NULL DEFAULT NULL,
  `last_login` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `UK_USERNAME`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of m_user
-- ----------------------------
INSERT INTO `m_user` VALUES (1, 'markerhub', 'https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/5a9f48118166308daba8b6da7e466aab.jpg', NULL, '96e79218965eb72c92a549dd5a330112', 0, '2020-04-20 10:44:01', NULL);

SET FOREIGN_KEY_CHECKS = 1;
