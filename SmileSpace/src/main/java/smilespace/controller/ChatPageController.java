package smilespace.controller;

import org.springframework.stereotype.Controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;

import smilespace.model.LearningModule;
import smilespace.dao.LearningModuleDAO;

import jakarta.servlet.http.HttpSession;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/ai")
public class ChatPageController {
    
    @Autowired
    private LearningModuleDAO learningModuleDAO;
    
    @Autowired
    private HttpSession httpSession;
    
    @GetMapping("/learn")
    public String learningHub(
            @RequestParam(name = "category", required = false) String category,
            @RequestParam(name = "level", required = false) String level,
            @RequestParam(name = "search", required = false) String search,
            @RequestParam(name = "status", defaultValue = "published") String status,
            Model model) {
        
        try {
            List<LearningModule> modules;
            
            if (search != null && !search.trim().isEmpty() || 
                (category != null && !"all".equals(category)) || 
                (level != null && !"all".equals(level))) {

                modules = learningModuleDAO.search(search, category, level, "Submitted");
            } else {
                modules = learningModuleDAO.findAll();
                modules = modules.stream()
                    .filter(module -> "Submitted".equals(module.getStatus()))
                    .collect(Collectors.toList());
            }
            
            Map<String, Object> stats = learningModuleDAO.getModuleStatistics();
            if (stats != null) {
                Long submittedCount = modules.stream()
                    .filter(module -> "Submitted".equals(module.getStatus()))
                    .count();
                stats.put("totalModules", submittedCount);
                
                Map<String, Integer> submittedCategoryStats = new HashMap<>();
                for (LearningModule module : modules) {
                    if ("Submitted".equals(module.getStatus())) {
                        String cat = module.getCategory();
                        submittedCategoryStats.put(cat, submittedCategoryStats.getOrDefault(cat, 0) + 1);
                    }
                }
                stats.put("categoryStats", submittedCategoryStats);
            }
            
            List<String> categories = new ArrayList<>();
            categories.add("Stress");
            categories.add("Anxiety");
            categories.add("Mindfulness");
            categories.add("Self-Esteem");
            categories.add("Sleep");
            
            List<String> levels = new ArrayList<>();
            levels.add("Beginner");
            levels.add("Intermediate");
            levels.add("Advanced");
            
            model.addAttribute("modules", modules);
            model.addAttribute("stats", stats);
            model.addAttribute("categories", categories);
            model.addAttribute("levels", levels);
            model.addAttribute("selectedCategory", category);
            model.addAttribute("selectedLevel", level);
            model.addAttribute("searchTerm", search);
            
            String userFullName = (String) httpSession.getAttribute("userFullName");
            if (userFullName == null) {
                userFullName = "Guest Student";
            }
            model.addAttribute("userFullName", userFullName);
            
            System.out.println("DEBUG: Loaded " + modules.size() + " SUBMITTED modules for learning hub");
            for (LearningModule module : modules) {
                System.out.println("  - " + module.getId() + " | " + module.getTitle() + 
                                " | Status: " + module.getStatus() + 
                                " | Category: " + module.getCategory());
            }
            
        } catch (Exception e) {
            System.err.println("ERROR loading learning hub: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("modules", new ArrayList<LearningModule>());
            model.addAttribute("error", "Unable to load learning modules. Please try again later.");
        }
        
        return "AIAssistant/Learn/AILearningHub";
    }

    @GetMapping("/learn/{moduleId}")
    public String moduleDetails(
            @PathVariable("moduleId") String moduleId,
            @RequestParam(name = "action", required = false) String action,
            Model model) {
        
        try {
            System.out.println("DEBUG: Loading module details for ID: " + moduleId);
            
            learningModuleDAO.incrementViews(moduleId);
            
            LearningModule module = learningModuleDAO.findById(moduleId);
            
            if (module == null) {
                System.out.println("DEBUG: Module not found with ID: " + moduleId);
                model.addAttribute("error", "Module not found!");
                return "redirect:/ai/learn";
            }
            
            Integer userId = (Integer) httpSession.getAttribute("userId");
            if (userId != null) {
                System.out.println("DEBUG: Recording access for user ID: " + userId);
                learningModuleDAO.recordAccess(moduleId, userId, "view", module.getStatus());
            } else {
                System.out.println("DEBUG: User not logged in (userId is null)");
            }
            
            String[] outlineArray = parseStringToArray(module.getContentOutline());
            String[] guideArray = parseStringToArray(module.getLearningGuide());
            String[] keyPointsArray = parseStringToArray(module.getKeyPoints());
            
            List<Map<String, Object>> accessHistory = learningModuleDAO.getAccessHistory(moduleId);
            
            model.addAttribute("module", module);
            model.addAttribute("outlineArray", outlineArray);
            model.addAttribute("guideArray", guideArray);
            model.addAttribute("keyPointsArray", keyPointsArray);
            model.addAttribute("accessHistory", accessHistory);
            
            String userFullName = (String) httpSession.getAttribute("userFullName");
            if (userFullName == null) {
                userFullName = "Guest Student";
            }
            model.addAttribute("userFullName", userFullName);
            
            System.out.println("DEBUG: Successfully loaded module: " + module.getTitle());
            
        } catch (Exception e) {
            System.err.println("ERROR loading module details: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Unable to load module. Please try again later.");
            return "redirect:/ai/learn";
        }
        
        return "AIAssistant/Learn/module-details";
    }

    @GetMapping("/learn/{moduleId}/interactive")
    public String interactiveLearning(
            @PathVariable("moduleId") String moduleId,
            @RequestParam(name = "topic", defaultValue = "1") String topicParam,
            @RequestParam(name = "complete", defaultValue = "false") String complete,
            Model model) {
        
        try {
            System.out.println("DEBUG: Starting interactive learning for module: " + moduleId);
            
            LearningModule module = learningModuleDAO.findById(moduleId);
            
            if (module == null) {
                System.out.println("DEBUG: Module not found: " + moduleId);
                model.addAttribute("error", "Module not found!");
                return "redirect:/ai/learn";
            }
            
            Integer userId = (Integer) httpSession.getAttribute("userId");
            if (userId != null) {
                System.out.println("DEBUG: Recording interactive learning access for user: " + userId);
                learningModuleDAO.recordAccess(moduleId, userId, "interactive_learning", module.getStatus());
            }
            
            int currentTopic = 1;
            boolean isComplete = "true".equalsIgnoreCase(complete);
            
            if (!isComplete) {
                try {
                    currentTopic = Integer.parseInt(topicParam);
                    if (currentTopic < 1) currentTopic = 1;
                    if (currentTopic > 3) {
                        currentTopic = 3;
                        isComplete = true;
                    }
                } catch (NumberFormatException e) {
                    System.out.println("DEBUG: Invalid topic parameter: " + topicParam + ", defaulting to 1");
                    currentTopic = 1;
                }
            }
            
            System.out.println("DEBUG: Current topic: " + currentTopic + ", Complete: " + isComplete);
            
            Map<String, Object> topicData = getTopicContent(module.getCategory(), currentTopic);
            
            int widthPercent = 0;
            if (!isComplete) {
                widthPercent = (int) Math.round(((currentTopic - 1) * 100.0) / 3.0);
            } else {
                widthPercent = 100;
            }
            
            System.out.println("DEBUG: Progress percentage: " + widthPercent + "%");
            
            model.addAttribute("module", module);
            model.addAttribute("currentTopic", currentTopic);
            model.addAttribute("isComplete", isComplete);
            model.addAttribute("topicTitle", topicData.get("title"));
            model.addAttribute("aiMessage", topicData.get("aiMessage"));
            model.addAttribute("mainContent", topicData.get("mainContent"));
            model.addAttribute("exampleContent", topicData.get("exampleContent"));
            model.addAttribute("progress", widthPercent);
            model.addAttribute("topicData", topicData);
            
            String userFullName = (String) httpSession.getAttribute("userFullName");
            if (userFullName == null) {
                userFullName = "Guest Student";
            }
            model.addAttribute("userFullName", userFullName);
            
            System.out.println("DEBUG: Interactive learning ready for module: " + module.getTitle());
            
        } catch (Exception e) {
            System.err.println("ERROR in interactive learning: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Unable to start interactive learning. Please try again later.");
            return "redirect:/ai/learn";
        }
        
        return "AIAssistant/Learn/learn-module";
    }
    
    @PostMapping("/learn/{moduleId}/start")
    public String startLearningSession(
            @PathVariable("moduleId") String moduleId,
            @RequestParam(name = "mode", defaultValue = "interactive") String mode) {
        
        System.out.println("DEBUG: Starting learning session for module: " + moduleId + ", mode: " + mode);
        
        if ("interactive".equals(mode)) {
            return "redirect:/ai/learn/" + moduleId + "/interactive?topic=1";
        } else {
            return "redirect:/ai/learn/" + moduleId;
        }
    }
    
    @GetMapping("/learn/{moduleId}/next")
    public String nextTopic(
            @PathVariable("moduleId") String moduleId,
            @RequestParam(name = "currentTopic") int currentTopic) {
        
        System.out.println("DEBUG: Moving to next topic. Current topic: " + currentTopic);
        
        if (currentTopic < 3) {
            int nextTopic = currentTopic + 1;
            System.out.println("DEBUG: Redirecting to topic: " + nextTopic);
            return "redirect:/ai/learn/" + moduleId + "/interactive?topic=" + nextTopic;
        } else {
            System.out.println("DEBUG: All topics completed, marking as complete");
            return "redirect:/ai/learn/" + moduleId + "/interactive?complete=true";
        }
    }

    @PostMapping("/learn/{moduleId}/complete")
    @ResponseBody
    public Map<String, Object> completeModule(
            @PathVariable("moduleId") String moduleId) {
        
        System.out.println("DEBUG: Completing module: " + moduleId);
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            LearningModule module = learningModuleDAO.findById(moduleId);
            
            Integer userId = (Integer) httpSession.getAttribute("userId");
            if (userId != null) {
                String moduleStatus = module != null ? module.getStatus() : "published";
                learningModuleDAO.recordAccess(moduleId, userId, "completed", moduleStatus);
                System.out.println("DEBUG: Module completion recorded for user: " + userId);
            }
            
            response.put("success", true);
            response.put("message", "Module completed successfully!");
            response.put("redirect", "/ai/learn/" + moduleId + "/interactive?complete=true");
            
            System.out.println("DEBUG: Module completion response: " + response);
            
        } catch (Exception e) {
            System.err.println("ERROR completing module: " + e.getMessage());
            response.put("success", false);
            response.put("message", "Error completing module: " + e.getMessage());
        }
        
        return response;
    }
    
    @GetMapping("/chat")
    public String aiConservation() {
        System.out.println("DEBUG: Loading AI chat hub");
        return "AIAssistant/Chat/AIConservationHub";
    }
    
    
    private Map<String, Object> getTopicContent(String category, int topicNumber) {
        Map<String, Object> topicData = new HashMap<>();
        
        switch (topicNumber) {
            case 1:
                topicData.put("title", "Understanding " + category);
                topicData.put("aiMessage", "Let's start learning about " + category + ". Understanding the basics is the first step toward improvement.");
                topicData.put("mainContent", "This module will help you understand the fundamentals of " + category.toLowerCase() + ". Knowledge is power when it comes to mental wellness.");
                topicData.put("exampleContent", "For example, many people experience " + category.toLowerCase() + " without recognizing the symptoms. Awareness is the first step to management.");
                topicData.put("responses", Map.of(
                    "what is " + category.toLowerCase(), "This is a comprehensive introduction to " + category.toLowerCase() + " and its effects on mental health.",
                    "symptoms", "Common symptoms include both physical and emotional changes that affect daily functioning.",
                    "causes", "Various factors can contribute, including biological, psychological, and environmental elements."
                ));
                topicData.put("tip", "Start by observing your own experiences without judgment.");
                topicData.put("explainMore", "This topic covers the foundational knowledge needed to understand " + category.toLowerCase() + " and its impact.");
                topicData.put("showExample", "Real-world examples will help you recognize patterns in your own experience.");
                break;
                
            case 2:
                topicData.put("title", "Coping with " + category);
                topicData.put("aiMessage", "Now let's explore practical strategies for managing " + category.toLowerCase() + ".");
                topicData.put("mainContent", "Effective coping strategies can significantly improve your ability to manage " + category.toLowerCase() + ". Practice makes progress.");
                topicData.put("exampleContent", "Try implementing one new strategy this week and observe its effects.");
                topicData.put("responses", Map.of(
                    "strategies", "There are multiple evidence-based strategies for managing " + category.toLowerCase() + ".",
                    "techniques", "Different techniques work for different people - it's about finding what works for you.",
                    "practice", "Consistent practice is key to making these strategies effective."
                ));
                topicData.put("tip", "Small, consistent efforts are more effective than occasional intense efforts.");
                topicData.put("explainMore", "This section covers practical techniques and approaches for managing " + category.toLowerCase() + ".");
                topicData.put("showExample", "Case studies show how others have successfully implemented these strategies.");
                break;
                
            case 3:
                topicData.put("title", "Advanced " + category + " Management");
                topicData.put("aiMessage", "Let's discuss long-term strategies for sustainable " + category.toLowerCase() + " management.");
                topicData.put("mainContent", "Building lasting habits and resilience is crucial for long-term success in managing " + category.toLowerCase() + ".");
                topicData.put("exampleContent", "Creating a personalized wellness plan can help maintain progress over time.");
                topicData.put("responses", Map.of(
                    "long term", "Sustainable management requires ongoing attention and adaptation.",
                    "habits", "Building positive habits creates a foundation for lasting change.",
                    "maintenance", "Regular check-ins and adjustments help maintain progress."
                ));
                topicData.put("tip", "Review and adjust your approach regularly based on what's working.");
                topicData.put("explainMore", "This final section focuses on creating sustainable systems for ongoing management.");
                topicData.put("showExample", "Success stories demonstrate how consistent practice leads to lasting improvement.");
                break;
                
            default:
                topicData.put("title", "Module Complete");
                topicData.put("aiMessage", "Congratulations on completing this module!");
                topicData.put("mainContent", "You've taken important steps toward better understanding and managing " + category.toLowerCase() + ".");
                topicData.put("exampleContent", "Continue practicing what you've learned and consider exploring related modules.");
                break;
        }
        
        return topicData;
    }
    
    private String[] parseStringToArray(String input) {
        if (input == null || input.trim().isEmpty()) {
            return new String[0];
        }
        
        if (input.contains("\n")) {
            return input.split("\n");
        } else if (input.contains(",")) {
            return input.split(",");
        } else if (input.contains(";")) {
            return input.split(";");
        } else {
            return new String[]{input};
        }
    }
}