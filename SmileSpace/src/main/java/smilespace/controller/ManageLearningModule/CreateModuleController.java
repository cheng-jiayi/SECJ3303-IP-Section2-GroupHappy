package smilespace.controller.ManageLearningModule;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import smilespace.model.LearningModule;  // IMPORT ADDED

@WebServlet("/create-module")
public class CreateModuleController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/modules/manageLearningModule/create-module.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String level = request.getParameter("level");
        String authorName = request.getParameter("authorName");
        String estimatedDuration = request.getParameter("estimatedDuration");
        String coverImage = request.getParameter("coverImage");
        String resourceFile = request.getParameter("resourceFile");
        
        LearningModule module = new LearningModule();
        module.setTitle(title);
        module.setDescription(description);
        module.setCategory(category);
        module.setLevel(level);
        module.setAuthorName(authorName);
        module.setEstimatedDuration(estimatedDuration);
        module.setCoverImage(coverImage);
        module.setResourceFile(resourceFile);
        module.setViews(0);
        
        SimpleDateFormat sdf = new SimpleDateFormat("dd / MM / yyyy");
        module.setLastUpdated(sdf.format(new Date()));
        
        DashboardController.addModule(module);
        
        response.sendRedirect("dashboard");
    }
}