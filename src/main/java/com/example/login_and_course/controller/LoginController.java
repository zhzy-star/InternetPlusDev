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

import java.io.IOException;

@WebServlet(name = "loginController", value = "/LoginController")
public class LoginController extends HttpServlet {
    private final LoginService loginService = new LoginService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userName = trim(request.getParameter("userName"));
        String password = trim(request.getParameter("password"));
        String college = trim(request.getParameter("college"));
        String department = trim(request.getParameter("department"));

        if (userName.isEmpty() || password.isEmpty() || college.isEmpty() || department.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

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
}
