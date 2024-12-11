<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

    <h3>教师审核</h3>
    <table>
        <thead>
        <tr>
            <th>申请ID</th>
            <th>申请人姓名</th>
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
                int creatorId = (int) session.getAttribute("teacherId"); // 当前登录教师的ID

                // 查询待审核的教师申请
                String queryTeacher = "SELECT tc.id, tc.teacher_id, tc.class_id, tc.approval_status, u.username, c.class_name " +
                        "FROM teacher_classes tc " +
                        "JOIN classes c ON tc.class_id = c.id " +
                        "JOIN users u ON tc.teacher_id = u.id " +
                        "WHERE c.teacher_id = ? AND tc.approval_status = 'pending'";
                stmt = conn.prepareStatement(queryTeacher);
                stmt.setInt(1, creatorId);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    int requestId = rs.getInt("id");
                    String applicantName = rs.getString("username");
                    String className = rs.getString("class_name");
                    String approvalStatus = rs.getString("approval_status");
        %>
        <tr>
            <td><%= requestId %></td>
            <td><%= applicantName %> (教师)</td>
            <td><%= className %></td>
            <td><%= approvalStatus %></td>
            <td>
                <form method="post" action="${pageContext.request.contextPath}/ApproveJoinRequestServlet" style="display: inline;">
                    <input type="hidden" name="requestId" value="<%= requestId %>">
                    <input type="hidden" name="action" value="approve">
                    <input type="hidden" name="type" value="teacher"> <!-- 如果是教师申请 -->
                    <button type="submit" class="btn" style="background-color: #4caf50;">通过</button>
                </form>

                <form method="post" action="${pageContext.request.contextPath}/ApproveJoinRequestServlet" style="display: inline;">
                    <input type="hidden" name="requestId" value="<%= requestId %>">
                    <input type="hidden" name="action" value="reject">
                    <input type="hidden" name="type" value="teacher"> <!-- 如果是教师申请 -->
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
    <td></td>
    <td></td>
    <h3>家长审核</h3>
    <table>
        <thead>
        <tr>
            <th>申请ID</th>
            <th>家长姓名</th>
            <th>班级名称</th>
            <th>申请状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <%
            Connection conn2 = null;
            PreparedStatement stmt2 = null;
            ResultSet rs2 = null;

            try {
                int creatorId = (int) session.getAttribute("teacherId"); // 当前登录教师的ID
                conn2 = DatabaseUtil.getConnection();
                // 查询待审核的家长申请
                String queryParent = "SELECT pc.id, pc.parent_id, pc.class_id, pc.status, u.username, c.class_name " +
                        "FROM parent_classes pc " +
                        "JOIN classes c ON pc.class_id = c.id " +
                        "JOIN users u ON pc.parent_id = u.id " +
                        "WHERE c.teacher_id = ? AND pc.status = 'pending'";
                stmt2 = conn2.prepareStatement(queryParent);
                stmt2.setInt(1, creatorId);
                rs2 = stmt2.executeQuery();

                while (rs2.next()) {
                    int requestId = rs2.getInt("id");
                    String applicantName = rs2.getString("username");
                    String className = rs2.getString("class_name");
                    String approvalStatus = rs2.getString("status");
        %>
        <tr>
            <td><%= requestId %></td>
            <td><%= applicantName %> (家长)</td>
            <td><%= className %></td>
            <td><%= approvalStatus %></td>
            <td>
                <form method="post" action="${pageContext.request.contextPath}/ApproveJoinRequestServlet" style="display: inline;">
                    <input type="hidden" name="requestId" value="<%= requestId %>">
                    <input type="hidden" name="action" value="approve">
                    <input type="hidden" name="type" value="parent"> <!-- 如果是家长申请 -->
                    <button type="submit" class="btn" style="background-color: #4caf50;">通过</button>
                </form>

                <form method="post" action="${pageContext.request.contextPath}/ApproveJoinRequestServlet" style="display: inline;">
                    <input type="hidden" name="requestId" value="<%= requestId %>">
                    <input type="hidden" name="action" value="reject">
                    <input type="hidden" name="type" value="parent"> <!-- 如果是家长申请 -->
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
                DatabaseUtil.close(conn2, stmt2, rs2);
            }
        %>
        </tbody>
    </table>

    <a href="${pageContext.request.contextPath}/teacher.jsp" class="back-btn">返回教师界面</a>
</div>
</body>
</html>
