<%@ page import="com.example.login_and_course.pojo.DynContent" %>
<%@ page import="com.example.login_and_course.pojo.ElectiveSub" %>
<%@ page import="com.example.login_and_course.pojo.User" %>
<%@ page import="com.example.login_and_course.service.CourseService" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    DynContent dynContent = (DynContent) request.getAttribute("dynContent");
    List<ElectiveSub> selectedCourses = new ArrayList<>();
    String pageErrorMessage = null;

    if (dynContent != null && dynContent.getSelectedCourses() != null) {
        selectedCourses = dynContent.getSelectedCourses();
        if (currentUser == null) {
            currentUser = dynContent.getUser();
            session.setAttribute("currentUser", currentUser);
        }
    } else if (currentUser != null) {
        try {
            CourseService courseService = new CourseService();
            selectedCourses = courseService.getStudentCourseList(currentUser.getUId());
        } catch (Exception e) {
            pageErrorMessage = "课程数据加载失败：" + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>课程管理</title>
    <style>
        :root {
            --bg: #f5f8fc;
            --surface: #ffffff;
            --primary: #0c5c78;
            --accent: #dff2f7;
            --text: #173042;
            --muted: #6a7f8f;
            --border: #d5e3ec;
            --error: #b42318;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: "Microsoft YaHei", sans-serif;
            color: var(--text);
            background:
                linear-gradient(180deg, rgba(12, 92, 120, 0.08), rgba(12, 92, 120, 0)),
                var(--bg);
            padding: 32px 18px;
        }

        .page {
            width: min(100%, 960px);
            margin: 0 auto;
            background: var(--surface);
            border-radius: 20px;
            box-shadow: 0 18px 42px rgba(23, 48, 66, 0.08);
            padding: 28px;
        }

        .page-title {
            margin: 0 0 12px;
            font-size: 28px;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 20px;
        }

        .meta {
            display: flex;
            gap: 18px;
            flex-wrap: wrap;
            color: var(--muted);
        }

        .meta strong {
            color: var(--text);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 14px;
            border: 1px solid var(--border);
            margin-bottom: 24px;
        }

        thead {
            background: #e9f4fa;
        }

        th,
        td {
            padding: 14px 12px;
            border-bottom: 1px solid var(--border);
            text-align: left;
        }

        tbody tr:nth-child(even) {
            background: #fafcfe;
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
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-secondary {
            background: #6a7f8f;
        }

        .empty-state,
        .error-box {
            padding: 18px;
            border-radius: 14px;
            margin-bottom: 16px;
        }

        .empty-state {
            background: #f8fbfd;
            color: var(--muted);
        }

        .error-box {
            background: #fff1f1;
            color: var(--error);
        }
    </style>
</head>
<body>
<main class="page">
    <h1 class="page-title">课程管理页面</h1>

    <%
        if (currentUser == null) {
    %>
    <div class="empty-state">未检测到登录状态，请先返回登录页面。</div>
    <a class="link-btn" href="<%= request.getContextPath() %>/login.jsp">返回登录</a>
    <%
        } else {
    %>
    <div class="top-bar">
        <div class="meta">
            <span>学号：<strong><%= currentUser.getUId() %></strong></span>
            <span>姓名：<strong><%= currentUser.getUName() %></strong></span>
            <span>学院：<strong><%= currentUser.getUSchool() %></strong></span>
        </div>
        <a class="link-btn" href="<%= request.getContextPath() %>/addElectiveSubject.jsp">新增选修课程</a>
    </div>

    <% if (pageErrorMessage != null) { %>
    <div class="error-box"><%= pageErrorMessage %></div>
    <% } %>

    <table>
        <thead>
        <tr>
            <th>选择</th>
            <th>序号</th>
            <th>课程名称</th>
            <th>课程类型</th>
            <th>分数</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (selectedCourses == null || selectedCourses.isEmpty()) {
        %>
        <tr>
            <td colspan="5">当前暂无已选课程。</td>
        </tr>
        <%
            } else {
                for (int i = 0; i < selectedCourses.size(); i++) {
                    ElectiveSub electiveSub = selectedCourses.get(i);
        %>
        <tr>
            <td><input type="checkbox" name="courseSelect"></td>
            <td><%= i + 1 %></td>
            <td><%= electiveSub.getCourse().getCName() %></td>
            <td><%= electiveSub.getCourse().getCType() %></td>
            <td><%= electiveSub.getGrade() == null ? "暂无" : electiveSub.getGrade() %></td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>

    <div class="button-group">
        <button class="btn btn-secondary" type="button">退选</button>
        <a class="link-btn" href="<%= request.getContextPath() %>/login.jsp">退出并返回登录</a>
    </div>
    <%
        }
    %>
</main>
</body>
</html>
