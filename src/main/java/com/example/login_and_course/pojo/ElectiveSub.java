package com.example.login_and_course.pojo;

public class ElectiveSub {
    private String uId;
    private int cId;
    private Integer grade;
    private Course course;

    public ElectiveSub() {
    }

    public ElectiveSub(String uId, int cId, Integer grade, Course course) {
        this.uId = uId;
        this.cId = cId;
        this.grade = grade;
        this.course = course;
    }

    public String getUId() {
        return uId;
    }

    public void setUId(String uId) {
        this.uId = uId;
    }

    public int getCId() {
        return cId;
    }

    public void setCId(int cId) {
        this.cId = cId;
    }

    public Integer getGrade() {
        return grade;
    }

    public void setGrade(Integer grade) {
        this.grade = grade;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }
}
