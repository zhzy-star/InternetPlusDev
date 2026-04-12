package com.example.login_and_course.pojo;

import java.util.ArrayList;
import java.util.List;

public class DynContent {
    private User user;
    private List<ElectiveSub> selectedCourses = new ArrayList<>();

    public DynContent() {
    }

    public DynContent(User user, List<ElectiveSub> selectedCourses) {
        this.user = user;
        this.selectedCourses = selectedCourses;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<ElectiveSub> getSelectedCourses() {
        return selectedCourses;
    }

    public void setSelectedCourses(List<ElectiveSub> selectedCourses) {
        this.selectedCourses = selectedCourses;
    }
}
