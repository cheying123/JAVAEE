import com.example.myapplication.util.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DeleteClassNotificationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取通知ID
        String notificationIdStr = request.getParameter("notification_id");

        if (notificationIdStr == null || notificationIdStr.isEmpty()) {
            request.getSession().setAttribute("error", "通知ID无效！");
            response.sendRedirect("/teacher/manageClassNotifications.jsp");
            return;
        }

        int notificationId;
        try {
            notificationId = Integer.parseInt(notificationIdStr);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "通知ID无效！");
            response.sendRedirect("/teacher/manageClassNotifications.jsp");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();

            // 删除通知
            String deleteQuery = "DELETE FROM class_notifications WHERE id = ?";
            stmt = conn.prepareStatement(deleteQuery);
            stmt.setInt(1, notificationId);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                request.getSession().setAttribute("message", "通知删除成功！");
            } else {
                request.getSession().setAttribute("error", "通知删除失败，请重试！");
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
