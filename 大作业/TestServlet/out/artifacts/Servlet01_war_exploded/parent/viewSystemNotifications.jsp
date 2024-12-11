<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.myapplication.util.DatabaseUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>查看系统通知</title>
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
    </style>
</head>
<body>
<div class="container">
    <h2>系统通知</h2>
    <table>
        <thead>
        <tr>
            <th>通知内容</th>
            <th>标题</th>
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
                String query = "SELECT content, title, created_at FROM admin_notifications  ORDER BY created_at DESC";
                stmt = conn.prepareStatement(query);
                rs = stmt.executeQuery();
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("content") %></td>
            <td>系统通知</td>
            <td><%= rs.getTimestamp("created_at") %></td>
        </tr>
        <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        %>
        <tr>
            <td colspan="3">加载失败，请稍后重试。</td>
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
