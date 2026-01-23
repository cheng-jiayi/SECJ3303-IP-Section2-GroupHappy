package smilespace.controller.ManageLearningModule;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;

import smilespace.model.LearningModule;
import smilespace.service.LearningModuleService;
import smilespace.model.Question;

import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
public class ViewQuizController {
    
    @Autowired
    private LearningModuleService moduleService;
    
    @GetMapping("/view-quiz")
    public String viewQuiz(@RequestParam("moduleId") String moduleId, 
                          Model model, 
                          HttpSession session) {
        System.out.println("=== ViewQuizController: viewQuiz for module: " + moduleId + " ===");
        
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        LearningModule module = moduleService.getModuleById(moduleId);
        if (module == null) {
            return "redirect:/admin-module-dashboard";
        }
        
        List<Question> questions = moduleService.getQuizQuestionsByModule(moduleId);
        
        long filledQuestions = questions.stream()
            .filter(q -> q.getText() != null && !q.getText().trim().isEmpty())
            .count();
        
        model.addAttribute("module", module);
        model.addAttribute("questions", questions);
        model.addAttribute("totalQuestions", 10);
        model.addAttribute("duration", "10-15 minutes");
        model.addAttribute("type", "True/False Quiz");
        model.addAttribute("filledQuestions", filledQuestions);
        
        return "manageLearningModule/view-quiz";
    }
}