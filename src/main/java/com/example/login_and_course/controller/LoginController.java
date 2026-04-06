package com.example.login_and_course.controller;

import com.example.login_and_course.pojo.DynContent;
import com.example.login_and_course.pojo.Login;
import com.example.login_and_course.pojo.LoginStatus;
import com.example.login_and_course.service.LoginService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "loginController", value = "/LoginController")
public class LoginController extends HttpServlet {
    private static final String CAPTCHA_SESSION_KEY = "captchaCode";
    private final LoginService loginService = new LoginService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userName = trim(request.getParameter("userName"));
        String password = trim(request.getParameter("password"));
        String college = trim(request.getParameter("college"));
        String department = trim(request.getParameter("department"));
        String captcha = trim(request.getParameter("captcha"));

        if (userName.isEmpty() && password.isEmpty() && college.isEmpty() && department.isEmpty() && captcha.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (userName.isEmpty() || password.isEmpty() || college.isEmpty() || department.isEmpty() || captcha.isEmpty()) {
            forwardToLogin(request, response, "请完整填写登录信息和验证码。");
            return;
        }

        HttpSession session = request.getSession(false);
        String expectedCaptcha = session == null ? "" : trim((String) session.getAttribute(CAPTCHA_SESSION_KEY));
        if (expectedCaptcha.isEmpty() || !expectedCaptcha.equalsIgnoreCase(captcha)) {
            if (session != null) {
                session.removeAttribute(CAPTCHA_SESSION_KEY);
            }
            forwardToLogin(request, response, "验证码错误，请重新输入。");
            return;
        }

        session.removeAttribute(CAPTCHA_SESSION_KEY);

        Login login = new Login();
        login.setUserName(userName);
        login.setPassword(password);
        login.setCollege(college);
        login.setDepartment(department);

        LoginStatus loginStatus = loginService.validateLogin(login);

        DynContent dynContent = new DynContent();
        dynContent.setUserName(login.getUserName());
        dynContent.setCollege(login.getCollege());
        dynContent.setCourseScores(loginStatus.getCourseScores());

        request.setAttribute("dynContent", dynContent);
        request.getRequestDispatcher("/courseMng.jsp").forward(request, response);
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private void forwardToLogin(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}
