<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.myapplication.util.DatabaseUtil" %>
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
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;


            // 获取当前登录的教师ID
            Integer teacherId = (Integer) request.getSession().getAttribute("teacherId");
            if (teacherId == null) {
                response.sendRedirect("../index.jsp");  // 如果没有登录，跳转到登录页面
                return;
            }

            try {
                conn = DatabaseUtil.getConnection();

                // 查询所有已生效的班级，排除当前教师创建的班级和已加入的班级
                String query = "SELECT c.id, c.class_name, c.class_briefly, c.status, " +
                        "(SELECT approval_status FROM teacher_classes tc WHERE tc.teacher_id = ? AND tc.class_id = c.id) AS approval_status " +
                        "FROM classes c " +
                        "WHERE c.status = 'approved' " +
                        "AND c.teacher_id != ? " +  // 排除当前教师创建的班级
                        "AND NOT EXISTS (SELECT 1 FROM teacher_classes tc WHERE tc.teacher_id = ? AND tc.class_id = c.id)"; // 排除当前教师已加入的班级

                stmt = conn.prepareStatement(query);
                stmt.setInt(1, teacherId);
                stmt.setInt(2, teacherId); // 排除自己创建的班级
                stmt.setInt(3, teacherId); // 排除自己已加入的班级
                rs = stmt.executeQuery();

                boolean hasClasses = false; // 检查是否有班级可加入

                while (rs.next()) {
                    hasClasses = true; // 存在可加入的班级

                    int classId = rs.getInt("id");
                    String className = rs.getString("class_name");
                    String classBriefly = rs.getString("class_briefly");
                    String classStatus = rs.getString("status");
                    String approvalStatus = rs.getString("approval_status");
        %>
        <tr>
            <td><%= classId %></td>
            <td><%= className %></td>
            <td><%= classBriefly %></td>
            <td><%= classStatus %></td>
            <td>
                <% if (approvalStatus == null) { %>
                <!-- 未申请，显示申请按钮 -->
                <form method="post" action="${pageContext.request.contextPath}/JoinClassServlet" style="display: inline;">
                    <input type="hidden" name="class_id" value="<%= classId %>">
                    <button type="submit" class="btn">申请加入</button>
                </form>
                <% } else if ("pending".equals(approvalStatus)) { %>
                <!-- 已申请，待审核 -->
                <span style="color: orange;">待审核</span>
                <% } else if ("approved".equals(approvalStatus)) { %>
                <!-- 已通过 -->
                <span style="color: green;">已加入</span>
                <% } else if ("rejected".equals(approvalStatus)) { %>
                <!-- 被拒绝 -->
                <span style="color: red;">被拒绝</span>
                <% } %>
            </td>
        </tr>
        <%
            }
            if (!hasClasses) {
        %>
        <tr>
            <td colspan="5">当前没有可加入的班级。</td>
        </tr>
        <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
        %>
        <tr>
            <td colspan="5">加载数据时出错，请稍后重试。</td>
        </tr>
        <%-- 显示操作提示信息 --%>
        <%
            String message = (String) session.getAttribute("message");
            String error = (String) session.getAttribute("error");
            if (message != null) {
        %>
        <div style="color: green;"><%= message %></div>
        <%
            session.removeAttribute("message");  // 操作完成后移除消息
        } else if (error != null) {
        %>
        <div style="color: red;"><%= error %></div>
        <%
                session.removeAttribute("error");  // 操作完成后移除错误信息
            }
        %>
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
