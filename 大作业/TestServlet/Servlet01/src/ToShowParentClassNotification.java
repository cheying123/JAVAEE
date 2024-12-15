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

public class ToShowParentClassNotification extends HttpServlet {
    public void doGet(HttpServletRequest request,
                      HttpServletResponse response)
            throws ServletException, IOException
    {
        // 设置响应内容类型
        response.setContentType("text/html");

        // 创建 NotificationDAO 实例
        NotificationDAO notificationDAO = new NotificationDAO();
        List<Notification> res = null;

        // 获取当前会话的家长ID
        HttpSession session = request.getSession();
        Integer parentId = (Integer) session.getAttribute("parentId");

        // 获取家长相关的班级通知
        try {
            res = notificationDAO.getClassNotificationsByParent(parentId);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("数据库操作失败", e);
        }

        // 如果查询到通知，将结果放入请求属性中
        if (res != null && !res.isEmpty()) {
            request.setAttribute("notifications", res);
        } else {
            request.setAttribute("error", "没有找到任何通知。");
        }

        // 转发到家长通知页面
        request.getRequestDispatcher("parent/viewClassNotifications.jsp").forward(request, response);
    }
}
