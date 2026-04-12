package com.example.login_and_course.dao;

import com.example.login_and_course.pojo.User;
import com.example.login_and_course.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginDAO {
    public User findUserByCredentials(String uId, String password) throws SQLException {
        String sql = "select uId, uName, uPw, uSchool, uDepartment from `user` where uId = ? and uPw = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, uId);
            preparedStatement.setString(2, password);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return new User(
                            resultSet.getString("uId"),
                            resultSet.getString("uName"),
                            resultSet.getString("uPw"),
                            resultSet.getString("uSchool"),
                            resultSet.getString("uDepartment")
                    );
                }
                return null;
            }
        }
    }
}
