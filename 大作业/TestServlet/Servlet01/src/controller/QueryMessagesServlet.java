package controller;

import model.Message;
import service.MessageService;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class QueryMessagesServlet extends HttpServlet {
    private final MessageService messageService = new MessageService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("parentId"); // 当前登录用户的 ID
        if( userId == null ){
            userId = (Integer) session.getAttribute("teacherId");
        }

        String sender = request.getParameter("sender");         //发送者
        String receiver = request.getParameter("receiver");     //接受者
        String dateFrom = request.getParameter("dateFrom");     //开始日期
        String dateTo = request.getParameter("dateTo");         //结束日期
        String role = request.getParameter("role"); // 判断用户是发送方还是接收方
        String content = request.getParameter("content");   //获取查询文本

        boolean isSender = "sender".equals(role);

        List<Message> messages = messageService.getMessages(userId, sender, receiver, dateFrom, dateTo, isSender,content);

        request.setAttribute("messages", messages);
        Integer teacherId = (Integer) session.getAttribute("teacherId");
        Integer parentId = (Integer) session.getAttribute("parentId");
        if (teacherId != null){
            RequestDispatcher dispatcher = request.getRequestDispatcher("teacher/queryMessages.jsp");
            dispatcher.forward(request, response);
        }else
        if( parentId != null){
            RequestDispatcher dispatcher = request.getRequestDispatcher("parent/queryMessages.jsp");
            dispatcher.forward(request, response);
        }
    }
}
