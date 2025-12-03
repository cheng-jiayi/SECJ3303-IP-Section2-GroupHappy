package smilespace.controller.ManageLearningModule;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import smilespace.model.LearningModule;  // IMPORT ADDED

@WebServlet("/edit-module")
public class EditModuleController extends HttpServlet {
    
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
        request.getRequestDispatcher("/modules/manageLearningModule/edit-module.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String level = request.getParameter("level");
        String authorName = request.getParameter("authorName");
        String estimatedDuration = request.getParameter("estimatedDuration");
        String coverImage = request.getParameter("coverImage");
        String resourceFile = request.getParameter("resourceFile");
        
        LearningModule updatedModule = new LearningModule();
        updatedModule.setTitle(title);
        updatedModule.setDescription(description);
        updatedModule.setCategory(category);
        updatedModule.setLevel(level);
        updatedModule.setAuthorName(authorName);
        updatedModule.setEstimatedDuration(estimatedDuration);
        updatedModule.setCoverImage(coverImage);
        updatedModule.setResourceFile(resourceFile);
        updatedModule.setViews(0);
        
        SimpleDateFormat sdf = new SimpleDateFormat("dd / MM / yyyy");
        updatedModule.setLastUpdated(sdf.format(new Date()));
        
        DashboardController.updateModule(id, updatedModule);
        
        response.sendRedirect("dashboard");
    }
}