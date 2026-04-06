package com.example.login_and_course.pojo;

import java.util.LinkedHashMap;
import java.util.Map;

public class LoginStatus {
    private Map<String, Integer> courseScores = new LinkedHashMap<>();

    public LoginStatus() {
    }

    public LoginStatus(Map<String, Integer> courseScores) {
        this.courseScores = courseScores;
    }

    public Map<String, Integer> getCourseScores() {
        return courseScores;
    }

    public void setCourseScores(Map<String, Integer> courseScores) {
        this.courseScores = courseScores;
    }
}
