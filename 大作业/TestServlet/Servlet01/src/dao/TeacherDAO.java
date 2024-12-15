package dao;

import com.example.myapplication.util.DatabaseUtil;

import model.Teacher;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TeacherDAO {

    // 获取待审核的教师列表
    public List<Teacher> getPendingTeachers() throws SQLException {
        List<Teacher> teachers = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String query = "SELECT id, username, created_at, status FROM users WHERE (role = 'teacher' OR role = 'admin') AND status = 'pending'";
            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Teacher teacher = new Teacher();
                teacher.setId(rs.getInt("id"));
                teacher.setUsername(rs.getString("username"));
                teacher.setCreatedAt(rs.getString("created_at"));
                teacher.setStatus(rs.getString("status"));
                teachers.add(teacher);
            }
        } finally {
            DatabaseUtil.close(conn, stmt, rs);
        }

        return teachers;
    }

    // 更新教师的审核状态
    public void updateTeacherStatus(int id, String action) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();
            String updateQuery;
            if ("approve".equals(action)) {
                updateQuery = "UPDATE users SET status = 'approved' WHERE id = ?";
            } else if ("deny".equals(action)) {
                updateQuery = "DELETE FROM users WHERE id = ?";
            } else {
                throw new IllegalArgumentException("未知操作: " + action);
            }

            stmt = conn.prepareStatement(updateQuery);
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } finally {
            DatabaseUtil.close(conn, stmt, null);
        }
    }

    // 获取同班的教师列表
    public List<Teacher> getTeachersbySameClass(int parentId) throws SQLException {
        List<Teacher> teachers = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            // 修改后的查询，包括了班级老师和创建班级的老师
            String query = "SELECT id, username FROM users WHERE id IN ( " +
                    "SELECT teacher_id FROM teacher_classes WHERE class_id IN " +
                    "(SELECT class_id FROM parent_classes WHERE parent_id = ?) " +
                    ") OR id IN (" +
                    "SELECT teacher_id FROM classes WHERE id IN " +
                    "(SELECT class_id FROM parent_classes WHERE parent_id = ?) " +
                    ")";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, parentId);
            stmt.setInt(2, parentId);  // 第二次传入parentId用于查询创建班级的老师
            rs = stmt.executeQuery();


            while (rs.next()) {
                Teacher teacher = new Teacher();
                teacher.setId(rs.getInt("id"));
                teacher.setUsername(rs.getString("username"));
                teachers.add(teacher);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, stmt, rs);
        }
        return teachers;
    }
}
