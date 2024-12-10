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
        }

        .container {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            width: 400px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
        }

        .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .btn {
            display: block;
            width: 100%;
            padding: 10px;
            background-color: #4caf50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
        }

        .btn:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>创建班级</h2>
    <form method="post" action="${pageContext.request.contextPath}/CreateClassServlet">
        <div class="form-group">
            <label for="className">班级名称</label>
            <input type="text" id="className" name="className" placeholder="请输入班级名称" required>
        </div>
        <div class="form-group">
            <label for="className">班级简述</label>
            <input type="text" id="class_briefly" name="class_briefly" placeholder="请输入班级简述" required>
        </div>
        <button type="submit" class="btn">提交</button>
    </form>
    <div id="result" class="msgres">
        <%
            // 从请求中获取错误信息
            String errorMessage = (String) request.getAttribute("error");
            if (errorMessage != null && !errorMessage.isEmpty()) {
        %>
        <p style="color: red;"><%= errorMessage %></p>
        <%
            }
        %>
    </div>
    <div id="result_message" class="msgres">
        <%
            // 从请求中获取错误信息
            String message = (String) request.getAttribute("message");
            if (message != null && !message.isEmpty()) {
        %>
        <p style="color: red;"><%= message %></p>
        <%
            }
        %>
    </div>
    <a href="${pageContext.request.contextPath}/teacher.jsp" class="back-btn">返回教师界面</a>
</div>
</body>
</html>
