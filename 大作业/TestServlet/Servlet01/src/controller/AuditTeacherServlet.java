package controller;

import model.Teacher;
import service.AuditTeacherService;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

// 审核教师的 Servlet
public class AuditTeacherServlet extends HttpServlet {
    private final AuditTeacherService auditTeacherService = new AuditTeacherService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 获取待审核教师列表
            List<Teacher> pendingTeachers = auditTeacherService.getPendingTeachers();
            request.setAttribute("pendingTeachers", pendingTeachers);

            // 转发到 JSP 页面
            request.getRequestDispatcher("/admin/AuditTeacherRegistration.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("获取待审核教师列表时出错", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int teacherId = Integer.parseInt(request.getParameter("id"));

        try {
            // 处理审核操作（通过或拒绝）
            auditTeacherService.handleTeacherApproval(teacherId, action);

            // 重定向回审核页面
            response.sendRedirect(request.getContextPath() + "/AuditTeacherServlet");
        } catch (SQLException e) {
            throw new ServletException("处理审核操作时出错", e);
        }
    }
}
