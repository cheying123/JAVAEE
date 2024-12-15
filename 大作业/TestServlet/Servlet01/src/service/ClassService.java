package service;

import dao.ClassDAO;
import java.sql.SQLException;

public class ClassService {

    private final ClassDAO classDAO = new ClassDAO();

    // 创建班级的业务逻辑
    public String createClass(String className, int teacherId, String classBriefly) {
        try {
            // 检查班级名是否已存在
            if (classDAO.isClassNameExists(className)) {
                return "班级名已存在，请选择其他班级名！";
            }

            // 插入班级信息
            boolean isSuccess = classDAO.createClass(className, teacherId, classBriefly);
            return isSuccess ? "success" : "班级创建失败，请稍后重试！";
        } catch (SQLException e) {
            e.printStackTrace();
            return "系统错误：班级创建失败！";
        }
    }

}
