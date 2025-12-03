package smilespace.controller.ManageLearningModule;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import smilespace.model.LearningModule;  // Fixed import

@WebServlet("/delete-module")
public class DeleteModuleController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        
        if (id == null || id.isEmpty()) {
            response.sendRedirect("dashboard");
            return;
        }
        
        LearningModule module = DashboardController.getModuleById(id);
        
        if (module == null) {
            response.sendRedirect("dashboard");
            return;
        }
        
        request.setAttribute("module", module);
        // Updated path
        request.getRequestDispatcher("/modules/manageLearningModule/delete-module.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        
        if (id != null && !id.isEmpty()) {
            DashboardController.deleteModule(id);
        }
        
        response.sendRedirect("dashboard");
    }
}