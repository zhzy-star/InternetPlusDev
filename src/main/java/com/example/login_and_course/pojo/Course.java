package com.example.login_and_course.pojo;

public class Course {
    private int cId;
    private String cName;
    private String cType;

    public Course() {
    }

    public Course(int cId, String cName, String cType) {
        this.cId = cId;
        this.cName = cName;
        this.cType = cType;
    }

    public int getCId() {
        return cId;
    }

    public void setCId(int cId) {
        this.cId = cId;
    }

    public String getCName() {
        return cName;
    }

    public void setCName(String cName) {
        this.cName = cName;
    }

    public String getCType() {
        return cType;
    }

    public void setCType(String cType) {
        this.cType = cType;
    }
}
