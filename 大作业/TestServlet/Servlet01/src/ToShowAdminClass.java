import dao.ClassDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Class;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class ToShowAdminClass extends HttpServlet {
    public void doGet(HttpServletRequest request,
                      HttpServletResponse response)
            throws ServletException, IOException
    {
        // 设置响应内容类型
        response.setContentType("text/html");
        ClassDAO auditClassDAO = new ClassDAO();
        List<Class> res = null;
        try {
            res = auditClassDAO.getPendingClasses();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        if(res != null && !res.isEmpty()){
            request.setAttribute("classList",res);
        }
        request.getRequestDispatcher("admin/AuditClassCreation.jsp").forward(request, response);
    }
}
