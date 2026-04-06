<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>&#30331;&#24405;&#39029;&#38754;</title>
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

        .submit-btn:hover {
            filter: brightness(1.03);
        }

        @media (max-width: 520px) {
            .login-card {
                padding: 24px 18px;
            }

            .login-title {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
<section class="login-card">
    <h1 class="login-title">SecondPractice_114</h1>
    <p class="login-subtitle">&#35831;&#22635;&#20889;&#29992;&#25143;&#21517;&#12289;&#23494;&#30721;&#65292;&#24182;&#36873;&#25321;&#25152;&#22312;&#23398;&#38498;&#21644;&#31995;&#12290;&#23494;&#30721;&#24517;&#39035;&#21516;&#26102;&#21253;&#21547;&#23383;&#27597;&#21644;&#25968;&#23383;&#12290;</p>

    <form id="loginForm" action="<%= request.getContextPath() %>/LoginController" method="get">
        <div class="field">
            <label for="userName">&#29992;&#25143;&#21517;</label>
            <input id="userName" name="userName" type="text" placeholder="&#35831;&#36755;&#20837;&#29992;&#25143;&#21517;" required>
        </div>

        <div class="field">
            <label for="password">&#23494;&#30721;</label>
            <input id="password" name="password" type="password" placeholder="&#35831;&#36755;&#20837;&#23494;&#30721;" required>
            <p class="tips">&#31034;&#20363;&#26684;&#24335;&#65306;abc123</p>
        </div>

        <div class="field">
            <label for="college">&#23398;&#38498;</label>
            <select id="college" name="college" required></select>
        </div>

        <div class="field">
            <label for="department">&#31995;</label>
            <select id="department" name="department" required></select>
        </div>

        <div class="error-message" id="errorMessage"></div>
        <button class="submit-btn" type="submit">&#30331;&#24405;</button>
    </form>
</section>

<script>
    const collegeDepartmentMap = {
        "\u8ba1\u7b97\u673a\u5b66\u9662": [
            "\u8f6f\u4ef6\u5de5\u7a0b",
            "\u8ba1\u7b97\u673a\u79d1\u5b66\u4e0e\u6280\u672f",
            "\u6570\u636e\u79d1\u5b66\u4e0e\u5927\u6570\u636e\u6280\u672f"
        ],
        "\u7ecf\u6d4e\u7ba1\u7406\u5b66\u9662": [
            "\u5de5\u5546\u7ba1\u7406",
            "\u4f1a\u8ba1\u5b66",
            "\u5e02\u573a\u8425\u9500"
        ],
        "\u5916\u56fd\u8bed\u5b66\u9662": [
            "\u82f1\u8bed",
            "\u5546\u52a1\u82f1\u8bed",
            "\u65e5\u8bed"
        ]
    };

    const collegeSelect = document.getElementById("college");
    const departmentSelect = document.getElementById("department");
    const passwordInput = document.getElementById("password");
    const errorMessage = document.getElementById("errorMessage");
    const loginForm = document.getElementById("loginForm");
    const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d).+$/;

    function renderDepartments(selectedCollege) {
        const departments = collegeDepartmentMap[selectedCollege] || [];
        departmentSelect.innerHTML = "";

        departments.forEach(function (department) {
            const option = document.createElement("option");
            option.value = department;
            option.textContent = department;
            departmentSelect.appendChild(option);
        });
    }

    function renderColleges() {
        Object.keys(collegeDepartmentMap).forEach(function (college) {
            const option = document.createElement("option");
            option.value = college;
            option.textContent = college;
            collegeSelect.appendChild(option);
        });

        renderDepartments(collegeSelect.value);
    }

    function validatePassword() {
        const password = passwordInput.value.trim();
        const valid = passwordPattern.test(password);
        const message = valid ? "" : "\u5bc6\u7801\u5fc5\u987b\u540c\u65f6\u5305\u542b\u5b57\u6bcd\u548c\u6570\u5b57\u3002";

        passwordInput.setCustomValidity(message);
        errorMessage.textContent = message;
        return valid;
    }

    renderColleges();

    collegeSelect.addEventListener("change", function () {
        renderDepartments(collegeSelect.value);
    });

    passwordInput.addEventListener("input", validatePassword);

    loginForm.addEventListener("submit", function (event) {
        if (!validatePassword()) {
            event.preventDefault();
            passwordInput.focus();
        }
    });
</script>
</body>
</html>
