<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Class" %>
<%@ page import="dao.ClassDAO" %>
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
            width: 90%;
            max-width: 1000px;
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
            padding: 10px;
            text-align: center;
            border: 1px solid #ddd;
        }

        th {
            background-color: #f4f4f4;
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
    </style>
</head>
<body>
<div class="container">
    <h2>发布班级通知</h2>

    <!-- 消息提示 -->
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

    <!-- 班级列表 -->
    <h3>当前管理的班级</h3>
    <table>
        <thead>
        <tr>
            <th>班级ID</th>
            <th>班级名称</th>
            <th>班级简述</th>
            <th>创建教师ID</th>
            <th>班级状态</th>
        </tr>
        </thead>
        <tbody>
        <%
            Integer teacherId = (Integer) session.getAttribute("teacherId");
            ClassDAO classDAO = new ClassDAO();
            List<Class> classes = classDAO.getClassesbyTeacher(teacherId);
            if (classes != null && !classes.isEmpty()) {
                for (Class cls : classes) {
        %>
        <tr>
            <td><%= cls.getId() %></td>
            <td><%= cls.getClassName() %></td>
            <td><%= cls.getClassBriefly() %></td>
            <td><%= cls.getTeacherId() %></td>
            <td><%= cls.getStatus() %></td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="5">暂无班级数据。</td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>

    <!-- 发布通知表单 -->
    <form action="${pageContext.request.contextPath}/AddClassNotificationServlet" method="post">
        <div class="form-group">
            <label for="class_id">班级ID:</label>
            <input type="text" id="class_id" name="class_id" placeholder="请输入班级ID" required>
        </div>

        <div class="form-group">
            <label for="title">通知标题:</label>
            <input type="text" id="title" name="title" placeholder="请输入通知标题" required>
        </div>

        <div class="form-group">
            <label for="content">通知内容:</label>
            <textarea id="content" name="content" placeholder="请输入通知内容" required></textarea>
        </div>

        <button type="submit">发布通知</button>
    </form>
</div>
</body>
</html>
