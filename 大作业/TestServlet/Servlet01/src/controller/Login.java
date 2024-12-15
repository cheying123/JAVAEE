package controller;

import service.LoginService;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class Login extends HttpServlet {
    private final LoginService loginService = new LoginService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String identify = request.getParameter("identify");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            if (loginService.userExists(username, identify)) {
                if (loginService.validatePassword(username, password)) {
                    if (loginService.isApprovedOrParent(username, password)) {
                        int userId = loginService.getUserId(username, identify); // 从数据库获取用户ID
                        if (userId == -1) {
                            handleError(request, response, "无法找到用户ID", username);
                            return;
                        }
                        HttpSession session = request.getSession();
                        session.setAttribute("username", username);

                        // 根据角色重定向页面
                        if ("teacher".equals(identify)) {
                            session.setAttribute("teacherId", userId);
                            session.setAttribute("parentId", null);
                            session.setAttribute("adminId", null);
                            request.getRequestDispatcher("teacher.jsp").forward(request, response);
                        } else if ("parent".equals(identify)) {
                            session.setAttribute("parentId", userId);
                            session.setAttribute("teacherId", null);
                            session.setAttribute("adminId", null);
                            request.getRequestDispatcher("parent.jsp").forward(request, response);
                        } else if ("admin".equals(identify)) {
                            session.setAttribute("adminId", userId);
                            session.setAttribute("teacherId", null);
                            session.setAttribute("parentId", null);
                            request.getRequestDispatcher("admin.jsp").forward(request, response);
                        }
                    } else {
                        handleError(request, response, "用户未审核", username);
                    }
                } else {
                    handleError(request, response, "密码错误", username);
                }
            } else {
                handleError(request, response, "用户名不存在或者身份错误", username);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("登录处理出错", e);
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage, String username)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("username", username);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}
