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
}
