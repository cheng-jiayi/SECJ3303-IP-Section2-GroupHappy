package smilespace.controller.ManageLearningModule;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import smilespace.model.LearningModule;
import smilespace.service.LearningModuleService;

import jakarta.servlet.http.HttpSession;

@Controller
public class DraftConfirmationController {
    
    @Autowired
    private LearningModuleService moduleService;
    
    @GetMapping("/draft-confirmation")
    public String showDraftConfirmation(@RequestParam("id") String id, 
                                       @RequestParam("action") String action,
                                       Model model,
                                       HttpSession session) {
        
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        LearningModule module = moduleService.getModuleById(id);
        if (module == null) {
            return "redirect:/admin-module-dashboard?error=module_not_found";
        }
        
        if (!module.getCreatedBy().equals(userId)) {
            return "redirect:/admin-module-dashboard?error=unauthorized";
        }
        
        model.addAttribute("module", module);
        model.addAttribute("action", action);
        return "manageLearningModule/draft-confirmation";
    }
    
    @PostMapping("/handle-draft-action")
    public String handleDraftAction(
            @RequestParam("id") String id,
            @RequestParam("action") String action,
            @RequestParam(value = "saveAsDraft", required = false) Boolean saveAsDraft,
            RedirectAttributes redirectAttributes,
            HttpSession session) {
        
        try {
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                redirectAttributes.addFlashAttribute("error", "Please login first");
                return "redirect:/loginPage";
            }
            
            if (saveAsDraft != null && saveAsDraft) {
                boolean success = moduleService.saveAsDraft(id);
                if (success) {
                    redirectAttributes.addFlashAttribute("success", "Module saved as draft successfully");
                } else {
                    redirectAttributes.addFlashAttribute("error", "Failed to save module as draft");
                }
            } else {
                redirectAttributes.addFlashAttribute("info", "Changes discarded");
            }
            
            return "redirect:/admin-module-dashboard";
            
        } catch (Exception e) {
            System.err.println("Error handling draft action: " + e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Error: " + e.getMessage());
            return "redirect:/admin-module-dashboard";
        }
    }
}