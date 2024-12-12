package service;

import dao.LoginDAO;

import java.sql.ResultSet;

public class LoginService {
    private final LoginDAO loginDAO = new LoginDAO();

    /**
     * 检查用户是否存在
     */
    public boolean userExists(String username, String role) throws Exception {
        try (ResultSet rs = loginDAO.findUserByUsernameAndRole(username, role)) {
            return rs != null && rs.next();
        }
    }

    /**
     * 验证密码是否正确
     */
    public boolean validatePassword(String username, String password) throws Exception {
        try (ResultSet rs = loginDAO.validateUserPassword(username, password)) {
            return rs != null && rs.next();
        }
    }

    /**
     * 检查用户审核状态
     */
    public boolean isApprovedOrParent(String username, String password) throws Exception {
        try (ResultSet rs = loginDAO.checkUserApprovalStatus(username, password)) {
            return rs != null && rs.next();
        }
    }

    /**
     * 获取用户ID
     */
    public int getUserId(String username, String role) throws Exception {
        return loginDAO.getUserId(username, role);
    }
}
