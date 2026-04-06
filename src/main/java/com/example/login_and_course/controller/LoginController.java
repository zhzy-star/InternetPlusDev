package com.example.login_and_course.controller;

import com.example.login_and_course.pojo.DynContent;
import com.example.login_and_course.pojo.Login;
import com.example.login_and_course.pojo.LoginStatus;
import com.example.login_and_course.service.CaptchaService;
import com.example.login_and_course.service.CaptchaService.CaptchaValidationStatus;
import com.example.login_and_course.service.LoginFormValidator;
import com.example.login_and_course.service.LoginService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "loginController", value = "/LoginController")
public class LoginController extends HttpServlet {
    private static final String MESSAGE_ATTRIBUTE = "msg";
    private static final String REFRESH_CAPTCHA_ATTRIBUTE = "refreshCaptcha";
    private static final Logger LOGGER = Logger.getLogger(LoginController.class.getName());
    private final LoginService loginService = new LoginService();
    private final LoginFormValidator loginFormValidator = new LoginFormValidator();
    private final CaptchaService captchaService = new CaptchaService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String userName = trim(request.getParameter("userName"));
        String password = trim(request.getParameter("password"));
        String college = trim(request.getParameter("college"));
        String department = trim(request.getParameter("department"));
        String captcha = trim(request.getParameter("captcha"));
        Login login = new Login(userName, password, college, department);

        if (isInitialRequest(userName, password, college, department, captcha)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            String validationMessage = loginFormValidator.validate(login, captcha);
            if (validationMessage != null) {
                forwardToLogin(request, response, login, validationMessage, false);
                return;
            }

            CaptchaValidationStatus captchaValidationStatus = captchaService.validateCaptcha(request.getSession(false), captcha);
            if (captchaValidationStatus != CaptchaValidationStatus.VALID) {
                forwardToLogin(request, response, login, resolveCaptchaMessage(captchaValidationStatus), true);
                return;
            }

            LoginStatus loginStatus = loginService.validateLogin(login);
            if (loginStatus == null || loginStatus.getCourseScores() == null) {
                throw new IllegalStateException("Login service returned invalid result");
            }

            DynContent dynContent = new DynContent();
            dynContent.setUserName(login.getUserName());
            dynContent.setCollege(login.getCollege());
            dynContent.setCourseScores(loginStatus.getCourseScores());

            request.setAttribute("dynContent", dynContent);
            request.getRequestDispatcher("/courseMng.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Invalid login request", e);
            forwardToLogin(request, response, login, "提交信息不合法，请检查后重试。", false);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to process login request", e);
            captchaService.clearCaptcha(request.getSession(false));
            forwardToLogin(request, response, login, "系统出现异常，请稍后重试。", true);
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isInitialRequest(String userName, String password, String college, String department, String captcha) {
        return userName.isEmpty() && password.isEmpty() && college.isEmpty() && department.isEmpty() && captcha.isEmpty();
    }

    private String resolveCaptchaMessage(CaptchaValidationStatus captchaValidationStatus) {
        switch (captchaValidationStatus) {
            case MISSING:
            case EXPIRED:
                return "验证码已失效，请刷新后重试。";
            case MISMATCH:
                return "验证码错误，请重新输入。";
            case VALID:
            default:
                return "验证码校验失败。";
        }
    }

    private void forwardToLogin(HttpServletRequest request, HttpServletResponse response, Login login,
                                String message, boolean refreshCaptcha) throws ServletException, IOException {
        request.setAttribute("userNameValue", login == null ? "" : trim(login.getUserName()));
        request.setAttribute("selectedCollege", login == null ? "" : trim(login.getCollege()));
        request.setAttribute("selectedDepartment", login == null ? "" : trim(login.getDepartment()));
        request.setAttribute(MESSAGE_ATTRIBUTE, message);
        request.setAttribute(REFRESH_CAPTCHA_ATTRIBUTE, refreshCaptcha);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}
