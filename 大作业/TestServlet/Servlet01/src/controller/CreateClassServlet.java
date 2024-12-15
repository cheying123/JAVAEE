package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.ClassService;

import java.io.IOException;

@WebServlet("/CreateClassController")
public class CreateClassServlet extends HttpServlet {

    private final ClassService classService = new ClassService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取表单数据
        String className = request.getParameter("className");
        String classBriefly = request.getParameter("class_briefly");
        Integer teacherId = (Integer) request.getSession().getAttribute("teacherId");

        // 防止 teacherId 未登录异常
        if (teacherId == null) {
            request.setAttribute("error", "您尚未登录，请重新登录！");
            request.getRequestDispatcher("teacher/createClass.jsp").forward(request, response);
            return;
        }

        try {
            // 调用服务层处理创建班级的逻辑
            String result = classService.createClass(className, teacherId, classBriefly);

            if ("success".equals(result)) {
                request.setAttribute("message", "班级创建成功，请等待管理员审核！");
            } else {
                request.setAttribute("error", result);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "系统错误：班级创建失败，请稍后重试！");
        }

        // 转发回 JSP 显示结果
        request.getRequestDispatcher("teacher/createClass.jsp").forward(request, response);
    }
}
