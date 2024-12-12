package dao;

import com.example.myapplication.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginDAO {

    /**
     * 根据用户名和角色查找用户
     */
    public ResultSet findUserByUsernameAndRole(String username, String role) throws SQLException {
        String query = "SELECT * FROM users WHERE username = ? AND role = ?";
        Connection conn = DatabaseUtil.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setString(1, username);
        pstmt.setString(2, role);
        return pstmt.executeQuery();
    }

    /**
     * 验证用户密码
     */
    public ResultSet validateUserPassword(String username, String password) throws SQLException {
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";
        Connection conn = DatabaseUtil.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setString(1, username);
        pstmt.setString(2, password);
        return pstmt.executeQuery();
    }

    /**
     * 检查用户审核状态
     */
    public ResultSet checkUserApprovalStatus(String username, String password) throws SQLException {
        String query = "SELECT * FROM users WHERE username = ? AND password = ? AND (status = 'approved' || role = 'parent')";
        Connection conn = DatabaseUtil.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setString(1, username);
        pstmt.setString(2, password);
        return pstmt.executeQuery();
    }

    /**
     * 根据用户名和角色获取用户ID
     */
    public int getUserId(String username, String role) throws SQLException {
        String query = "SELECT id FROM users WHERE username = ? AND role = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, username);
            pstmt.setString(2, role);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }
        return -1; // 返回 -1 表示未找到用户
    }
}
