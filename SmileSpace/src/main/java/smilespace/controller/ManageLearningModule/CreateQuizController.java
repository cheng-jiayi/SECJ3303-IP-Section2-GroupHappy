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
public class CreateQuizController {
    
    @Autowired
    private LearningModuleService moduleService;
    
    @GetMapping("/create-quiz")
    public String showCreateQuizForm(@RequestParam("moduleId") String moduleId, 
                                    Model model, 
                                    HttpSession session,
                                    RedirectAttributes redirectAttributes) {
        System.out.println("=== CreateQuizController: showCreateQuizForm for module: " + moduleId + " ===");
        
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            System.out.println("User not logged in, redirecting to login");
            return "redirect:/login";
        }
        
        LearningModule module = moduleService.getModuleById(moduleId);
        if (module == null) {
            System.out.println("ERROR: Module not found: " + moduleId);
            redirectAttributes.addFlashAttribute("error", "Module not found");
            return "redirect:/admin-module-dashboard";
        }
        
        System.out.println("Module found: " + module.getId() + " - " + module.getTitle());
        System.out.println("Module status: " + module.getStatus());
        System.out.println("Module created by: " + module.getCreatedBy());
        System.out.println("Current user ID: " + userId);
        
        List<Question> existingQuestions = moduleService.getQuizQuestionsByModule(moduleId);
        List<Question> questions;
        
        if (existingQuestions != null && !existingQuestions.isEmpty()) {
            questions = existingQuestions;
            System.out.println("Found existing quiz with " + questions.size() + " questions");
        } else {
            questions = new ArrayList<>();
            for (int i = 1; i <= 10; i++) {
                Question question = new Question();
                question.setModuleId(moduleId);
                question.setOrder(i);
                question.setText("");
                question.setCorrectAnswer(true); 
                question.setExplanation("");
                questions.add(question);
            }
            System.out.println("Created new empty quiz template");
        }
        
        boolean isModuleSubmitted = "Submitted".equalsIgnoreCase(module.getStatus());
        
        boolean hasExistingQuiz = existingQuestions != null && !existingQuestions.isEmpty();
        boolean quizHasBeenSubmitted = false;
        
        if (hasExistingQuiz) {
            for (Question q : existingQuestions) {
                if (q.getText() != null && !q.getText().trim().isEmpty()) {
                    quizHasBeenSubmitted = true;
                    break;
                }
            }
        }
        
        model.addAttribute("module", module);
        model.addAttribute("questions", questions);
        model.addAttribute("totalQuestions", 10);
        model.addAttribute("duration", "10-15 minutes");
        model.addAttribute("type", "True/False Quiz");
        model.addAttribute("isModuleSubmitted", isModuleSubmitted);
        model.addAttribute("hasExistingQuiz", hasExistingQuiz);
        model.addAttribute("quizHasBeenSubmitted", quizHasBeenSubmitted);
        
        return "manageLearningModule/create-quiz";
    }
    
    @PostMapping("/create-quiz")
    public String saveQuiz(@RequestParam("moduleId") String moduleId,
                          @RequestParam(value = "action", defaultValue = "save") String action,
                          @RequestParam Map<String, String> allParams,
                          HttpSession session,
                          RedirectAttributes redirectAttributes) {
        
        System.out.println("=== CreateQuizController: saveQuiz for module: " + moduleId + " ===");
        System.out.println("Action: " + action);
        
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
            
            boolean isModuleSubmitted = "Submitted".equalsIgnoreCase(module.getStatus());
            
            if ("submit".equalsIgnoreCase(action)) {
                if (validQuestions < 10) {
                    redirectAttributes.addFlashAttribute("error", "Please fill all 10 questions before submitting");
                    redirectAttributes.addFlashAttribute("questions", questions);
                    return "redirect:/create-quiz?moduleId=" + moduleId;
                }
            }
            
            boolean saveSuccess = moduleService.saveQuizQuestions(moduleId, questions);
            
            if (saveSuccess) {
                String newStatus;
                String successMessage;
                
                if ("submit".equalsIgnoreCase(action)) {
                    newStatus = "Submitted";
                    successMessage = "Quiz submitted successfully! Module status set to 'Submitted'.";
                    System.out.println("Module " + moduleId + " status set to: " + newStatus);
                } else {
                    newStatus = "Draft";
                    
                    if (isModuleSubmitted) {
                        successMessage = "Quiz saved as draft successfully! Note: Module was previously submitted. You need to submit the quiz again to update.";
                    } else {
                        successMessage = "Quiz saved as draft. Module status set to 'Draft'.";
                    }
                    System.out.println("Module " + moduleId + " status set to: " + newStatus);
                }
                
                moduleService.updateModuleStatus(moduleId, newStatus);
                
                session.removeAttribute("newModuleId");
                session.removeAttribute("newModuleTitle");
                session.removeAttribute("newModuleCategory");
                session.removeAttribute("newModuleLevel");
                
                redirectAttributes.addFlashAttribute("success", successMessage);
                redirectAttributes.addFlashAttribute("isModuleSubmitted", isModuleSubmitted);
                return "redirect:/admin-module-dashboard";
            } else {
                redirectAttributes.addFlashAttribute("error", "Failed to save quiz questions");
                redirectAttributes.addFlashAttribute("questions", questions);
                return "redirect:/create-quiz?moduleId=" + moduleId;
            }
            
        } catch (Exception e) {
            System.err.println("ERROR in CreateQuizController.saveQuiz: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Error creating quiz: " + e.getMessage());
            return "redirect:/create-quiz?moduleId=" + moduleId;
        }
    }
}