import java.util.ArrayList;
import java.util.List;

public class UserDatabase {
    private static List<User> userList = new ArrayList<>();
    // 用userList来保存信息，模拟数据库的作用
    // 添加用户到静态列表
    public static void addUser(User user) {
        userList.add(user);
    }

    // 查找用户
    public static User findUser(String username) {
        for (User user : userList) {
            if (user.getUsername().equals(username)) {
                return user;
            }
        }
        return null;
    }
}
