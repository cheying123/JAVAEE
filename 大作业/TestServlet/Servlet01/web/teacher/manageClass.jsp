<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Class" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>班级管理</title>
    <style>
        * {
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background-image: linear-gradient(to right, #fbc2eb, #a6c1ee);
            min-height: 100vh;
        }

        .container {
            margin: 50px auto;
            width: 80%;
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            text-align: center;
            border: 1px solid #ddd;
        }

        th {
            background-color: #f4f4f4;
        }

        .btn {
            padding: 5px 10px;
            background-color: #f44336; /* 红色的删除按钮 */
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn:hover {
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
    </style>
</head>
<body>
<div class="container">
    <h2>班级管理</h2>
    <table>
        <thead>
        <tr>
            <th>班级ID</th>
            <th>班级名称</th>
            <th>班级简述</th>
            <th>教师ID</th>
            <th>状态</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<Class> classes = (List<Class>) request.getAttribute("Classes");
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
            <td colspan="6">暂无班级数据。</td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <a href="${pageContext.request.contextPath}/teacher.jsp" class="back-btn">返回教师界面</a>
</div>
</body>
</html>
