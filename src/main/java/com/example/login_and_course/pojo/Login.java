package com.example.login_and_course.pojo;

public class Login {
    private String uId;
    private String password;
    private String college;
    private String department;

    public Login() {
    }

    public Login(String uId, String password, String college, String department) {
        this.uId = uId;
        this.password = password;
        this.college = college;
        this.department = department;
    }

    public String getUId() {
        return uId;
    }

    public void setUId(String uId) {
        this.uId = uId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getCollege() {
        return college;
    }

    public void setCollege(String college) {
        this.college = college;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }
}
