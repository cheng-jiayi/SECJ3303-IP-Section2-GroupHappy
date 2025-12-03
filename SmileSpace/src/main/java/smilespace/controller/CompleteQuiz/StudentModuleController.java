package smilespace.controller.CompleteQuiz;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "StudentModuleController", value = "/student-learning-modules")
public class StudentModuleController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Add a simple test message first
        System.out.println("StudentModuleController accessed!");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/modules/completeQuiz/student-module.jsp");
        dispatcher.forward(request, response);
    }
}