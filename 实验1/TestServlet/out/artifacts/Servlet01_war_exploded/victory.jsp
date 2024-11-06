<%--
  Created by IntelliJ IDEA.
  User: cheying
  Date: 2024/11/5
  Time: 15:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录成功</title>
    <h1 style="font-size: 30px">登录成功</h1>
    <div class="username">
        <%= request.getParameter("username") != null ? request.getParameter("username") : "未提供用户名" %>
    </div>
    <div>恭喜你,登录成功</div>
</head>
<body>

</body>
</html>
