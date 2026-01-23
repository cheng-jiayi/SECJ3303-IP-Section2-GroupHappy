package smilespace.controller.ManageLearningModule;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;

import smilespace.model.LearningModule;
import smilespace.service.LearningModuleService;

import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Controller
public class ViewModuleController {
    
    @Autowired
    private LearningModuleService moduleService;
    
    @GetMapping("/view-module")
    public String viewModule(@RequestParam("id") String id, 
                            Model model, 
                            HttpSession session,
                            HttpServletRequest request) {
        
        if (id == null || id.isEmpty()) {
            return "redirect:/admin-module-dashboard";
        }
        
        LearningModule module = moduleService.getModuleById(id);
        
        if (module == null) {
            return "redirect:/admin-module-dashboard";
        }
        
        String contextPath = request.getContextPath();
        
        String coverImagePath = module.getCoverImagePath();
        boolean hasCoverImage = (coverImagePath != null && !coverImagePath.trim().isEmpty());
        
        if (hasCoverImage) {
            String imageUrl = contextPath + "/uploads/" + coverImagePath;
            module.setCoverImage(imageUrl);
        } else {
            module.setCoverImage("");
        }
        
        String resourceFilePath = module.getResourceFilePath();
        boolean hasResourceFile = (resourceFilePath != null && !resourceFilePath.trim().isEmpty());
        
        if (hasResourceFile) {
            String resourceUrl = contextPath + "/uploads/" + resourceFilePath;
            module.setResourceFile(resourceUrl);
            
            String fileName = resourceFilePath.substring(resourceFilePath.lastIndexOf("/") + 1);
            model.addAttribute("resourceFileName", fileName);
        } else {
            module.setResourceFile("");
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");
        
        if (userId != null) {
            moduleService.recordModuleAccess(id, userId, "view");
        }
        
        if (userId != null && ("admin".equals(userRole) || "faculty".equals(userRole) || "professional".equals(userRole))) {
            List<Map<String, Object>> accessHistory = moduleService.getAccessHistory(id);
            model.addAttribute("accessHistory", accessHistory);
        }
        
        model.addAttribute("hasCoverImage", hasCoverImage);
        model.addAttribute("hasResourceFile", hasResourceFile);
        model.addAttribute("module", module);
        model.addAttribute("userRole", userRole);
        return "manageLearningModule/view-module";
    }
}