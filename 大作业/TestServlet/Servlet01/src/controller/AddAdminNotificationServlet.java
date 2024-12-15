package controller;

import service.NotificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AddAdminNotificationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        HttpSession session = request.getSession();
        Integer adminId = (Integer) session.getAttribute("adminId");

        if (adminId == null) {
            session.setAttribute("error", "管理员未登录！");
            response.sendRedirect("index.jsp");
            return;
        }

        NotificationService notificationService = new NotificationService();
        boolean isSuccess = notificationService.addNotification(adminId, title, content);

        if (isSuccess) {
            session.setAttribute("message", "通知发布成功！");
            response.sendRedirect("ToShowAdminNotification");
        } else {
            session.setAttribute("error", "发布通知失败，请稍后再试。");
            response.sendRedirect("ToShowAdminNotification");
        }
    }
}
