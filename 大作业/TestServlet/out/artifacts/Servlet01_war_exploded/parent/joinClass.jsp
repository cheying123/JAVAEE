<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Class" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>加入班级</title>
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
            width: 60%;
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
            background-color: #4caf50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #43a047;
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
    <h2>加入班级</h2>
    <%
        List<Class> availableClasses = (List<Class>) request.getAttribute("availableClasses");
        if (availableClasses != null && !availableClasses.isEmpty()) {
    %>
    <!-- 表头仅显示一次 -->
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>班级名称</th>
            <th>班级简述</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (Class c : availableClasses) {
        %>
        <tr>
            <td><%= c.getId() %></td>
            <td><%= c.getClassName() %></td>
            <td><%= c.getClassBriefly() %></td>
            <td><%= c.getStatus() %></td>
            <td>
                <form method="post" action="${pageContext.request.contextPath}/ParentJoinClassServlet" style="display: inline;">
                    <input type="hidden" name="class_id" value="<%= c.getId() %>">
                    <button type="submit" class="btn">申请加入</button>
                </form>
            </td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <%
    } else {
    %>
    <p>没有可加入的班级。</p>
    <%
        }
    %>

    <a href="../parent.jsp" class="back-btn">返回主页</a>
</div>
</body>
</html>
