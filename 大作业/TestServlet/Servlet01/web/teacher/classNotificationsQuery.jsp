<%@ page import="model.Notification" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.NotificationDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>查询班级通知</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: auto;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        input, select, button {
            margin: 10px 0;
            padding: 10px;
            width: 100%;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f4f4f4;
        }
        .actions {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        /* 新增的按钮样式 */
        .button {
            display: inline-block;
            padding: 10px 20px;
            font-size: 16px;
            color: #fff;
            background-color: #007bff;
            text-decoration: none;
            border-radius: 4px;
            text-align: center;
            transition: background-color 0.3s ease;
        }
        .button:hover {
            background-color: #0056b3;
        }
        .button:active {
            background-color: #003d80;
        }
        .header {
            text-align: center;
            font-size: 24px;  /* 你可以调整字体大小 */
            font-weight: bold;  /* 使文本加粗 */
        }

    </style>
</head>
<body>
<div class="container">
    <div class="login-wrapper">
        <div class="header" >查询班级通知</div>

        <!-- 查询表单 -->
        <form action="SearchClassNotifications" method="GET">
            <label for="title">通知标题：</label>
            <input type="text" id="title" name="title" value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>" placeholder="输入通知标题" />
            <br><br>

            <label for="content">内容：</label>
            <input type="text" id="content" name="content" value="<%= request.getParameter("content") != null ? request.getParameter("content") : "" %>" placeholder="输入通知内容" />
            <br><br>

            <label for="startDate">开始时间：</label>
            <input type="date" id="startDate" name="startDate" value="<%= request.getParameter("startDate") != null ? request.getParameter("startDate") : "" %>" />
            <br><br>

            <label for="endDate">结束时间：</label>
            <input type="date" id="endDate" name="endDate" value="<%= request.getParameter("endDate") != null ? request.getParameter("endDate") : "" %>" />
            <br><br>

            <button type="submit">查询</button>
        </form>
        <!-- 返回按钮 -->
        <div class="actions">
            <button class="button" onclick="window.location.href='teacher.jsp'">返回</button>
        </div>
        <hr>

        <!-- 显示查询结果 -->
        <table>
            <thead>
            <tr>
                <th>标题</th>
                <th>通知内容</th>
                <th>发布时间</th>
            </tr>
            </thead>
            <tbody>
            <%
                NotificationDAO notificationDAO = new NotificationDAO();
                List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
                if (notifications != null && !notifications.isEmpty()) {
                    for (Notification notification : notifications) {
            %>
            <tr>
                <td><%= notification.getTitle() %></td>
                <td><%= notification.getContent() %></td>
                <td><%= notification.getCreatedAt() %></td>
            </tr>
            <% } }else { %>
            <tr>
                <td colspan="3">没有符合条件的通知。</td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
