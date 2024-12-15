

import dao.ParentClassDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Class;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class ToShowParentClass extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置响应内容类型
        response.setContentType("text/html");

        // 创建ParentClassDAO对象
        ParentClassDAO parentClassDAO = new ParentClassDAO();
        List<Class> availableClasses = null;

        try {
            // 获取家长可以加入的班级列表
            int parentId = (Integer) request.getSession().getAttribute("parentId"); // 获取当前登录的家长ID
            availableClasses = parentClassDAO.getAvailableClassesForParent(parentId); // 查询可加入的班级
        } catch (SQLException e) {
            throw new RuntimeException("加载班级信息失败", e);
        }

        // 将结果传递给JSP页面
        if (availableClasses != null && !availableClasses.isEmpty()) {
            request.setAttribute("availableClasses", availableClasses); // 存储可加入的班级列表
        }

        // 将请求转发到JSP页面进行展示
        request.getRequestDispatcher("parent/joinClass.jsp").forward(request, response);
    }
}
