import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.example.myapplication.util.DatabaseUtil;

@WebServlet("/AuditClassServlet")
public class AuditClassServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action"); // 通过/拒绝的动作
        int classId = Integer.parseInt(request.getParameter("classId")); // 获取班级ID

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();

            String newStatus = null;
            if (action.equals("approve")) {
                newStatus = "approved"; // 设置班级状态为审核通过
            } else if (action.equals("reject")) {
                newStatus = "rejected"; // 设置班级状态为审核拒绝
            }

            if (newStatus != null) {
                // 更新班级状态
                String updateQuery = "UPDATE classes SET status = ? WHERE id = ?";
                stmt = conn.prepareStatement(updateQuery);
                stmt.setString(1, newStatus);
                stmt.setInt(2, classId);
                stmt.executeUpdate();

                // 设置成功消息
                request.getSession().setAttribute("message", "班级审核成功！");
            } else {
                request.getSession().setAttribute("error", "班级审核失败，请重试！");
            }

            // 重定向回审核页面
            response.sendRedirect("admin/AuditClassCreation.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "班级审核失败，请稍后重试！");
            request.getRequestDispatcher("AuditClassCreation.jsp").forward(request, response);
        } finally {
            DatabaseUtil.close(conn, stmt, null);
        }
    }
}
