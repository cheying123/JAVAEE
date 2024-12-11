import com.example.myapplication.util.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;

public class SendMessageServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int senderId = (Integer) request.getSession().getAttribute("teacherId");  // 获取当前登录的用户ID (老师)
        int receiverId = Integer.parseInt(request.getParameter("receiverId"));  // 获取接收方的ID (家长)
        String content = request.getParameter("content");  // 获取消息内容

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();

            // 插入消息到 messages 表
            String insertQuery = "INSERT INTO messages (sender_id, receiver_id, content, created_at) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(insertQuery);
            stmt.setInt(1, senderId);
            stmt.setInt(2, receiverId);
            stmt.setString(3, content);
            stmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));  // 当前时间

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                request.setAttribute("operationMessage", "消息发送成功！");
            } else {
                request.setAttribute("operationMessage", "消息发送失败，请稍后重试！");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("operationMessage", "服务器错误，请稍后重试！");
        } finally {
            DatabaseUtil.close(conn, stmt, null);
        }

        // 发送完消息后，重定向回发送消息的页面
        request.getRequestDispatcher("/teacher.jsp").forward(request, response);
    }
}
