import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Notification;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class ToShowAdminNotification extends HttpServlet {
    public void doGet(HttpServletRequest request,
                      HttpServletResponse response)
            throws ServletException, IOException
    {
        // 设置响应内容类型
        response.setContentType("text/html");
        NotificationDAO Notification = new NotificationDAO();
        List<Notification> res = null;

        HttpSession session = request.getSession();
        Integer adminId = (Integer) session.getAttribute("adminId");

        try {
            res = Notification.getNotificationsByAdmin(adminId);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        if(res != null && !res.isEmpty()){
            request.setAttribute("notifications",res);
        }
        request.getRequestDispatcher("admin/manageNotifications.jsp").forward(request, response);
    }
}
