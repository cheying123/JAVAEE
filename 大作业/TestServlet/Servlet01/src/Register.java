import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class Register extends HttpServlet {
    // 数据库连接信息
    private static final String DB_URL = "jdbc:mysql://localhost:3306/hscms"; // 修改为你的数据库 URL
    private static final String DB_USER = "root";                            // 修改为你的数据库用户名
    private static final String DB_PASSWORD = "123456";                      // 修改为你的数据库密码

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取表单参数
        String identify = request.getParameter("identify");         // 用户角色（admin, teacher, parent）
        String username = request.getParameter("username");         // 用户名
        String password = request.getParameter("password");         // 密码
        String confirmPassword = request.getParameter("confirmPassword"); // 确认密码

        // 打印 identify 值到日志中，便于调试
        System.out.println("Identify value: " + identify);

        // 检查两次输入的密码是否匹配
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "两次输入的密码不匹配！");
            request.setAttribute("username", username); // 保留用户输入的用户名
            request.getRequestDispatcher("register.jsp").forward(request, response); // 返回注册页面
            return;
        }

        Connection conn = null;            // 数据库连接
        PreparedStatement stmt = null;     // SQL 预编译语句
        ResultSet rs = null;               // 查询结果集

        try {
            // 加载 MySQL 驱动
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 建立数据库连接
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // 检查用户名是否已存在
            String checkUserQuery = "SELECT * FROM users WHERE username = ? AND role = ?";
            stmt = conn.prepareStatement(checkUserQuery);
            stmt.setString(1, username);
            stmt.setString(2, identify);
            rs = stmt.executeQuery();

            if (rs.next()) { // 如果查询结果不为空，说明用户名已存在
                request.setAttribute("errorMessage", "用户名已存在！");
                request.setAttribute("username", username);
                request.getRequestDispatcher("register.jsp").forward(request, response); // 返回注册页面
                return;
            }

            // 插入新用户，默认状态为 "pending"
            String insertUserQuery = "INSERT INTO users (username, password, role, status) VALUES (?, ?, ?, 'pending')";
            stmt = conn.prepareStatement(insertUserQuery);
            stmt.setString(1, username);
            stmt.setString(2, password); // 建议对密码进行加密（如使用 BCrypt）
            stmt.setString(3, identify);
            stmt.executeUpdate();

            // 注册成功后重定向到登录页面
            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("数据库访问出错！", e);
        } finally {
            // 关闭资源
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
