<%@ page import="com.example.login_and_course.service.LoginFormValidator" %>
<%@ page import="com.example.login_and_course.service.CaptchaService" %>
<%@ page import="java.util.List" %>
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

    private String escapeJs(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "")
                .replace("\n", "\\n");
    }

    private String readValue(HttpServletRequest request, String attributeName, String parameterName) {
        Object attributeValue = request.getAttribute(attributeName);
        if (attributeValue != null) {
            return String.valueOf(attributeValue);
        }
        String parameterValue = request.getParameter(parameterName);
        return parameterValue == null ? "" : parameterValue;
    }
%>
<%
    Map<String, List<String>> collegeDepartmentMap = LoginFormValidator.getCollegeDepartmentMap();
    int userNameMaxLength = LoginFormValidator.USER_NAME_MAX_LENGTH;
    int captchaLength = CaptchaService.CAPTCHA_LENGTH;
    String userNameValue = escapeHtml(readValue(request, "userNameValue", "userName"));
    String selectedCollege = escapeHtml(readValue(request, "selectedCollege", "college"));
    String selectedDepartment = escapeHtml(readValue(request, "selectedDepartment", "department"));
    String serverMessage = escapeHtml(request.getAttribute("msg") == null ? "" : request.getAttribute("msg").toString());
    boolean refreshCaptcha = Boolean.TRUE.equals(request.getAttribute("refreshCaptcha"));
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>登录页面</title>
    <style>
        body {
            margin: 24px;
            font-family: "Microsoft YaHei", sans-serif;
            color: #222;
        }

        .page {
            max-width: 580px;
        }

        .tip {
            margin-bottom: 16px;
            color: #666;
            line-height: 1.6;
        }

        .form-table {
            border-collapse: collapse;
        }

        .form-table td {
            padding: 8px 6px;
            vertical-align: top;
        }

        .form-table td:first-child {
            width: 90px;
        }

        input[type="text"],
        input[type="password"],
        select {
            width: 260px;
            padding: 6px 8px;
            border: 1px solid #bbb;
        }

        .field-tip {
            display: block;
            margin-top: 6px;
            color: #666;
            font-size: 13px;
        }

        .captcha-row {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .captcha-image {
            height: 42px;
            border: 1px solid #bbb;
        }

        .captcha-input {
            text-transform: uppercase;
        }

        .message {
            min-height: 22px;
            color: #c62828;
            padding-top: 4px;
        }

        .message[aria-live] {
            margin: 0;
        }
    </style>
</head>
<body>
<div class="page">
    <h2>用户登录</h2>
    <p class="tip">请输入用户名、密码、学院、系和验证码。密码必须同时包含字母和数字。</p>

    <form id="loginForm"
          action="<%= request.getContextPath() %>/LoginController"
          method="get"
          data-selected-college="<%= selectedCollege %>"
          data-selected-department="<%= selectedDepartment %>">
        <table class="form-table">
            <tr>
                <td>用户名：</td>
                <td>
                    <input type="text"
                           id="userName"
                           name="userName"
                           maxlength="<%= userNameMaxLength %>"
                           autocomplete="username"
                           value="<%= userNameValue %>"
                           required>
                </td>
            </tr>
            <tr>
                <td>密码：</td>
                <td>
                    <input type="password"
                           id="password"
                           name="password"
                           maxlength="20"
                           autocomplete="current-password"
                           pattern="(?=.*[A-Za-z])(?=.*\d).+"
                           title="密码必须同时包含字母和数字"
                           required>
                    <span class="field-tip">示例：abc123</span>
                </td>
            </tr>
            <tr>
                <td>学院：</td>
                <td>
                    <select id="college" name="college" required></select>
                </td>
            </tr>
            <tr>
                <td>系：</td>
                <td>
                    <select id="department" name="department" required></select>
                </td>
            </tr>
            <tr>
                <td>验证码：</td>
                <td>
                    <div class="captcha-row">
                        <input type="text"
                               id="captcha"
                               class="captcha-input"
                               name="captcha"
                               maxlength="<%= captchaLength %>"
                               pattern="[A-Za-z0-9]{<%= captchaLength %>}"
                               title="验证码必须为<%= captchaLength %>位字母或数字"
                               autocomplete="off"
                               required>
                        <img id="captchaImage"
                             class="captcha-image"
                             src="<%= request.getContextPath() %>/CaptchaController"
                             alt="验证码">
                        <button id="refreshCaptcha" type="button">刷新验证码</button>
                    </div>
                </td>
            </tr>
            <tr>
                <td>提示：</td>
                <td>
                    <div class="message" aria-live="polite"><%= serverMessage %></div>
                    <div id="clientMessage" class="message" aria-live="polite"></div>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <button type="submit">登录</button>
                </td>
            </tr>
        </table>
    </form>
</div>

<script>
    const collegeDepartmentMap = {
        <% int collegeIndex = 0; %>
        <% for (Map.Entry<String, List<String>> entry : collegeDepartmentMap.entrySet()) { %>
        "<%= escapeJs(entry.getKey()) %>": [
            <% for (int i = 0; i < entry.getValue().size(); i++) { %>
            "<%= escapeJs(entry.getValue().get(i)) %>"<%= i < entry.getValue().size() - 1 ? "," : "" %>
            <% } %>
        ]<%= collegeIndex++ < collegeDepartmentMap.size() - 1 ? "," : "" %>
        <% } %>
    };

    const loginForm = document.getElementById("loginForm");
    const collegeSelect = document.getElementById("college");
    const departmentSelect = document.getElementById("department");
    const passwordInput = document.getElementById("password");
    const captchaInput = document.getElementById("captcha");
    const captchaImage = document.getElementById("captchaImage");
    const refreshCaptchaButton = document.getElementById("refreshCaptcha");
    const clientMessage = document.getElementById("clientMessage");
    const selectedCollege = loginForm.dataset.selectedCollege;
    const selectedDepartment = loginForm.dataset.selectedDepartment;
    const shouldRefreshCaptcha = <%= refreshCaptcha ? "true" : "false" %>;

    function showClientMessage(message) {
        clientMessage.textContent = message || "";
    }

    function appendOption(select, value, text) {
        const option = document.createElement("option");
        option.value = value;
        option.textContent = text;
        select.appendChild(option);
    }

    function renderDepartments(collegeValue, selectedDepartmentValue) {
        const departments = collegeDepartmentMap[collegeValue] || [];
        departmentSelect.innerHTML = "";
        departmentSelect.disabled = departments.length === 0;
        appendOption(departmentSelect, "", "请选择系");

        for (let i = 0; i < departments.length; i++) {
            appendOption(departmentSelect, departments[i], departments[i]);
        }

        if (selectedDepartmentValue && departments.indexOf(selectedDepartmentValue) !== -1) {
            departmentSelect.value = selectedDepartmentValue;
        }
    }

    function renderColleges() {
        const colleges = Object.keys(collegeDepartmentMap);
        collegeSelect.innerHTML = "";
        appendOption(collegeSelect, "", "请选择学院");

        for (let i = 0; i < colleges.length; i++) {
            appendOption(collegeSelect, colleges[i], colleges[i]);
        }

        if (selectedCollege && collegeDepartmentMap[selectedCollege]) {
            collegeSelect.value = selectedCollege;
        }

        renderDepartments(collegeSelect.value, selectedDepartment);
    }

    function validatePassword() {
        const password = passwordInput.value.trim();
        const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d).+$/;
        if (!passwordPattern.test(password)) {
            showClientMessage("密码必须同时包含字母和数字。");
            return false;
        }
        showClientMessage("");
        return true;
    }

    function validateSelections() {
        if (!collegeSelect.value) {
            showClientMessage("请选择学院。");
            return false;
        }

        if (!departmentSelect.value) {
            showClientMessage("请选择系。");
            return false;
        }

        showClientMessage("");
        return true;
    }

    function validateCaptcha() {
        const captcha = captchaInput.value.trim();
        if (!/^[A-Za-z0-9]{<%= captchaLength %>}$/.test(captcha)) {
            showClientMessage("验证码必须为<%= captchaLength %>位字母或数字。");
            return false;
        }
        showClientMessage("");
        return true;
    }

    function refreshCaptchaImage() {
        captchaImage.src = "<%= request.getContextPath() %>/CaptchaController?t=" + Date.now();
    }

    renderColleges();

    collegeSelect.addEventListener("change", function () {
        renderDepartments(collegeSelect.value, "");
        showClientMessage("");
    });

    passwordInput.addEventListener("input", function () {
        if (passwordInput.value.trim().length === 0) {
            showClientMessage("");
            return;
        }
        validatePassword();
    });

    captchaInput.addEventListener("input", function () {
        captchaInput.value = captchaInput.value.replace(/[^A-Za-z0-9]/g, "").toUpperCase();
        if (captchaInput.value.trim().length === 0) {
            showClientMessage("");
            return;
        }
        validateCaptcha();
    });

    refreshCaptchaButton.addEventListener("click", refreshCaptchaImage);
    captchaImage.addEventListener("click", refreshCaptchaImage);
    captchaImage.addEventListener("error", function () {
        showClientMessage("验证码加载失败，请刷新页面后重试。");
    });

    loginForm.addEventListener("submit", function (event) {
        showClientMessage("");

        if (!validateSelections()) {
            event.preventDefault();
            if (!collegeSelect.value) {
                collegeSelect.focus();
            } else {
                departmentSelect.focus();
            }
            return;
        }

        if (!validatePassword()) {
            event.preventDefault();
            passwordInput.focus();
            return;
        }

        if (!validateCaptcha()) {
            event.preventDefault();
            captchaInput.focus();
        }
    });

    if (shouldRefreshCaptcha) {
        refreshCaptchaImage();
    }
</script>
</body>
</html>
