package dao;

import com.example.myapplication.util.DatabaseUtil;
import model.Notification;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {
    public boolean addNotification(int adminId, String title, String content) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DatabaseUtil.getConnection();
            String query = "INSERT INTO admin_notifications (admin_id, title, content) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, adminId);
            stmt.setString(2, title);
            stmt.setString(3, content);
            return stmt.executeUpdate() > 0;
        } finally {
            DatabaseUtil.close(conn, stmt, null);
        }
    }

    public List<Notification> getNotificationsByAdmin(int adminId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Notification> notifications = new ArrayList<>();
        try {
            conn = DatabaseUtil.getConnection();
            String query = "SELECT id, title, content, created_at FROM admin_notifications WHERE admin_id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, adminId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Notification notification = new Notification();
                notification.setId(rs.getInt("id"));
                notification.setTitle(rs.getString("title"));
                notification.setContent(rs.getString("content"));
                notification.setCreatedAt(rs.getTimestamp("created_at"));
                notifications.add(notification);
            }
        } finally {
            DatabaseUtil.close(conn, stmt, rs);
        }
        return notifications;
    }

    public boolean deleteNotification(int notificationId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DatabaseUtil.getConnection();
            String query = "DELETE FROM admin_notifications WHERE id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, notificationId);
            return stmt.executeUpdate() > 0;
        } finally {
            DatabaseUtil.close(conn, stmt, null);
        }
    }

}
