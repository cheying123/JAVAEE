package dao;

import com.example.myapplication.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Class;

public class ClassDAO {

    public List<Class> getPendingClasses() throws SQLException {
        List<Class> classList = new ArrayList<>();
        String query = "SELECT c.id, c.class_name, c.created_at, c.status, c.teacher_id, u.username, c.class_briefly " +
                "FROM classes c " +
                "JOIN users u ON c.teacher_id = u.id WHERE c.status = 'pending'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Class newClass = new Class();
                newClass.setId(rs.getInt("id"));
                newClass.setClassName(rs.getString("class_name"));
                newClass.setCreatedAt(rs.getString("created_at"));
                newClass.setStatus(rs.getString("status"));
                newClass.setTeacherId(rs.getInt("teacher_id"));
                newClass.setTeacherName(rs.getString("username"));
                newClass.setClassBriefly(rs.getString("class_briefly"));
                classList.add(newClass);
            }
        }
        return classList;
    }

    public boolean updateClassStatus(int classId, String status) throws SQLException {
        String updateQuery = "UPDATE classes SET status = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(updateQuery)) {
            stmt.setString(1, status);
            stmt.setInt(2, classId);
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        }
    }

    // 下面为老师的功能

    // 检查班级名是否存在
    public boolean isClassNameExists(String className) throws SQLException {
        String query = "SELECT COUNT(*) FROM classes WHERE class_name = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, className);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    // 创建班级
    public boolean createClass(String className, int teacherId, String classBriefly) throws SQLException {
        String query = "INSERT INTO classes (class_name, teacher_id, status, class_briefly) VALUES (?, ?, 'pending', ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, className);
            stmt.setInt(2, teacherId);
            stmt.setString(3, classBriefly);
            return stmt.executeUpdate() > 0;
        }
    }



}
