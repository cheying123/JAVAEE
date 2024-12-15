package dao;

import model.Message;
import com.example.myapplication.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {
    public List<Message> queryMessages(Integer userId, String sender, String receiver, String dateFrom, String dateTo, boolean isSender,String content) {
        List<Message> messages = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            StringBuilder query = new StringBuilder(
                    "SELECT u1.username AS sender, u2.username AS receiver, m.content, m.created_at " +
                            "FROM messages m " +
                            "JOIN users u1 ON m.sender_id = u1.id " +
                            "JOIN users u2 ON m.receiver_id = u2.id " +
                            "WHERE 1=1 "
            );

            // 当前用户是发送方或接收方
            if (isSender) {
                query.append("AND m.sender_id = ? ");
            } else {
                query.append("AND m.receiver_id = ? ");
            }

            if (sender != null && !sender.isEmpty()) {
                query.append("AND u1.username LIKE ? ");
            }
            if (receiver != null && !receiver.isEmpty()) {
                query.append("AND u2.username LIKE ? ");
            }
            if (dateFrom != null && !dateFrom.isEmpty()) {
                query.append("AND m.created_at >= ? ");
            }
            if (dateTo != null && !dateTo.isEmpty()) {
                query.append("AND m.created_at <= ? ");
            }
            if (content != null && !content.isEmpty()) {
                query.append(" AND m.content LIKE ?");
            }

            stmt = conn.prepareStatement(query.toString());
            int paramIndex = 1;

            // 当前用户的 ID
            stmt.setInt(paramIndex++, userId);

            if (sender != null && !sender.isEmpty()) {
                stmt.setString(paramIndex++, "%" + sender + "%");
            }
            if (receiver != null && !receiver.isEmpty()) {
                stmt.setString(paramIndex++, "%" + receiver + "%");
            }
            if (dateFrom != null && !dateFrom.isEmpty()) {
                stmt.setDate(paramIndex++, Date.valueOf(dateFrom));
            }
            if (dateTo != null && !dateTo.isEmpty()) {
                stmt.setDate(paramIndex++, Date.valueOf(dateTo));
            }
            if (content != null && !content.isEmpty()) {
                stmt.setString(paramIndex++, "%" + content + "%");
            }

            rs = stmt.executeQuery();
            while (rs.next()) {
                Message message = new Message();
                message.setSender(rs.getString("sender"));
                message.setReceiver(rs.getString("receiver"));
                message.setContent(rs.getString("content"));
                message.setCreatedAt(rs.getTimestamp("created_at"));
                messages.add(message);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, stmt, rs);
        }
        return messages;
    }

    public String sendMessage(int senderId,int receiverId,String content){
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();

            // 插入消息到 messages 表
            String insertQuery = "INSERT INTO messages (sender_id, receiver_id, content, created_at) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(insertQuery);
            stmt.setInt(1, senderId);
            stmt.setInt(2, receiverId);
            stmt.setString(3, content);
            stmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));  // 当前时间

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                return "消息发送成功！";
            } else {
                return  "消息发送失败，请稍后重试！";
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "服务器错误，请稍后重试！";
        } finally {
            DatabaseUtil.close(conn, stmt, null);
        }
    }
}
