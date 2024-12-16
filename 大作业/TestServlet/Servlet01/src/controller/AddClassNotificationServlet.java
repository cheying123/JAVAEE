package controller;

import com.example.myapplication.util.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AddClassNotificationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 设置响应编码
        response.setContentType("text/html;charset=UTF-8");

        // 获取请求参数
        String classIdStr = request.getParameter("class_id");
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        // 检查参数有效性
        if (classIdStr == null || classIdStr.isEmpty() || title == null || title.isEmpty() || content == null || content.isEmpty()) {
            request.getSession().setAttribute("error", "所有字段均为必填项！");
            response.sendRedirect("/teacher/addClassNotification.jsp");
            return;
        }

        int classId;
        try {
            classId = Integer.parseInt(classIdStr);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "班级ID无效！");
            response.sendRedirect("/teacher/addClassNotification.jsp");
            return;
        }

        // 获取当前登录的教师ID
        Integer teacherId = (Integer) request.getSession().getAttribute("teacherId");
        if (teacherId == null) {
            response.sendRedirect("index.jsp"); // 未登录跳转到登录页面
            return;
        }

        // 数据库操作
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();

            // 插入通知信息
            String insertQuery = "INSERT INTO class_notifications (class_id, teacher_id, title, content) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(insertQuery);
            stmt.setInt(1, classId);
            stmt.setInt(2, teacherId);
            stmt.setString(3, title);
            stmt.setString(4, content);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                request.getSession().setAttribute("message", "通知发布成功！");
            } else {
                request.getSession().setAttribute("error", "通知发布失败，请重试！");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "服务器错误，请稍后重试！");
        } finally {
            DatabaseUtil.close(conn, stmt, null);
        }

        // 重定向到通知管理页面
        response.sendRedirect("/teacher/manageClassNotifications.jsp");
    }
}
