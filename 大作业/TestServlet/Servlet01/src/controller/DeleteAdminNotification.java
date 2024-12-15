package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.NotificationService;

import java.io.IOException;



public class DeleteAdminNotification extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("notification_id"));

        HttpSession session = request.getSession();
        Integer adminId = (Integer) session.getAttribute("adminId");

        if (adminId == null) {
            session.setAttribute("error", "管理员未登录！");
            response.sendRedirect("index.jsp");
            return;
        }

        NotificationService notificationService = new NotificationService();
        boolean isSuccess = notificationService.deleteNotification(id);

        if (isSuccess) {
            session.setAttribute("message", "通知删除成功！");
            response.sendRedirect("ToShowAdminNotification");
        } else {
            session.setAttribute("error", "删除通知失败，请稍后再试。");
            response.sendRedirect("ToShowAdminNotification");
        }
    }
}
