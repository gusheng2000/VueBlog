## Java后端接口开发

### 1、前言

从零开始搭建一个项目骨架，最好选择合适，熟悉的技术，并且在未来易拓展，适合微服务化体系等。所以一般以Springboot作为我们的框架基础，这是离不开的了。

然后数据层，我们常用的是Mybatis，易上手，方便维护。但是单表操作比较困难，特别是添加字段或减少字段的时候，比较繁琐，所以这里我推荐使用Mybatis Plus（https://mp.baomidou.com/），为简化开发而生，只需简单配置，即可快速进行 CRUD 操作，从而节省大量时间。

作为一个项目骨架，权限也是我们不能忽略的，Shiro配置简单，使用也简单，所以使用Shiro作为我们的的权限。

考虑到项目可能需要部署多台，这时候我们的会话等信息需要共享，Redis是现在主流的缓存中间件，也适合我们的项目。

然后因为前后端分离，所以我们使用jwt作为我们用户身份凭证。

ok，我们现在就开始搭建我们的项目脚手架！

技术栈：

- SpringBoot
- mybatis plus
- shiro
- lombok
- redis
- hibernate validatior
- jwt

导图：https://www.markerhub.com/map/131

### 2、新建Springboot项目

这里，我们使用IDEA来开发我们项目，新建步骤比较简单，我们就不截图了。

开发工具与环境：

- idea
- mysql
- jdk 8
- maven3.3.9

新建好的项目结构如下，SpringBoot版本使用的目前最新的2.2.6.RELEASE版本

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/be1226b48ef24b2bbe00d75996bd7f89.png)

pom的jar包导入如下：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
    <optional>true</optional>
</dependency>
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <optional>true</optional>
</dependency>
```

- devtools：项目的热加载重启插件

- lombok：简化代码的工具

  ### 3、整合mybatis plus

接下来，我们来整合mybatis plus，让项目能完成基本的增删改查操作。步骤很简单：可以去官网看看：https://mp.baomidou.com/guide/install.html

**第一步：导入jar包**

pom中导入mybatis plus的jar包，因为后面会涉及到代码生成，所以我们还需要导入页面模板引擎，这里我们用的是freemarker。

```xml
<!--mp-->
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-boot-starter</artifactId>
    <version>3.2.0</version>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-freemarker</artifactId>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <scope>runtime</scope>
</dependency>
<!--mp代码生成器-->
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-generator</artifactId>
    <version>3.2.0</version>
</dependency>
```

**第二步：然后去写配置文件**

```yaml
# DataSource Config
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/vueblog?useUnicode=true&useSSL=false&characterEncoding=utf8&serverTimezone=Asia/Shanghai
    username: root
    password: admin
mybatis-plus:
  mapper-locations: classpath*:/mapper/**Mapper.xml
```

上面除了配置数据库的信息，还配置了myabtis plus的mapper的xml文件的扫描路径，这一步不要忘记了。
**第三步：开启mapper接口扫描，添加分页插件**

新建一个包：通过[@mapperScan](https://github.com/mapperScan)注解指定要变成实现类的接口所在的包，然后包下面的所有接口在编译之后都会生成相应的实现类。PaginationInterceptor是一个分页插件。

- com.markerhub.config.MybatisPlusConfig

```java
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
```

**第四步：代码生成**

如果你没再用其他插件，那么现在就已经可以使用mybatis plus了，官方给我们提供了一个代码生成器，然后我写上自己的参数之后，就可以直接根据数据库表信息生成entity、service、mapper等接口和实现类。

- com.markerhub.CodeGenerator

因为代码比较长，就不贴出来了，在代码仓库上看哈！

首先我在数据库中新建了一个user表：

```sql
CREATE TABLE `m_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `password` varchar(64) DEFAULT NULL,
  `status` int(5) NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `UK_USERNAME` (`username`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `m_blog` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `content` longtext,
  `created` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `status` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;
INSERT INTO `vueblog`.`m_user` (`id`, `username`, `avatar`, `email`, `password`, `status`, `created`, `last_login`) VALUES ('1', 'markerhub', 'https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/5a9f48118166308daba8b6da7e466aab.jpg', NULL, '96e79218965eb72c92a549dd5a330112', '0', '2020-04-20 10:44:01', NULL);
```

运行CodeGenerator的main方法，输入表名：m_user，生成结果如下：

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/47682f628eae4c3588f6729e1df322af.png)

得到：

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/f5e4daec518044619c0d374daa844f40.png)

简洁！方便！经过上面的步骤，基本上我们已经把mybatis plus框架集成到项目中了。

ps：额，注意一下m_blog表的代码也生成一下哈。

在UserController中写个测试：

```
@RestController
@RequestMapping("/user")
public class UserController {
    @Autowired
    UserService userService;
    @GetMapping("/{id}")
    public Object test(@PathVariable("id") Long id) {
        return userService.getById(id);
    }
}
```

访问：http://localhost:8080/user/1 获得结果如下，整合成功！
![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/ecb8c3a623694595a22980a26821ccb6.png)

### 3、统一结果封装

这里我们用到了一个Result的类，这个用于我们的异步统一返回的结果封装。一般来说，结果里面有几个要素必要的

- 是否成功，可用code表示（如200表示成功，400表示异常）
- 结果消息
- 结果数据

所以可得到封装如下：

- com.markerhub.common.lang.Result

```
@Data
public class Result implements Serializable {
    private String code;
    private String msg;
    private Object data;
    public static Result succ(Object data) {
        Result m = new Result();
        m.setCode("0");
        m.setData(data);
        m.setMsg("操作成功");
        return m;
    }
    public static Result succ(String mess, Object data) {
        Result m = new Result();
        m.setCode("0");
        m.setData(data);
        m.setMsg(mess);
        return m;
    }
    public static Result fail(String mess) {
        Result m = new Result();
        m.setCode("-1");
        m.setData(null);
        m.setMsg(mess);
        return m;
    }
    public static Result fail(String mess, Object data) {
        Result m = new Result();
        m.setCode("-1");
        m.setData(data);
        m.setMsg(mess);
        return m;
    }
}
```

### 4、整合shiro+jwt，并会话共享

考虑到后面可能需要做集群、负载均衡等，所以就需要会话共享，而shiro的缓存和会话信息，我们一般考虑使用redis来存储这些数据，所以，我们不仅仅需要整合shiro，同时也需要整合redis。在开源的项目中，我们找到了一个starter可以快速整合shiro-redis，配置简单，这里也推荐大家使用。

而因为我们需要做的是前后端分离项目的骨架，所以一般我们会采用token或者jwt作为跨域身份验证解决方案。所以整合shiro的过程中，我们需要引入jwt的身份验证过程。

那么我们就开始整合：

我们使用一个shiro-redis-spring-boot-starter的jar包，具体教程可以看官方文档：https://github.com/alexxiyang/shiro-redis/blob/master/docs/README.md#spring-boot-starter

第一步：导入shiro-redis的starter包：还有jwt的工具包，以及为了简化开发，我引入了hutool工具包。

```
<dependency>
    <groupId>org.crazycake</groupId>
    <artifactId>shiro-redis-spring-boot-starter</artifactId>
    <version>3.2.1</version>
</dependency>
<!-- hutool工具类-->
<dependency>
    <groupId>cn.hutool</groupId>
    <artifactId>hutool-all</artifactId>
    <version>5.3.3</version>
</dependency>
<!-- jwt -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt</artifactId>
    <version>0.9.1</version>
</dependency>
```

第二步：编写配置：

#### ShiroConfig

- com.markerhub.config.ShiroConfig

```
/**
 * shiro启用注解拦截控制器
 */
@Configuration
public class ShiroConfig {
    @Autowired
    JwtFilter jwtFilter;
    @Bean
    public SessionManager sessionManager(RedisSessionDAO redisSessionDAO) {
        DefaultWebSessionManager sessionManager = new DefaultWebSessionManager();
        sessionManager.setSessionDAO(redisSessionDAO);
        return sessionManager;
    }
    @Bean
    public DefaultWebSecurityManager securityManager(AccountRealm accountRealm,
                                                     SessionManager sessionManager,
                                                     RedisCacheManager redisCacheManager) {
        DefaultWebSecurityManager securityManager = new DefaultWebSecurityManager(accountRealm);
        securityManager.setSessionManager(sessionManager);
        securityManager.setCacheManager(redisCacheManager);
        /*
         * 关闭shiro自带的session，详情见文档
         */
        DefaultSubjectDAO subjectDAO = new DefaultSubjectDAO();
        DefaultSessionStorageEvaluator defaultSessionStorageEvaluator = new DefaultSessionStorageEvaluator();
        defaultSessionStorageEvaluator.setSessionStorageEnabled(false);
        subjectDAO.setSessionStorageEvaluator(defaultSessionStorageEvaluator);
        securityManager.setSubjectDAO(subjectDAO);
        return securityManager;
    }
    @Bean
    public ShiroFilterChainDefinition shiroFilterChainDefinition() {
        DefaultShiroFilterChainDefinition chainDefinition = new DefaultShiroFilterChainDefinition();
        Map<String, String> filterMap = new LinkedHashMap<>();
        filterMap.put("/**", "jwt"); // 主要通过注解方式校验权限
        chainDefinition.addPathDefinitions(filterMap);
        return chainDefinition;
    }
    @Bean("shiroFilterFactoryBean")
    public ShiroFilterFactoryBean shiroFilterFactoryBean(SecurityManager securityManager,
                                                         ShiroFilterChainDefinition shiroFilterChainDefinition) {
        ShiroFilterFactoryBean shiroFilter = new ShiroFilterFactoryBean();
        shiroFilter.setSecurityManager(securityManager);
        Map<String, Filter> filters = new HashMap<>();
        filters.put("jwt", jwtFilter);
        shiroFilter.setFilters(filters);
        Map<String, String> filterMap = shiroFilterChainDefinition.getFilterChainMap();
        shiroFilter.setFilterChainDefinitionMap(filterMap);
        return shiroFilter;
    }

    // 开启注解代理（默认好像已经开启，可以不要）
    @Bean
    public AuthorizationAttributeSourceAdvisor authorizationAttributeSourceAdvisor(SecurityManager securityManager){
        AuthorizationAttributeSourceAdvisor authorizationAttributeSourceAdvisor = new AuthorizationAttributeSourceAdvisor();
        authorizationAttributeSourceAdvisor.setSecurityManager(securityManager);
        return authorizationAttributeSourceAdvisor;
    }
    @Bean
    public static DefaultAdvisorAutoProxyCreator getDefaultAdvisorAutoProxyCreator() {
        DefaultAdvisorAutoProxyCreator creator = new DefaultAdvisorAutoProxyCreator();
        return creator;
    }
}
```

上面ShiroConfig，我们主要做了几件事情：

1. 引入RedisSessionDAO和RedisCacheManager，为了解决shiro的权限数据和会话信息能保存到redis中，实现会话共享。
2. 重写了SessionManager和DefaultWebSecurityManager，同时在DefaultWebSecurityManager中为了关闭shiro自带的session方式，我们需要设置为false，这样用户就不再能通过session方式登录shiro。后面将采用jwt凭证登录。
3. 在ShiroFilterChainDefinition中，我们不再通过编码形式拦截Controller访问路径，而是所有的路由都需要经过JwtFilter这个过滤器，然后判断请求头中是否含有jwt的信息，有就登录，没有就跳过。跳过之后，有Controller中的shiro注解进行再次拦截，比如[@RequiresAuthentication](https://github.com/RequiresAuthentication)，这样控制权限访问。

那么，接下来，我们聊聊ShiroConfig中出现的AccountRealm，还有JwtFilter。

#### AccountRealm

AccountRealm是shiro进行登录或者权限校验的逻辑所在，算是核心了，我们需要重写3个方法，分别是

- supports：为了让realm支持jwt的凭证校验
- doGetAuthorizationInfo：权限校验
- doGetAuthenticationInfo：登录认证校验

我们先来总体看看AccountRealm的代码，然后逐个分析：

- com.markerhub.shiro.AccountRealm

```
@Slf4j
@Component
public class AccountRealm extends AuthorizingRealm {
    @Autowired
    JwtUtils jwtUtils;
    @Autowired
    UserService userService;
    @Override
    public boolean supports(AuthenticationToken token) {
        return token instanceof JwtToken;
    }
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
        return null;
    }
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
        JwtToken jwt = (JwtToken) token;
        log.info("jwt----------------->{}", jwt);
        String userId = jwtUtils.getClaimByToken((String) jwt.getPrincipal()).getSubject();
        User user = userService.getById(Long.parseLong(userId));
        if(user == null) {
            throw new UnknownAccountException("账户不存在！");
        }
        if(user.getStatus() == -1) {
            throw new LockedAccountException("账户已被锁定！");
        }
        AccountProfile profile = new AccountProfile();
        BeanUtil.copyProperties(user, profile);
        log.info("profile----------------->{}", profile.toString());
        return new SimpleAuthenticationInfo(profile, jwt.getCredentials(), getName());
    }
}
```

其实主要就是doGetAuthenticationInfo登录认证这个方法，可以看到我们通过jwt获取到用户信息，判断用户的状态，最后异常就抛出对应的异常信息，否者封装成SimpleAuthenticationInfo返回给shiro。
接下来我们逐步分析里面出现的新类：

1、shiro默认supports的是UsernamePasswordToken，而我们现在采用了jwt的方式，所以这里我们自定义一个JwtToken，来完成shiro的supports方法。

#### JwtToken

- com.markerhub.shiro.JwtToken

```plain
public class JwtToken implements AuthenticationToken {
    private String token;
    public JwtToken(String token) {
        this.token = token;
    }
    @Override
    public Object getPrincipal() {
        return token;
    }
    @Override
    public Object getCredentials() {
        return token;
    }
}
```

2、JwtUtils是个生成和校验jwt的工具类，其中有些jwt相关的密钥信息是从项目配置文件中配置的：

```plain
package com.markerhub.util;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;
import java.util.Date;

/**
 * @Author sc
 * @ClassName JwtUtils
 * @Description class function:
 * @Date 2022/5/1 21:50:39
 **/
@Slf4j
@Data
@Component
@ConfigurationProperties(prefix = "markerhub.jwt")
public class JwtUtils {
    //密钥
    private String secret;
    private long expire;
    private String header;

    /**
     * 生成jwt token
     */
    public String generateToken(long userId) {
        Date nowData = new Date();
        //过期时间
        Date expireData = new Date(nowData.getTime() + expire * 1000);
        return Jwts.builder()
                .setHeaderParam("typ", "JWT")
                .setSubject(userId + "")
                .setIssuedAt(nowData)
                .setExpiration(expireData)
                .signWith(SignatureAlgorithm.HS512, secret)
                .compact();
    }

    // 获取jwt的信息
    public Claims getClaimByToken(String token) {
        try {
            return Jwts.parser()
                    .setSigningKey(secret)
                    .parseClaimsJws(token)
                    .getBody();
        } catch (Exception e) {
            log.debug("验证错误",e);
            return null;
        }
    }

    /**
     * token是否过期
     * @return true：过期
     */
    public boolean isTokenExpired(Date expiration) {
        return expiration.before(new Date());
    }
}

```

3、而在AccountRealm我们还用到了AccountProfile，这是为了登录成功之后返回的一个用户信息的载体，

#### AccountProfile

- com.markerhub.shiro.AccountProfile

```plain
@Data
public class AccountProfile implements Serializable {
    private Long id;
    private String username;
    private String avatar;
}
```

第三步，ok，基本的校验的路线完成之后，我们需要少量的基本信息配置：

```
shiro-redis:
  enabled: true
  redis-manager:
    host: 127.0.0.1:6379
markerhub:
  jwt:
    # 加密秘钥
    secret: f4e2e52034348f86b67cde581c0f9eb5
    # token有效时长，7天，单位秒
    expire: 604800
    header: token
```

第四步：另外，如果你项目有使用spring-boot-devtools，需要添加一个配置文件，在resources目录下新建文件夹META-INF，然后新建文件spring-devtools.properties，这样热重启时候才不会报错。

- resources/META-INF/spring-devtools.properties

```
restart.include.shiro-redis=/shiro-[\\w-\\.]+jar
```

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/f227ba4a47614a6ea2f849a56fcb352d.png)

#### JwtFilter

第五步：定义jwt的过滤器JwtFilter。

这个过滤器是我们的重点，这里我们继承的是Shiro内置的AuthenticatingFilter，一个可以内置了可以自动登录方法的的过滤器，有些同学继承BasicHttpAuthenticationFilter也是可以的。

我们需要重写几个方法：

1. createToken：实现登录，我们需要生成我们自定义支持的JwtToken
2. onAccessDenied：拦截校验，当头部没有Authorization时候，我们直接通过，不需要自动登录；当带有的时候，首先我们校验jwt的有效性，没问题我们就直接执行executeLogin方法实现自动登录
3. onLoginFailure：登录异常时候进入的方法，我们直接把异常信息封装然后抛出
4. preHandle：拦截器的前置拦截，因为我们是前后端分析项目，项目中除了需要跨域全局配置之外，我们再拦截器中也需要提供跨域支持。这样，拦截器才不会在进入Controller之前就被限制了。

下面我们看看总体的代码：

- com.markerhub.shiro.JwtFilter

```plain
@Component
public class JwtFilter extends AuthenticatingFilter {
    @Autowired
    JwtUtils jwtUtils;
    @Override
    protected AuthenticationToken createToken(ServletRequest servletRequest, ServletResponse servletResponse) throws Exception {
        // 获取 token
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        String jwt = request.getHeader("Authorization");
        if(StringUtils.isEmpty(jwt)){
            return null;
        }
        return new JwtToken(jwt);
    }
    @Override
    protected boolean onAccessDenied(ServletRequest servletRequest, ServletResponse servletResponse) throws Exception {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        String token = request.getHeader("Authorization");
        if(StringUtils.isEmpty(token)) {
            return true;
        } else {
            // 判断是否已过期
            Claims claim = jwtUtils.getClaimByToken(token);
            if(claim == null || jwtUtils.isTokenExpired(claim.getExpiration())) {
                throw new ExpiredCredentialsException("token已失效，请重新登录！");
            }
        }
        // 执行自动登录
        return executeLogin(servletRequest, servletResponse);
    }
    @Override
    protected boolean onLoginFailure(AuthenticationToken token, AuthenticationException e, ServletRequest request, ServletResponse response) {
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        try {
            //处理登录失败的异常
            Throwable throwable = e.getCause() == null ? e : e.getCause();
            Result r = Result.fail(throwable.getMessage());
            String json = JSONUtil.toJsonStr(r);
            httpResponse.getWriter().print(json);
        } catch (IOException e1) {
        }
        return false;
    }
    /**
     * 对跨域提供支持
     */
    @Override
    protected boolean preHandle(ServletRequest request, ServletResponse response) throws Exception {
        HttpServletRequest httpServletRequest = WebUtils.toHttp(request);
        HttpServletResponse httpServletResponse = WebUtils.toHttp(response);
        httpServletResponse.setHeader("Access-control-Allow-Origin", httpServletRequest.getHeader("Origin"));
        httpServletResponse.setHeader("Access-Control-Allow-Methods", "GET,POST,OPTIONS,PUT,DELETE");
        httpServletResponse.setHeader("Access-Control-Allow-Headers", httpServletRequest.getHeader("Access-Control-Request-Headers"));
        // 跨域时会首先发送一个OPTIONS请求，这里我们给OPTIONS请求直接返回正常状态
        if (httpServletRequest.getMethod().equals(RequestMethod.OPTIONS.name())) {
            httpServletResponse.setStatus(org.springframework.http.HttpStatus.OK.value());
            return false;
        }
        return super.preHandle(request, response);
    }
}
```

那么到这里，我们的shiro就已经完成整合进来了，并且使用了jwt进行身份校验。

### 5、异常处理

有时候不可避免服务器报错的情况，如果不配置异常处理机制，就会默认返回tomcat或者nginx的5XX页面，对普通用户来说，不太友好，用户也不懂什么情况。这时候需要我们程序员设计返回一个友好简单的格式给前端。

处理办法如下：通过使用[@ControllerAdvice](https://github.com/ControllerAdvice)来进行统一异常处理，[@ExceptionHandler](https://github.com/ExceptionHandler)(value = RuntimeException.class)来指定捕获的Exception各个类型异常 ，这个异常的处理，是全局的，所有类似的异常，都会跑到这个地方处理。

- com.markerhub.common.exception.GlobalExceptionHandler

步骤二、定义全局异常处理，[@ControllerAdvice](https://github.com/ControllerAdvice)表示定义全局控制器异常处理，[@ExceptionHandler](https://github.com/ExceptionHandler)表示针对性异常处理，可对每种异常针对性处理。

```java
/**
 * 全局异常处理
 */
@Slf4j
@RestControllerAdvice
public class GlobalExcepitonHandler {
    // 捕捉shiro的异常
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    @ExceptionHandler(ShiroException.class)
    public Result handle401(ShiroException e) {
        return Result.fail(401, e.getMessage(), null);
    }
    /**
     * 处理Assert的异常
     */
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(value = IllegalArgumentException.class)
    public Result handler(IllegalArgumentException e) throws IOException {
        log.error("Assert异常:-------------->{}",e.getMessage());
        return Result.fail(e.getMessage());
    }
    /**
     * @Validated 校验错误异常处理
     */
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(value = MethodArgumentNotValidException.class)
    public Result handler(MethodArgumentNotValidException e) throws IOException {
        log.error("运行时异常:-------------->",e);
        BindingResult bindingResult = e.getBindingResult();
        ObjectError objectError = bindingResult.getAllErrors().stream().findFirst().get();
        return Result.fail(objectError.getDefaultMessage());
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(value = RuntimeException.class)
    public Result handler(RuntimeException e) throws IOException {
        log.error("运行时异常:-------------->",e);
        return Result.fail(e.getMessage());
    }
}
```

上面我们捕捉了几个异常：

- ShiroException：shiro抛出的异常，比如没有权限，用户登录异常
- IllegalArgumentException：处理Assert的异常
- MethodArgumentNotValidException：处理实体校验的异常
- RuntimeException：捕捉其他异常

### 6、实体校验

当我们表单数据提交的时候，前端的校验我们可以使用一些类似于jQuery Validate等js插件实现，而后端我们可以使用Hibernate validatior来做校验。

我们使用springboot框架作为基础，那么就已经自动集成了Hibernate validatior。

那么用起来啥样子的呢？

第一步：首先在实体的属性上添加对应的校验规则，比如：

```java
@TableName("m_user")
public class User implements Serializable {
    private static final long serialVersionUID = 1L;
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;
    @NotBlank(message = "昵称不能为空")
    private String username;
    @NotBlank(message = "邮箱不能为空")
    @Email(message = "邮箱格式不正确")
    private String email;

    ...
}
```

第二步 ：这里我们使用[@Validated](https://github.com/Validated)注解方式，如果实体不符合要求，系统会抛出异常，那么我们的异常处理中就捕获到MethodArgumentNotValidException。

- com.markerhub.controller.UserController

```
/**
 * 测试实体校验
 * @param user
 * @return
 */
@PostMapping("/save")
public Object testUser(@Validated @RequestBody User user) {
    return user.toString();
}
```

### 7、跨域问题

因为是前后端分析，所以跨域问题是避免不了的，我们直接在后台进行全局跨域处理：

- com.markerhub.config.CorsConfig

```java
/**
 * 解决跨域问题
 */
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("GET", "HEAD", "POST", "PUT", "DELETE", "OPTIONS")
                .allowCredentials(true)
                .maxAge(3600)
                .allowedHeaders("*");
    }
}
```

ok，因为我们系统开发的接口比较简单，所以我就不集成swagger2啦，也比较简单而已。下面我们就直接进入我们的正题，进行编写登录接口。

### 8、登录接口开发

登录的逻辑其实很简答，只需要接受账号密码，然后把用户的id生成jwt，返回给前段，为了后续的jwt的延期，所以我们把jwt放在header上。具体代码如下：

- com.markerhub.controller.AccountController

```java
@RestController
public class AccountController {
    @Autowired
    JwtUtils jwtUtils;
    @Autowired
    UserService userService;
    /**
     * 默认账号密码：markerhub / 111111
     *
     */
    @CrossOrigin
    @PostMapping("/login")
    public Result login(@Validated @RequestBody LoginDto loginDto, HttpServletResponse response) {
        User user = userService.getOne(new QueryWrapper<User>().eq("username", loginDto.getUsername()));
        Assert.notNull(user, "用户不存在");
        if(!user.getPassword().equals(SecureUtil.md5(loginDto.getPassword()))) {
            return Result.fail("密码错误！");
        }
        String jwt = jwtUtils.generateToken(user.getId());
        response.setHeader("Authorization", jwt);
        response.setHeader("Access-Control-Expose-Headers", "Authorization");
        // 用户可以另一个接口
        return Result.succ(MapUtil.builder()
                .put("id", user.getId())
                .put("username", user.getUsername())
                .put("avatar", user.getAvatar())
                .put("email", user.getEmail())
                .map()
        );
    }

    // 退出
    @GetMapping("/logout")
    @RequiresAuthentication
    public Result logout() {
        SecurityUtils.getSubject().logout();
        return Result.succ(null);
    }
}
```

接口测试：
![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/5000047b0a874b09850c4ffde0053c8d.png)

### 9、博客接口开发

我们的骨架已经完成，接下来，我们就可以添加我们的业务接口了，下面我以一个简单的博客列表、博客详情页为例子开发：

- com.markerhub.controller.BlogController

```java
@RestController
public class BlogController {
    @Autowired
    BlogService blogService;
    @GetMapping("/blogs")
    public Result blogs(Integer currentPage) {
        if(currentPage == null || currentPage < 1) currentPage = 1;
        Page page = new Page(currentPage, 5)
        IPage pageData = blogService.page(page, new QueryWrapper<Blog>().orderByDesc("created"));
        return Result.succ(pageData);
    }
    @GetMapping("/blog/{id}")
    public Result detail(@PathVariable(name = "id") Long id) {
        Blog blog = blogService.getById(id);
        Assert.notNull(blog, "该博客已删除！");
        return Result.succ(blog);
    }

    @RequiresAuthentication
@PostMapping("/blog/edit")
public Result edit(@Validated @RequestBody Blog blog) {
    System.out.println(blog.toString());
    Blog temp = null;
    if(blog.getId() != null) {
        temp = blogService.getById(blog.getId());
        Assert.isTrue(temp.getUserId() == ShiroUtil.getProfile().getId(), "没有权限编辑");
    } else {
        temp = new Blog();
        temp.setUserId(ShiroUtil.getProfile().getId());
        temp.setCreated(LocalDateTime.now());
        temp.setStatus(0);
    }
    BeanUtil.copyProperties(blog, temp, "id", "userId", "created", "status");
    blogService.saveOrUpdate(temp);
    return Result.succ("操作成功", null);
}
}
```

注意[@RequiresAuthentication](https://github.com/RequiresAuthentication)说明需要登录之后才能访问的接口，其他需要权限的接口可以添加shiro的相关注解。
接口比较简单，我们就不多说了，基本增删改查而已。注意的是edit方法是需要登录才能操作的受限资源。

接口测试：

![图片](https://image-1300566513.cos.ap-guangzhou.myqcloud.com/upload/images/20201117/f9269851970c43d096d3c777730fffde.png)

### 10、后端总结

好了，一篇文章搞定一个基本骨架，好像有点赶，但是基本的东西这里已经有了。后面我们就要去开发我们的前端接口了。

项目代码：https://github.com/MarkerHub/vueblog

项目视频：https://www.bilibili.com/video/BV1PQ4y1P7hZ/