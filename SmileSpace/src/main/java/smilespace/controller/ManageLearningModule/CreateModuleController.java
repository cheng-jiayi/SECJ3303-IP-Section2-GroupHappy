package smilespace.controller.ManageLearningModule;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import smilespace.model.LearningModule;
import jakarta.servlet.annotation.MultipartConfig;

@WebServlet("/create-module")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 10, // 10MB max file size
    maxRequestSize = 1024 * 1024 * 15 // 15MB max request size
)
public class CreateModuleController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/modules/manageLearningModule/create-module.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 处理表单数据
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String level = request.getParameter("level");
        String authorName = request.getParameter("authorName");
        String estimatedDuration = request.getParameter("estimatedDuration");
        String notes = request.getParameter("notes");
        
        // 处理文件上传
        Part coverImagePart = request.getPart("coverImage");
        Part resourceFilePart = request.getPart("resourceFile");
        
        String coverImage = "";
        String resourceFile = "";
        
        if (coverImagePart != null && coverImagePart.getSize() > 0) {
            String fileName = getFileName(coverImagePart);
            if (fileName != null && !fileName.isEmpty()) {
                coverImage = "uploads/" + fileName; // 保存路径，实际项目中需要保存文件
            }
        }
        
        if (resourceFilePart != null && resourceFilePart.getSize() > 0) {
            String fileName = getFileName(resourceFilePart);
            if (fileName != null && !fileName.isEmpty()) {
                resourceFile = "uploads/" + fileName; // 保存路径，实际项目中需要保存文件
            }
        }
        
        // 创建并保存模块
        LearningModule module = new LearningModule();
        module.setTitle(title);
        module.setDescription(description);
        module.setCategory(category);
        module.setLevel(level);
        module.setAuthorName(authorName);
        module.setEstimatedDuration(estimatedDuration);
        module.setCoverImage(coverImage);
        module.setResourceFile(resourceFile);
        module.setNotes(notes);
        module.setViews(0);
        
        SimpleDateFormat sdf = new SimpleDateFormat("dd / MM / yyyy");
        module.setLastUpdated(sdf.format(new Date()));
        
        DashboardController.addModule(module);
        
        response.sendRedirect("dashboard");
    }
    
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf('=') + 2, item.length() - 1);
            }
        }
        return null;
    }
}