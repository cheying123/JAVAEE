import dao.ClassDAO;
import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Class;
import model.Notification;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class ToShowTeacherClasses extends HttpServlet {
    public void doGet(HttpServletRequest request,
                      HttpServletResponse response)
            throws ServletException, IOException
    {
        // 设置响应内容类型
        response.setContentType("text/html");
        ClassDAO classDAO = new ClassDAO();
        List<Class> res = null;

        HttpSession session = request.getSession();
        Integer teacherId = (Integer) session.getAttribute("teacherId");

        try {
            res = classDAO.getClassesbyTeacher(teacherId);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        if(res != null && !res.isEmpty()){
            request.setAttribute("Classes",res);
        }
        request.getRequestDispatcher("teacher/manageClass.jsp").forward(request, response);
    }
}
