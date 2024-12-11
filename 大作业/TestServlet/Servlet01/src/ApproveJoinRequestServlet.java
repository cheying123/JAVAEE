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
        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String action = request.getParameter("action"); // 获取操作类型：approve 或 reject
        String type = request.getParameter("type"); // 请求类型：teacher 或 parent

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();

            // 根据请求类型决定目标表
            String updateQuery = "";
            if ("teacher".equals(type)) {
                // 对于教师申请，更新 teacher_classes 表
                updateQuery = "UPDATE teacher_classes SET approval_status = ? WHERE id = ?";
            } else if ("parent".equals(type)) {
                // 对于家长申请，更新 parent_classes 表
                updateQuery = "UPDATE parent_classes SET status = ? WHERE id = ?";
            }

            // 执行更新操作
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
