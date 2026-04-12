package com.example.login_and_course.service;

import com.example.login_and_course.dao.CourseDAO;
import com.example.login_and_course.pojo.Course;
import com.example.login_and_course.pojo.ElectiveSub;

import java.sql.SQLException;
import java.util.List;

public class CourseService {
    private final CourseDAO courseDAO = new CourseDAO();

    public List<Course> getAllCourses() throws SQLException {
        return courseDAO.findAllCourses();
    }

    public List<ElectiveSub> getStudentCourseList(String uId) throws SQLException {
        return courseDAO.findSelectedCoursesByStudent(uId);
    }

    public boolean addCoursesForStudent(String uId, List<Integer> cIds) throws SQLException {
        if (cIds == null || cIds.isEmpty()) {
            throw new SQLException("请至少选择一门课程。");
        }
        return courseDAO.addElectiveSubjects(uId, cIds);
    }
}
