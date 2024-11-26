<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.example.myapplication.util.DatabaseUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>审核账号注册</title>
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
    <h2>教师注册审核</h2>
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
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = DatabaseUtil.getConnection(); // 使用DatabaseUtil获取连接
                String query = "SELECT id, username, created_at, status FROM users WHERE (role = 'teacher' or role = 'admin') AND status = 'pending'";
                stmt = conn.prepareStatement(query);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String username = rs.getString("username");
                    String createdAt = rs.getString("created_at");
                    String status = rs.getString("status");

        %>
        <tr>
            <td><%= id %></td>
            <td><%= username %></td>
            <td><%= createdAt %></td>
            <td><%= status %></td>
            <td>
                <form method="post" action="${pageContext.request.contextPath}/AuditTeacherServlet" style="display: inline;">
                    <input type="hidden" name="id" value="<%= id %>">
                    <input type="hidden" name="action" value="approve">
                    <button type="submit" class="btn">通过</button>
                </form>
                <form method="post" action="${pageContext.request.contextPath}/AuditTeacherServlet" style="display: inline;">
                    <input type="hidden" name="id" value="<%= id %>">
                    <input type="hidden" name="action" value="deny">
                    <button type="submit" class="btn deny">拒绝</button>
                </form>
            </td>
        </tr>
        <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        %>
        <tr>
            <td colspan="5">加载数据时出错，请稍后重试。</td>
        </tr>
        <%
            } finally {
                DatabaseUtil.close(conn, stmt, rs);
            }
        %>
        </tbody>
    </table>
    <!-- 返回按钮 -->
    <a href="${pageContext.request.contextPath}/admin.jsp" class="back-btn">返回管理员登录</a>
</div>
</body>
</html>
