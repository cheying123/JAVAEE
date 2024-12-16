<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.myapplication.util.DatabaseUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>老师功能界面</title>
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
            font-family: Arial, sans-serif;
        }

        .container {
            height: 100%;
            background-image: linear-gradient(to right, #fbc2eb, #a6c1ee);
        }

        .dashboard-wrapper {
            background-color: #fff;
            width: 358px;
            min-height: 500px;
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

        .section {
            margin-top: 20px;
        }

        .table-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-top: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 15px;
            text-align: center;
            border: 1px solid #ddd;
            width: 25%;  /* 可以调整为你想要的比例 */
        }


        th {
            background-color: #f4f4f4;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="dashboard-wrapper">
        <div class="header">老师功能界面</div>
        <a href="teacher/createClass.jsp" class="menu-item">创建班级</a>

        <a href="teacher/joinClass.jsp" class="menu-item">加入班级</a>
        <a href="ToShowTeacherClasses" class="menu-item">管理班级</a>
        <a href="teacher/manageJoinRequests.jsp" class="menu-item">管理班级加入申请</a>
        <a href="teacher/manageClassNotifications.jsp" class="menu-item">管理班级通知</a>

        <a href="teacher/sendMessages.jsp" class="menu-item">与家长沟通</a>
        <a href="QueryMessagesServlet" class="menu-item">查询站内消息</a>
        <a href="SearchClassNotifications" class="menu-item">查询班级通知</a>
        <a href="teacher/viewSystemNotifications.jsp" class="menu-item">查看系统通知</a>
        <a href="index.jsp" class="menu-item">退出登录</a>

    </div>
</div>
</body>
</html>
