package com.example.login_and_course.pojo;

import java.util.LinkedHashMap;
import java.util.Map;

public class DynContent {
    private String userName;
    private String college;
    private Map<String, Integer> courseScores = new LinkedHashMap<>();

    public DynContent() {
    }

    public DynContent(String userName, String college, Map<String, Integer> courseScores) {
        this.userName = userName;
        this.college = college;
        this.courseScores = courseScores;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getCollege() {
        return college;
    }

    public void setCollege(String college) {
        this.college = college;
    }

    public Map<String, Integer> getCourseScores() {
        return courseScores;
    }

    public void setCourseScores(Map<String, Integer> courseScores) {
        this.courseScores = courseScores;
    }
}
