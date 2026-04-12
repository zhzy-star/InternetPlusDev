# AGENTS.md - 第三次作业实现指南

## 角色
你是一名 Java Web 开发者，需要基于第二次作业的 MVC 结构，扩展为使用 MySQL 数据库的真实数据持久化应用，并完整实现学生选课管理功能（查看已选课程、新增选修课程）。

## 项目规范
- **技术栈**：JSP（View）、Servlet（Controller）、MySQL（数据库）、JDBC、Java 实体类（POJO）、业务逻辑服务类（Service）、数据访问类（DAO）
- **开发环境**：IntelliJ IDEA + Tomcat + MySQL
- **项目命名**：`序号-ThirdWork`（例如 `114-ThirdWork`），web 应用名称 `ThirdWork_序号`（例如 `ThirdWork_114`），序号为 3 位（不足前导补 0）

## 数据库设计与初始化要求

- 采用 MySQL 作为数据库服务器。
- 创建数据库，名称为：`序号_JDBC`（序号为 3 位，如 `114_JDBC`）。

- 创建以下 3 张表，字段数据类型自行合理设定：

  - **user**：存放学生信息  
    `user(uId, uName, uPw, uSchool, uDepartment)`  
    依次为：学生 id、学生姓名、密码、所在学院、所在系。

  - **course**：存放课程信息  
    `course(cId, cName, cType)`  
    依次为：课程 id、课程名、课程类型（选修或必修）。

  - **electiveSub**：存放学生选修课程信息  
    `electiveSub(uId, cId, grade)`  
    依次为：用户 id（学生学号）、课程 id、分数。

- 表创建完成后，**预先插入测试数据**：
  - `user` 表：不少于 3 个用户。
  - `course` 表：不少于 10 门课程，课程名称使用中文。
  - `electiveSub` 表：每个用户选修 1~5 门课程不等，分数可自行设定。


## 核心功能实现步骤

### 1. 项目结构调整（基于第二次作业）
- 复制第二次作业项目，重命名为 `序号-ThirdWork`。
- 修改 `web.xml` 中 `<display-name>` 等元信息（如有）。
- 确保所有 JSP 和 Servlet 的路径及名称与第三次作业要求一致。

### 2. 数据库连接工具类（可选但推荐）
创建 `DBUtil.java` 提供静态方法获取 `Connection`（使用 JDBC，加载驱动、连接 URL、用户名、密码）。

### 3. 改写登录功能（接入 MySQL）

#### 3.1 创建 `LoginDAO`
- 类名：`LoginDAO`
- 方法：`public User findUserByCredentials(String uId, String password)`
  根据学号（`uId`）和密码查询 `user` 表，若存在则返回包含完整学生信息的 `User` POJO，否则返回 `null`。

#### 3.2 创建 `User` 实体类（POJO）
属性：`uId, uName, uPw, uSchool, uDepartment`，提供构造方法、getter/setter。

#### 3.3 修改 `LoginService`
- 原 `validateLogin(Login login)` 不再使用硬编码规则，改为调用 `LoginDAO` 验证用户。
- 若验证成功，根据 `uId` 查询该学生已选课程及成绩（调用 `CourseDAO`），构造 `DynContent` 对象（包含用户名、学院、课程列表）。
- 若验证失败，返回 `null` 或特定状态。

#### 3.4 修改 `LoginController`
- 保持 `doGet` 方法，调用 `LoginService` 后，将 `DynContent` 存入 request 属性，并将 `User` 对象存入 session（便于后续选课操作）。
- 转发到 `courseMng.jsp`。

### 4. 课程管理功能（展示 + 新增）

#### 4.1 实体类
- **`Course`**：属性 `cId, cName, cType`，getter/setter。
- **`ElectiveSub`**：属性 `uId, cId, grade`，以及关联的 `Course` 对象（可选）。

#### 4.2 数据访问类 `CourseDAO`
方法示例：
- `List<Course> findAllCourses()`：查询所有课程（用于新增选课时展示）。
- `List<ElectiveSub> findSelectedCoursesByStudent(String uId)`：查询学生已选课程及成绩（关联 `course` 表获取课程名）。
- `boolean addElectiveSubjects(String uId, List<Integer> cIds)`：为学生批量添加选课记录，需避免重复选课（若某课程已选，则整个操作失败并抛出异常）。

#### 4.3 业务逻辑类 `CourseService`
- `List<Course> getAllCourses()`：调用 `CourseDAO.findAllCourses()`。
- `List<ElectiveSub> getStudentCourseList(String uId)`：返回已选课程列表（含成绩）。
- `boolean addCoursesForStudent(String uId, List<Integer> cIds)`：调用 DAO 添加，处理异常，返回成功/失败。

#### 4.4 修改 `courseMng.jsp`
- 从 session 中获取 `User` 对象，展示学号（或姓名）、学院。
- 调用 `CourseService.getStudentCourseList(uId)` 获取已选课程列表，以表格形式展示：序号（行号）、课程名称、分数。
- 表格每行前带复选框（用于“退选”功能，本次作业仅作展示，按钮可不实现逻辑）。
- 增加按钮 **“新增选修课程”**，点击后跳转到 `addElectiveSubject.jsp`。

#### 4.5 创建 `addElectiveSubject.jsp`
- 功能：展示所有可供选修的课程（即 `course` 表中全部课程，或未选课程，推荐展示全部课程，后端再做重复校验）。
- UI 设计：表格形式，每行课程前带 checkbox（支持多选），底部有提交按钮。
- 表单提交到 `CourseController`（使用 POST 方法）。
- 若添加成功，重定向到 `courseMng.jsp`；若失败，转发到 `failure.jsp` 并给出失败原因（如“课程已选”、“数据库错误”等），并提供超链接返回 `courseMng.jsp`。

#### 4.6 创建 `failure.jsp`
- 简单页面，显示错误信息（通过 request 属性获取）。
- 包含超链接 `<a href="courseMng.jsp">返回课程管理</a>`。

### 5. 控制器 `CourseController`
- 继承 `HttpServlet`，重写 `doPost` 方法（处理新增选课请求）。
- 功能：
  - 从 session 中获取当前登录学生的 `uId`。
  - 获取请求参数中选中的课程 ID 数组（`cIds`）。
  - 调用 `CourseService.addCoursesForStudent(uId, cIdList)`。
  - 若成功，重定向到 `courseMng.jsp`（由该 JSP 重新查询并展示更新后的课程列表）。
  - 若失败，将错误信息存入 request 属性，转发到 `failure.jsp`。

### 6. 其他调整
- 所有涉及数据库操作的类都需要处理 `SQLException`，并在 `failure.jsp` 中展示用户友好的错误信息。
- 注意中文乱码：JSP 页面、Servlet 请求响应、数据库连接 URL 均设置 UTF-8。
- 确保项目使用 JDBC 驱动（MySQL Connector/J），将 jar 包置于 `WEB-INF/lib` 或通过 Maven 依赖添加。

## 注意事项

- 第二次作业已有的功能（验证码、前端密码校验、学院/系联动）不需要重复创建，但需要确保在第三次作业中仍然正常工作。
- 所有新创建的类、JSP 页面都要遵循 MVC 分层，DAO 只负责数据库读写，Service 负责业务逻辑。
- 新增选修课程时，课程来源只从 `course` 表中读取，不要硬编码。
- 如果使用 Maven，记得添加 MySQL 驱动依赖

## 文件结构建议
```text
序号-ThirdWork/
├── pom.xml
├── src/main/
│   ├── java/com/序号/
│   │   ├── controller/
│   │   │   ├── LoginController.java
│   │   │   ├── CourseController.java
│   │   │   └── CaptchaController.java
│   │   ├── service/
│   │   │   ├── LoginService.java
│   │   │   └── CourseService.java
│   │   ├── dao/
│   │   │   ├── LoginDAO.java
│   │   │   └── CourseDAO.java
│   │   ├── pojo/
│   │   │   ├── User.java
│   │   │   ├── Course.java
│   │   │   ├── ElectiveSub.java
│   │   │   ├── Login.java        （第二次作业遗留）
│   │   │   ├── LoginStatus.java  （可整合到 DynContent）
│   │   │   └── DynContent.java
│   │   └── util/
│   │       └── DBUtil.java
│   └── webapp/
│       ├── login.jsp
│       ├── courseMng.jsp
│       ├── addElectiveSubject.jsp
│       ├── failure.jsp
│       ├── WEB-INF/
│       │   ├── web.xml
│       │   └── lib/
│       └── ...
└── ...

