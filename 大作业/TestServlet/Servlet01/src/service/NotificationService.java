package service;

import dao.NotificationDAO;
import model.Notification;

import java.sql.SQLException;
import java.util.List;

public class NotificationService {
    private NotificationDAO notificationDAO;

    public NotificationService() {
        this.notificationDAO = new NotificationDAO();
    }

    public boolean addNotification(int adminId, String title, String content) {
        try {
            return notificationDAO.addNotification(adminId, title, content);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteNotification(int notificationId) {
        try {
            return notificationDAO.deleteNotification(notificationId);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
