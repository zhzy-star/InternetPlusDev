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
    <title>&#35838;&#31243;&#31649;&#29702;</title>
    <style>
        :root {
            --bg: #f5f8fc;
            --surface: #ffffff;
            --primary: #0c5c78;
            --text: #173042;
            --muted: #6a7f8f;
            --border: #d5e3ec;
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
            width: min(100%, 920px);
            margin: 0 auto;
            background: var(--surface);
            border-radius: 20px;
            box-shadow: 0 18px 42px rgba(23, 48, 66, 0.08);
            padding: 28px;
        }

        .page-title {
            margin: 0 0 20px;
            font-size: 28px;
        }

        .meta {
            display: flex;
            gap: 18px;
            flex-wrap: wrap;
            margin-bottom: 20px;
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

        .actions {
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
        }

        .actions button,
        .back-link {
            border: none;
            border-radius: 999px;
            padding: 11px 18px;
            background: var(--primary);
            color: #fff;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
        }

        .empty-state {
            padding: 24px 0;
            color: var(--muted);
        }
    </style>
</head>
<body>
<main class="page">
    <h1 class="page-title">&#35838;&#31243;&#31649;&#29702;&#39029;&#38754;</h1>
    <%
        if (dynContent == null) {
    %>
    <div class="empty-state">
        &#26410;&#26816;&#27979;&#21040;&#30331;&#24405;&#20449;&#24687;&#65292;&#35831;&#20808;&#36820;&#22238;&#30331;&#24405;&#39029;&#38754;&#12290;
    </div>
    <a class="back-link" href="<%= request.getContextPath() %>/login.jsp">&#36820;&#22238;&#30331;&#24405;</a>
    <%
        } else {
    %>
    <div class="meta">
        <span>&#29992;&#25143;&#21517;&#65306;<strong><%= dynContent.getUserName() %></strong></span>
        <span>&#25152;&#22312;&#23398;&#38498;&#65306;<strong><%= dynContent.getCollege() %></strong></span>
    </div>

    <table>
        <thead>
        <tr>
            <th>&#36873;&#25321;</th>
            <th>&#24207;&#21495;</th>
            <th>&#35838;&#31243;&#21517;&#31216;</th>
            <th>&#20998;&#25968;</th>
        </tr>
        </thead>
        <tbody>
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
        </tbody>
    </table>

    <div class="actions">
        <button type="button">&#36864;&#36873;</button>
        <button type="button">&#35838;&#31243;&#31649;&#29702;</button>
        <a class="back-link" href="<%= request.getContextPath() %>/login.jsp">&#36820;&#22238;&#30331;&#24405;</a>
    </div>
    <%
        }
    %>
</main>
</body>
</html>
