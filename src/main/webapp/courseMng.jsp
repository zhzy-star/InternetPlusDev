<%@ page import="com.example.login_and_course.pojo.DynContent" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    DynContent dynContent = (DynContent) request.getAttribute("dynContent");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>课程管理</title>
</head>
<body>
<h2>课程管理页面</h2>
    <%
        if (dynContent == null) {
    %>
    <p>没有登录信息，请先返回登录页面。</p>
    <a href="<%= request.getContextPath() %>/login.jsp">返回登录</a>
    <%
        } else {
    %>
    <p>用户名：<%= dynContent.getUserName() %></p>
    <p>所在学院：<%= dynContent.getCollege() %></p>

    <table border="1" cellspacing="0" cellpadding="8">
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
            <td><%= entry.getKey() %></td>
            <td><%= entry.getValue() %></td>
        </tr>
        <%
            }
        %>
    </table>

    <p>
        <input type="button" value="退选">
        <input type="button" value="课程管理">
        <a href="<%= request.getContextPath() %>/login.jsp">返回登录</a>
    </p>
    <%
        }
    %>
</body>
</html>
