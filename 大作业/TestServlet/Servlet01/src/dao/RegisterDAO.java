package dao;

import com.example.myapplication.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RegisterDAO {

    /**
     * 检查用户名是否已存在
     *
     * @param username 用户名
     * @param role     用户角色
     * @return 如果存在返回 true，否则返回 false
     */
    public boolean isUsernameExists(String username, String role) {
        String query = "SELECT id FROM users WHERE username = ? AND role = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, role);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("查询用户名是否存在时出错", e);
        }
    }

    /**
     * 插入新用户
     *
     * @param username 用户名
     * @param password 密码
     * @param role     用户角色
     * @param status   用户状态
     */
    public void insertUser(String username, String password, String role, String status) {
        String query = "INSERT INTO users (username, password, role, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.setString(3, role);
            stmt.setString(4, status);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("插入用户时出错", e);
        }
    }
}
