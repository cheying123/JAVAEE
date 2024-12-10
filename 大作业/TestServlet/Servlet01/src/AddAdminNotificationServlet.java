import com.example.myapplication.util.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AddAdminNotificationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        HttpSession session = request.getSession();
        Integer adminId = (Integer) session.getAttribute("adminId");

        if (adminId == null) {
            session.setAttribute("error", "管理员未登录！");
            response.sendRedirect("index.jsp");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String query = "INSERT INTO admin_notifications (admin_id, title, content) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, adminId);
            stmt.setString(2, title);
            stmt.setString(3, content);
            stmt.executeUpdate();

            session.setAttribute("message", "通知发布成功！");
            response.sendRedirect("admin/manageNotifications.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "发布通知失败，请稍后再试。");
            response.sendRedirect("admin/addAdminNotification.jsp");
        } finally {
            DatabaseUtil.close(conn, stmt, null);
        }
    }
}
