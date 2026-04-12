<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage == null || errorMessage.trim().isEmpty()) {
        errorMessage = "操作失败，请稍后重试。";
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>操作失败</title>
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #fff7f7 0%, #ffe7e7 100%);
            font-family: "Microsoft YaHei", sans-serif;
            color: #5b1f1f;
            padding: 20px;
        }

        .card {
            width: min(100%, 520px);
            background: #ffffff;
            border-radius: 18px;
            padding: 28px;
            box-shadow: 0 18px 38px rgba(91, 31, 31, 0.12);
        }

        .title {
            margin: 0 0 12px;
            font-size: 28px;
        }

        .message {
            margin-bottom: 20px;
            line-height: 1.7;
        }

        .back-link {
            display: inline-block;
            padding: 11px 18px;
            border-radius: 999px;
            text-decoration: none;
            background: #b42318;
            color: #ffffff;
        }
    </style>
</head>
<body>
<section class="card">
    <h1 class="title">操作失败</h1>
    <div class="message"><%= errorMessage %></div>
    <a class="back-link" href="<%= request.getContextPath() %>/courseMng.jsp">返回课程管理</a>
</section>
</body>
</html>
