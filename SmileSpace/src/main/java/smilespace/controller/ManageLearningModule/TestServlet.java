package smilespace.controller.ManageLearningModule;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/test")
public class TestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><title>Test</title></head>");
        out.println("<body>");
        out.println("<h1>Test Servlet Working!</h1>");
        out.println("<p>If you see this, servlets are working correctly.</p>");
        
        // Test if model class exists
        try {
            Class.forName("smilespace.model.LearningModule");
            out.println("<p style='color:green'>✅ LearningModule class found!</p>");
        } catch (ClassNotFoundException e) {
            out.println("<p style='color:red'>❌ LearningModule class NOT found</p>");
        }
        
        out.println("</body>");
        out.println("</html>");
    }
}