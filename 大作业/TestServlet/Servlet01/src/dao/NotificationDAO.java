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


    public List<Notification> getAdminNotifications() throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Notification> notifications = new ArrayList<>();
        try {
            conn = DatabaseUtil.getConnection();
            String query = "SELECT id, title, content, created_at FROM admin_notifications";
            stmt = conn.prepareStatement(query);
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

    public List<Notification> getClassNotificationsByParent(int parentId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Notification> notifications = new ArrayList<>();
        try {
            conn = DatabaseUtil.getConnection();
            String query = "SELECT c.title, c.content, c.created_at FROM class_notifications c " +
                    "JOIN parent_classes p ON c.class_id = p.class_id " +
                    "WHERE p.parent_id = ? ORDER BY c.created_at DESC";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, parentId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Notification notification = new Notification();
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

    public List<Notification> getClassNotifications(int userId, String role, String title, String content, String startDate, String endDate) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Notification> notifications = new ArrayList<>();

        try {
            conn = DatabaseUtil.getConnection();
            String query = null;
            // 构建 SQL 查询语句
            if (role.equals("parent")) {
                query = "SELECT c.title, c.content, c.created_at FROM class_notifications c " +
                        "JOIN parent_classes p ON c.class_id = p.class_id " +
                        "WHERE p.parent_id = ?";
            } else if (role.equals("teacher")) {
                query = "SELECT c.title, c.content, c.created_at " +
                        "FROM class_notifications c " +
                        "JOIN teacher_classes tc ON c.class_id = tc.class_id " +
                        "JOIN classes cl ON c.class_id = cl.id " +
                        "WHERE (tc.teacher_id = ? AND tc.approval_status = 'approved') " +
                        "OR (cl.teacher_id = ?)";

            }

            // 根据条件拼接查询
            if (title != null && !title.isEmpty()) {
                query += " AND c.title LIKE ?";
            }
            if (content != null && !content.isEmpty()) {
                query += " AND c.content LIKE ?";
            }
            if (startDate != null && !startDate.isEmpty()) {
                query += " AND c.created_at >= ?";
            }
            if (endDate != null && !endDate.isEmpty()) {
                query += " AND c.created_at <= ?";
            }

            stmt = conn.prepareStatement(query);

            // 设置查询参数
            stmt.setInt(1, userId);
            if (role.equals("teacher")){
                stmt.setInt(2, userId);  // 同样设置教师ID，分别用于条件
            }
            int index = 2;
            if( role.equals("teacher") ){
                index += 1;
            }
            if (title != null && !title.isEmpty()) {
                stmt.setString(index++, "%" + title + "%");
            }
            if (content != null && !content.isEmpty()) {
                stmt.setString(index++, "%" + content + "%");
            }
            if (startDate != null && !startDate.isEmpty()) {
                stmt.setDate(index++, Date.valueOf(startDate));
            }
            if (endDate != null && !endDate.isEmpty()) {
                stmt.setDate(index++, Date.valueOf(endDate));
            }

            rs = stmt.executeQuery();
            while (rs.next()) {
                Notification notification = new Notification();
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



}
