import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

public class Register extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");                 //账号
        String password = request.getParameter("password");                 //输入的密码
        String confirmPassword = request.getParameter("confirmPassword");   //第二次输入的密码

        // 检查用户名是否已存在
        User existingUser = UserDatabase.findUser(username); // 假设UserDatabase是管理用户的静态类
        if (existingUser != null) {
            request.setAttribute("errorMessage", "用户名已存在");
            request.setAttribute("username", username); // 保留输入的用户名
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 检查密码是否匹配
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "两遍密码不匹配");          //返回错误信息
            request.setAttribute("username", username);                   //保留输入的用户名
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 注册用户
        User newUser = new User(username, password);    //
        UserDatabase.addUser(newUser);                  // 这个方法会将用户添加到静态列表中

        // 注册成功，重定向到登录页或成功页
        response.sendRedirect("http://localhost:8080"); // 重定向到登录页面
    }
}
