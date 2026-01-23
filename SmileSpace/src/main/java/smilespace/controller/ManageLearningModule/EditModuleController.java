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
import smilespace.model.Question;

import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Controller
public class EditModuleController {
    
    @Autowired
    private LearningModuleService moduleService;
    
    @Autowired
    private FileStorageService fileStorageService;
    
    
    @GetMapping("/edit-module")
    public String showEditForm(@RequestParam("id") String id, Model model) {
        System.out.println("=== EditModuleController called ===");
        
        if (id == null || id.isEmpty()) {
            System.out.println("ERROR: ID is null or empty!");
            return "redirect:/admin-module-dashboard";
        }
        
        LearningModule module = moduleService.getModuleById(id);
        
        if (module == null) {
            System.out.println("ERROR: Module with ID " + id + " not found!");
            return "redirect:/admin-module-dashboard";
        }
        
        System.out.println("Module details:");
        System.out.println("  ID: " + module.getId());
        System.out.println("  Title: " + module.getTitle());
        System.out.println("  Status: " + module.getStatus());
        System.out.println("  Cover Image Path: " + module.getCoverImagePath());
        System.out.println("  Resource File Path: " + module.getResourceFilePath());
        
        List<Question> quizQuestions = moduleService.getQuizQuestionsByModule(id);
        boolean quizExists = quizQuestions != null && !quizQuestions.isEmpty();
        
        model.addAttribute("module", module);
        model.addAttribute("quizExists", quizExists);
        return "manageLearningModule/edit-module";
    }
    
    @PostMapping("/edit-module")
    public String updateModule(
            @RequestParam("id") String id,
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
            @RequestParam(value = "redirect", defaultValue = "edit") String redirect,
            HttpSession session,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {
        
        System.out.println("=== Processing Edit Module ===");
        System.out.println("Action: " + action);
        System.out.println("Redirect parameter: " + redirect);
        
        try {
            if (id == null || id.isEmpty()) {
                System.out.println("ERROR: ID is null or empty!");
                return "redirect:/admin-module-dashboard";
            }
            
            LearningModule existingModule = moduleService.getModuleById(id);
            if (existingModule == null) {
                System.out.println("ERROR: Module with ID " + id + " not found!");
                return "redirect:/admin-module-dashboard";
            }
            
            System.out.println("Found existing module: " + existingModule.getId() + " - " + existingModule.getTitle());
            
            String oldCoverImagePath = existingModule.getCoverImagePath();
            String oldResourceFilePath = existingModule.getResourceFilePath();
            
            if (coverImage != null && !coverImage.isEmpty()) {
                try {
                    String newCoverImagePath = fileStorageService.storeFile(coverImage, "covers");
                    System.out.println("New cover image saved to: " + newCoverImagePath);
                    
                    if (oldCoverImagePath != null && !oldCoverImagePath.isEmpty()) {
                        fileStorageService.deleteFile(oldCoverImagePath);
                    }
                    
                    existingModule.setCoverImagePath(newCoverImagePath);
                } catch (Exception e) {
                    System.err.println("Error storing cover image: " + e.getMessage());
                    redirectAttributes.addFlashAttribute("error", "Error uploading cover image: " + e.getMessage());
                    return "redirect:/edit-module?id=" + id;
                }
            }
            
            if (resourceFile != null && !resourceFile.isEmpty()) {
                try {
                    String newResourceFilePath = fileStorageService.storeFile(resourceFile, "resources");
                    System.out.println("New resource file saved to: " + newResourceFilePath);
                    
                    if (oldResourceFilePath != null && !oldResourceFilePath.isEmpty()) {
                        fileStorageService.deleteFile(oldResourceFilePath);
                    }
                    
                    existingModule.setResourceFilePath(newResourceFilePath);
                } catch (Exception e) {
                    System.err.println("Error storing resource file: " + e.getMessage());
                    redirectAttributes.addFlashAttribute("error", "Error uploading resource file: " + e.getMessage());
                    return "redirect:/edit-module?id=" + id;
                }
            }
            
            existingModule.setTitle(title != null ? title : existingModule.getTitle());
            existingModule.setDescription(description != null ? description : existingModule.getDescription());
            existingModule.setCategory(category != null ? category : existingModule.getCategory());
            
            if (level != null) {
                if ("Advanced".equals(level)) {
                    existingModule.setLevel("Advance");
                } else {
                    existingModule.setLevel(level);
                }
            }
            
            existingModule.setAuthorName(authorName != null ? authorName : existingModule.getAuthorName());
            existingModule.setEstimatedDuration(estimatedDuration != null ? estimatedDuration : existingModule.getEstimatedDuration());
            existingModule.setVideoUrl(videoUrl != null ? videoUrl : existingModule.getVideoUrl());
            existingModule.setContentOutline(contentOutline != null ? contentOutline : existingModule.getContentOutline());
            existingModule.setLearningGuide(learningGuide != null ? learningGuide : existingModule.getLearningGuide());
            existingModule.setLearningTip(learningTip != null ? learningTip : existingModule.getLearningTip());
            existingModule.setKeyPoints(keyPoints != null ? keyPoints : existingModule.getKeyPoints());
            existingModule.setNotes(notes != null ? notes : existingModule.getNotes());
            
            boolean hasNullStatus = moduleService.hasNullStatus(id);
            System.out.println("Module has null status? " + hasNullStatus);
            
            if ("submit".equals(action)) {
                existingModule.setStatus("Submitted");
            } else {
                existingModule.setStatus("Draft");
            }
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            existingModule.setLastUpdated(sdf.format(new Date()));
            
            System.out.println("Updated module: " + existingModule.getId() + " with status: " + existingModule.getStatus());
            System.out.println("Cover image path: " + existingModule.getCoverImagePath());
            System.out.println("Resource file path: " + existingModule.getResourceFilePath());
            
            boolean success = moduleService.updateModule(id, existingModule);
            System.out.println("Module update result: " + success);
            
            if (success) {
                Integer userId = (Integer) session.getAttribute("userId");
                
                if (userId != null) {
                    moduleService.recordModuleAccess(id, userId, "edit");
                }
                
                String successMessage = "Draft".equals(existingModule.getStatus()) ? 
                    "Module saved as draft successfully" : 
                    "Module submitted successfully";
                System.out.println("Edit module completed successfully: " + successMessage);
                
                redirectAttributes.addFlashAttribute("success", successMessage);
                
                String redirectTo = request.getParameter("redirectTo");
                if ("quiz".equals(redirectTo)) {
                    System.out.println("Redirecting to create quiz after saving module");
                    return "redirect:/create-quiz?moduleId=" + id;
                }
                
                System.out.println("Redirecting to admin-module-dashboard");
                return "redirect:/admin-module-dashboard";
                
            } else {
                redirectAttributes.addFlashAttribute("error", "Failed to update module");
                return "redirect:/edit-module?id=" + id;
            }
            
        } catch (Exception e) {
            System.out.println("ERROR in EditModuleController: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Server error: " + e.getMessage());
            return "redirect:/admin-module-dashboard";
        }
    }
}