import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import dao.ClassDAO;

@WebServlet("/AuditClassServlet")
public class AuditClassServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int classId = Integer.parseInt(request.getParameter("classId"));

        ClassDAO classDAO = new ClassDAO();
        try {
            boolean isUpdated = false;
            if ("approve".equals(action)) {
                isUpdated = classDAO.updateClassStatus(classId, "approved");
            } else if ("deny".equals(action)) {
                isUpdated = classDAO.updateClassStatus(classId, "rejected");
            }

            if (isUpdated) {
                request.getSession().setAttribute("message", "班级审核成功！");
            } else {
                request.getSession().setAttribute("error", "班级审核失败，请重试！");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "数据库操作错误，请稍后重试！");
        }

        // 重定向到审核页面
        response.sendRedirect("admin/AuditClassCreation.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ClassDAO classDAO = new ClassDAO();
            // 获取待审核的班级数据
        try {
            request.setAttribute("classList", classDAO.getPendingClasses());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        // 转发到 JSP 页面
        request.getRequestDispatcher("admin/AuditClassCreation.jsp").forward(request, response);
    }
}
