<%@ page import="com.example.login_and_course.pojo.Course" %>
<%@ page import="com.example.login_and_course.pojo.User" %>
<%@ page import="com.example.login_and_course.service.CourseService" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<Course> allCourses = new ArrayList<>();
    String pageErrorMessage = null;

    if (currentUser != null) {
        try {
            CourseService courseService = new CourseService();
            allCourses = courseService.getAllCourses();
        } catch (Exception e) {
            pageErrorMessage = "课程列表加载失败：" + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>新增选修课程</title>
    <style>
        :root {
            --bg: #f7f9fc;
            --surface: #ffffff;
            --primary: #145374;
            --primary-light: #e7f3f8;
            --text: #1f2d3d;
            --muted: #5f7081;
            --border: #d8e2ea;
            --error: #b42318;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            background:
                radial-gradient(circle at right top, rgba(20, 83, 116, 0.12), transparent 35%),
                var(--bg);
            color: var(--text);
            font-family: "Microsoft YaHei", sans-serif;
            padding: 28px 18px;
        }

        .page {
            width: min(100%, 920px);
            margin: 0 auto;
            background: var(--surface);
            border-radius: 20px;
            padding: 28px;
            box-shadow: 0 18px 42px rgba(31, 45, 61, 0.08);
        }

        .page-title {
            margin: 0 0 12px;
            font-size: 28px;
        }

        .meta {
            margin-bottom: 20px;
            color: var(--muted);
        }

        .error-box {
            padding: 16px;
            border-radius: 12px;
            background: #fff1f1;
            color: var(--error);
            margin-bottom: 16px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            border: 1px solid var(--border);
            border-radius: 14px;
            overflow: hidden;
            margin-bottom: 20px;
        }

        thead {
            background: var(--primary-light);
        }

        th,
        td {
            padding: 14px 12px;
            border-bottom: 1px solid var(--border);
            text-align: left;
        }

        tbody tr:nth-child(even) {
            background: #fbfdff;
        }

        .button-group {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn,
        .link-btn {
            display: inline-block;
            border: none;
            border-radius: 999px;
            padding: 11px 18px;
            background: var(--primary);
            color: #fff;
            text-decoration: none;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-secondary {
            background: #6b7b8c;
        }
    </style>
</head>
<body>
<main class="page">
    <h1 class="page-title">新增选修课程</h1>

    <%
        if (currentUser == null) {
    %>
    <div class="error-box">当前未登录，请先返回登录页面。</div>
    <a class="link-btn" href="<%= request.getContextPath() %>/login.jsp">返回登录</a>
    <%
        } else {
    %>
    <div class="meta">
        当前学生：<strong><%= currentUser.getUId() %> <%= currentUser.getUName() %></strong>
    </div>

    <% if (pageErrorMessage != null) { %>
    <div class="error-box"><%= pageErrorMessage %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/CourseController" method="post">
        <table>
            <thead>
            <tr>
                <th>选择</th>
                <th>课程编号</th>
                <th>课程名称</th>
                <th>课程类型</th>
            </tr>
            </thead>
            <tbody>
            <%
                if (allCourses == null || allCourses.isEmpty()) {
            %>
            <tr>
                <td colspan="4">暂无课程数据。</td>
            </tr>
            <%
                } else {
                    for (Course course : allCourses) {
            %>
            <tr>
                <td><input type="checkbox" name="cIds" value="<%= course.getCId() %>"></td>
                <td><%= course.getCId() %></td>
                <td><%= course.getCName() %></td>
                <td><%= course.getCType() %></td>
            </tr>
            <%
                    }
                }
            %>
            </tbody>
        </table>

        <div class="button-group">
            <button class="btn" type="submit">提交新增选课</button>
            <a class="link-btn btn-secondary" href="<%= request.getContextPath() %>/courseMng.jsp">返回课程管理</a>
        </div>
    </form>
    <%
        }
    %>
</main>
</body>
</html>
