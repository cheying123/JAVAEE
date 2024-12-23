<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>管理员界面</title>
    <style>
        * {
            margin: 0;
            padding: 0;
        }
        html {
            height: 100%;
        }
        body {
            height: 100%;
        }
        .container {
            height: 100%;
            background-image: linear-gradient(to right, #fbc2eb, #a6c1ee);
        }
        .login-wrapper {
            background-color: #fff;
            width: 358px;
            min-height: 400px;
            border-radius: 15px;
            padding: 30px 20px;
            position: relative;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }
        .header {
            font-size: 28px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
            color: #555;
        }
        .menu-item {
            display: block;
            padding: 15px;
            margin: 10px 0;
            background-color: #f1f1f1;
            text-align: center;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            color: #555;
            text-decoration: none;
        }
        .menu-item:hover {
            background-color: #a6c1ee;
            color: #fff;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="login-wrapper">
        <div class="header">管理员功能界面</div>
        <a href="ToShowAdminTeacher" class="menu-item">审核教师注册</a>
        <a href="ToShowAdminClass" class="menu-item">审核班级创建</a>
        <a href="ToShowAdminNotification" class="menu-item">管理系统通知</a>
        <a href="index.jsp" class="menu-item">退出登录</a>
    </div>
</div>
</body>
</html>
