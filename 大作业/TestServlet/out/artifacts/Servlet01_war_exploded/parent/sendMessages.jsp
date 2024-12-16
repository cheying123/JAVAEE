<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.myapplication.util.DatabaseUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Teacher" %>
<%@ page import="dao.TeacherDAO" %>
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
        .message {
            color: red;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .return-button {
            background-color: #FF5722; /* 可以修改为你想要的颜色 */
            color: white;
            margin-top: 20px;
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        .return-button:hover {
            background-color: #E64A19;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>发送站内消息</h2>

    <!-- 显示消息发送结果 -->
    <div class="message">
        <%= request.getAttribute("resultMessage") != null ? request.getAttribute("resultMessage") : "" %>
    </div>

    <form action="${pageContext.request.contextPath}/SendMessageServlet" method="post">
        <label for="receiver">接收方:</label>
        <select name="receiverId" id="receiver" required>
            <%
                int parentId = (Integer) session.getAttribute("parentId");
                TeacherDAO teacherDAO = new TeacherDAO();
                List<Teacher> teachers = null;

                try {
                    // 获取同班的所有教师
                    teachers = teacherDAO.getTeachersbySameClass(parentId);

                    // 检查是否有教师，若有则生成下拉选项
                    if (teachers != null && !teachers.isEmpty()) {
                        for (Teacher teacher : teachers) {
                            int teacherId = teacher.getId();
                            String teacherName = teacher.getUsername();
            %>
            <option value="<%= teacherId %>"><%= teacherName %></option>
            <%
                }
            } else {
            %>
            <option value="">没有可选的教师</option>
            <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            %>
            <option value="">无法加载教师列表</option>
            <%
                }
            %>
        </select>

        <label for="content">消息内容:</label>
        <textarea name="content" id="content" rows="5" required></textarea>

        <button type="submit">发送消息</button>
    </form>

    <!-- 返回按钮 -->
    <a href="../parent.jsp" class="return-button">返回家长主页</a>

</div>
</body>
</html>
