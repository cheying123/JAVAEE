import com.example.myapplication.util.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.xml.transform.Result;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AuditTeacherServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String action = request.getParameter("action");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();

            String updateQuery;
            if ("approve".equals(action)) {
                updateQuery = "UPDATE users SET status = 'approved' WHERE id = ?";
            } else if ("deny".equals(action)) {
                updateQuery = "DELETE FROM users WHERE id = ?";
            } else {
                throw new IllegalArgumentException("未知操作: " + action);
            }

            stmt = conn.prepareStatement(updateQuery);
            stmt.setString(1, id);
            stmt.executeUpdate();

            response.sendRedirect("admin/AuditTeacherRegistration.jsp"); // 重定向回审核页面
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("处理审核请求时出错", e);
        } finally {
            DatabaseUtil.close(conn, stmt, rs);
        }
    }
}
