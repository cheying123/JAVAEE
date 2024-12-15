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

    public List<Notification> getNotificationsByAdmin(int adminId) {
        try {
            return notificationDAO.getNotificationsByAdmin(adminId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
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




    public List<Notification> getClassNotificationsByParent(int parentId) throws SQLException {
        return notificationDAO.getClassNotificationsByParent(parentId);
    }

    public List<Notification> getAdminNotification() throws  SQLException{
        return notificationDAO.getAdminNotifications();
    }

}
