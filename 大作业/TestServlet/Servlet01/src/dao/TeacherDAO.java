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
}
