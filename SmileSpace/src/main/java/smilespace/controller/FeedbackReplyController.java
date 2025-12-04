package smilespace.controller;

public package smilespace.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import smilespace.model.FeedbackModel;
import smilespace.service.FeedbackAnalyticsService;

@WebServlet("/feedback/reply")
public class FeedbackReplyController extends HttpServlet {

    private FeedbackAnalyticsService feedbackAnalyticsService = new FeedbackAnalyticsService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the feedback ID from the URL
        String feedbackIdStr = request.getParameter("id");
        int feedbackId = Integer.parseInt(feedbackIdStr);

        // Fetch the feedback based on the ID
        FeedbackModel feedback = feedbackAnalyticsService.getFeedbackById(feedbackId);

        // Set the feedback details to the request attributes
        request.setAttribute("feedbackName", feedback.getName());
        request.setAttribute("feedbackMessage", feedback.getMessage());
        request.setAttribute("feedbackId", feedback.getId());

        // Forward to the reply page
        request.getRequestDispatcher("/WEB-INF/views/feedbackReply.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the reply message and feedback ID from the form
        String replyMessage = request.getParameter("replyMessage");
        int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));

        // Save the reply using the service
        feedbackAnalyticsService.sendReply(feedbackId, replyMessage);

        // Redirect back to the feedback analytics page
        response.sendRedirect("/modules/feedbackAndAnalyticsModule/feedbackAnalytics");
    }
}
 {
    
}
