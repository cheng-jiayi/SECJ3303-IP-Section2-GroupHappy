package smilespace.controller;

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

@WebServlet("/modules/feedbackAndAnalyticsModule/feedbackAnalytics")
public class FeedbackController extends HttpServlet {

    private FeedbackAnalyticsService feedbackAnalyticsService = new FeedbackAnalyticsService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Fetch feedback list from the service
        List<FeedbackModel> feedbackList = feedbackAnalyticsService.getAllFeedback();

        // If feedbackList is null or empty, set an empty list to avoid NPE in JSP
        if (feedbackList == null) {
            feedbackList = new ArrayList<>();
        }

        // Set feedbackList as a request attribute
        request.setAttribute("feedbackList", feedbackList);

        // Set user information from session
        String userFullName = (String) request.getSession().getAttribute("userFullName");
        String userRole = (String) request.getSession().getAttribute("userRole");

        // If userFullName or userRole is null, provide default values
        if (userFullName == null) {
            userFullName = "Guest";
        }
        if (userRole == null) {
            userRole = "Student";
        }

        // Set user info as request attributes to be used in JSP
        request.setAttribute("userFullName", userFullName);
        request.setAttribute("userRole", userRole);

        // Count the number of feedbacks per sentiment
        int positiveCount = 0;
        int neutralCount = 0;
        int negativeCount = 0;
        for (FeedbackModel feedback : feedbackList) {
            if (null != feedback.getSentiment()) switch (feedback.getSentiment()) {
                case "Positive" -> positiveCount++;
                case "Neutral" -> neutralCount++;
                case "Negative" -> negativeCount++;
                default -> {
                }
            }
        }

        // Set sentiment counts as request attributes to be used in JSP
        request.setAttribute("positiveCount", positiveCount);
        request.setAttribute("neutralCount", neutralCount);
        request.setAttribute("negativeCount", negativeCount);

        // Forward the request to the JSP
        request.getRequestDispatcher("/WEB-INF/views/modules/feedbackAndAnalyticsModule/feedbackAnalytics.jsp").forward(request, response);
    }
}