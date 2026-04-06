<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String userNameValue = request.getParameter("userName") == null ? "" : request.getParameter("userName");
    String selectedCollege = request.getParameter("college") == null ? "" : request.getParameter("college");
    String selectedDepartment = request.getParameter("department") == null ? "" : request.getParameter("department");
    String msg = request.getAttribute("msg") == null ? "" : request.getAttribute("msg").toString();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>登录页面</title>
</head>
<body>
<h2>用户登录</h2>

<form id="loginForm"
      action="<%= request.getContextPath() %>/LoginController"
      method="get"
      data-selected-college="<%= selectedCollege %>"
      data-selected-department="<%= selectedDepartment %>">
    <table>
        <tr>
            <td>用户名：</td>
            <td><input type="text" id="userName" name="userName" value="<%= userNameValue %>"></td>
        </tr>
        <tr>
            <td>密码：</td>
            <td>
                <input type="password" id="password" name="password">
                <span>密码必须包含字母和数字</span>
            </td>
        </tr>
        <tr>
            <td>学院：</td>
            <td>
                <select id="college" name="college"></select>
            </td>
        </tr>
        <tr>
            <td>系：</td>
            <td>
                <select id="department" name="department"></select>
            </td>
        </tr>
        <tr>
            <td>验证码：</td>
            <td>
                <input type="text" id="captcha" name="captcha" maxlength="4">
                <img id="captchaImage" src="<%= request.getContextPath() %>/CaptchaController" alt="验证码">
                <input type="button" id="refreshCaptcha" value="刷新验证码">
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <span id="msg" style="color:red;"><%= msg %></span>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <input type="submit" value="登录">
            </td>
        </tr>
    </table>
</form>

<script>
    const collegeDepartmentMap = {
        "计算机学院": [
            "软件工程",
            "计算机科学与技术",
            "数据科学与大数据技术"
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
    const msg = document.getElementById("msg");
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
        if (!valid) {
            msg.innerHTML = "密码必须同时包含字母和数字。";
            return false;
        }
        msg.innerHTML = "";
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
