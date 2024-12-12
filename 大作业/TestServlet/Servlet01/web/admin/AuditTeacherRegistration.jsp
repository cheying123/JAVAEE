<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Teacher" %>
<%@ page import="java.util.List" %>
<%
    List<Teacher> pendingTeachers = (List<Teacher>) request.getAttribute("pendingTeachers");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>审核教师注册</title>
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
            width: 80%;
            max-width: 900px;
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
            padding: 12px;
            text-align: center;
            border: 1px solid #ddd;
        }

        th {
            background-color: #f4f4f4;
        }

        .view-btn {
            padding: 6px 12px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .view-btn:hover {
            background-color: #45a049;
        }

        .delete-btn {
            padding: 6px 12px;
            background-color: #f44336;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .delete-btn:hover {
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

        .notification-title,
        .notification-content {
            max-width: 200px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>待审核教师列表</h2>
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>用户名</th>
            <th>注册时间</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>

        <%
            List<Teacher> TeacherList = (List<Teacher>) request.getAttribute("TeacherList");
            if (TeacherList != null) {
                for (Teacher teacher : TeacherList) {
        %>

        <tr>
            <td><%= teacher.getId() %></td>
            <td><%= teacher.getUsername() %></td>
            <td><%= teacher.getCreatedAt() %></td>
            <td><%= teacher.getStatus() %></td>
            <td>
                <form method="post" action="<%= request.getContextPath() %>/AuditTeacherServlet" style="display: inline;">
                    <input type="hidden" name="id" value="<%= teacher.getId() %>">
                    <input type="hidden" name="action" value="approve">
                    <button type="submit" class="view-btn">通过</button>
                </form>
                <form method="post" action="<%= request.getContextPath() %>/AuditTeacherServlet" style="display: inline;">
                    <input type="hidden" name="id" value="<%= teacher.getId() %>">
                    <input type="hidden" name="action" value="deny">
                    <button type="submit" class="delete-btn">拒绝</button>
                </form>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="5">暂无待审核教师</td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <a href="<%= request.getContextPath() %>/admin.jsp" class="back-btn">返回管理员主页</a>
</div>
</body>
</html>
