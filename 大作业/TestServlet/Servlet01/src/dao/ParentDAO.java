package dao;

import com.example.myapplication.util.DatabaseUtil;
import model.Parent;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ParentDAO {
    public List<Parent> getParentbySameClass(int tercherId) throws SQLException {
        List<Parent> parents = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String query = "SELECT DISTINCT u.id, u.username \n" +
                    "FROM users u\n" +
                    "INNER JOIN parent_classes pc ON u.id = pc.parent_id\n" +
                    "WHERE pc.class_id IN (\n" +
                    "    SELECT id FROM classes WHERE teacher_id = ? \n" +
                    "    UNION \n" +
                    "    SELECT class_id FROM teacher_classes WHERE teacher_id = ?\n" +
                    ")\n";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, tercherId);  // 班级创建者
            stmt.setInt(2, tercherId);  // 加入该班级的老师
            rs = stmt.executeQuery();


            while (rs.next()) {
                Parent parent = new Parent();
                parent.setId(rs.getInt("id"));
                parent.setUsername(rs.getString("username"));
                parents.add(parent);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, stmt, rs);
        }
        return parents;
    }
}
