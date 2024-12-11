<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.myapplication.util.DatabaseUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>发送站内消息</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: auto;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        input, textarea, select {
            width: 100%;
            margin: 10px 0;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        button {
            padding: 10px 20px;
            background-color: #2196F3;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #1976D2;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>发送站内消息</h2>
    <form action="${pageContext.request.contextPath}/SendMessageServlet" method="post">
        <label for="receiver">接收方:</label>
        <select name="receiverId" id="receiver" required>
            <%
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;
                int teacherId = (Integer) session.getAttribute("teacherId");

                try {
                    conn = DatabaseUtil.getConnection();
                    // 修改后的查询：包含班级创建者和加入班级的老师
                    String query = "SELECT u.id, u.username FROM users u " +
                            "INNER JOIN parent_classes pc ON u.id = pc.parent_id " +
                            "WHERE pc.class_id IN (SELECT id FROM classes WHERE teacher_id = ? " +
                            "                         UNION " +
                            "                         SELECT class_id FROM teacher_classes WHERE teacher_id = ?)";
                    stmt = conn.prepareStatement(query);
                    stmt.setInt(1, teacherId);  // 班级创建者
                    stmt.setInt(2, teacherId);  // 加入该班级的老师
                    rs = stmt.executeQuery();

                    while (rs.next()) {
                        int parentId = rs.getInt("id");
                        String parentName = rs.getString("username");
            %>
            <option value="<%= parentId %>"><%= parentName %></option>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    DatabaseUtil.close(conn, stmt, rs);
                }
            %>
        </select>

        <label for="content">消息内容:</label>
        <textarea name="content" id="content" rows="5" required></textarea>

        <button type="submit">发送消息</button>
    </form>
</div>
</body>
</html>
