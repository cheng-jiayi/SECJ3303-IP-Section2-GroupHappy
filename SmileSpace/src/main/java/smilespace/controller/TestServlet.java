
package smilespace.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "TestServlet", value = "/test")
public class TestServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<h1>Servlet is working!</h1>");
        out.println("<p>Server Time: " + new java.util.Date() + "</p>");
        out.println("<p>Context Path: " + request.getContextPath() + "</p>");
        out.println("<h2>Test Links:</h2>");
        out.println("<ul>");
        out.println("<li><a href='" + request.getContextPath() + "/student-learning-modules'>Student Modules</a></li>");
        out.println("<li><a href='" + request.getContextPath() + "/quiz-dashboard'>Quiz Dashboard</a></li>");
        out.println("<li><a href='" + request.getContextPath() + "/quiz?action=start'>Quiz Start</a></li>");
        out.println("</ul>");
        out.println("</body></html>");
    }
}