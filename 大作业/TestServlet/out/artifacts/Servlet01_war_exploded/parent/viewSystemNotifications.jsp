<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Notification" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>查看系统通知</title>
    <style>
        /* 引入你提供的CSS样式 */
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
            // 获取通知数据并展示
            List<Notification> notifications = (List<Notification>) request.getAttribute("Adminnotifications");
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
            <td colspan="3" class="error-message">没有系统通知。</td>
        </tr>
        <%
            }

            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <tr>
            <td colspan="3" class="error-message"><%= error %></td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <a href="../parent.jsp" class="back-btn">返回上一页</a>
</div>
</body>
</html>
