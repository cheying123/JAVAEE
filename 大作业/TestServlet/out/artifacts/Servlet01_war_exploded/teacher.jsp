<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.example.myapplication.util.DatabaseUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>老师功能界面</title>
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
            font-family: Arial, sans-serif;
        }

        .container {
            height: 100%;
            background-image: linear-gradient(to right, #fbc2eb, #a6c1ee);
        }

        .dashboard-wrapper {
            background-color: #fff;
            width: 358px;
            min-height: 500px;
            border-radius: 15px;
            padding: 30px 20px;
            position: relative;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }

        .header {
            font-size: 28px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
            color: #555;
        }

        .menu-item {
            display: block;
            padding: 15px;
            margin: 10px 0;
            background-color: #f1f1f1;
            text-align: center;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            color: #555;
            text-decoration: none;
        }

        .menu-item:hover {
            background-color: #a6c1ee;
            color: #fff;
        }

        .section {
            margin-top: 20px;
        }

        .table-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-top: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 15px;
            text-align: center;
            border: 1px solid #ddd;
            width: 25%;  /* 可以调整为你想要的比例 */
        }


        th {
            background-color: #f4f4f4;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="dashboard-wrapper">
        <div class="header">老师功能界面</div>
        <a href="teacher/createClass.jsp" class="menu-item">创建班级</a>
        <a href="teacher/joinClass.jsp" class="menu-item">加入班级</a>
        <a href="teacher/manageClass.jsp" class="menu-item">管理班级</a>
        <a href="teacher/manageJoinRequests.jsp" class="menu-item">管理班级加入申请</a>

        <a href="teacher/postNotification.jsp" class="menu-item">发布班级通知</a>
        <a href="index.jsp" class="menu-item">退出登录</a>

        <!-- 我的班级列表 -->
        <div class="section">
            <h3 style="text-align: center; color: #555;">我的班级</h3>
            <div class="table-container">
                <table>
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>班级名称</th>
                        <th>状态</th>
                        <th>创建时间</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;
                        if(request.getSession().getAttribute("teacherId") == null){
                            response.sendRedirect("index.jsp");  // 如果没有登录，跳转到登录页面
                            return;
                        }
                        int teacherId = (int) request.getSession().getAttribute("teacherId");
                        try {
                            conn = DatabaseUtil.getConnection();
                            String query = "SELECT id, class_name, status, created_at FROM classes WHERE teacher_id = ?";
                            stmt = conn.prepareStatement(query);
                            stmt.setInt(1, teacherId);
                            rs = stmt.executeQuery();

                            while (rs.next()) {
                                int id = rs.getInt("id");
                                String name = rs.getString("class_name");
                                String status = rs.getString("status");
                                if( status.equals("approved") ){
                                    status = "已通过";
                                }else{
                                    status = "未审核";
                                }
                                String createdAt = rs.getString("created_at");
                    %>
                    <tr>
                        <td><%= id %></td>
                        <td><%= name %></td>
                        <td><%= status %></td>
                        <td><%= createdAt %></td>
                    </tr>
                    <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    %>
                    <tr>
                        <td colspan="4">加载数据时出错！</td>
                    </tr>
                    <%
                        } finally {
                            DatabaseUtil.close(conn, stmt, rs);
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
