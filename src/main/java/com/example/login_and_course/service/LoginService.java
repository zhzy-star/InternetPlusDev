package com.example.login_and_course.service;

import com.example.login_and_course.pojo.Login;
import com.example.login_and_course.pojo.LoginStatus;

import java.util.LinkedHashMap;
import java.util.Map;

public class LoginService {
    public LoginStatus validateLogin(Login login) {
        if (login == null) {
            throw new IllegalArgumentException("login cannot be null");
        }

        LoginStatus loginStatus = new LoginStatus();
        loginStatus.setCourseScores(buildCourseScores(login));
        return loginStatus;
    }

    private Map<String, Integer> buildCourseScores(Login login) {
        if ("\u8ba1\u7b97\u673a\u5b66\u9662".equals(login.getCollege())
                && "\u8f6f\u4ef6\u5de5\u7a0b".equals(login.getDepartment())) {
            return buildSoftwareEngineeringCourses();
        }

        return buildSecondPresetCourses();
    }

    private Map<String, Integer> buildSoftwareEngineeringCourses() {
        LinkedHashMap<String, Integer> courseScores = new LinkedHashMap<>();
        courseScores.put("\u9762\u5411\u4e92\u8054\u7f51+\u7684\u8f6f\u4ef6\u8bfe\u7a0b\u8bbe\u8ba1", 100);
        courseScores.put("\u6570\u636e\u6316\u6398", 90);
        courseScores.put("\u8f6f\u4ef6\u8bfe\u7a0b\u8bbe\u8ba1I", 90);
        courseScores.put("Java\u7a0b\u5e8f\u8bbe\u8ba1", 95);
        return courseScores;
    }

    private Map<String, Integer> buildSecondPresetCourses() {
        LinkedHashMap<String, Integer> courseScores = new LinkedHashMap<>();
        courseScores.put("\u6570\u636e\u6316\u6398", 90);
        return courseScores;
    }
}
