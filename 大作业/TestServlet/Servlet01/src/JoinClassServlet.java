
import com.example.myapplication.util.DatabaseUtil;
import dao.TeacherDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

public class JoinClassServlet extends HttpServlet {

    // 处理POST请求
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int classId = Integer.parseInt(request.getParameter("class_id"));
        Integer teacherId = (Integer) request.getSession().getAttribute("teacherId");

        if (teacherId == null) {
            response.sendRedirect("../index.jsp");  // 如果没有登录，跳转到登录页面
            return;
        }
        TeacherDAO teacherDAO = new TeacherDAO();
        try {
            conn = DatabaseUtil.getConnection();

            // 检查是否已经申请该班级
            String checkQuery = "SELECT approval_status FROM teacher_classes WHERE teacher_id = ? AND class_id = ?";
            stmt = conn.prepareStatement(checkQuery);
            stmt.setInt(1, teacherId);
            stmt.setInt(2, classId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String approvalStatus = rs.getString("approval_status");
                if ("pending".equals(approvalStatus)) {
                    request.getSession().setAttribute("error", "您已经申请过该班级，待审核中");
                } else if ("approved".equals(approvalStatus)) {
                    request.getSession().setAttribute("error", "您已经加入该班级");
                } else if ("rejected".equals(approvalStatus)) {
                    request.getSession().setAttribute("error", "您曾申请加入该班级，但被拒绝");
                }
            } else {
                // 插入申请记录
                String fin  = teacherDAO.TeacherJoinClass(teacherId,classId);


                if (fin.equals("true")) {
                    request.getSession().setAttribute("message", "您的加入申请已提交，待审核");
                } else {
                    request.getSession().setAttribute("error", "加入班级失败，请稍后再试");
                }
            }

            // 重定向回班级加入页面
            response.sendRedirect(request.getContextPath() + "/teacher/joinClass.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "数据库操作错误，请稍后重试");
            response.sendRedirect(request.getContextPath() + "/teacher/joinClass.jsp");
        } finally {
            DatabaseUtil.close(conn, stmt, rs);
        }
    }


}
