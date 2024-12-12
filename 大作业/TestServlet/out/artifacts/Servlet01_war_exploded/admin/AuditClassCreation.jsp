<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Class" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>班级创建审核</title>
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
            background-color: #4caf50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn.deny {
            background-color: #f44336;
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
    <h2>班级创建审核</h2>
    <table>
        <thead>
        <tr>
            <th>班级名称</th>
            <th>创建时间</th>
            <th>创建教师ID</th>
            <th>创建教师</th>
            <th>班级简述</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<Class> classList = (List<Class>) request.getAttribute("classList");
            if (classList != null) {
                for (Class c : classList) {
        %>
        <tr>
            <td><%= c.getClassName() %></td>
            <td><%= c.getCreatedAt() %></td>
            <td><%= c.getTeacherId() %></td>
            <td><%= c.getTeacherName() %></td>
            <td><%= c.getClassBriefly() %></td>
            <td><%= c.getStatus().equals("approved") ? "已通过" : "未审核" %></td>
            <td>
                <form method="post" action="AuditClassServlet">
                    <input type="hidden" name="classId" value="<%= c.getId() %>">
                    <input type="hidden" name="action" value="approve">
                    <button type="submit" class="btn">通过</button>
                </form>
                <form method="post" action="AuditClassServlet">
                    <input type="hidden" name="classId" value="<%= c.getId() %>">
                    <input type="hidden" name="action" value="deny">
                    <button type="submit" class="btn deny">拒绝</button>
                </form>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="7">没有待审核的班级。</td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <a href="../admin.jsp" class="back-btn">返回管理员登录</a>
</div>
</body>
</html>
