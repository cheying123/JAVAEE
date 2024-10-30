import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class Login extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取请求中的用户名和密码
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 从UserDatabase查找用户
        User user = UserDatabase.findUser(username);

        if (user == null) {
            // 用户名不存在
            request.setAttribute("errorMessage", "用户名不存在");
            request.setAttribute("username", username); // 保留用户名
            request.setAttribute("password", "");    // 清空密码
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } else if (!user.getPassword().equals(password)) {
            // 密码错误
            request.setAttribute("errorMessage", "密码错误");
            request.setAttribute("username", username); // 保留用户名
            request.setAttribute("password", "");    // 清空密码
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } else {
            // 登录成功，创建会话并跳转到成功页
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect("https://jwc.dgut.edu.cn/");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 将GET请求重定向到登录页面
        // 就是点击登录时，不会进行页面跳转到别的画面，还是在index.jsp上
        response.sendRedirect("index.jsp");
    }
}
