package smilespace.controller.ManageLearningModule;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import smilespace.model.LearningModule;

@WebServlet("/edit-module")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 10, // 10MB max file size
    maxRequestSize = 1024 * 1024 * 15 // 15MB max request size
)
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
        
        System.out.println("=== Processing Edit Module (Multipart) ===");
        
        try {
            // Get form parameters using request.getParameter() - should work with @MultipartConfig
            String id = request.getParameter("id");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String category = request.getParameter("category");
            String level = request.getParameter("level");
            String authorName = request.getParameter("authorName");
            String estimatedDuration = request.getParameter("estimatedDuration");
            String notes = request.getParameter("notes");
            
            System.out.println("ID: " + id);
            System.out.println("Title: " + title);
            System.out.println("Category: " + category);
            System.out.println("Level: " + level);
            System.out.println("Author: " + authorName);
            
            if (id == null || id.isEmpty()) {
                System.out.println("ERROR: ID is null or empty!");
                response.sendRedirect("dashboard");
                return;
            }
            
            // Get existing module
            LearningModule existingModule = DashboardController.getModuleById(id);
            if (existingModule == null) {
                System.out.println("ERROR: Module with ID " + id + " not found!");
                response.sendRedirect("dashboard");
                return;
            }
            
            System.out.println("Found existing module: " + existingModule.getId() + " - " + existingModule.getTitle());
            
            // Update the existing module
            existingModule.setTitle(title != null ? title : existingModule.getTitle());
            existingModule.setDescription(description != null ? description : existingModule.getDescription());
            existingModule.setCategory(category != null ? category : existingModule.getCategory());
            existingModule.setLevel(level != null ? level : existingModule.getLevel());
            existingModule.setAuthorName(authorName != null ? authorName : existingModule.getAuthorName());
            existingModule.setEstimatedDuration(estimatedDuration != null ? estimatedDuration : existingModule.getEstimatedDuration());
            existingModule.setNotes(notes != null ? notes : existingModule.getNotes());
            
            // Handle file uploads
            Part coverImagePart = request.getPart("coverImage");
            Part resourceFilePart = request.getPart("resourceFile");
            
            if (coverImagePart != null && coverImagePart.getSize() > 0) {
                String fileName = getFileName(coverImagePart);
                if (fileName != null && !fileName.isEmpty()) {
                    existingModule.setCoverImage("uploads/" + fileName);
                    System.out.println("Updated cover image: " + fileName);
                }
            }
            
            if (resourceFilePart != null && resourceFilePart.getSize() > 0) {
                String fileName = getFileName(resourceFilePart);
                if (fileName != null && !fileName.isEmpty()) {
                    existingModule.setResourceFile("uploads/" + fileName);
                    System.out.println("Updated resource file: " + fileName);
                }
            }
            
            // Update last updated date
            SimpleDateFormat sdf = new SimpleDateFormat("dd / MM / yyyy");
            existingModule.setLastUpdated(sdf.format(new Date()));
            
            System.out.println("Updated module: " + existingModule.getId());
            System.out.println("New title: " + existingModule.getTitle());
            System.out.println("New category: " + existingModule.getCategory());
            System.out.println("New level: " + existingModule.getLevel());
            
            // Update module in DashboardController
            DashboardController.updateModule(id, existingModule);
            
            System.out.println("Edit module completed successfully");
            
        } catch (Exception e) {
            System.out.println("ERROR in EditModuleController: " + e.getMessage());
            e.printStackTrace();
        }
        
        response.sendRedirect("dashboard");
    }
    
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null) return null;
        
        String[] items = contentDisposition.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf('=') + 2, item.length() - 1);
            }
        }
        return null;
    }
}