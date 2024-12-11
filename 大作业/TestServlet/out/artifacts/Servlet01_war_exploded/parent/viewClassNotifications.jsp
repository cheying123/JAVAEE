<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.myapplication.util.DatabaseUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>查看班级通知</title>
    <style>
        .container {
            margin: 20px auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            width: 80%;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }
        th {
            background-color: #f4f4f4;
        }
        .no-notifications {
            text-align: center;
            color: #888;
            font-size: 16px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>班级通知</h2>
    <table>
        <thead>
        <tr>
            <th>通知标题</th>
            <th>通知内容</th>
            <th>发布时间</th>
        </tr>
        </thead>
        <tbody>
        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            try {
                conn = DatabaseUtil.getConnection();
                Integer parentId = (Integer) session.getAttribute("parentId"); // 获取家长ID
                String query = "SELECT c.title, c.content, c.created_at FROM class_notifications c " +
                        "JOIN parent_classes p ON c.class_id = p.class_id " +
                        "WHERE p.parent_id = ? ORDER BY c.created_at DESC";
                stmt = conn.prepareStatement(query);
                stmt.setInt(1, parentId);
                rs = stmt.executeQuery();

                boolean hasNotifications = false;
                while (rs.next()) {
                    hasNotifications = true;
        %>
        <tr>
            <td><%= rs.getString("title") %></td>
            <td><%= rs.getString("content") %></td>
            <td><%= rs.getTimestamp("created_at") %></td>
        </tr>
        <%
            }
            if (!hasNotifications) {
        %>
        <tr>
            <td colspan="3" class="no-notifications">当前没有班级通知。</td>
        </tr>
        <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        %>
        <tr>
            <td colspan="3" class="no-notifications">加载失败，请稍后重试。</td>
        </tr>
        <%
            } finally {
                DatabaseUtil.close(conn, stmt, rs);
            }
        %>
        </tbody>
    </table>
</div>
</body>
</html>
