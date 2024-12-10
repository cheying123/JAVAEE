<<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.myapplication.util.DatabaseUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>审核加入班级申请</title>
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

        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: bold;
        }

        .success {
            background-color: #4caf50;
            color: white;
        }

        .error {
            background-color: #f44336;
            color: white;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>审核加入班级申请</h2>

    <%-- 显示操作结果消息 --%>
    <%
        String operationMessage = (String) request.getAttribute("operationMessage");
        if (operationMessage != null) {
            // 根据操作结果的不同显示不同的颜色
            String messageClass = operationMessage.contains("失败") || operationMessage.contains("错误") ? "error" : "success";
    %>
    <div class="message <%= messageClass %>">
        <%= operationMessage %>
    </div>
    <% } %>

    <table>
        <thead>
        <tr>
            <th>申请ID</th>
            <th>教师姓名</th>
            <th>班级名称</th>
            <th>申请状态</th>
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
                int creatorId = (int) session.getAttribute("teacherId"); // 当前登录用户ID
                String query = "SELECT tc.id, tc.teacher_id, tc.class_id, tc.approval_status, u.username, c.class_name " +
                        "FROM teacher_classes tc " +
                        "JOIN classes c ON tc.class_id = c.id " +
                        "JOIN users u ON tc.teacher_id = u.id " +
                        "WHERE c.teacher_id = ? AND tc.approval_status = 'pending'";
                stmt = conn.prepareStatement(query);
                stmt.setInt(1, creatorId);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    int requestId = rs.getInt("id");
                    String teacherName = rs.getString("username");
                    String className = rs.getString("class_name");
                    String approvalStatus = rs.getString("approval_status");
        %>
        <tr>
            <td><%= requestId %></td>
            <td><%= teacherName %></td>
            <td><%= className %></td>
            <td><%= approvalStatus %></td>
            <td>
                <form method="post" action="${pageContext.request.contextPath}/ApproveJoinRequestServlet" style="display: inline;">
                    <input type="hidden" name="requestId" value="<%= requestId %>">
                    <input type="hidden" name="action" value="approve">
                    <button type="submit" class="btn" style="background-color: #4caf50;">通过</button> <!-- 绿色的通过按钮 -->
                </form>
                <form method="post" action="${pageContext.request.contextPath}/ApproveJoinRequestServlet" style="display: inline;">
                    <input type="hidden" name="requestId" value="<%= requestId %>">
                    <input type="hidden" name="action" value="reject">
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
            <td colspan="5">加载数据失败，请稍后重试！</td>
        </tr>
        <%
            } finally {
                DatabaseUtil.close(conn, stmt, rs);
            }
        %>
        </tbody>
    </table>
    <a href="${pageContext.request.contextPath}/teacher.jsp" class="back-btn">返回教师界面</a>
</div>
</body>
</html>

