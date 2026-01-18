package smilespace.controller.selfAssessment;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import smilespace.model.DassAssessment;
import smilespace.service.DassAssessmentService;

@Controller
@RequestMapping("/self-assessment")
public class SelfAssessmentController {
    
    @Autowired
    private DassAssessmentService dassAssessmentService;
    
    private static final int TOTAL_QUESTIONS = 21;
    private static final int MIN_ANSWER_VALUE = 0;
    private static final int MAX_ANSWER_VALUE = 3;
    
    @GetMapping("")
    public String showAssessmentForm(Model model, HttpSession session,
                                    @RequestParam(required = false) String error,
                                    @RequestParam(required = false) String success) {
        
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            return "redirect:/login?redirect=/self-assessment";
        }
        
        String[] questions = dassAssessmentService.getQuestions();
        String[] questionTypes = dassAssessmentService.getQuestionTypes();
        
        model.addAttribute("questions", questions);
        model.addAttribute("questionTypes", questionTypes);
        model.addAttribute("totalQuestions", questions.length);
        
        if (error != null && !error.isEmpty()) {
            model.addAttribute("error", error);
        }
        if (success != null && !success.isEmpty()) {
            model.addAttribute("success", success);
        }
        
        return "selfAssessmentModule/assessment";
    }
    
    @GetMapping("/new")
    public String startNewAssessment(HttpSession session, RedirectAttributes redirectAttributes) {
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            return "redirect:/login";
        }
        
        clearSessionAssessmentData(session);
        redirectAttributes.addFlashAttribute("success", "Starting new assessment. Please answer all questions.");
        
        return "redirect:/self-assessment";
    }
    
    @PostMapping("/submit")
    public String submitAssessment(
            @RequestParam Map<String, String> allParams,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            return "redirect:/login";
        }
        
        try {
            List<Integer> answers = parseAnswersFromParameters(allParams);
            
            DassAssessment assessment = createAssessment(userId, answers);
            DassAssessment savedAssessment = dassAssessmentService.saveAssessment(assessment, answers, userId);
            
            if (savedAssessment != null && savedAssessment.getAssessmentId() > 0) {
                storeAssessmentInSession(session, savedAssessment, answers);
                return "redirect:/self-assessment/result/" + savedAssessment.getAssessmentId();
            } else {
                redirectAttributes.addFlashAttribute("error", "Failed to save assessment. Please try again.");
                return "redirect:/self-assessment";
            }
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error processing assessment: " + e.getMessage());
            return "redirect:/self-assessment";
        }
    }
    
    @GetMapping("/result/{id}")
    public String viewResult(
            @PathVariable("id") Integer assessmentId,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            return "redirect:/login";
        }
        
        try {
            DassAssessment assessment = getAssessmentFromSessionOrDatabase(session, assessmentId);
            
            if (assessment == null) {
                redirectAttributes.addFlashAttribute("error", "Assessment not found. It may have been deleted.");
                return "redirect:/self-assessment/my-history";
            }
            
            if (!isUserAuthorized(session, userId, assessment)) {
                redirectAttributes.addFlashAttribute("error", "You are not authorized to view this assessment");
                return "redirect:/dashboard";
            }
            
            model.addAttribute("assessment", assessment);
            model.addAttribute("recommendations", getPersonalizedRecommendations(assessment));
            
            try {
                List<DassAssessment> previousAssessments = dassAssessmentService.getAssessmentsByUser(userId);
                previousAssessments.removeIf(a -> a.getAssessmentId() == assessmentId);
                model.addAttribute("previousAssessments", previousAssessments);
            } catch (Exception e) {
                model.addAttribute("previousAssessments", new ArrayList<>());
            }
            
            clearTemporarySessionData(session);
            
            return "selfAssessmentModule/viewResult";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error loading assessment: " + e.getMessage());
            return "redirect:/self-assessment/my-history";
        }
    }
    
    @GetMapping("/result")
    public String viewLatestResult(HttpSession session, RedirectAttributes redirectAttributes) {
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            return "redirect:/login";
        }
        
        DassAssessment tempAssessment = (DassAssessment) session.getAttribute("tempAssessment");
        if (tempAssessment != null) {
            return "redirect:/self-assessment/result/" + tempAssessment.getAssessmentId();
        }
        
        try {
            List<DassAssessment> assessments = dassAssessmentService.getAssessmentsByUser(userId);
            
            if (assessments != null && !assessments.isEmpty()) {
                return "redirect:/self-assessment/result/" + assessments.get(0).getAssessmentId();
            } else {
                redirectAttributes.addFlashAttribute("error", "No assessments found. Please take an assessment first.");
                return "redirect:/self-assessment";
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error loading assessments. Please take a new assessment.");
            return "redirect:/self-assessment";
        }
    }
    
    @GetMapping("/my-history")
    public String viewMyAssessmentHistory(Model model, HttpSession session) {
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            return "redirect:/login";
        }
        
        try {
            List<DassAssessment> myAssessments = dassAssessmentService.getAssessmentsByUser(userId);
            model.addAttribute("assessments", myAssessments);
            
            if (myAssessments != null && myAssessments.size() > 1) {
                Map<String, Object> comparison = dassAssessmentService.getAssessmentComparison(userId);
                model.addAttribute("comparison", comparison);
            }
            
            return "selfAssessmentModule/myAssessmentHistory";
        } catch (Exception e) {
            model.addAttribute("error", "Error loading assessment history: " + e.getMessage());
            return "selfAssessmentModule/myAssessmentHistory";
        }
    }
    
    @GetMapping("/my-history/export")
    public void exportMyHistory(HttpServletResponse response, HttpSession session) throws IOException {
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            response.sendRedirect(session.getServletContext().getContextPath() + "/login");
            return;
        }
        
        try {
            List<DassAssessment> myAssessments = dassAssessmentService.getAssessmentsByUser(userId);
            
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"my_assessment_history_" + 
                             new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".pdf\"");
            
            createAssessmentHistoryPdf(response, myAssessments, session);
            
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Error exporting PDF: " + e.getMessage());
        }
    }
    
    @PostMapping("/clear-progress")
    @ResponseBody
    public Map<String, Object> clearProgress(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        clearSessionAssessmentData(session);
        response.put("clearLocalStorage", true);
        response.put("success", true);
        response.put("message", "All progress cleared. Ready for new assessment.");
        
        return response;
    }
    
    @GetMapping("/manage")
    public String manageAssessments(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String severity,
            Model model,
            HttpSession session) {
        
        if (!isAuthorizedProfessional(session)) {
            return "redirect:/dashboard?error=unauthorized";
        }
        
        try {
            List<DassAssessment> assessments = getFilteredAssessments(search, severity);
            
            model.addAttribute("assessments", assessments);
            model.addAttribute("search", search);
            model.addAttribute("severity", severity);
            model.addAttribute("averageScores", dassAssessmentService.getAverageScores());
            model.addAttribute("severityDistribution", dassAssessmentService.getSeverityDistribution());
            
            return "selfAssessmentModule/assessmentManagement";
        } catch (Exception e) {
            model.addAttribute("error", "Error loading assessments: " + e.getMessage());
            return "selfAssessmentModule/assessmentManagement";
        }
    }
    
    @PostMapping("/delete")
    public String deleteAssessment(
            @RequestParam Integer assessmentId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        if (!isAuthorizedProfessional(session)) {
            return "redirect:/dashboard?error=unauthorized";
        }
        
        Integer userId = getUserIdFromSession(session);
        boolean success = dassAssessmentService.deleteAssessment(assessmentId, userId);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Assessment deleted successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to delete assessment");
        }
        
        return "redirect:/self-assessment/manage";
    }
    
    @PostMapping("/delete-batch")
    public String deleteBatchAssessments(
            @RequestParam("assessmentIds") List<Integer> assessmentIds,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        if (!isAuthorizedProfessional(session)) {
            return "redirect:/dashboard?error=unauthorized";
        }
        
        Integer userId = getUserIdFromSession(session);
        int successCount = 0;
        int totalCount = assessmentIds != null ? assessmentIds.size() : 0;
        
        if (assessmentIds != null && !assessmentIds.isEmpty()) {
            for (Integer assessmentId : assessmentIds) {
                boolean success = dassAssessmentService.deleteAssessment(assessmentId, userId);
                if (success) {
                    successCount++;
                }
            }
        }
        
        if (successCount > 0) {
            redirectAttributes.addFlashAttribute("success", 
                "Successfully deleted " + successCount + " out of " + totalCount + " assessment(s)!");
        } else {
            redirectAttributes.addFlashAttribute("error", "No assessments were deleted.");
        }
        
        return "redirect:/self-assessment/manage";
    }
    
    @GetMapping("/export/history-csv")
    public void exportPersonalHistoryCsv(HttpServletResponse response, HttpSession session) throws IOException {
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            response.sendRedirect(session.getServletContext().getContextPath() + "/login");
            return;
        }
        
        try {
            List<DassAssessment> myAssessments = dassAssessmentService.getAssessmentsByUser(userId);
            
            response.setContentType("text/csv; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", 
                "attachment; filename=\"my_assessment_history_" + 
                new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".csv\"");
            
            writeAssessmentsToCsv(response, myAssessments);
            
        } catch (Exception e) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<html><body><h3>Error exporting CSV</h3><p>" + 
                                      e.getMessage() + "</p></body></html>");
        }
    }
    
    @GetMapping("/export/csv")
    public void exportAssessmentsCsv(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String severity,
            HttpServletResponse response,
            HttpSession session) throws IOException {
        
        if (!isAuthorizedProfessional(session)) {
            response.sendRedirect(session.getServletContext().getContextPath() + "/dashboard?error=unauthorized");
            return;
        }
        
        try {
            List<DassAssessment> assessments = getFilteredAssessments(search, severity);
            
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=\"assessments_" + 
                             new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".csv\"");
            
            writeProfessionalAssessmentsToCsv(response, assessments);
            
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Error exporting CSV: " + e.getMessage());
        }
    }
    
    @GetMapping("/details/{id}")
    public String viewAssessmentDetails(
            @PathVariable("id") Integer assessmentId,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        if (!isAuthorizedProfessional(session)) {
            return "redirect:/dashboard?error=unauthorized";
        }
        
        try {
            DassAssessment assessment = dassAssessmentService.getAssessmentById(assessmentId);
            
            if (assessment == null) {
                redirectAttributes.addFlashAttribute("error", "Assessment not found with ID: " + assessmentId);
                return "redirect:/self-assessment/manage";
            }
            
            model.addAttribute("assessment", assessment);
            return "selfAssessmentModule/assessmentDetails";
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error loading assessment details: " + e.getMessage());
            return "redirect:/self-assessment/manage";
        }
    }
    
    @GetMapping("/details/{id}/ajax")
    @ResponseBody
    public Map<String, Object> getAssessmentDetailsAjax(
            @PathVariable("id") Integer assessmentId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        if (!isAuthorizedProfessional(session)) {
            response.put("success", false);
            response.put("error", "Unauthorized");
            return response;
        }
        
        try {
            DassAssessment assessment = dassAssessmentService.getAssessmentById(assessmentId);
            
            if (assessment != null) {
                populateAssessmentDetailsResponse(response, assessment);
            } else {
                response.put("success", false);
                response.put("error", "Assessment not found");
            }
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
        }
        
        return response;
    }
    
    private Integer getUserIdFromSession(HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            return null;
        }
        
        if (userIdObj instanceof Integer) {
            return (Integer) userIdObj;
        } else if (userIdObj instanceof String) {
            try {
                return Integer.parseInt((String) userIdObj);
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }
    
    private List<Integer> parseAnswersFromParameters(Map<String, String> allParams) {
        List<Integer> answers = new ArrayList<>();
        for (int i = 0; i < TOTAL_QUESTIONS; i++) {
            String answer = findAnswerForQuestion(allParams, i);
            answers.add(parseAnswerValue(answer));
        }
        return answers;
    }
    
    private String findAnswerForQuestion(Map<String, String> allParams, int questionIndex) {
        String[] possibleNames = {
            "answer" + questionIndex,
            "q" + (questionIndex + 1),
            "question" + (questionIndex + 1)
        };
        
        for (String paramName : possibleNames) {
            String answer = allParams.get(paramName);
            if (answer != null && !answer.trim().isEmpty()) {
                return answer;
            }
        }
        return null;
    }
    
    private int parseAnswerValue(String answer) {
        if (answer == null || answer.trim().isEmpty()) {
            return MIN_ANSWER_VALUE;
        }
        
        try {
            int value = Integer.parseInt(answer.trim());
            if (value >= MIN_ANSWER_VALUE && value <= MAX_ANSWER_VALUE) {
                return value;
            }
        } catch (NumberFormatException e) {
            // Ignore and return default value
        }
        return MIN_ANSWER_VALUE;
    }
    
    private DassAssessment createAssessment(Integer userId, List<Integer> answers) {
        DassAssessment assessment = new DassAssessment();
        assessment.setUserId(userId);
        assessment.setAssessmentDate(new Date());
        
        int depressionScore = dassAssessmentService.calculateScore(answers, "depression");
        int anxietyScore = dassAssessmentService.calculateScore(answers, "anxiety");
        int stressScore = dassAssessmentService.calculateScore(answers, "stress");
        
        assessment.setDepressionScore(depressionScore);
        assessment.setAnxietyScore(anxietyScore);
        assessment.setStressScore(stressScore);
        assessment.setDepressionSeverity(dassAssessmentService.determineSeverity(depressionScore, "depression"));
        assessment.setAnxietySeverity(dassAssessmentService.determineSeverity(anxietyScore, "anxiety"));
        assessment.setStressSeverity(dassAssessmentService.determineSeverity(stressScore, "stress"));
        assessment.setOverallSeverity(dassAssessmentService.determineOverallSeverity(depressionScore, anxietyScore, stressScore));
        assessment.setCompleted(true);
        
        return assessment;
    }
    
    private void storeAssessmentInSession(HttpSession session, DassAssessment assessment, List<Integer> answers) {
        session.setAttribute("tempAssessment", assessment);
        session.setAttribute("tempAnswers", answers);
    }
    
    private DassAssessment getAssessmentFromSessionOrDatabase(HttpSession session, Integer assessmentId) {
        DassAssessment assessment = (DassAssessment) session.getAttribute("tempAssessment");
        
        if (assessment == null) {
            try {
                assessment = dassAssessmentService.getAssessmentById(assessmentId);
            } catch (Exception e) {
                // Log error but continue
            }
        }
        
        return assessment;
    }
    
    private boolean isUserAuthorized(HttpSession session, Integer userId, DassAssessment assessment) {
        if (userId.equals(assessment.getUserId())) {
            return true;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        return "professional".equals(userRole);
    }
    
    private boolean isAuthorizedProfessional(HttpSession session) {
        String userRole = (String) session.getAttribute("userRole");
        return "professional".equals(userRole);
    }
    
    private void clearSessionAssessmentData(HttpSession session) {
        session.removeAttribute("assessmentProgress");
        session.removeAttribute("currentQuestion");
        session.removeAttribute("progressTimestamp");
        session.removeAttribute("currentAssessmentData");
        session.removeAttribute("lastAssessmentId");
        session.removeAttribute("tempAssessment");
        session.removeAttribute("tempAnswers");
    }
    
    private void clearTemporarySessionData(HttpSession session) {
        session.removeAttribute("tempAssessment");
        session.removeAttribute("tempAnswers");
    }
    
    private List<DassAssessment> getFilteredAssessments(String search, String severity) {
        if ((search != null && !search.trim().isEmpty()) || 
            (severity != null && !severity.trim().isEmpty() && !"All Severities".equals(severity))) {
            return dassAssessmentService.searchAssessments(
                search != null ? search.trim() : null,
                severity != null ? severity.trim() : null
            );
        } else {
            return dassAssessmentService.getAllAssessments();
        }
    }
    
    private void createAssessmentHistoryPdf(HttpServletResponse response, 
                                           List<DassAssessment> assessments, 
                                           HttpSession session) throws Exception {
        response.getOutputStream().write("PDF generation would be implemented here".getBytes());
    }
    
    private void writeAssessmentsToCsv(HttpServletResponse response, List<DassAssessment> assessments) throws IOException {
        response.getWriter().write("\uFEFF"); // UTF-8 BOM for Excel
        response.getWriter().write("Assessment ID,Date,Depression Score,Depression Severity,Anxiety Score,Anxiety Severity,Stress Score,Stress Severity,Overall Severity,Total Score\n");
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        for (DassAssessment assessment : assessments) {
            String line = String.format("%d,\"%s\",%d,\"%s\",%d,\"%s\",%d,\"%s\",\"%s\",%d\n",
                assessment.getAssessmentId(),
                dateFormat.format(assessment.getAssessmentDate()),
                assessment.getDepressionScore(),
                assessment.getDepressionSeverity(),
                assessment.getAnxietyScore(),
                assessment.getAnxietySeverity(),
                assessment.getStressScore(),
                assessment.getStressSeverity(),
                assessment.getOverallSeverity(),
                assessment.getDepressionScore() + assessment.getAnxietyScore() + assessment.getStressScore()
            );
            response.getWriter().write(line);
        }
        
        response.getWriter().flush();
    }
    
    private void writeProfessionalAssessmentsToCsv(HttpServletResponse response, 
                                                  List<DassAssessment> assessments) throws IOException {
        response.getWriter().write("Assessment ID,Student Name,Username,Date,Depression Score,Depression Severity,Anxiety Score,Anxiety Severity,Stress Score,Stress Severity,Overall Severity\n");
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        for (DassAssessment assessment : assessments) {
            String line = String.format("%d,\"%s\",\"%s\",\"%s\",%d,\"%s\",%d,\"%s\",%d,\"%s\",\"%s\"\n",
                assessment.getAssessmentId(),
                assessment.getUserFullName() != null ? assessment.getUserFullName() : "",
                assessment.getUserName() != null ? assessment.getUserName() : "",
                dateFormat.format(assessment.getAssessmentDate()),
                assessment.getDepressionScore(),
                assessment.getDepressionSeverity(),
                assessment.getAnxietyScore(),
                assessment.getAnxietySeverity(),
                assessment.getStressScore(),
                assessment.getStressSeverity(),
                assessment.getOverallSeverity()
            );
            response.getWriter().write(line);
        }
        
        response.getWriter().flush();
    }
    
    private void populateAssessmentDetailsResponse(Map<String, Object> response, DassAssessment assessment) {
        response.put("success", true);
        response.put("assessmentId", assessment.getAssessmentId());
        response.put("userFullName", assessment.getUserFullName());
        response.put("userName", assessment.getUserName());
        response.put("assessmentDate", assessment.getAssessmentDate());
        response.put("depressionScore", assessment.getDepressionScore());
        response.put("anxietyScore", assessment.getAnxietyScore());
        response.put("stressScore", assessment.getStressScore());
        response.put("depressionSeverity", assessment.getDepressionSeverity());
        response.put("anxietySeverity", assessment.getAnxietySeverity());
        response.put("stressSeverity", assessment.getStressSeverity());
        response.put("overallSeverity", assessment.getOverallSeverity());
    }
    
    private List<String> getPersonalizedRecommendations(DassAssessment assessment) {
        List<String> recommendations = new ArrayList<>();
        
        addDepressionRecommendations(recommendations, assessment.getDepressionScore());
        addAnxietyRecommendations(recommendations, assessment.getAnxietyScore());
        addStressRecommendations(recommendations, assessment.getStressScore());
        addOverallSeverityRecommendations(recommendations, assessment.getOverallSeverity());
        addGeneralRecommendations(recommendations);
        
        return recommendations.size() > 5 ? recommendations.subList(0, 5) : recommendations;
    }
    
    private void addDepressionRecommendations(List<String> recommendations, int depressionScore) {
        if (depressionScore >= 28) {
            recommendations.add("Your depression score indicates extremely severe symptoms. It's important to seek professional help immediately.");
        } else if (depressionScore >= 21) {
            recommendations.add("Your depression score suggests severe symptoms that may be affecting your daily life.");
        } else if (depressionScore >= 14) {
            recommendations.add("You're experiencing moderate depression symptoms. Consider talking to a counselor.");
        } else if (depressionScore >= 10) {
            recommendations.add("You have mild depression symptoms. Try engaging in regular physical activity.");
        } else {
            recommendations.add("Your depression score is in the normal range. Continue practicing good mental health habits.");
        }
    }
    
    private void addAnxietyRecommendations(List<String> recommendations, int anxietyScore) {
        if (anxietyScore >= 20) {
            recommendations.add("Your anxiety score indicates extremely severe symptoms. Please seek professional support immediately.");
        } else if (anxietyScore >= 15) {
            recommendations.add("You're experiencing severe anxiety. Consider professional support and try relaxation exercises.");
        } else if (anxietyScore >= 10) {
            recommendations.add("Moderate anxiety detected. Practice mindfulness meditation daily.");
        } else if (anxietyScore >= 8) {
            recommendations.add("Mild anxiety symptoms present. Consider keeping a worry journal.");
        }
    }
    
    private void addStressRecommendations(List<String> recommendations, int stressScore) {
        if (stressScore >= 34) {
            recommendations.add("Extremely severe stress levels detected. Implement stress management techniques.");
        } else if (stressScore >= 26) {
            recommendations.add("You're experiencing severe stress. Implement time management strategies.");
        } else if (stressScore >= 19) {
            recommendations.add("Moderate stress levels. Take regular breaks and practice time management.");
        } else if (stressScore >= 15) {
            recommendations.add("Mild stress detected. Regular exercise and proper sleep can help.");
        }
    }
    
    private void addOverallSeverityRecommendations(List<String> recommendations, String overallSeverity) {
        if ("Extremely Severe".equals(overallSeverity) || "Severe".equals(overallSeverity)) {
            recommendations.add("Given your overall score, we strongly recommend contacting professional support.");
            recommendations.add("Consider reaching out to trusted friends or family members for support.");
        } else if ("Moderate".equals(overallSeverity)) {
            recommendations.add("Regular check-ins with a counselor could be beneficial for ongoing support.");
        }
    }
    
    private void addGeneralRecommendations(List<String> recommendations) {
        recommendations.add("Maintain a regular routine with consistent sleep, nutrition, and exercise.");
        recommendations.add("Practice mindfulness or meditation for 10-15 minutes daily.");
        recommendations.add("Connect with friends, family, or support groups regularly.");
        recommendations.add("Explore our learning modules for additional mental health education.");
        recommendations.add("Consider keeping a mood journal to track patterns and triggers.");
    }
}