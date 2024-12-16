package controller;

import dao.NotificationDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Notification;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class SearchClassNotifications extends HttpServlet {

    // 处理查询班级通知的请求
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("parentId");
        String role = "parent";
        if ( userId == null){
            userId = (Integer) session.getAttribute("teacherId");
            role = "teacher";
        }

        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 获取查询参数
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");



        try {
            NotificationDAO notificationDAO = new NotificationDAO();
            List<Notification> notifications = notificationDAO.getClassNotifications(userId,role ,title,content, startDate, endDate);

            // 将查询结果传递到 JSP
            request.setAttribute("notifications", notifications);
            if( role.equals("parent") ){
                RequestDispatcher dispatcher = request.getRequestDispatcher("parent/classNotificationsQuery.jsp");
                dispatcher.forward(request, response);
            } else if (role.equals("teacher")) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("teacher/classNotificationsQuery.jsp");
                dispatcher.forward(request, response);
            }


        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "加载通知时发生错误，请稍后重试。");
            if( role.equals("parent") ){
                RequestDispatcher dispatcher = request.getRequestDispatcher("parent/classNotificationsQuery.jsp");
                dispatcher.forward(request, response);
            } else if (role.equals("teacher")) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("teacher/classNotificationsQuery.jsp");
                dispatcher.forward(request, response);
            }
        }
    }
}
