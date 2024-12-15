<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.myapplication.util.DatabaseUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Notification" %>
<%@ page import="dao.NotificationDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>查看系统通知</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(to right, #fbc2eb, #a6c1ee);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: #333;
        }

        .container {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 800px;
            padding: 30px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #4CAF50;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            text-align: left;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
        }

        th {
            background: #f4f4f4;
            text-align: center;
            font-weight: bold;
        }

        td {
            color: #555;
            text-align: center;
        }

        tr:hover {
            background: #f9f9f9;
        }

        .back-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #2196F3;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            text-align: center;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        .back-btn:hover {
            background-color: #1E88E5;
        }

        .error-message {
            text-align: center;
            color: red;
            font-weight: bold;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>系统通知</h2>
    <table>
        <thead>
        <tr>
            <th>标题</th>
            <th>通知内容</th>
            <th>发布时间</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<Notification> notifications = null;
            NotificationDAO notificationDAO = new NotificationDAO();
            try {
                // 获取系统通知
                notifications = notificationDAO.getAdminNotifications();

                // 检查通知列表是否为空
                if (notifications != null && !notifications.isEmpty()) {
                    for (Notification notification : notifications) {
        %>
        <tr>
            <td><%= notification.getTitle() %></td>
            <td><%= notification.getContent() %></td>
            <td><%= notification.getCreatedAt() %></td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="3" class="error-message">暂无通知</td>
        </tr>
        <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        %>
        <tr>
            <td colspan="3" class="error-message">加载失败，请稍后重试。</td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <a href="../teacher.jsp" class="back-btn">返回上一页</a>
</div>
</body>
</html>
