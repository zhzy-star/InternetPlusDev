# 114-ThirdWork

基于 `JSP + Servlet + JDBC + MySQL` 的学生选课管理作业项目，采用 MVC 分层实现登录、验证码校验、课程查询与新增选课功能。

## 项目简介

本项目是第三次 Java Web 作业实现，延续第二次作业的页面交互与 MVC 结构，并将登录验证和课程数据改为从 MySQL 数据库读取。

当前项目已实现：

- 学号、密码、学院、系别、验证码联合登录
- 验证码图片动态生成与 Session 校验
- 基于 MySQL 的用户登录认证
- 登录后展示当前学生已选课程与成绩
- 从课程库读取全部课程并支持批量新增选课
- 重复选课校验与失败页提示

## 技术栈

- Java 8
- JSP
- Servlet
- JDBC
- MySQL 8
- Maven
- Jakarta Servlet API 6.1

## 项目结构

```text
114-ThirdHomeWork/
├── pom.xml
├── sql/
│   └── 114_JDBC.sql
├── src/main/java/com/example/login_and_course/
│   ├── controller/
│   │   ├── CaptchaController.java
│   │   ├── CourseController.java
│   │   └── LoginController.java
│   ├── dao/
│   │   ├── CourseDAO.java
│   │   └── LoginDAO.java
│   ├── pojo/
│   │   ├── Course.java
│   │   ├── DynContent.java
│   │   ├── ElectiveSub.java
│   │   ├── Login.java
│   │   ├── LoginStatus.java
│   │   └── User.java
│   ├── service/
│   │   ├── CourseService.java
│   │   └── LoginService.java
│   └── util/
│       └── DBUtil.java
└── src/main/webapp/
    ├── addElectiveSubject.jsp
    ├── courseMng.jsp
    ├── failure.jsp
    ├── login.jsp
    └── WEB-INF/
        └── web.xml
```

## 功能说明

### 1. 登录

页面入口为 `login.jsp`，表单提交到 `/LoginController`。

登录时会校验：

- 学号
- 密码
- 学院
- 系别
- 验证码

`LoginController` 会先完成表单完整性和验证码校验，再调用 `LoginService` 和 `LoginDAO` 到数据库中验证用户信息。验证通过后，将当前用户保存到 Session，并转发到 `courseMng.jsp`。

### 2. 课程管理

`courseMng.jsp` 会展示当前登录学生的：

- 学号
- 姓名
- 学院
- 已选课程
- 课程成绩

课程数据由 `CourseService` 和 `CourseDAO` 查询 `electiveSub` 与 `course` 表后返回。

### 3. 新增选课

点击课程管理页中的“新增选修课程”后进入 `addElectiveSubject.jsp`，页面会展示数据库中的全部课程，并以复选框形式支持多选。

表单提交到 `/CourseController`，后端会：

- 读取当前登录用户
- 解析所选课程编号
- 校验是否为空
- 校验是否有重复课程
- 校验是否已经选过对应课程
- 批量写入 `electiveSub`

若操作失败，会转发到 `failure.jsp` 显示错误信息。

## 数据库说明

项目附带初始化脚本：

- [sql/114_JDBC.sql](/D:/JavaEE/114-ThirdHomeWork/sql/114_JDBC.sql)

脚本包含：

- 创建数据库 `114_JDBC`
- 创建 `user`、`course`、`electiveSub` 三张表
- 初始化测试用户
- 初始化课程数据
- 初始化学生选课与成绩数据

## 数据库连接配置

数据库连接写在 [DBUtil.java](/D:/JavaEE/114-ThirdHomeWork/src/main/java/com/example/login_and_course/util/DBUtil.java) 中，当前默认配置为：

```java
jdbc:mysql://localhost:3306/114_JDBC?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
username、password： 修改为你的本地 MySQL 用户名、密码或端口不同再运行。
```

## 运行步骤

### 1. 初始化数据库

在 MySQL 中执行：

```sql
source sql/114_JDBC.sql;
```

或直接导入该 SQL 文件。

### 2. 构建项目

在项目根目录执行：

```powershell
.\mvnw.cmd package -DskipTests
```

构建完成后会生成：

```text
target/ThirdWork_114.war
```

### 3. 部署到 Tomcat

将 `target/ThirdWork_114.war` 部署到 Tomcat。

默认访问地址：

```text
http://localhost:8080/ThirdWork_114/
```

欢迎页为：

```text
login.jsp
```

## 主要请求入口

- 登录控制器：`/LoginController`
- 验证码控制器：`/CaptchaController`
- 选课控制器：`/CourseController`

## Maven 依赖

当前 `pom.xml` 中已包含：

- `jakarta.servlet-api:6.1.0`
- `mysql-connector-j:8.4.0`

## 注意事项

- 项目使用 UTF-8 编码，数据库也应使用 UTF-8 相关字符集。
- 课程管理页中的“退选”按钮目前仅作界面展示，未实现后端逻辑。
- 当前数据库账号密码直接写在代码中，仅适合作业演示环境，不适合生产使用。
- 登录时除了校验学号和密码，还会校验所选学院和系别是否与数据库中的学生信息一致。

## 构建结果

项目已按 Maven Web 工程方式配置，最终制品名称为：

```text
ThirdWork_114.war
```
