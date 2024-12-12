package service;

import dao.RegisterDAO;

public class RegisterService {
    private final RegisterDAO registerDAO = new RegisterDAO();

    /**
     * 检查用户名是否存在
     *
     * @param username 用户名
     * @param role     用户角色
     * @return 如果存在返回 true，否则返回 false
     */
    public boolean isUsernameExists(String username, String role) {
        return registerDAO.isUsernameExists(username, role);
    }

    /**
     * 注册新用户
     *
     * @param username 用户名
     * @param password 密码
     * @param role     用户角色
     * @return 注册结果
     */
    public boolean registerUser(String username, String password, String role) {


        // 确定用户状态
        String status = "学生家长".equals(role) ? "approved" : "pending";

        // 插入用户
        registerDAO.insertUser(username, password, role, status);

        return true; // 表示注册成功
    }
}
