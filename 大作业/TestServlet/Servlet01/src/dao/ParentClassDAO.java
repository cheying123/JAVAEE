package dao;

import com.example.myapplication.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Class;

public class ParentClassDAO {

    // 申请加入班级
    public String applyForClass(int parentId, int classId) throws SQLException {
        String checkQuery = "SELECT COUNT(*) FROM parent_classes WHERE parent_id = ? AND class_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(checkQuery)) {
            stmt.setInt(1, parentId);
            stmt.setInt(2, classId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return "您已经加入该班级！";
                }
            }
        }

        String insertQuery = "INSERT INTO parent_classes (parent_id, class_id) VALUES (?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(insertQuery)) {
            stmt.setInt(1, parentId);
            stmt.setInt(2, classId);
            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0 ? "加入班级申请成功！" : "加入班级申请失败，请稍后再试！";
        }
    }

    // 获取家长可加入的班级列表
    public List<Class> getAvailableClassesForParent(int parentId) throws SQLException {
        List<Class> classList = new ArrayList<>();
        String query = "SELECT c.id, c.class_name, c.class_briefly, c.status " +
                "FROM classes c WHERE c.status = 'approved' " +
                "AND NOT EXISTS (SELECT 1 FROM parent_classes pc WHERE pc.parent_id = ? AND pc.class_id = c.id)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, parentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Class newClass = new Class();
                    newClass.setId(rs.getInt("id"));
                    newClass.setClassName(rs.getString("class_name"));
                    newClass.setClassBriefly(rs.getString("class_briefly"));
                    newClass.setStatus(rs.getString("status"));
                    classList.add(newClass);
                }
            }
        }
        return classList;
    }
}
