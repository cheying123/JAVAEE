<%@ page import="model.Notification" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>查看班级通知</title>
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
            List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
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
            <td colspan="3" class="no-notifications">当前没有班级通知。</td>
        </tr>
        <%
            }

            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <tr>
            <td colspan="3" class="no-notifications"><%= error %></td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <a href="../parent.jsp" class="back-btn">返回</a>
</div>
</body>
</html>
