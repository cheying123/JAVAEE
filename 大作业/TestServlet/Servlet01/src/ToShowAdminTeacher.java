import dao.TeacherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Class;
import model.Teacher;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class ToShowAdminTeacher extends HttpServlet {
    public void doGet(HttpServletRequest request,
                      HttpServletResponse response)
            throws ServletException, IOException
    {
        // 设置响应内容类型
        response.setContentType("text/html");
        TeacherDAO auditTeacherDAO = new TeacherDAO();
        List<Teacher> res = null;
        try {
            res = auditTeacherDAO.getPendingTeachers();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        if(res != null && !res.isEmpty()){
            request.setAttribute("TeacherList",res);
        }
        request.getRequestDispatcher("admin/AuditTeacherRegistration.jsp").forward(request, response);
    }
}
