<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>发布通知</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap">
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
            width: 70%;
            max-width: 800px;
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

        .form-group {
            margin-bottom: 15px;
        }

        label {
            font-weight: bold;
            display: block;
            color: #333;
        }

        input[type="text"], textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            margin-top: 5px;
        }

        textarea {
            resize: vertical;
            height: 150px;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #2196f3;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #1976d2;
        }

        .message {
            text-align: center;
            margin-top: 20px;
        }

        .error {
            color: red;
        }

        .success {
            color: green;
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
    <h2>发布系统通知</h2>

    <%
        String message = (String) session.getAttribute("message");
        String error = (String) session.getAttribute("error");
        if (message != null) {
    %>
    <div class="message success"><%= message %></div>
    <% session.removeAttribute("message"); }
    else if (error != null) { %>
    <div class="message error"><%= error %></div>
    <% session.removeAttribute("error"); }
    %>

    <form action="${pageContext.request.contextPath}/AddAdminNotificationServlet" method="post">
        <div class="form-group">
            <label for="title">通知标题:</label>
            <input type="text" id="title" name="title" required>
        </div>

        <div class="form-group">
            <label for="content">通知内容:</label>
            <textarea id="content" name="content" required></textarea>
        </div>

        <button type="submit">发布通知</button>
    </form>

    <a href="${pageContext.request.contextPath}/ToShowAdminNotification" class="back-btn">返回通知管理</a>
</div>
</body>
</html>
