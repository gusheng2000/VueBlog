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

 Date: 11/06/2022 19:26:26
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
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of m_blog
-- ----------------------------
INSERT INTO `m_blog` VALUES (1, 1, '抗战后学习SpringMVC！！！', 'Spring MVC属于SpringFrameWork的后续产品，已经融合在Spring Web Flow里面。Spring 框架提供了构建 Web 应用程序的全功能 MVC 模块。使用 Spring 可插入的 MVC 架构，从而在使用Spring进行WEB开发时，可以选择使用Spring的Spring MVC框架或集成其他MVC开发框架，如Struts1(现在一般不用)，Struts 2(一般老项目使用)等等。', '# SpringMVC 笔记\n\nSpringMVC是基于MVC处理模式的web框架，分离了 控制器 - 模型对象 - 过滤器 以及处理程序对象\n\nSpringMVC的工作流程:\n\n1. 客户端通过浏览器发出请求，通过web.xml的配置调用DispatcherServlet ( 核心处理器 ) 接收请求，并将请求交给处理器映射器处理\n2. 映射器 ( BeanNameUrlHandlerMapping ) 通过请求的url地址解析出映射关系，查找是否有符合规则的Bean，然后将映射关系返还给核心处理器，由核心处理器将映射关系交给映射器\n   3. 适配器 ( SimpleControllerHandlerAdapter ) 核心处理器，底层使用了instanceOf技术，主要是判断对应映射关系的Bean是否继承了Controller接口，符合则调用对应的Bean执行对应逻辑，并将结果返还给适配器，然后返还给核心处理器\n3. 核心处理器调用视图解析器（ViewResolver）适配器返还的结果进行解析，解析为View返还给处理器\n4. 核心处理器调用View将模型数据渲染为视图\n5. 核心处理器向客户端做出响应\n\n> 在使用 springmvc 之前需要在 maven 中引入目标依赖：\n\n~~~xml\n<dependency>\n	<groupId>org.springframework</groupId>\n	<artifactId>spring-webmvc</artifactId>\n	<version>5.1.5.RELEASE</version>\n</dependency>\n~~~\n\n笔记将基于 springmvc 5.1.5 记录\n\n## MVC的两种实现方式\n\n### XML配置MVC\n\n> 配置 web.xml \n\n在 web.xml 中配置 mvc 的 DispatcherServlet 的映射路径为 **/** ( 所有请求 )，让所有请求都交给 mvc 核心控制器进行处理\n\n~~~xml\n<servlet>\n    <servlet-name>springmvc</servlet-name>\n    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>\n	<!-- init-param标签用来指定mvc所需要的配置文件 -->\n    <init-param>\n        <param-name>contextConfigLocation</param-name>\n        <param-value>classpath:springmvc.xml</param-value>\n    </init-param>\n</servlet>\n<servlet-mapping>\n    <servlet-name>springmvc</servlet-name>\n    <url-pattern>/</url-pattern>\n</servlet-mapping>\n~~~\n\n在配置 web.xml 的时候可以不用配置 init-param ，他会默认的去 WEB-INF 目录下找配置文件，这时候文件名必须是 `servlet-name` 标签内的值，且后面必须加上-servlet，例如 springmvc-servlet.xml\n\n\n\n>配置 springmvc\n\n定义了映射器及适配器，将自己书写的实现了Controller的控制器类装配在Bean中，映射器和适配器是可以省略不写的，他有自己的默认配置，如果写了其中的一个，那么建议另一个一定要写上\n\n~~~xml\n<!--处理映射关系-->\n<bean class=\"org.springframework.web.servlet.handler.BeanNameUrlHandlerMapping\" />\n<!--适配器-->\n<bean class=\"org.springframework.web.servlet.mvc.SimpleControllerHandlerAdapter\" />\n~~~\n\n \n\n> 编写控制器类\n\n控制器就是 mvc 为我们封装好的 web 中的 servlet 类，他可以接收客户端发来的请求，省去了我们在 web 开发中较为麻烦的 web.xml 配置等等。\n\n~~~java\n@Override\npublic ModelAndView handleRequest(HttpServletRequest request,HttpServletResponse response) throws Exception {\n    ModelAndView model = new ModelAndView();\n    System.out.println(\"控制器被成功执行\");\n    model.addObject(\"message\", \"con1 goto index.jsp\");\n    model.setViewName(\"index.jsp\");\n    return model;\n}\n~~~\n\n- ModelAndView 类：\n  - 用来负责 mvc 中主要的逻辑，其中 setViewName 方法经过视图解析器后就是转发的目标路径\n  - addObject 方法就类似 request 中的 setAttribute 方法\n\n\n\n### 注解配置MVC\n\n注解配置 springmvc 相比配置文件来说更为简单，建议重新开个项目来写\n\n> 重写配置文件\n\n~~~xml\n<!-- 开启注解配置mvc -->\n<mvc:annotation-driven></mvc:annotation-driven>\n<!-- scan扫描注解所在的包 -->\n<context:component-scan base-package=\"club.hanzhe.web\" />\n<bean class=\"org.springframework.web.servlet.view.InternalResourceViewResolver\">\n	<property name=\"prefix\" value=\"/\" />\n	<property name=\"suffix\" value=\".jsp\" />\n</bean>\n~~~\n\n> 控制器类代码：\n\n~~~java\n@Controller\npublic class Con1 {\n    @RequestMapping(\"/main\")\n    public String method01() throws Exception {\n        System.out.println(\"mvc function run\");\n        return \"index\";\n    }\n}\n~~~\n\n1. 使用了 `@Controller` 注解，表明当前类是控制器类。\n2. 每个方法上都可以使用 `@RequestMapping` 来指定目标访问路径\n\n \n\n## MVC 的视图解析器\n\n在每个控制器中会返回 ModelAndView 的实例，这些返回的实例会被视图解析器接受并解析处理，setViewName 会被解析为路径拼接到视图解析器中，addObject 中的数据会被封装到目标路径的 request 域中\n\n视图解析器配置中的配置及最常用的两个属性\n\n- prefix：是解析视图名称后拼接在前面的前缀，**/** 代表目标视图在根目录\n- suffix：是解析视图名称后拼接在后面的后缀，.jsp 代表解析后为 jsp 视图\n\n~~~xml\n<bean class=\"org.springframework.web.servlet.view.InternalResourceViewResolver\">\n    <property name=\"prefix\" value=\"/\" />\n    <property name=\"suffix\" value=\".jsp\" />\n</bean>\n~~~\n\n\n\n## 请求参数绑定\n\n### 简单类型绑定\n\n想要什么名字，什么类型的参数，直接写在处理请求的方法的参数列表中即可，需要注意的是，变量名要与请求参数表单的 name 值相同\n\n例如：localhost:8080/Day01/1.action?user=abc\n\n这时表单传来的数据中 name 为 user，代码如下：\n\n~~~java\n@RequestMapping(\"1\") // 简单参数绑定，变量名需要与表单的name相同\npublic void test1( String user ) {\n    // 打印测试\n    System.out.println(\"user = \" + user);\n}   \n~~~\n\n如果参数列表和提交的表单的 name 不同，需要使用注解获取指定 name 的值\n\n~~~java\n// 请求地址： localhost:8080/username=zhang\n@ResponseBody\n@RequestMapping(\"/test\")\npublic String test( @RequestParam(\"username\")String name ){\n    return \"获取到的值：\" + name;\n}\n~~~\n\n', '2022-05-11 13:11:12', 0);
INSERT INTO `m_blog` VALUES (23, 65, '我的经典语录', '我的演绎的12句台词，经典而耐人寻味', '#### 1.虽然我很喜欢她，但始终没有告诉她，因为我知道得不到的东西永远是最好的。	  	     	——《东邪西毒》\n![张国荣1.jpg](https://rj213.oss-cn-shanghai.aliyuncs.com/2022/05/27/f95edefa-a080-4d2d-b1bf-bf593c907afb.jpg)\n#### 02.我想虞姬即使自刎于剑下，那一刻，她亦是幸福的，对望的眸中，她看到生死相许的来世。所以无怨，也无迟疑。\n					  ——《霸王别姬》\n\n#### 03.爱一个人，不一定要她整辈子跟着你。\n  \n					  ——《纵横四海》\n\n#### 04.我对上海只不过是一个过客，我做完要做的事，就会离开。\n\n					  ——《新上海滩》\n![张国荣2.jpg](https://rj213.oss-cn-shanghai.aliyuncs.com/2022/05/27/7b2e5373-6158-48a1-8422-0c9cd0ccd7d7.jpg)', '2022-05-28 00:15:10', 0);
INSERT INTO `m_blog` VALUES (24, 1, '亮剑精神!', '如何打好仗?', '## 1、知已知彼，百战不殆 ---- 精通业务，才能受重用\n 一名合格的团队成员，应该对自己的业务熟悉，不致于在 leader 问起时一问三不知，这样 leader 才会逐步把一些团队的重任交给你，你在团队才会越来越受重用。\n\n接下来我们来看两个反例，在《亮剑》第一剑李云龙发起冲锋时一个日军军官问它的部下对面是哪个部队时，这名部下的回答是这样的\n![李云龙1.gif](https://rj213.oss-cn-shanghai.aliyuncs.com/2022/06/06/ab32b2bd-6408-45c6-9472-698dc6730a7e.gif)\n\n也难怪之后被这名军官痛骂了一顿。\n\n第二次是在李云龙与楚云飞对仗时，李云龙已经知道对手是楚云飞了，结果楚云飞呢打了半天他和手下却不知对手到底是谁，在对战中知道对手是谁很重要，可以针对军官的作战特点对症下药\n![李云龙2.gif](https://rj213.oss-cn-shanghai.aliyuncs.com/2022/06/06/7f394767-9282-4d0b-9557-d70bad34a8d2.gif)\n\n看完了两个反面的例子，那我们来看看正面例子，我们知道张大彪是李云龙非常得力的一名干将，非常地受李云龙重用，原因从以下对话可以略知一二![lyl2.gif](https://rj213.oss-cn-shanghai.aliyuncs.com/2022/06/06/5872821a-045d-49d9-87ea-9fd3f2dd6ade.gif)\n而且说完这些张大彪还把坂田联队的特点（比如是精锐部队），以往与我军的交战史如数家珍般地说了出来，就就叫做对业务熟悉，这样的部下不受重用谁受重要？\n\n## 2、不迁怒，对事不对人----不用让情绪左右你的工作\n第一集李云龙叫来王承柱准备让他炮打对方的指挥部，王承柱报告说只有两名炮弹时，李云龙把王承柱骂了一顿，然后王承柱也不满地解释了下原因，李云龙训斥了两句话后马上转变了态度![lyl3.gif](https://rj213.oss-cn-shanghai.aliyuncs.com/2022/06/06/7cff25aa-6806-4158-ae06-e473d28655b9.gif)\n\n## 3、leader 的作用之一：指引方向，避免团队走向万劫不复的深渊\nleader 的作用并不是事必躬亲，而是任人唯贤，比如李云龙有孙得胜作骑兵连指挥官，有王承柱这样的重炮手，也有张大彪这样优秀的侦察员。当然除了任人唯贤，把握好方向，避免团队走弯路也是一个非常重要的点\n\n当时李云龙提出要炮轰对方的指挥部，张大彪提出以下有可能导致团队死伤惨重的提案![lyl4.gif](https://rj213.oss-cn-shanghai.aliyuncs.com/2022/06/06/41ba15d1-e548-49a7-ab2a-9d5aedcfe391.gif)', '2022-05-30 15:00:33', 0);
INSERT INTO `m_blog` VALUES (25, 65, '测试数据', '测试数据', '测试数据', '2022-06-07 08:37:44', 0);
INSERT INTO `m_blog` VALUES (26, 65, '测试数据二', '测试数据', '测试', '2022-06-07 08:38:09', 0);
INSERT INTO `m_blog` VALUES (27, 65, '张国荣百度百科', '张国荣（1956年9月12日-2003年4月1日），出生于香港，中国香港男歌手、演员、音乐人。1977年获得丽的电视亚洲歌唱大赛香港区亚军，..............', '### 他，是公认评选出来的香港四大绝色之首。\n香港四大才子的倪匡先生写他眉目如画、黄霑先生每次见到他都要亲他才罢休，很多见过他的人都说，他真人比镜头里要好看很多倍。\n![张国荣1.jpeg](https://rj213.oss-cn-shanghai.aliyuncs.com/2022/06/07/e37e4b07-0475-455e-9294-88887d3ccb59.jpeg)同时，他亦是香港金像奖影帝、香港乐坛最高荣誉大奖金针奖获得者。他就是张国荣。\n\n### 小时候好乖啊\n\n1956年9月12日，香港九龙。一声婴儿的啼哭，宣告着张家的第十个小儿子出生了。\n\n他们将他取名为张发宗，英文名叫Bobby。![张国荣.jpeg](https://rj213.oss-cn-shanghai.aliyuncs.com/2022/06/07/b2558d78-4f45-416a-8da8-57e07753d39a.jpeg)\n张发宗的父亲张活海是香港地区有名的洋服店老板兼裁缝，马龙·白兰度、希区柯克等好莱坞明星都是这家裁缝店的顾客。\n\n由于家中的孩子很多，加上裁缝店生意繁忙，张发宗童年时期，很少见到他的父母，只有佣人六姐一如既往的关心他。\n\n而哥哥姐姐们与他年龄相差太大，调皮的兄长还时常拿他开玩笑。父母对他的家教又非常严厉，张发宗在家中难免觉得孤独。![张国荣3.jpeg](https://rj213.oss-cn-shanghai.aliyuncs.com/2022/06/07/e5579485-76a6-4287-8d8c-072aa8d041bb.jpeg)\n\n\n到了念书的时候，他又因为数学一塌糊涂而感到十分烦恼。\n\n于是当他得知去外国念书学数学会很容易时，他毅然决然选择了去英国念书。\n\n1969年，张发宗踏上了去大不列颠的留学路。在英国中学毕业后，他考入了英国里兹大学就读纺织专业。![张国荣4.jpeg](https://rj213.oss-cn-shanghai.aliyuncs.com/2022/06/07/bed0ba50-574c-48e4-82fa-94f1c06272b4.jpeg)\n他想过属于自己的人生。\n\n在打工路上经历过几番挫折失败后，1977年，他的一位同学对他说：“丽的电视台有一个唱歌比赛啊，你去不去？”\n\n他不想再靠父母生活，于是就和他的同学一起去参加了比赛。\n\n\n“当有人问起香港80年代歌星时，你们能随便提一提我，我就很开心了。”\n\n世间阴差阳错的事情发生得多了，最终落到了他头上。![张国荣5.jpeg](https://rj213.oss-cn-shanghai.aliyuncs.com/2022/06/07/e9f5aec5-a175-4454-8ce0-d598c60ef278.jpeg)\n他拿到了亚军。\n颁奖的时候，有个人对他说：“I will make you a star.”\n他顿时觉得自己前途一片光明。\n那时候的他，早已改名。“张发宗”成了过去式，现在的他，叫张国荣。顺便呢，他也就把英文名给改了。因喜欢饰演乱世佳人的Leslie，他把自己的英文名也改成了Leslie。', '2022-06-07 08:46:42', 0);

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
  `status` int NOT NULL DEFAULT 0,
  `created` datetime NULL DEFAULT NULL,
  `last_login` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `UK_USERNAME`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of m_user
-- ----------------------------
INSERT INTO `m_user` VALUES (1, '李云龙', 'https://rj213.oss-cn-shanghai.aliyuncs.com/2022/06/11/421b10ec-3940-45ef-bc08-09402ecb9012.jpg', NULL, '202cb962ac59075b964b07152d234b70', 0, '2020-04-20 10:44:01', NULL);
INSERT INTO `m_user` VALUES (65, '张国荣', 'https://rj213.oss-cn-shanghai.aliyuncs.com/2022/06/10/a20c2d65-61ab-42ad-8fcb-0c6055c1987a.jpeg', NULL, '202cb962ac59075b964b07152d234b70', 0, NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;
