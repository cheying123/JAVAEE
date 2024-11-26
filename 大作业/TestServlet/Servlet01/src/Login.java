import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class Login extends HttpServlet {
    // 数据库连接信息
    private static final String DB_URL = "jdbc:mysql://localhost:3306/hscms"; // 修改为你的数据库 URL
    private static final String DB_USER = "root"; // 修改为你的数据库用户名
    private static final String DB_PASSWORD = "123456"; // 修改为你的数据库密码

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取请求中的身份、用户名和密码
        String identify = request.getParameter("identify");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 从UserDatabase查找用户-------------------------
        Connection conn = null;                 //建立数据库连接
        PreparedStatement stmt = null;          //通过conn辅助预编译SQL语句
        ResultSet rs = null;                    //返回查询结果

        try {
            // 加载数据库驱动
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 建立数据库连接
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String checkUserQuery = "SELECT * FROM users WHERE username = ? and role = ? ";
            //zh是表名，ac是表里面的类名
            stmt = conn.prepareStatement(checkUserQuery);           //预编译SQL语句
            stmt.setString(1, username);              //设置第1个参数为"username"
            stmt.setString(2, identify);               //设置第二个参数是“role”
            rs = stmt.executeQuery();                              //返回查询结果

            if (rs.next()) {           // 如果有结果，说明用户名已存在
                String checkUserPW = "SELECT * FROM users WHERE username = ? and password = ?";
                stmt = conn.prepareStatement(checkUserPW);
                stmt.setString(1,username);
                stmt.setString(2,password);
                rs = stmt.executeQuery();
                if( rs.next() ){
                    String checkUserST = "SELECT * FROM users WHERE username = ? and password = ? and status = 'approved'";
                    stmt = conn.prepareStatement(checkUserST);
                    stmt.setString(1,username);
                    stmt.setString(2,password);
                    rs = stmt.executeQuery();

                    if(rs.next()){
                        //将用户名设置为请求属性
                        request.setAttribute("username", username);
                        //RequestDispatcher不会重定向，不会让数据丢失
                        if( identify.equals("teacher") ){
                            RequestDispatcher dispatcher = request.getRequestDispatcher("teacher.jsp");
                            dispatcher.forward(request, response);
                        }
                        else if( identify.equals("parent") ){
                            RequestDispatcher dispatcher = request.getRequestDispatcher("parent.jsp");
                            dispatcher.forward(request, response);
                        }
                        else if( identify.equals("admin") ){
                            RequestDispatcher dispatcher = request.getRequestDispatcher("admin.jsp");
                            dispatcher.forward(request, response);
                        }

                    }else{
                        request.setAttribute("errorMessage", "用户未审核");
                        request.setAttribute("username", username); // 保留输入的用户名
                        request.getRequestDispatcher("index.jsp").forward(request, response);
                        return;
                    }

                }else{
                    request.setAttribute("errorMessage", "密码错误");
                    request.setAttribute("username", username); // 保留输入的用户名
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                    return;
                }

                return;
            }else{
                request.setAttribute("errorMessage", "用户名不存在或者身份错误");
                request.setAttribute("username", username); // 保留输入的用户名
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }



        }catch (Exception e) {
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 将GET请求重定向到登录页面
        // 就是点击登录时，不会进行页面跳转到别的画面，还是在index.jsp上
        response.sendRedirect("index.jsp");
    }
}
