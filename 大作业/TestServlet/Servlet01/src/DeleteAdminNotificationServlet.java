import com.example.myapplication.util.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DeleteAdminNotificationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取要删除的通知ID
        String notificationIdStr = request.getParameter("notification_id");

        if (notificationIdStr == null || notificationIdStr.isEmpty()) {
            request.setAttribute("error", "通知ID无效");
            request.getRequestDispatcher("/admin/manageNotifications.jsp").forward(request, response);
            return;
        }

        int notificationId = Integer.parseInt(notificationIdStr);
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // 获取数据库连接
            conn = DatabaseUtil.getConnection();

            // 创建删除通知的SQL语句
            String sql = "DELETE FROM admin_notifications WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, notificationId);

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                request.setAttribute("message", "通知删除成功");
            } else {
                request.setAttribute("error", "删除失败，找不到通知");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "数据库错误，请稍后再试");
        } finally {
            // 关闭数据库资源
            DatabaseUtil.close(conn, stmt, null);
        }

        // 转发到通知管理页面
        request.getRequestDispatcher("/admin/manageNotifications.jsp").forward(request, response);
    }
}
