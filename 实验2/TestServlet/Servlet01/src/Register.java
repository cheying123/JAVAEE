import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.mysql.cj.jdbc.Driver;



public class Register extends HttpServlet {
    // 数据库连接信息
    private static final String DB_URL = "jdbc:mysql://localhost:3306/zh"; // 修改为你的数据库 URL
    private static final String DB_USER = "root"; // 修改为你的数据库用户名
    private static final String DB_PASSWORD = "123456"; // 修改为你的数据库密码

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");                 // 账号
        String password = request.getParameter("password");                 // 输入的密码
        String confirmPassword = request.getParameter("confirmPassword");   // 第二次输入的密码

        // 检查密码是否匹配
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "两遍密码不匹配");          // 返回错误信息
            request.setAttribute("username", username);                     // 保留输入的用户名
            request.getRequestDispatcher("register.jsp").forward(request, response);
            //重定向
            return;
        }

        Connection conn = null;                 //建立数据库连接
        PreparedStatement stmt = null;          //通过conn辅助预编译SQL语句
        ResultSet rs = null;                    //返回查询结果

        try {
            // 加载数据库驱动
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 建立数据库连接
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // 检查用户名是否已存在
            String checkUserQuery = "SELECT * FROM zh WHERE ac = ?";
            //zh是表名，ac是表里面的类名
            stmt = conn.prepareStatement(checkUserQuery);           //预编译SQL语句
            stmt.setString(1, username);               //设置第1个参数为"username"
            rs = stmt.executeQuery();                               //返回查询结果

            if (rs.next()) { // 如果有结果，说明用户名已存在
                request.setAttribute("errorMessage", "用户名已存在");
                request.setAttribute("username", username); // 保留输入的用户名
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // 插入新用户
            String insertUserQuery = "INSERT INTO zh (ac, ps) VALUES (?, ?)";
            stmt = conn.prepareStatement(insertUserQuery);
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.executeUpdate(); // 执行插入操作

            // 注册成功，重定向到登录页或成功页
            response.sendRedirect("http://localhost:8080"); // 重定向到登录页面
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("数据库访问出错", e); // 如果出错，抛出异常
        } finally {
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
