import com.example.myapplication.util.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class ApproveJoinRequestServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int requestId = Integer.parseInt(request.getParameter("requestId")); // teacher_classes 表的主键 ID
        String action = request.getParameter("action"); // 获取操作类型：approve 或 reject

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();

            // 更新申请状态
            String updateQuery = "UPDATE teacher_classes SET approval_status = ? WHERE id = ?";
            stmt = conn.prepareStatement(updateQuery);
            if ("approve".equals(action)) {
                stmt.setString(1, "approved"); // 批准
            } else {
                stmt.setString(1, "rejected"); // 拒绝
            }
            stmt.setInt(2, requestId);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                request.setAttribute("operationMessage", "操作成功！"); // 设置操作反馈信息
            } else {
                request.setAttribute("operationMessage", "操作失败，请稍后重试！");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("operationMessage", "服务器错误，请稍后重试！");
        } finally {
            DatabaseUtil.close(conn, stmt, null);
        }

        // 操作完后，重定向回审核加入班级申请页面
        request.getRequestDispatcher("teacher/manageJoinRequests.jsp").forward(request, response);
    }
}
