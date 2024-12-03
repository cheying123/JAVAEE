import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.example.myapplication.util.DatabaseUtil;

@WebServlet("/CreateClassServlet")
public class CreateClassServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取表单数据
        String className = request.getParameter("className");
        int teacherId = (int) request.getSession().getAttribute("teacherId");
        String class_briefly = request.getParameter("class_briefly");
        // 这里的 teacherId 必须是有效的 id
        // 登录后存储了教师ID



        // 数据库操作
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection(); // 获取数据库连接

            // 检查班级名是否已存在
            String checkClassQuery = "SELECT COUNT(*) FROM classes WHERE class_name = ?";
            stmt = conn.prepareStatement(checkClassQuery);
            stmt.setString(1, className);
            rs = stmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                // 如果返回的结果大于0，说明班级名已经存在
                request.setAttribute("error", "班级名已存在，请选择其他班级名！");
                request.getRequestDispatcher("teacher/createClass.jsp").forward(request, response);
                return;
            }

            // 如果班级名不存在，执行插入操作
            String sql = "INSERT INTO classes (class_name, teacher_id, status,class_briefly) VALUES (?, ?, 'pending',?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, className);
            stmt.setInt(2, teacherId);
            stmt.setString(3,class_briefly);
            stmt.executeUpdate();

            // 设置成功消息并重定向
            request.setAttribute("message", "班级创建成功，请等待管理员审核！");
            request.getRequestDispatcher("teacher/createClass.jsp").forward(request, response);
            // 返回教师主页面
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "班级创建失败，请稍后重试！");
            request.getRequestDispatcher("teacher/createClass.jsp").forward(request, response);
        } finally {
            DatabaseUtil.close(conn, stmt, rs);
        }
    }
}
