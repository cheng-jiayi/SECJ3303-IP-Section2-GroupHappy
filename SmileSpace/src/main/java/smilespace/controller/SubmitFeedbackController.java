package smilespace.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/submit-feedback")
public class SubmitFeedbackController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form fields
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        // Basic validation
        if (message == null || message.trim().isEmpty()) {
            request.setAttribute("error", "Feedback message cannot be empty!");
            request.getRequestDispatcher("modules/feedbackAndAnalyticsModule/feedback.jsp")
                   .forward(request, response);
            return;
        }

        // Simulate saving (no DB yet)
        System.out.println("=== FEEDBACK RECEIVED ===");
        System.out.println("Name: " + name);
        System.out.println("Email: " + email);
        System.out.println("Message: " + message);
        System.out.println("==========================");

        // Set success message for popup
        request.setAttribute("successMessage", "Your feedback has been submitted successfully!");

        // Forward back to the JSP
        request.getRequestDispatcher("modules/feedbackAndAnalyticsModule/feedback.jsp")
               .forward(request, response);
    }
}
