<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Notification" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>通知管理</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background-image: linear-gradient(to right, #fbc2eb, #a6c1ee);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
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

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th, td {
            padding: 12px;
            text-align: center;
            border: 1px solid #ddd;
        }

        th {
            background-color: #f4f4f4;
        }

        .view-btn {
            padding: 6px 12px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .view-btn:hover {
            background-color: #45a049;
        }

        .delete-btn {
            padding: 6px 12px;
            background-color: #f44336;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .delete-btn:hover {
            background-color: #d32f2f;
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

        .notification-title,
        .notification-content {
            max-width: 200px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>通知管理</h2>

    <!-- 消息提示 -->
    <%
        String message = (String) session.getAttribute("message");
        String error = (String) session.getAttribute("error");
        if (message != null) {
    %>
    <div class="message success"><%= message %></div>
    <% session.removeAttribute("message"); }
    else if (error != null) {
    %>
    <div class="message error"><%= error %></div>
    <% session.removeAttribute("error"); }
    %>

    <!-- 通知列表 -->
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>标题</th>
            <th>内容</th>
            <th>发布时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <%
            // 获取通知列表
            List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
            if (notifications != null) {
                for (Notification notification : notifications) {
        %>
        <tr>
            <td><%= notification.getId() %></td>
            <td class="notification-title"><%= notification.getTitle() %></td>
            <td class="notification-content"><%= notification.getContent() %></td>
            <td><%= notification.getCreatedAt() %></td>
            <td>
                <a href="viewAdminNotification.jsp?id=<%= notification.getId() %>" class="view-btn">查看详情</a>
                <form action="DeleteAdminNotification" method="post" style="display:inline;">
                    <input type="hidden" name="notification_id" value="<%= notification.getId() %>">
                    <button type="submit" class="delete-btn">删除</button>
                </form>
            </td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>

    <a href="admin/addNotification.jsp" class="back-btn">发布通知</a>
    <a href="admin.jsp" class="back-btn">返回管理员界面</a>
</div>
</body>
</html>
