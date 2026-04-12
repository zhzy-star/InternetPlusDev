package com.example.login_and_course.pojo;

public class User {
    private String uId;
    private String uName;
    private String uPw;
    private String uSchool;
    private String uDepartment;

    public User() {
    }

    public User(String uId, String uName, String uPw, String uSchool, String uDepartment) {
        this.uId = uId;
        this.uName = uName;
        this.uPw = uPw;
        this.uSchool = uSchool;
        this.uDepartment = uDepartment;
    }

    public String getUId() {
        return uId;
    }

    public void setUId(String uId) {
        this.uId = uId;
    }

    public String getUName() {
        return uName;
    }

    public void setUName(String uName) {
        this.uName = uName;
    }

    public String getUPw() {
        return uPw;
    }

    public void setUPw(String uPw) {
        this.uPw = uPw;
    }

    public String getUSchool() {
        return uSchool;
    }

    public void setUSchool(String uSchool) {
        this.uSchool = uSchool;
    }

    public String getUDepartment() {
        return uDepartment;
    }

    public void setUDepartment(String uDepartment) {
        this.uDepartment = uDepartment;
    }
}
