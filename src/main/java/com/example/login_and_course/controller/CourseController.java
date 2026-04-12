package com.example.login_and_course.controller;

import com.example.login_and_course.pojo.User;
import com.example.login_and_course.service.CourseService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "courseController", value = "/CourseController")
public class CourseController extends HttpServlet {
    private final CourseService courseService = new CourseService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String[] cIds = request.getParameterValues("cIds");
        List<Integer> courseIds = new ArrayList<>();
        if (cIds != null) {
            for (String cId : cIds) {
                if (cId != null && !cId.trim().isEmpty()) {
                    try {
                        courseIds.add(Integer.parseInt(cId));
                    } catch (NumberFormatException e) {
                        request.setAttribute("errorMessage", "课程编号格式错误，请重新选择。");
                        request.getRequestDispatcher("/failure.jsp").forward(request, response);
                        return;
                    }
                }
            }
        }

        try {
            courseService.addCoursesForStudent(currentUser.getUId(), courseIds);
            response.sendRedirect(request.getContextPath() + "/courseMng.jsp");
        } catch (SQLException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/failure.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect(request.getContextPath() + "/courseMng.jsp");
    }
}
