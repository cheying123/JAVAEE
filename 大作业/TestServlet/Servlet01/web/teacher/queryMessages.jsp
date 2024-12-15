<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Message" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>查询站内消息</title>
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
    </style>
</head>
<body>
<div class="container">
    <h2>查询站内消息</h2>
    <form method="get" action="${pageContext.request.contextPath}/QueryMessagesServlet">
        <label for="sender">发送方:</label>
        <input type="text" name="sender" id="sender" placeholder="发送方姓名" value="<%= request.getParameter("sender") != null ? request.getParameter("sender") : "" %>">

        <label for="receiver">接收方:</label>
        <input type="text" name="receiver" id="receiver" placeholder="接收方姓名" value="<%= request.getParameter("receiver") != null ? request.getParameter("receiver") : "" %>">

        <label for="dateFrom">起始时间:</label>
        <input type="date" name="dateFrom" id="dateFrom" value="<%= request.getParameter("dateFrom") != null ? request.getParameter("dateFrom") : "" %>">

        <label for="dateTo">结束时间:</label>
        <input type="date" name="dateTo" id="dateTo" value="<%= request.getParameter("dateTo") != null ? request.getParameter("dateTo") : "" %>">

        <label for="content">消息内容:</label>
        <input type="text" name="content" id="content" placeholder="输入消息内容" value="<%= request.getParameter("content") != null ? request.getParameter("content") : "" %>">

        <label for="role">角色:</label>
        <select name="role" id="role">
            <option value="sender" <%= "sender".equals(request.getParameter("role")) ? "selected" : "" %>>我是发送方</option>
            <option value="receiver" <%= "receiver".equals(request.getParameter("role")) ? "selected" : "" %>>我是接收方</option>
        </select>

        <button type="submit">查询</button>
    </form>

    <!-- 数据表格 -->
    <%
        List<Message> messages = (List<Message>) request.getAttribute("messages");

        if (messages != null && !messages.isEmpty()) {
    %>
    <table>
        <thead>
        <tr>
            <th>发送方</th>
            <th>接收方</th>
            <th>内容</th>
            <th>时间</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (Message message : messages) {
        %>
        <tr>
            <td><%= message.getSender() %></td>
            <td><%= message.getReceiver() %></td>
            <td><%= message.getContent() %></td>
            <td><%= message.getCreatedAt() %></td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <%
    } else {
    %>
    <p>没有找到符合条件的消息。</p>
    <%
        }
    %>
    <hr>
    <a href="../teacher.jsp" class="button">返回上一页</a>

</div>
</body>
</html>
