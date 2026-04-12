package com.example.login_and_course.service;

import com.example.login_and_course.dao.CourseDAO;
import com.example.login_and_course.dao.LoginDAO;
import com.example.login_and_course.pojo.DynContent;
import com.example.login_and_course.pojo.Login;
import com.example.login_and_course.pojo.User;

import java.sql.SQLException;

public class LoginService {
    private final LoginDAO loginDAO = new LoginDAO();
    private final CourseDAO courseDAO = new CourseDAO();

    public DynContent validateLogin(Login login) throws SQLException {
        User user = loginDAO.findUserByCredentials(login.getUId(), login.getPassword());
        if (user == null) {
            return null;
        }

        if (!user.getUSchool().equals(login.getCollege()) || !user.getUDepartment().equals(login.getDepartment())) {
            return null;
        }

        DynContent dynContent = new DynContent();
        dynContent.setUser(user);
        dynContent.setSelectedCourses(courseDAO.findSelectedCoursesByStudent(user.getUId()));
        return dynContent;
    }
}
