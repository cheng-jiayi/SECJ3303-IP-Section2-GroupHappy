package smilespace.controller.completeQuiz;

import smilespace.model.LearningModule;
import smilespace.service.LearningModuleService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.List;
import java.util.stream.Collectors;

@Controller
public class QuizDashboardController {
    
    @Autowired
    private LearningModuleService moduleService;
    
    @GetMapping("/quiz-dashboard")
    public String showDashboard(@RequestParam(value = "category", required = false) String category,
                               Model model) {
        
        System.out.println("=== QuizDashboardController START ===");
        System.out.println("Requested category: " + category);
        
        List<LearningModule> modules;
        String pageTitle;
        String selectedCategory = category;
        
        if (category == null || category.isEmpty() || "all".equalsIgnoreCase(category)) {
            modules = moduleService.getAllModules();
            modules = modules.stream()
                .filter(module -> "Submitted".equals(module.getStatus()))
                .collect(Collectors.toList());
            pageTitle = "All Learning Modules";
            selectedCategory = "all";
            System.out.println("No category specified, showing ALL SUBMITTED modules");
        } else {
            modules = moduleService.getModulesByCategory(category);
            modules = modules.stream()
                .filter(module -> "Submitted".equals(module.getStatus()))
                .collect(Collectors.toList());
            pageTitle = category + " Modules";
            System.out.println("Showing SUBMITTED modules for category: " + category);
        }
        
        System.out.println("Submitted modules found: " + modules.size());
        
        for (LearningModule module : modules) {
            System.out.println("Submitted Module: " + module.getId() + " - " + 
                             module.getTitle() + " | Category: " + module.getCategory() + 
                             " | Status: " + module.getStatus());
        }
        
        model.addAttribute("stressModules", modules);
        model.addAttribute("pageTitle", pageTitle);
        model.addAttribute("selectedCategory", selectedCategory);
        
        System.out.println("=== QuizDashboardController END ===");
        
        return "completeQuiz/quiz-dashboard";
    }
}