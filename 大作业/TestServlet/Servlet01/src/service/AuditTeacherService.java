package service;

import dao.TeacherDAO;
import model.Teacher;

import java.sql.SQLException;
import java.util.List;

// 审核教师服务类
public class AuditTeacherService {
    private final TeacherDAO teacherDAO;

    // 构造方法，初始化 TeacherDAO
    public AuditTeacherService() {
        this.teacherDAO = new TeacherDAO();
    }

    // 获取待审核教师列表
    public List<Teacher> getPendingTeachers() throws SQLException {
        return teacherDAO.getPendingTeachers();
    }

    // 处理教师审核操作（通过或拒绝）
    public void handleTeacherApproval(int id, String action) throws SQLException {
        teacherDAO.updateTeacherStatus(id, action);
    }
}
