package smilespace.controller.ManageLearningModule;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import smilespace.model.LearningModule;
import smilespace.service.LearningModuleService;
import smilespace.model.Question;

import jakarta.servlet.http.HttpSession;
import java.util.*;

@Controller
public class EditQuizController {
    
    @Autowired
    private LearningModuleService moduleService;
    
    @GetMapping("/edit-quiz")
    public String showEditQuizForm(@RequestParam("moduleId") String moduleId, 
                                  Model model, 
                                  HttpSession session) {
        System.out.println("=== EditQuizController: showEditQuizForm for module: " + moduleId + " ===");
        
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            System.out.println("ERROR: User not logged in");
            return "redirect:/login";
        }
        
        System.out.println("User ID from session: " + userId);
        
        LearningModule module = moduleService.getModuleById(moduleId);
        if (module == null) {
            System.out.println("ERROR: Module with ID " + moduleId + " not found!");
            return "redirect:/admin-module-dashboard";
        }
        
        System.out.println("Found module: " + module.getId() + " - " + module.getTitle());
        System.out.println("Module status: " + module.getStatus());
        
        List<Question> existingQuestions = moduleService.getQuizQuestionsByModule(moduleId);
        System.out.println("Retrieved " + (existingQuestions != null ? existingQuestions.size() : 0) + " questions from database");
        
        List<Question> questions;
        
        if (existingQuestions != null && !existingQuestions.isEmpty()) {
            questions = existingQuestions;
            System.out.println("Found existing quiz with " + questions.size() + " questions");
            
            while (questions.size() < 10) {
                Question question = new Question();
                question.setModuleId(moduleId);
                question.setText("");
                question.setCorrectAnswer(true);
                question.setExplanation("");
                question.setOrder(questions.size() + 1);
                questions.add(question);
            }
        } else {
            questions = new ArrayList<>();
            for (int i = 1; i <= 10; i++) {
                Question question = new Question();
                question.setModuleId(moduleId);
                question.setText("");
                question.setCorrectAnswer(true);
                question.setExplanation("");
                question.setOrder(i);
                questions.add(question);
            }
            System.out.println("Created new empty quiz template");
        }
        
        String moduleStatus = module.getStatus();
        String quizStatus = moduleStatus != null ? moduleStatus : "Draft";
        
        System.out.println("Quiz status determined from module status: " + quizStatus);
        
        model.addAttribute("module", module);
        model.addAttribute("questions", questions);
        model.addAttribute("totalQuestions", 10);
        model.addAttribute("duration", "10-15 minutes");
        model.addAttribute("type", "True/False Quiz");
        model.addAttribute("quizStatus", quizStatus);
        
        return "manageLearningModule/edit-quiz";
    }
    
    @PostMapping("/edit-quiz")
    public String updateQuiz(@RequestParam("moduleId") String moduleId,
                           @RequestParam(value = "action", defaultValue = "save") String action,
                           @RequestParam(value = "redirect", defaultValue = "edit") String redirect,
                           @RequestParam Map<String, String> allParams,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        
        System.out.println("=== EditQuizController: updateQuiz for module: " + moduleId + " ===");
        System.out.println("Action: " + action);
        System.out.println("Redirect parameter: " + redirect);
        
        try {
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                return "redirect:/login";
            }
            
            LearningModule module = moduleService.getModuleById(moduleId);
            if (module == null) {
                redirectAttributes.addFlashAttribute("error", "Module not found");
                return "redirect:/admin-module-dashboard";
            }
            
            List<Question> questions = new ArrayList<>();
            int validQuestions = 0;
            
            for (int i = 1; i <= 10; i++) {
                String questionText = allParams.get("question_" + i);
                String correctAnswerStr = allParams.get("correct_answer_" + i);
                String explanation = allParams.get("explanation_" + i);
                
                if (questionText != null && !questionText.trim().isEmpty()) {
                    validQuestions++;
                    Question question = new Question();
                    question.setModuleId(moduleId);
                    question.setText(questionText.trim());
                    
                    boolean correctAnswer = true;
                    if (correctAnswerStr != null && "false".equalsIgnoreCase(correctAnswerStr)) {
                        correctAnswer = false;
                    }
                    question.setCorrectAnswer(correctAnswer);
                    
                    question.setExplanation(explanation != null ? explanation.trim() : "");
                    question.setOrder(i);
                    questions.add(question);
                } else {
                    Question question = new Question();
                    question.setModuleId(moduleId);
                    question.setText("");
                    question.setCorrectAnswer(true);
                    question.setExplanation("");
                    question.setOrder(i);
                    questions.add(question);
                }
            }
            
            System.out.println("Parsed " + validQuestions + " valid questions out of 10");
            
            if ("submit".equalsIgnoreCase(action)) {
                if (validQuestions < 10) {
                    redirectAttributes.addFlashAttribute("error", "Please fill all 10 questions before submitting");
                    redirectAttributes.addFlashAttribute("questions", questions);
                    return "redirect:/edit-quiz?moduleId=" + moduleId;
                }
            } else if ("save".equalsIgnoreCase(action)) {
                if (validQuestions < 1) {
                    redirectAttributes.addFlashAttribute("error", "Please fill at least 1 question before saving as draft");
                    redirectAttributes.addFlashAttribute("questions", questions);
                    return "redirect:/edit-quiz?moduleId=" + moduleId;
                }
            }
            
            boolean saveSuccess = moduleService.saveQuizQuestions(moduleId, questions);
            
            if (saveSuccess) {
                String newStatus;
                String successMessage;
                
                if ("submit".equalsIgnoreCase(action)) {
                    newStatus = "Submitted";
                    successMessage = "Quiz updated and submitted successfully! Module status updated to 'Submitted'.";
                    System.out.println("Module " + moduleId + " status updated to: " + newStatus);
                } else {
                    newStatus = "Draft";
                    successMessage = "Quiz saved as draft successfully! Module status remains as 'Draft'.";
                    System.out.println("Module " + moduleId + " status set to: " + newStatus);
                }
                
                moduleService.updateModuleStatus(moduleId, newStatus);
                
                redirectAttributes.addFlashAttribute("success", successMessage);
                
                if ("dashboard".equalsIgnoreCase(redirect) && "submit".equalsIgnoreCase(action)) {
                    System.out.println("Redirecting to admin-module-dashboard");
                    return "redirect:/admin-module-dashboard";
                } else {
                    System.out.println("Redirecting back to edit-quiz page");
                    return "redirect:/edit-quiz?moduleId=" + moduleId;
                }
                
            } else {
                redirectAttributes.addFlashAttribute("error", "Failed to save quiz questions");
                redirectAttributes.addFlashAttribute("questions", questions);
                return "redirect:/edit-quiz?moduleId=" + moduleId;
            }
            
        } catch (Exception e) {
            System.err.println("ERROR in EditQuizController.updateQuiz: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Error updating quiz: " + e.getMessage());
            return "redirect:/edit-quiz?moduleId=" + moduleId;
        }
    }
}