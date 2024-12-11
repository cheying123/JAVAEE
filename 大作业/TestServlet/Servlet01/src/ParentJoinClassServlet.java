import com.example.myapplication.util.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ParentJoinClassServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 设置响应编码为 UTF-8
        response.setContentType("text/html;charset=UTF-8");

        // 获取 class_id 参数
        String classIdStr = request.getParameter("class_id");

        // 检查 class_id 是否为空或者无效
        if (classIdStr == null || classIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "班级ID不能为空");
            return;
        }

        int classId;
        try {
            classId = Integer.parseInt(classIdStr);  // 将 class_id 转换为整数
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的班级ID");
            return;
        }

        // 获取当前登录的教师ID
        Integer parentId = (Integer) request.getSession().getAttribute("parentId");
        if (parentId == null) {
            response.sendRedirect("index.jsp");  // 如果没有登录，跳转到登录页面
            return;
        }

        // 执行数据库插入操作
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();

            // 插入加入班级申请数据
            String insertQuery = "INSERT INTO parent_classes (parent_id, class_id, status) " +
                    "VALUES (?, ?, 'pending')";
            stmt = conn.prepareStatement(insertQuery);
            stmt.setInt(1, parentId);
            stmt.setInt(2, classId);

            int rowsAffected = stmt.executeUpdate();

            // 根据操作结果设置session消息
            if (rowsAffected > 0) {
                // 设置成功消息
                request.getSession().setAttribute("message", "申请加入班级成功，待审核");
            } else {
                // 设置错误消息
                request.getSession().setAttribute("error", "申请加入班级失败，请稍后重试");
            }

            // 重定向回当前页面
            response.sendRedirect("parent/joinClass.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "服务器错误，请稍后重试");
        } finally {
            DatabaseUtil.close(conn, stmt, null);
        }
    }
}
