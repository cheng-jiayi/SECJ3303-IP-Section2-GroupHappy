package smilespace.controller.completeQuiz;

import smilespace.model.LearningModule;
import smilespace.service.LearningModuleService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.beans.factory.annotation.Autowired;
import jakarta.servlet.http.HttpSession;

@Controller
public class StudentModuleController {
    
    @Autowired
    private LearningModuleService moduleService;
    
    @GetMapping("/student-module")
    public String showModule(@RequestParam(value = "id", required = false) String moduleId,
                            @RequestParam(value = "action", required = false) String action,
                            @RequestParam(value = "category", required = false) String category,
                            HttpSession session,
                            Model model) {
        
        System.out.println("StudentModuleController: moduleId=" + moduleId + ", action=" + action + ", category=" + category);
        
        if (moduleId == null) {

            if (category != null) {
                return "redirect:/quiz-dashboard?category=" + category;
            }
            return "redirect:/quiz-dashboard";
        }
        
        try {
            LearningModule module = moduleService.getModuleById(moduleId);
            
            if (module == null) {
                System.out.println("Module not found in DB for ID: " + moduleId);
                if (category != null) {
                    return "redirect:/quiz-dashboard?category=" + category;
                }
                return "redirect:/quiz-dashboard";
            }
            
            System.out.println("Found module: " + module.getTitle());
            
            moduleService.incrementModuleViews(moduleId);
            
            session.setAttribute("currentModule", module);
            
            if (category != null) {
                model.addAttribute("category", category);
            } else {
                model.addAttribute("category", module.getCategory());
            }
            
            if ("content".equals(action)) {
                String videoUrl = module.getVideoUrl();
                model.addAttribute("videoUrl", videoUrl);
                model.addAttribute("module", module);
                
                return "completeQuiz/module-content";
            } else {
                model.addAttribute("module", module);
                model.addAttribute("contentOutline", module.getContentOutlineArray());
                model.addAttribute("learningGuide", module.getLearningGuideArray());
                model.addAttribute("keyPoints", module.getKeyPointsArray());
                
                return "completeQuiz/quiz-intro";
            }
            
        } catch (Exception e) {
            System.err.println("ERROR in StudentModuleController: " + e.getMessage());
            e.printStackTrace();
            if (category != null) {
                return "redirect:/quiz-dashboard?category=" + category;
            }
            return "redirect:/quiz-dashboard";
        }
    }
}