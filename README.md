# 114-SecondPractice

一个基于 JSP + Servlet + Maven 的 Java Web 练习项目，实现了登录页、验证码校验和课程管理页的基本联动。

## 项目简介

用户在登录页输入用户名、密码，选择学院和系，并填写验证码后提交表单。服务端校验通过后，会跳转到课程管理页面，并根据所选学院/专业返回一组预设课程成绩数据。

这个项目目前更偏向课堂练习或实验性质，使用的是本地预设数据，没有接入数据库，也没有实现真实的用户认证和课程增删改逻辑。

## 已实现功能

- 登录页面展示与表单提交
- 学院和系的前端联动下拉框
- 密码格式前端校验
- 验证码图片生成、刷新与服务端校验
- 登录成功后跳转到课程管理页面
- 根据学院/系返回不同的预设课程成绩

## 技术栈

- Java 8
- JSP / Servlet
- Maven
- Jakarta Servlet API
- HTML / CSS / JavaScript

## 项目结构

```text
src
└─ main
   ├─ java
   │  └─ com.example.login_and_course
   │     ├─ controller
   │     │  ├─ CaptchaController.java
   │     │  └─ LoginController.java
   │     ├─ pojo
   │     │  ├─ DynContent.java
   │     │  ├─ Login.java
   │     │  └─ LoginStatus.java
   │     └─ service
   │        └─ LoginService.java
   └─ webapp
      ├─ login.jsp
      ├─ courseMng.jsp
      └─ WEB-INF
         └─ web.xml
```

## 页面说明

### `login.jsp`

- 项目默认欢迎页
- 包含用户名、密码、学院、系、验证码输入
- 前端会校验密码必须同时包含字母和数字
- 点击验证码图片或刷新按钮可重新获取验证码

### `courseMng.jsp`

- 登录成功后进入的课程管理页面
- 展示用户名、所在学院和课程成绩表
- 页面中的“退选”“课程管理”按钮目前为静态按钮，尚未接入业务逻辑

## 运行方式

### 1. 打包项目

在项目根目录执行：

```powershell
.\mvnw.cmd package
```

打包完成后生成：

```text
target/SecondPractice_114.war
```

### 2. 部署到 Servlet 容器

将 `target/SecondPractice_114.war` 部署到支持 Jakarta Servlet 的 Web 容器中。

部署成功后，可按容器默认上下文路径访问：

```text
http://localhost:8080/SecondPractice_114/
```

项目欢迎页为：

```text
login.jsp
```

## 请求入口

- 登录提交：`/LoginController`
- 验证码图片：`/CaptchaController`

## 业务说明

- 当学院为“计算机学院”且系为“软件工程”时，会返回一组预设课程和成绩
- 其他学院/系目前返回另一组默认课程数据
- 服务端当前只校验表单完整性和验证码，不做真实账号密码鉴权

## 当前限制

- 无数据库
- 无真实用户体系
- 无 Session 登录态管理页面
- 无课程退选、增删改功能
- 无单元测试

## 构建验证

已在当前项目中执行：

```powershell
.\mvnw.cmd package -DskipTests
```

结果为 `BUILD SUCCESS`。
