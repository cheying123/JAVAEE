<%--
  Created by IntelliJ IDEA.
  User: cheying
  Date: 2024/10/15
  Time: 14:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>登录页面</title>
  <style>
    * {
      margin: 0;
      padding: 0;
    }
    html, body {
      height: 100%;
    }
    .container {
      height: 100%;
      background-image: linear-gradient(to right, #fbc2eb, #a6c1ee);
    }
    .login-wrapper {
      background-color: #fff;
      width: 358px;
      height: 588px;
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
    }
    #result {
      color: red;
    }
    a {
      text-decoration-line: none;
      color: #abc1ee;
    }
    /* 样式用于模态对话框 */
    .modal {
      display: none; /* 默认隐藏 */
      position: fixed; /* 固定位置 */
      z-index: 1; /* 确保在最上层 */
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      overflow: auto; /* 允许滚动 */
      background-color: rgba(0,0,0,0.4); /* 半透明背景 */
    }
    .modal-content {
      background-color: #fefefe;
      margin: 15% auto;
      padding: 20px;
      border: 1px solid #888;
      width: 80%;
      max-width: 600px;
    }
    .close {
      color: #aaa;
      float: right;
      font-size: 28px;
      font-weight: bold;
    }
    .close:hover,
    .close:focus {
      color: black;
      text-decoration: none;
      cursor: pointer;
    }
  </style>
  <!-- 引入jQuery库 -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="container">
  <div class="login-wrapper">
    <div class="header">登录</div>

    <form id="loginForm" method="post" action="${pageContext.request.contextPath}/login">


      <div class="form-wrapper">
        <select name="identify" style="width: 30%" class="input-item">
          <option value="" disabled>学生家长</option>
          <option value="parent">学生家长</option>
          <option value="teacher">老师</option>
          <option value="admin">管理员</option>
        </select>

        <input type="text" name="username" placeholder="登录名/邮箱" class="input-item"
               required value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>">
        <input type="password" name="password" placeholder="密码" class="input-item">

        <div id="result" class="msgres">
          <%
            // 从请求中获取错误信息
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null && !errorMessage.isEmpty()) {
          %>
          <p style="color: red;"><%= errorMessage %></p>
          <%
            }
          %>
        </div>

        <label>
          <input type="checkbox" name="terms">
          我已同意并且详细阅读 <a href="#" id="termsLink">相关条款</a>
        </label>
        <button type="submit" class="btn">登录</button>
      </div>
    </form>

    <div class="msg">
      没有账号?
      <a href="register.jsp">注册一个</a>
    </div>
  </div>
</div>

<!-- z这里应该使用模态对话框 -->
<div id="termsModal" class="modal">
  <div class="modal-content">
    <span class="close">&times;</span>
    <h2>相关条款</h2>
    <p>这里是条款的详细内容。还没填呢</p>
  </div>
</div>

<script>

</script>
</body>
</html>

