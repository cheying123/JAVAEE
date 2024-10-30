<%--
  Created by IntelliJ IDEA.
  User: cheying
  Date: 2024/10/29
  Time: 16:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册</title>
    <style>
        * {
            margin: 0;
            padding: 0;
        }
        html {
            height: 100%;
        }
        body {
            height: 100%;
        }
        .container {
            height: 100%;
            background-image: linear-gradient(to right, #fbc2eb, #a6c1ee);
        }
        .login-wrapper {
            background-color: #fff;
            width: 358px;
            height: 688px; /* Adjusted height to accommodate confirmation password */
            border-radius: 15px;
            padding: 0 50px;
            position: relative;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
        }
        .header {
            font-size: 38px;
            font-weight: bold;
            text-align: center;
            line-height: 200px;
        }
        .input-item {
            display: block;
            width: 100%;
            margin-bottom: 20px;
            border: 0;
            padding: 10px;
            border-bottom: 1px solid rgb(128, 125, 125);
            font-size: 15px;
            outline: none;
        }
        .input-item::placeholder {
            text-transform: uppercase;
        }
        .btn {
            text-align: center;
            padding: 10px;
            width: 100%;
            margin-top: 20px;
            background-image: linear-gradient(to right, #a6c1ee, #fbc2eb);
            color: #fff;
            border: none;
            cursor: pointer;
        }
        .msg {
            text-align: center;
            line-height: 88px;
        }

        .msgres {
            text-align: center;
            color: red;
        }
        a {
            text-decoration-line: none;
            color: #abc1ee;
        }
    </style>
    <!-- 引入jQuery库 -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<div class="container">
    <div class="login-wrapper">
        <div class="header">注册</div>

        <form id="registerForm" method="post" action="${pageContext.request.contextPath}/register"> <!-- 确保action指向正确的Servlet -->
            <div class="form-wrapper">
                <div>注册名</div>
                <input type="text" name="username" placeholder="注册名/邮箱" class="input-item"
                       value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>">
                <div>密码</div>
                <input type="password" name="password" placeholder="密码" class="input-item">
                <div>确认密码</div>
                <input type="password" name="confirmPassword" placeholder="确认密码" class="input-item">

                <div id="result" class="msgres">
                    <%
                        String errorMessage = (String) request.getAttribute("errorMessage");
                        if (errorMessage != null && !errorMessage.isEmpty()) {
                    %>
                    <p style="color: red;"><%= errorMessage %></p>
                    <%
                        }
                    %>
                </div>

                <button type="submit" class="btn">注册</button>
            </div>
        </form>
        <div class="msg">
            已有账号?
            <a href="http://localhost:8080">登录</a>
        </div>
    </div>
</div>

<script>

</script>
</body>
</html>




