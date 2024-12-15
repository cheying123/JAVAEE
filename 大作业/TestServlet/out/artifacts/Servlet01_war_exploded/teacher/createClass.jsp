<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>创建班级</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: linear-gradient(to right, #fbc2eb, #a6c1ee);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
        }

        .container {
            background: #fff;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            width: 400px;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .btn {
            display: block;
            width: 100%;
            padding: 12px;
            background-color: #4caf50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            text-align: center;
        }

        .btn:hover {
            background-color: #45a049;
        }

        .back-btn {
            display: inline-block;
            margin-top: 15px;
            text-align: center;
            color: #555;
            text-decoration: none;
            font-size: 14px;
        }

        .back-btn:hover {
            text-decoration: underline;
        }

        .error-message {
            color: red;
            font-size: 14px;
            margin-bottom: 15px;
            text-align: center;
        }

        .success-message {
            color: green;
            font-size: 14px;
            margin-bottom: 15px;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>创建班级</h2>
    <!-- 表单提交到 MVC 的 Controller -->
    <form method="post" action="${pageContext.request.contextPath}/CreateClassServlet">
        <!-- 班级名称输入框 -->
        <div class="form-group">
            <label for="className">班级名称</label>
            <input type="text" id="className" name="className" placeholder="请输入班级名称" required>
        </div>

        <!-- 班级简述输入框 -->
        <div class="form-group">
            <label for="classBriefly">班级简述</label>
            <input type="text" id="classBriefly" name="class_briefly" placeholder="请输入班级简述" required>
        </div>

        <!-- 提交按钮 -->
        <button type="submit" class="btn">提交</button>
    </form>

    <!-- 错误提示信息 -->
    <div>
        <%
            // 获取错误消息并显示
            String errorMessage = (String) request.getAttribute("error");
            if (errorMessage != null && !errorMessage.isEmpty()) {
        %>
        <p class="error-message"><%= errorMessage %></p>
        <%
            }
        %>
    </div>

    <!-- 成功提示信息 -->
    <div>
        <%
            // 获取成功消息并显示
            String successMessage = (String) request.getAttribute("message");
            if (successMessage != null && !successMessage.isEmpty()) {
        %>
        <p class="success-message"><%= successMessage %></p>
        <%
            }
        %>
    </div>

    <!-- 返回按钮 -->
    <a href="${pageContext.request.contextPath}/teacher.jsp" class="back-btn">返回教师主页面</a>
</div>
</body>
</html>
