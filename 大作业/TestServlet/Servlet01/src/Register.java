
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.RegisterService;

import java.io.IOException;

public class Register extends HttpServlet {
    private final RegisterService registerService = new RegisterService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取表单参数
        String identify = request.getParameter("identify");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 检查两次输入的密码是否匹配
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "两次输入的密码不匹配！");
            request.setAttribute("username", username);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 检查用户名是否已存在
        if (registerService.isUsernameExists(username, identify)) {
            request.setAttribute("errorMessage", "用户名已存在！");
            request.setAttribute("username", username);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 注册用户
        try {
            registerService.registerUser(username, password, identify);
            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "注册失败，请稍后再试！");
            request.setAttribute("username", username);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
