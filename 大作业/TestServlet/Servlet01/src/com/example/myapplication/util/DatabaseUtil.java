package com.example.myapplication.util;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;



public class DatabaseUtil {

    // 数据库连接信息
    private static final String URL = "jdbc:mysql://localhost:3306/hscms"; // 修改为你的数据库 URL
    private static final String USER = "root";
    private static final String PASSWORD = "123456";

    // 加载数据库驱动，只需加载一次
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL 驱动类
        } catch (ClassNotFoundException e) {
            System.err.println("数据库驱动加载失败！");
            e.printStackTrace();
        }
    }

    /**
     * 获取数据库连接
     *
     * @return 数据库连接对象
     */
    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            System.err.println("数据库连接失败！");
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 关闭资源
     *
     * @param conn 数据库连接
     * @param pstmt 预编译语句
     * @param rs 结果集
     */
    public static void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            System.err.println("关闭结果集失败！");
            e.printStackTrace();
        }
        try {
            if (pstmt != null) pstmt.close();
        } catch (SQLException e) {
            System.err.println("关闭PreparedStatement失败！");
            e.printStackTrace();
        }
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.err.println("关闭数据库连接失败！");
            e.printStackTrace();
        }
    }

    /**
     * 测试数据库连接
     */
    public static void main(String[] args) {
        Connection connection = getConnection();
        if (connection != null) {
            System.out.println("数据库连接成功！");
            close(connection, null, null);
        } else {
            System.out.println("数据库连接失败！");
        }
    }
}
