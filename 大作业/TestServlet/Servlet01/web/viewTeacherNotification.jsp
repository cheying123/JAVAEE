<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.myapplication.util.DatabaseUtil" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>查看通知</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background-color: #fbc2eb;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            width: 80%;
            max-width: 900px;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }

        .notification-content {
            margin-bottom: 30px;
            font-size: 16px;
            line-height: 1.6;
        }

        .back-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #2196f3;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            text-align: center;
        }

        .back-btn:hover {
            background-color: #1e88e5;
        }

    </style>
</head>
<body>
<div class="container">
    <h2>通知详情</h2>

    <%
        String notificationIdStr = request.getParameter("id");
        if (notificationIdStr == null || notificationIdStr.isEmpty()) {
            response.getWriter().println("<p>无效的通知ID</p>");
        } else {
            int notificationId = Integer.parseInt(notificationIdStr);
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            try {
                conn = DatabaseUtil.getConnection();
                String query = "SELECT * FROM class_notifications WHERE id = ?";
                stmt = conn.prepareStatement(query);
                stmt.setInt(1, notificationId);
                rs = stmt.executeQuery();

                if (rs.next()) {
    %>
    <div class="notification-content">
        <h3><%= rs.getString("title") %></h3>
        <p><%= rs.getString("content") %></p>
        <p><strong>发布时间:</strong> <%= rs.getTimestamp("created_at") %></p>
    </div>
    <%
                } else {
                    response.getWriter().println("<p>找不到该通知</p>");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().println("<p>查询错误，请稍后再试。</p>");
            } finally {
                DatabaseUtil.close(conn, stmt, rs);
            }
        }
    %>

    <a href="teacher/manageClassNotifications.jsp" class="back-btn">返回通知管理</a>
</div>
</body>
</html>
