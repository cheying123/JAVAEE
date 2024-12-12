package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import service.NotificationService;
import model.Notification;

import java.io.IOException;
import java.util.List;

public class NotificationController extends HttpServlet {
    private NotificationService notificationService;

    @Override
    public void init() {
        notificationService = new NotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Integer adminId = (Integer) session.getAttribute("adminId");

        if (adminId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        if ("list".equals(action)) {
            // 获取通知列表
            List<Notification> notifications = notificationService.getNotificationsByAdmin(adminId);
            request.setAttribute("notifications", notifications);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/notificationList.jsp");
            dispatcher.forward(request, response);
        } else if ("delete".equals(action)) {
            // 删除通知
            int notificationId = Integer.parseInt(request.getParameter("notification_id"));
            boolean success = notificationService.deleteNotification(notificationId);

            if (success) {
                session.setAttribute("message", "通知删除成功！");
            } else {
                session.setAttribute("error", "通知删除失败，请稍后再试！");
            }
            response.sendRedirect("NotificationController?action=list");
        }
    }
}
