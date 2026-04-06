<%@ page import="com.example.login_and_course.pojo.DynContent" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>
<%
    DynContent dynContent = (DynContent) request.getAttribute("dynContent");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>课程管理</title>
    <style>
        body {
            margin: 24px;
            font-family: "Microsoft YaHei", sans-serif;
            color: #222;
        }

        .page {
            max-width: 760px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 16px 0;
        }

        th,
        td {
            border: 1px solid #bbb;
            padding: 8px 10px;
            text-align: left;
        }

        .actions {
            margin-top: 16px;
        }

        .actions button,
        .actions a {
            margin-right: 8px;
        }
    </style>
</head>
<body>
<div class="page">
    <h2>课程管理页面</h2>
    <%
        if (dynContent == null) {
    %>
    <p>未检测到登录信息，请先返回登录页面。</p>
    <a href="<%= request.getContextPath() %>/login.jsp">返回登录</a>
    <%
        } else {
    %>
    <p>用户名：<strong><%= escapeHtml(dynContent.getUserName()) %></strong></p>
    <p>所在学院：<strong><%= escapeHtml(dynContent.getCollege()) %></strong></p>

    <%
        if (dynContent.getCourseScores() == null || dynContent.getCourseScores().isEmpty()) {
    %>
    <p>当前暂无课程信息。</p>
    <%
        } else {
    %>
    <table>
        <tr>
            <th>选择</th>
            <th>序号</th>
            <th>课程名称</th>
            <th>分数</th>
        </tr>
        <%
            int index = 1;
            for (Map.Entry<String, Integer> entry : dynContent.getCourseScores().entrySet()) {
        %>
        <tr>
            <td><input type="checkbox" name="courseSelect"></td>
            <td><%= index++ %></td>
            <td><%= escapeHtml(entry.getKey()) %></td>
            <td><%= entry.getValue() %></td>
        </tr>
        <%
            }
        %>
    </table>
    <%
        }
    %>

    <div class="actions">
        <button type="button">退选</button>
        <button type="button">课程管理</button>
        <a href="<%= request.getContextPath() %>/login.jsp">返回登录</a>
    </div>
    <%
        }
    %>
</div>
</body>
</html>
