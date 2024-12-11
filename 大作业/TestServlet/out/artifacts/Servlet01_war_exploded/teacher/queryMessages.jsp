<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.myapplication.util.DatabaseUtil" %>
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
    </style>
</head>
<body>
<div class="container">
    <h2>查询站内消息</h2>
    <form method="get" action="queryMessages.jsp">
        <label for="sender">发送方:</label>
        <input type="text" name="sender" id="sender" placeholder="发送方姓名">

        <label for="receiver">接收方:</label>
        <input type="text" name="receiver" id="receiver" placeholder="接收方姓名">

        <label for="dateFrom">起始时间:</label>
        <input type="date" name="dateFrom" id="dateFrom">

        <label for="dateTo">结束时间:</label>
        <input type="date" name="dateTo" id="dateTo">

        <button type="submit">查询</button>
    </form>

    <%
        String sender = request.getParameter("sender");
        String receiver = request.getParameter("receiver");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            StringBuilder query = new StringBuilder("SELECT u1.username AS sender, u2.username AS receiver, m.content, m.created_at " +
                    "FROM messages m " +
                    "JOIN users u1 ON m.sender_id = u1.id " +
                    "JOIN users u2 ON m.receiver_id = u2.id WHERE 1=1");

            if (sender != null && !sender.isEmpty()) {
                query.append(" AND u1.username LIKE ?");
            }
            if (receiver != null && !receiver.isEmpty()) {
                query.append(" AND u2.username LIKE ?");
            }
            if (dateFrom != null && !dateFrom.isEmpty()) {
                query.append(" AND m.created_at >= ?");
            }
            if (dateTo != null && !dateTo.isEmpty()) {
                query.append(" AND m.created_at <= ?");
            }

            stmt = conn.prepareStatement(query.toString());
            int paramIndex = 1;

            if (sender != null && !sender.isEmpty()) {
                stmt.setString(paramIndex++, "%" + sender + "%");
            }
            if (receiver != null && !receiver.isEmpty()) {
                stmt.setString(paramIndex++, "%" + receiver + "%");
            }
            if (dateFrom != null && !dateFrom.isEmpty()) {
                stmt.setDate(paramIndex++, java.sql.Date.valueOf(dateFrom));
            }
            if (dateTo != null && !dateTo.isEmpty()) {
                stmt.setDate(paramIndex++, java.sql.Date.valueOf(dateTo));
            }

            rs = stmt.executeQuery();
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
            while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("sender") %></td>
            <td><%= rs.getString("receiver") %></td>
            <td><%= rs.getString("content") %></td>
            <td><%= rs.getTimestamp("created_at") %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                DatabaseUtil.close(conn, stmt, rs);
            }
        %>
        </tbody>
    </table>
</div>
</body>
</html>
