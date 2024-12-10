<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.myapplication.util.DatabaseUtil" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理通知</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap">
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

        /* 查看详情按钮绿色 */
        .view-btn {
            padding: 6px 12px;
            background-color: #4CAF50; /* 绿色 */
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .view-btn:hover {
            background-color: #45a049; /* 悬停时变成稍深的绿色 */
        }

        /* 删除按钮红色 */
        .delete-btn {
            padding: 6px 12px;
            background-color: #f44336; /* 红色 */
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .delete-btn:hover {
            background-color: #d32f2f; /* 悬停时变成稍深的红色 */
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

        /* 限制标题和内容的显示长度，并加上省略号 */
        .notification-title,
        .notification-content {
            max-width: 200px; /* 限制最大宽度 */
            white-space: nowrap; /* 防止文本换行 */
            overflow: hidden;
            text-overflow: ellipsis; /* 超出文本显示省略号 */
        }
    </style>
</head>
<body>
<div class="container">
    <h2>管理通知</h2>

    <%
        String message = (String) session.getAttribute("message");
        String error = (String) session.getAttribute("error");
        if (message != null) {
    %>
    <div class="message success"><%= message %></div>
    <% session.removeAttribute("message"); }
    else if (error != null) { %>
    <div class="message error"><%= error %></div>
    <% session.removeAttribute("error"); }
    %>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>标题</th>
            <th>内容</th>
            <th>发布时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = DatabaseUtil.getConnection();

                // 获取当前登录的管理员ID
                Integer adminId = (Integer) request.getSession().getAttribute("adminId");
                if (adminId == null) {
                    response.sendRedirect("../index.jsp");  // 如果没有登录，跳转到登录页面
                    return;
                }

                // 查询管理员发布的通知
                String query = "SELECT id, title, content, created_at FROM admin_notifications WHERE admin_id = ?";
                stmt = conn.prepareStatement(query);
                stmt.setInt(1, adminId); // 绑定管理员ID
                rs = stmt.executeQuery();

                while (rs.next()) {
                    String title = rs.getString("title");
                    String content = rs.getString("content");
                    // 截取前100个字符显示
                    String truncatedTitle = title.length() > 20 ? title.substring(0, 20) + "..." : title;
                    String truncatedContent = content.length() > 100 ? content.substring(0, 100) + "..." : content;
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td class="notification-title"><%= truncatedTitle %></td>
            <td class="notification-content"><%= truncatedContent %></td>
            <td><%= rs.getTimestamp("created_at") %></td>
            <td>
                <!-- 查看详细内容按钮 -->
                <a href="<%= request.getContextPath() + "viewAdminNotification.jsp?id=" + rs.getInt("id") %>" class="view-btn">查看详情</a>
                <form action="${pageContext.request.contextPath}/DeleteAdminNotificationServlet" method="post" style="display:inline;">
                    <input type="hidden" name="notification_id" value="<%= rs.getInt("id") %>">
                    <button type="submit" class="delete-btn">删除</button>
                </form>
            </td>
        </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                DatabaseUtil.close(conn, stmt, rs);
            }
        %>
        </tbody>
    </table>

    <a href="${pageContext.request.contextPath}/admin/addNotification.jsp" class="back-btn">发布通知</a>
    <a href="${pageContext.request.contextPath}/admin.jsp" class="back-btn">返回管理员界面</a>

</div>
</body>
</html>
