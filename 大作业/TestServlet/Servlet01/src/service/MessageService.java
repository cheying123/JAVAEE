//封装业务逻辑

package service;

import dao.MessageDAO;
import model.Message;

import java.util.List;

public class MessageService {
    private final MessageDAO messageDAO = new MessageDAO();

    public List<Message> getMessages(Integer userId, String sender, String receiver, String dateFrom, String dateTo, boolean isSender,String content) {
        return messageDAO.queryMessages(userId, sender, receiver, dateFrom, dateTo, isSender,content);
    }
}
