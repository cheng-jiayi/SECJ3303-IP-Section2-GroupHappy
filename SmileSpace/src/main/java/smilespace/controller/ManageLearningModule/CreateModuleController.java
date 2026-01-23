package smilespace.controller.ManageLearningModule;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import smilespace.model.LearningModule;
import smilespace.service.LearningModuleService;
import smilespace.service.FileStorageService;

import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;

import javax.sql.DataSource;

@Controller
public class CreateModuleController {
    
    @Autowired
    private LearningModuleService moduleService;

    @Autowired
    private FileStorageService fileStorageService;
    
    @Autowired
    private DataSource dataSource;
    
    @GetMapping("/create-module")
    public String showCreateForm(Model model, HttpServletRequest request) {
        System.out.println("=== CreateModuleController: showCreateForm ===");
        return "manageLearningModule/create-module";
    }
    
    @PostMapping("/create-module")
    public String createModule(
            @RequestParam("title") String title,
            @RequestParam("description") String description,
            @RequestParam("category") String category,
            @RequestParam("level") String level,
            @RequestParam("authorName") String authorName,
            @RequestParam("estimatedDuration") String estimatedDuration,
            @RequestParam(value = "videoUrl", required = false) String videoUrl,
            @RequestParam(value = "contentOutline", required = false) String contentOutline,
            @RequestParam(value = "learningGuide", required = false) String learningGuide,
            @RequestParam(value = "learningTip", required = false) String learningTip,
            @RequestParam(value = "keyPoints", required = false) String keyPoints,
            @RequestParam(value = "notes", required = false) String notes,
            @RequestParam(value = "coverImage", required = false) MultipartFile coverImage,
            @RequestParam(value = "resourceFile", required = false) MultipartFile resourceFile,
            @RequestParam(value = "action", defaultValue = "save") String action,
            @RequestParam(value = "redirectTo", defaultValue = "dashboard") String redirectTo,
            HttpSession session,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {
        
        try {
            System.out.println("=== Creating Module ===");
            System.out.println("Title: " + title);
            System.out.println("Action received: " + action);
            System.out.println("RedirectTo received: " + redirectTo);
            System.out.println("Cover image present: " + (coverImage != null && !coverImage.isEmpty()));
            System.out.println("User ID from session: " + session.getAttribute("userId"));
            
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                System.out.println("ERROR: User not logged in");
                redirectAttributes.addFlashAttribute("error", "Please login first");
                return "redirect:/login";
            }
            
            List<String> errors = new ArrayList<>();
            
            if (title == null || title.trim().isEmpty()) {
                errors.add("Title is required");
            }
            
            if (description == null || description.trim().isEmpty()) {
                errors.add("Description is required");
            }
            
            if (category == null || category.trim().isEmpty()) {
                errors.add("Category is required");
            }
            
            if (level == null || level.trim().isEmpty()) {
                errors.add("Level is required");
            }
            
            if (authorName == null || authorName.trim().isEmpty()) {
                errors.add("Author Name is required");
            }
            
            if (estimatedDuration == null || estimatedDuration.trim().isEmpty()) {
                errors.add("Estimated Duration is required");
            }
            
            if (coverImage == null || coverImage.isEmpty()) {
                errors.add("Cover image is required");
            } else {
                String contentType = coverImage.getContentType();
                if (contentType != null && !contentType.startsWith("image/")) {
                    errors.add("Please upload a valid image file (JPEG, PNG, GIF, BMP)");
                }
                
                if (coverImage.getSize() > 10 * 1024 * 1024) {
                    errors.add("Cover image must be less than 10MB");
                }
            }
            
            if (!errors.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", String.join("<br>", errors));
                return "redirect:/create-module";
            }
            
            System.out.println("All validations passed");
            
            String nextId = generateNextModuleId();
            System.out.println("Generated module ID: " + nextId);
            
            String coverImagePath = null;
            String resourceFilePath = null;
            
            try {
                if (coverImage != null && !coverImage.isEmpty()) {
                    coverImagePath = fileStorageService.storeFile(coverImage, "covers");
                    System.out.println("Cover image saved to: " + coverImagePath);
                }
            } catch (Exception e) {
                System.err.println("Error storing cover image: " + e.getMessage());
                redirectAttributes.addFlashAttribute("error", "Error uploading cover image: " + e.getMessage());
                return "redirect:/create-module";
            }
            
            if (resourceFile != null && !resourceFile.isEmpty()) {
                try {
                    resourceFilePath = fileStorageService.storeFile(resourceFile, "resources");
                    System.out.println("Resource file saved to: " + resourceFilePath);
                } catch (Exception e) {
                    System.err.println("Error storing resource file: " + e.getMessage());
                }
            }
            
            boolean success = saveModuleWithFilePaths(nextId, title, description, category, level, 
                                                    authorName, estimatedDuration, videoUrl,
                                                    contentOutline, learningGuide, learningTip,
                                                    keyPoints, notes, coverImagePath, resourceFilePath,
                                                    action, redirectTo, userId);
            
            if (success) {
                moduleService.recordModuleAccess(nextId, userId, "create");
                
                if ("quiz".equalsIgnoreCase(redirectTo)) {
                    System.out.println("SUCCESS: Module saved with 'Draft' status, redirecting to quiz creation");
                    System.out.println("DEBUG: Redirecting to quiz for module: " + nextId);
                    
                    session.setAttribute("newModuleId", nextId);
                    session.setAttribute("newModuleTitle", title);
                    session.setAttribute("newModuleCategory", category);
                    session.setAttribute("newModuleLevel", level);
                    
                    System.out.println("DEBUG: Session verification:");
                    System.out.println("  - newModuleId in session: " + session.getAttribute("newModuleId"));
                    
                    redirectAttributes.addFlashAttribute("success", "Module saved successfully! Now create the quiz.");
                    redirectAttributes.addFlashAttribute("moduleId", nextId);
                    redirectAttributes.addFlashAttribute("moduleTitle", title);
                    
                    redirectAttributes.getFlashAttributes().remove("error");
                    
                    return "redirect:/create-quiz?moduleId=" + nextId;
                } else {
                    System.out.println("SUCCESS: Module saved, redirecting to dashboard");
                    String message = "save".equals(action) 
                        ? "Module saved as draft successfully!" 
                        : "Module submitted successfully!";
                    redirectAttributes.addFlashAttribute("success", message);
                    return "redirect:/admin-module-dashboard";
                }
                
            } else {
                System.out.println("ERROR: Failed to create module in database");
                redirectAttributes.addFlashAttribute("error", "Failed to create module. Please try again.");
                return "redirect:/create-module";
            }
            
        } catch (Exception e) {
            System.err.println("ERROR in CreateModuleController: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Error creating module: " + e.getMessage());
            return "redirect:/create-module";
        }
    }

    private boolean saveModuleWithFilePaths(String moduleId, String title, String description, String category,
                                  String level, String authorName, String estimatedDuration,
                                  String videoUrl, String contentOutline, String learningGuide,
                                  String learningTip, String keyPoints, String notes,
                                  String coverImagePath, String resourceFilePath,
                                  String action, String redirectTo, int userId) {
        

        String status = "save".equals(action) ? "Draft" : "Submitted";
        System.out.println("Saving module with status: " + status);
        
        String sql = "INSERT INTO learning_modules (id, title, description, category, level, author_name, " +
                    "estimated_duration, video_url, content_outline, learning_guide, learning_tip, key_points, " +
                    "notes, views, last_updated, created_by, cover_image_path, resource_file_path, status, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        System.out.println("SQL Query: " + sql);
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String currentDate = sdf.format(new Date());
            
            if ("Advanced".equals(level)) {
                level = "Advance";
            }

            stmt.setString(1, moduleId);
            stmt.setString(2, title);
            stmt.setString(3, description);
            stmt.setString(4, category);
            stmt.setString(5, level);
            stmt.setString(6, authorName);
            stmt.setString(7, estimatedDuration);
            stmt.setString(8, videoUrl != null ? videoUrl : "");
            stmt.setString(9, contentOutline != null ? contentOutline : "");
            stmt.setString(10, learningGuide != null ? learningGuide : "");
            stmt.setString(11, learningTip != null ? learningTip : "");
            stmt.setString(12, keyPoints != null ? keyPoints : "");
            stmt.setString(13, notes != null ? notes : "");
            stmt.setInt(14, 0); 
            stmt.setString(15, currentDate); 
            stmt.setInt(16, userId); 

            if (coverImagePath != null) {
                stmt.setString(17, coverImagePath);
                System.out.println("Setting cover image path: " + coverImagePath);
            } else {
                stmt.setNull(17, java.sql.Types.VARCHAR);
                System.out.println("No cover image path provided");
            }
            
            if (resourceFilePath != null) {
                stmt.setString(18, resourceFilePath);
                System.out.println("Setting resource file path: " + resourceFilePath);
            } else {
                stmt.setNull(18, java.sql.Types.VARCHAR);
                System.out.println("No resource file path provided");
            }
            
            stmt.setString(19, status);
            
            stmt.setTimestamp(20, new Timestamp(System.currentTimeMillis())); 
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            System.out.println("Module saved: " + moduleId + " with status: " + status);
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("Error saving module with file paths: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private String generateNextModuleId() {
        try {
            List<LearningModule> allModules = moduleService.getAllModules();
            int maxId = 0;
            
            for (LearningModule module : allModules) {
                String id = module.getId();
                if (id != null && id.startsWith("LM")) {
                    try {
                        int idNum = Integer.parseInt(id.substring(2));
                        if (idNum > maxId) {
                            maxId = idNum;
                        }
                    } catch (NumberFormatException e) {
                        System.err.println("Error parsing ID: " + id);
                    }
                }
            }
            
            String nextId = "LM" + String.format("%03d", maxId + 1);
            System.out.println("Generated next module ID: " + nextId);
            return nextId;
        } catch (Exception e) {
            System.err.println("Error generating module ID: " + e.getMessage());
            return "LM001"; 
        }
    }
}