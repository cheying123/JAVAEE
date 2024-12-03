<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.example.myapplication.util.DatabaseUtil" %>
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
            <th>创建教师ID</th> <!-- 显示教师ID -->
            <th>创建教师</th>
            <th>班级简述</th> <!-- 新增班级简述列 -->
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
                String query = "SELECT c.id, c.class_name, c.created_at, c.status, c.teacher_id, u.username, c.class_briefly " +
                        "FROM classes c " +
                        "JOIN users u ON c.teacher_id = u.id WHERE c.status = 'pending'";
                stmt = conn.prepareStatement(query);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    int classId = rs.getInt("id");
                    String className = rs.getString("class_name");
                    String createdAt = rs.getString("created_at");
                    String status = rs.getString("status");
                    int teacherId = rs.getInt("teacher_id");
                    String teacherName = rs.getString("username");
                    String classBriefly = rs.getString("class_briefly");  // 获取班级简述
                    if( status.equals("approved") ){
                        status = "已通过";
                    }else{
                        status = "未审核";
                    }
        %>
        <tr>
            <td><%= className %></td>
            <td><%= createdAt %></td>
            <td><%= teacherId %></td> <!-- 显示教师ID -->
            <td><%= teacherName %></td>
            <td><%= classBriefly %></td> <!-- 显示班级简述 -->
            <td><%= status %></td>
            <td>
                <form method="post" action="${pageContext.request.contextPath}/AuditClassServlet" style="display: inline;">
                    <input type="hidden" name="classId" value="<%= classId %>">
                    <input type="hidden" name="action" value="approve">
                    <button type="submit" class="btn">通过</button>
                </form>
                <form method="post" action="${pageContext.request.contextPath}/AuditClassServlet" style="display: inline;">
                    <input type="hidden" name="classId" value="<%= classId %>">
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
            <td colspan="7">加载数据时出错，请稍后重试。</td>
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
