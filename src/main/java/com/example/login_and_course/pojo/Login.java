package com.example.login_and_course.pojo;

public class Login {
    private String userName;
    private String password;
    private String college;
    private String department;

    public Login() {
    }

    public Login(String userName, String password, String college, String department) {
        this.userName = userName;
        this.password = password;
        this.college = college;
        this.department = department;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
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
