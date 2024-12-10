<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.myapplication.util.DatabaseUtil" %>
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
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            // 获取当前登录的教师ID
            Integer ID = (Integer) request.getSession().getAttribute("teacherId");
            if (ID == null) {
                response.sendRedirect("../index.jsp");  // 如果没有登录，跳转到登录页面
                return;
            }

            try {
                conn = DatabaseUtil.getConnection(); // 使用DatabaseUtil获取连接
                String query = "SELECT id, class_name, class_briefly, teacher_id, status FROM classes";
                stmt = conn.prepareStatement(query);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String className = rs.getString("class_name");
                    String classBriefly = rs.getString("class_briefly");
                    int teacherId = rs.getInt("teacher_id");
                    String status = rs.getString("status");

                    // 判断教师ID是否为当前管理员ID
                    boolean canDelete = (ID == teacherId);
        %>
        <tr>
            <td><%= id %></td>
            <td><%= className %></td>
            <td><%= classBriefly %></td>
            <td><%= teacherId %></td>
            <td><%= status %></td>
            <td>
                <%
                    if (canDelete) { // 如果当前管理员是该班级的创建者，显示删除按钮
                %>
                <form method="post" action="${pageContext.request.contextPath}/DeleteClassServlet" style="display: inline;">
                    <input type="hidden" name="id" value="<%= id %>">
                    <button type="submit" class="btn">删除</button>
                </form>
                <%
                    }
                %>
            </td>
        </tr>
        <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
        %>
        <tr>
            <td colspan="6">加载数据时出错，请稍后重试。</td>
        </tr>
        <%
            } finally {
                DatabaseUtil.close(conn, stmt, rs);
            }
        %>
        </tbody>
    </table>
    <!-- 返回按钮 -->
    <a href="${pageContext.request.contextPath}/teacher.jsp" class="back-btn">返回教师界面</a>
</div>
</body>
</html>
