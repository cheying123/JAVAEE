package controller;

import dao.MessageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class SendMessageServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取当前登录的用户ID (老师或者家长)
        Integer senderId = (Integer) request.getSession().getAttribute("teacherId");
        if( senderId == null ){
            senderId = (Integer) request.getSession().getAttribute("parentId");
        }

        int receiverId = Integer.parseInt(request.getParameter("receiverId"));  // 获取接收方的ID (家长)
        String content = request.getParameter("content");  // 获取消息内容

        MessageDAO messageDAO = new MessageDAO();
        String string = messageDAO.sendMessage(senderId,receiverId,content);
        request.setAttribute("resultMessage", string);      //发送结果消息

        // 发送完消息后，重定向回发送消息的页面
        Integer teacherId = (Integer) request.getSession().getAttribute("teacherId");
        if( teacherId != null ){
            request.getRequestDispatcher("teacher/sendMessages.jsp").forward(request, response);
        }else{
            request.getRequestDispatcher("parent/sendMessages.jsp").forward(request, response);
        }

    }
}
