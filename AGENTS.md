# AGENTS.md - 第二次作业实现指南

## 角色
你是一名 Java Web 开发者，需要严格按照 MVC 模式完成一个具备用户登录、学院/系联动、动态课程展示的 Web 应用。

## 项目规范
- **技术栈**：JSP（View）、Servlet（Controller）、普通 Java 类（Service、POJO）、JDBC（可选）、HTML/CSS/JS（前端校验与联动）

## 核心功能与实现步骤

### 1. 登录页面 `login.jsp`
- 包含表单：用户名、密码、学院下拉框、系下拉框、验证码（必选）
- **前端校验（JS）**：密码必须同时包含数字和字母
- **联动（JS）**：至少 3 个学院，每个学院至少 3 个系，切换学院时系下拉框自动更新
- 提交方式：`GET`，提交到 `LoginController`

### 2. 控制器 `LoginController`（Servlet）
- 仅支持 `doGet` 方法
- 获取请求参数，封装为 `Login` POJO
- 调用 `LoginService.validateLogin(Login)`，得到 `LoginStatus`
- 根据 `LoginStatus` 构造 `DynContent` POJO
- 转发到 `courseMng.jsp`

### 3. POJO 类定义
- **`Login`**：用户名(String)、密码(String)、学院(String)、系(String)
- **`LoginStatus`**：课程名称与分数（可用 `Map<String, Integer>` 或 `List<Course>`）
- **`DynContent`**：用户名、所在学院、课程信息（列表）

### 4. 业务逻辑 `LoginService`
- 方法：`public LoginStatus validateLogin(Login login)`
- 规则：
    - 若学院为“计算机学院”且系为“软件工程” → 返回 4 组预设课程分数（参考作业表格）
    - 否则 → 返回第 2 组预设课程分数（作业表格中第二组数据）

### 5. 课程管理页面 `courseMng.jsp`
- 渲染 `DynContent` 对象，展示用户名、所在学院
- 以表格形式展示课程列表（序号、课程名称、分数），每行前带复选框
- 包含“退选”和“课程管理”按钮（前端占位即可）

## 部署与验证
- 部署到 Tomcat，访问 `http://localhost:8080/SecondPractice_114/login.jsp`
- 测试学院/系联动、密码前端校验、不同学院登录后课程表变化

## 注意事项
- 控制器只支持 GET 请求，页面表单 method="get"
- 前端校验不能绕过，但后端可不做重复校验（按作业要求）
- 验证码为可选，不做强制要求
- 所有类命名、包结构清晰，代码可读

## 文件结构建议
```text
序号-SecondPractice/                     # 项目根目录（IntelliJ IDEA 项目）
│
├── src/                                 # 源代码目录
│   └── main/                            # 主代码（Maven 结构）
│       ├── java/                        # Java 源码
│       │   └── com/yourpackage/         # 根据实际包名调整
│       │       ├── controller/
│       │       │   └── LoginController.java
│       │       ├── service/
│       │       │   └── LoginService.java
│       │       └── pojo/
│       │           ├── Login.java
│       │           ├── LoginStatus.java
│       │           └── DynContent.java
│       └── webapp/                      # Web 根目录
│           ├── login.jsp
│           ├── courseMng.jsp
│           ├── WEB-INF/
│           │   ├── web.xml
│           │   └── lib/                 # 依赖 jar 包
│           └── ...（其他静态资源，如 CSS/JS/图片）
│
├── pom.xml                              # Maven 配置文件（若使用 Maven）
├── 序号-SecondPractice.iml              # IDEA 模块文件
└── .idea/                               # IDEA 项目配置目录（可选）


