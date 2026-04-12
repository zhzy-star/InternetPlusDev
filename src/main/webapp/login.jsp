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
    String uIdValue = escapeHtml(request.getParameter("uId"));
    String selectedCollege = escapeHtml(request.getParameter("college"));
    String selectedDepartment = escapeHtml(request.getParameter("department"));
    String serverErrorMessage = escapeHtml((String) request.getAttribute("errorMessage"));
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>登录页面</title>
    <style>
        :root {
            --bg: #eef4ff;
            --card: #ffffff;
            --primary: #125b9a;
            --primary-dark: #0d4575;
            --text: #18324a;
            --muted: #5f7488;
            --border: #cfe0f2;
            --error: #ba1b1b;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: "Microsoft YaHei", sans-serif;
            background:
                radial-gradient(circle at top left, rgba(18, 91, 154, 0.18), transparent 35%),
                linear-gradient(135deg, #eef4ff 0%, #d9ebff 45%, #f8fbff 100%);
            color: var(--text);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }

        .login-card {
            width: min(100%, 480px);
            background: var(--card);
            border-radius: 18px;
            padding: 32px 28px;
            box-shadow: 0 18px 40px rgba(18, 91, 154, 0.18);
            border: 1px solid rgba(255, 255, 255, 0.7);
        }

        .login-title {
            margin: 0 0 8px;
            font-size: 30px;
            letter-spacing: 1px;
        }

        .login-subtitle {
            margin: 0 0 24px;
            color: var(--muted);
            line-height: 1.6;
        }

        .field {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
        }

        input,
        select {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border);
            border-radius: 12px;
            font-size: 15px;
            background: #f9fcff;
            color: var(--text);
        }

        input:focus,
        select:focus {
            outline: 2px solid rgba(18, 91, 154, 0.18);
            border-color: var(--primary);
        }

        .tips {
            margin: -4px 0 12px;
            font-size: 13px;
            color: var(--muted);
        }

        .error-message {
            min-height: 22px;
            color: var(--error);
            font-size: 13px;
            margin-bottom: 8px;
        }

        .captcha-row {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 120px;
            gap: 12px;
            align-items: center;
        }

        .captcha-image {
            width: 120px;
            height: 42px;
            border-radius: 12px;
            border: 1px solid var(--border);
            background: #f4f9ff;
            cursor: pointer;
        }

        .captcha-refresh {
            margin-top: 10px;
            padding: 0;
            border: none;
            background: none;
            color: var(--primary);
            font-size: 13px;
            cursor: pointer;
            text-align: left;
        }

        .submit-btn {
            width: 100%;
            padding: 13px 16px;
            border: none;
            border-radius: 999px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: #fff;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
        }

        @media (max-width: 520px) {
            .login-card {
                padding: 24px 18px;
            }

            .login-title {
                font-size: 24px;
            }

            .captcha-row {
                grid-template-columns: 1fr;
            }

            .captcha-image {
                width: 100%;
                object-fit: cover;
            }
        }
    </style>
</head>
<body>
<section class="login-card">
    <h1 class="login-title">ThirdWork_114</h1>
    <p class="login-subtitle">请输入学号、密码、学院、系并填写验证码。密码仍要求同时包含字母和数字。</p>

    <form id="loginForm"
          action="<%= request.getContextPath() %>/LoginController"
          method="get"
          data-selected-college="<%= selectedCollege %>"
          data-selected-department="<%= selectedDepartment %>">
        <div class="field">
            <label for="uId">学号</label>
            <input id="uId" name="uId" type="text" placeholder="请输入学号" value="<%= uIdValue %>" required>
        </div>

        <div class="field">
            <label for="password">密码</label>
            <input id="password" name="password" type="password" placeholder="请输入密码" required>
            <p class="tips">示例格式：abc123</p>
        </div>

        <div class="field">
            <label for="college">学院</label>
            <select id="college" name="college" required></select>
        </div>

        <div class="field">
            <label for="department">系</label>
            <select id="department" name="department" required></select>
        </div>

        <div class="field">
            <label for="captcha">验证码</label>
            <div class="captcha-row">
                <input id="captcha" name="captcha" type="text" placeholder="请输入验证码" maxlength="4" autocomplete="off" required>
                <img id="captchaImage"
                     class="captcha-image"
                     src="<%= request.getContextPath() %>/CaptchaController"
                     alt="验证码图片">
            </div>
            <button id="refreshCaptcha" class="captcha-refresh" type="button">看不清？点击刷新验证码</button>
        </div>

        <% if (!serverErrorMessage.isEmpty()) { %>
        <div class="error-message"><%= serverErrorMessage %></div>
        <% } %>
        <div class="error-message" id="clientErrorMessage"></div>
        <button class="submit-btn" type="submit">登录</button>
    </form>
</section>

<script>
    const collegeDepartmentMap = {
        "计算机学院": [
            "软件工程",
            "计算机科学与技术",
            "智能科学与技术"
        ],
        "经济管理学院": [
            "工商管理",
            "会计学",
            "市场营销"
        ],
        "外国语学院": [
            "英语",
            "商务英语",
            "日语"
        ]
    };

    const collegeSelect = document.getElementById("college");
    const departmentSelect = document.getElementById("department");
    const passwordInput = document.getElementById("password");
    const loginForm = document.getElementById("loginForm");
    const captchaImage = document.getElementById("captchaImage");
    const refreshCaptchaButton = document.getElementById("refreshCaptcha");
    const clientErrorMessage = document.getElementById("clientErrorMessage");
    const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d).+$/;
    const selectedCollege = loginForm.dataset.selectedCollege;
    const selectedDepartment = loginForm.dataset.selectedDepartment;

    function renderDepartments(selectedCollegeValue, selectedDepartmentValue) {
        const departments = collegeDepartmentMap[selectedCollegeValue] || [];
        departmentSelect.innerHTML = "";

        departments.forEach(function (department) {
            const option = document.createElement("option");
            option.value = department;
            option.textContent = department;
            departmentSelect.appendChild(option);
        });

        if (selectedDepartmentValue && departments.indexOf(selectedDepartmentValue) !== -1) {
            departmentSelect.value = selectedDepartmentValue;
        }
    }

    function renderColleges() {
        Object.keys(collegeDepartmentMap).forEach(function (college) {
            const option = document.createElement("option");
            option.value = college;
            option.textContent = college;
            collegeSelect.appendChild(option);
        });

        if (selectedCollege && collegeDepartmentMap[selectedCollege]) {
            collegeSelect.value = selectedCollege;
        }

        renderDepartments(collegeSelect.value, selectedDepartment);
    }

    function validatePassword() {
        const password = passwordInput.value.trim();
        const valid = passwordPattern.test(password);
        const message = valid ? "" : "密码必须同时包含字母和数字。";

        passwordInput.setCustomValidity(message);
        clientErrorMessage.textContent = message;
        return valid;
    }

    function refreshCaptcha() {
        captchaImage.src = "<%= request.getContextPath() %>/CaptchaController?t=" + Date.now();
    }

    renderColleges();

    collegeSelect.addEventListener("change", function () {
        renderDepartments(collegeSelect.value, "");
    });

    passwordInput.addEventListener("input", validatePassword);
    refreshCaptchaButton.addEventListener("click", refreshCaptcha);
    captchaImage.addEventListener("click", refreshCaptcha);

    loginForm.addEventListener("submit", function (event) {
        if (!validatePassword()) {
            event.preventDefault();
            passwordInput.focus();
        }
    });
</script>
</body>
</html>
