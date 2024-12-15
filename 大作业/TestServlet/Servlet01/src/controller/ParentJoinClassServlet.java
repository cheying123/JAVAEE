package controller;

import dao.ParentClassDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Class;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class ParentJoinClassServlet extends HttpServlet {

    private final ParentClassDAO parentClassDAO = new ParentClassDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取家长ID和班级ID
        int classId = Integer.parseInt(request.getParameter("class_id"));
        int parentId = (Integer) request.getSession().getAttribute("parentId");

        // 调用业务逻辑层申请加入班级
        String message = null;
        try {
            message = parentClassDAO.applyForClass(parentId, classId);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        // 将消息存储在session中，供JSP页面使用
        request.getSession().setAttribute("message", message);

        // 重定向回班级列表页面
        response.sendRedirect("ToShowParentClass");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取家长ID
        int parentId = (Integer) request.getSession().getAttribute("parentId");

        try {
            // 获取家长可加入的班级列表
            List<Class> availableClasses = parentClassDAO.getAvailableClassesForParent(parentId);
            // 将班级列表存放到请求属性中
            request.setAttribute("availableClasses", availableClasses);
            // 转发请求到JSP页面
            request.getRequestDispatcher("ToShowParentClass").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            // 如果发生异常，设置错误信息
            request.setAttribute("error", "加载班级信息失败，请稍后再试！");
            // 转发到JSP页面并显示错误
            request.getRequestDispatcher("ToShowParentClass").forward(request, response);
        }
    }
}
