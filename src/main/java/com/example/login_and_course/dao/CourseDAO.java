package com.example.login_and_course.dao;

import com.example.login_and_course.pojo.Course;
import com.example.login_and_course.pojo.ElectiveSub;
import com.example.login_and_course.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class CourseDAO {
    public List<Course> findAllCourses() throws SQLException {
        String sql = "select cId, cName, cType from `course` order by cId";
        List<Course> courses = new ArrayList<>();

        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql);
             ResultSet resultSet = preparedStatement.executeQuery()) {
            while (resultSet.next()) {
                Course course = new Course();
                course.setCId(resultSet.getInt("cId"));
                course.setCName(resultSet.getString("cName"));
                course.setCType(resultSet.getString("cType"));
                courses.add(course);
            }
        }

        return courses;
    }

    public List<ElectiveSub> findSelectedCoursesByStudent(String uId) throws SQLException {
        String sql = "select e.uId, e.cId, e.grade, c.cName, c.cType " +
                "from `electiveSub` e join `course` c on e.cId = c.cId " +
                "where e.uId = ? order by e.cId";
        List<ElectiveSub> electiveSubs = new ArrayList<>();

        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, uId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    Course course = new Course();
                    course.setCId(resultSet.getInt("cId"));
                    course.setCName(resultSet.getString("cName"));
                    course.setCType(resultSet.getString("cType"));

                    ElectiveSub electiveSub = new ElectiveSub();
                    electiveSub.setUId(resultSet.getString("uId"));
                    electiveSub.setCId(resultSet.getInt("cId"));
                    electiveSub.setGrade((Integer) resultSet.getObject("grade"));
                    electiveSub.setCourse(course);
                    electiveSubs.add(electiveSub);
                }
            }
        }

        return electiveSubs;
    }

    public boolean addElectiveSubjects(String uId, List<Integer> cIds) throws SQLException {
        if (cIds == null || cIds.isEmpty()) {
            return false;
        }

        Set<Integer> uniqueIds = new HashSet<>(cIds);
        if (uniqueIds.size() != cIds.size()) {
            throw new SQLException("提交的课程中包含重复项，请重新选择。");
        }

        String duplicateSql = "select c.cName from `electiveSub` e join `course` c on e.cId = c.cId where e.uId = ? and e.cId = ?";
        String insertSql = "insert into `electiveSub`(uId, cId, grade) values (?, ?, null)";

        try (Connection connection = DBUtil.getConnection()) {
            connection.setAutoCommit(false);
            try (PreparedStatement duplicateStatement = connection.prepareStatement(duplicateSql);
                 PreparedStatement insertStatement = connection.prepareStatement(insertSql)) {
                for (Integer cId : cIds) {
                    duplicateStatement.setString(1, uId);
                    duplicateStatement.setInt(2, cId);
                    try (ResultSet resultSet = duplicateStatement.executeQuery()) {
                        if (resultSet.next()) {
                            connection.rollback();
                            throw new SQLException("课程已选，不能重复添加：" + resultSet.getString("cName"));
                        }
                    }
                }

                for (Integer cId : cIds) {
                    insertStatement.setString(1, uId);
                    insertStatement.setInt(2, cId);
                    insertStatement.addBatch();
                }
                insertStatement.executeBatch();
                connection.commit();
                return true;
            } catch (SQLException e) {
                connection.rollback();
                throw e;
            } finally {
                connection.setAutoCommit(true);
            }
        }
    }
}
