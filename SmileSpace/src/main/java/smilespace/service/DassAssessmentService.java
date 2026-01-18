package smilespace.service;

import java.util.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import smilespace.dao.DassAssessmentDAO;
import smilespace.model.DassAnswer;
import smilespace.model.DassAssessment;

@Service
@Transactional
public class DassAssessmentService {
    private static final Logger logger = Logger.getLogger(DassAssessmentService.class.getName());
    
    @Autowired
    private DassAssessmentDAO dassAssessmentDAO;
    
    private static final String[] QUESTIONS = {
        "I found it hard to wind down",
        "I was aware of dryness of my mouth",
        "I couldn't seem to experience any positive feeling at all",
        "I experienced breathing difficulty",
        "I found it difficult to work up the initiative to do things",
        "I tended to over-react to situations",
        "I experienced trembling",
        "I felt that I was using a lot of nervous energy",
        "I was worried about situations in which I might panic and make a fool of myself",
        "I felt that I had nothing to look forward to",
        "I found myself getting agitated",
        "I found it difficult to relax",
        "I felt down-hearted and blue",
        "I was intolerant of anything that kept me from getting on with what I was doing",
        "I felt I was close to panic",
        "I was unable to become enthusiastic about anything",
        "I felt I wasn't worth much as a person",
        "I felt that I was rather touchy",
        "I was aware of the action of my heart in the absence of physical exertion",
        "I felt scared without any good reason",
        "I felt that life was meaningless"
    };
    
    private static final String[] QUESTION_TYPES = {
        "stress", "anxiety", "depression", "anxiety", "depression",
        "stress", "anxiety", "stress", "anxiety", "depression",
        "stress", "stress", "depression", "stress", "anxiety",
        "depression", "depression", "stress", "anxiety", "anxiety",
        "depression"
    };
    
    private static final int[] DEPRESSION_INDICES = {2, 4, 9, 12, 15, 16, 20};
    private static final int[] ANXIETY_INDICES = {1, 3, 6, 8, 14, 18, 19};
    private static final int[] STRESS_INDICES = {0, 5, 7, 10, 11, 13, 17};
    
    public String[] getQuestions() {
        return QUESTIONS;
    }
    
    public String[] getQuestionTypes() {
        return QUESTION_TYPES;
    }
    
    public int calculateScore(List<Integer> answers, String type) {
        if (answers == null || answers.size() != QUESTIONS.length) {
            logger.warning("Invalid answers list for score calculation");
            return 0;
        }
        
        int[] indices;
        if ("depression".equals(type)) {
            indices = DEPRESSION_INDICES;
        } else if ("anxiety".equals(type)) {
            indices = ANXIETY_INDICES;
        } else if ("stress".equals(type)) {
            indices = STRESS_INDICES;
        } else {
            return 0;
        }
        
        int score = 0;
        for (int index : indices) {
            if (index >= 0 && index < answers.size()) {
                Integer answer = answers.get(index);
                if (answer != null) {
                    score += answer;
                }
            }
        }
        
        return score * 2;
    }
    
    public String determineSeverity(int score, String type) {
        if (type.equals("depression")) {
            if (score <= 9) return "Normal";
            else if (score <= 13) return "Mild";
            else if (score <= 20) return "Moderate";
            else if (score <= 27) return "Severe";
            else return "Extremely Severe";
        } else if (type.equals("anxiety")) {
            if (score <= 7) return "Normal";
            else if (score <= 9) return "Mild";
            else if (score <= 14) return "Moderate";
            else if (score <= 19) return "Severe";
            else return "Extremely Severe";
        } else {
            if (score <= 14) return "Normal";
            else if (score <= 18) return "Mild";
            else if (score <= 25) return "Moderate";
            else if (score <= 33) return "Severe";
            else return "Extremely Severe";
        }
    }
    
    public String determineOverallSeverity(int depressionScore, int anxietyScore, int stressScore) {
        String depSev = determineSeverity(depressionScore, "depression");
        String anxSev = determineSeverity(anxietyScore, "anxiety");
        String strSev = determineSeverity(stressScore, "stress");
        
        int depLevel = getSeverityLevel(depSev);
        int anxLevel = getSeverityLevel(anxSev);
        int strLevel = getSeverityLevel(strSev);
        
        int maxLevel = Math.max(depLevel, Math.max(anxLevel, strLevel));
        
        return getSeverityFromLevel(maxLevel);
    }
    
    private int getSeverityLevel(String severity) {
        if (severity == null) return 0;
        
        switch (severity) {
            case "Extremely Severe": return 5;
            case "Severe": return 4;
            case "Moderate": return 3;
            case "Mild": return 2;
            case "Normal": return 1;
            default: return 0;
        }
    }
    
    private String getSeverityFromLevel(int level) {
        switch (level) {
            case 5: return "Extremely Severe";
            case 4: return "Severe";
            case 3: return "Moderate";
            case 2: return "Mild";
            case 1: return "Normal";
            default: return "Normal";
        }
    }
    
    public DassAssessment saveAssessment(DassAssessment assessment, List<Integer> answers, Integer userId) {
        logger.info(() -> "Starting assessment save for user ID: " + userId);
        
        validateAnswers(answers);
        
        int depressionScore = calculateScore(answers, "depression");
        int anxietyScore = calculateScore(answers, "anxiety");
        int stressScore = calculateScore(answers, "stress");
        
        String depressionSeverity = determineSeverity(depressionScore, "depression");
        String anxietySeverity = determineSeverity(anxietyScore, "anxiety");
        String stressSeverity = determineSeverity(stressScore, "stress");
        String overallSeverity = determineOverallSeverity(depressionScore, anxietyScore, stressScore);
        
        setAssessmentProperties(assessment, userId, depressionScore, anxietyScore, stressScore,
                              depressionSeverity, anxietySeverity, stressSeverity, overallSeverity);
        
        Integer assessmentId = dassAssessmentDAO.createAssessment(assessment);
        
        if (assessmentId == null || assessmentId <= 0) {
            logger.severe("Failed to create assessment in database");
            throw new RuntimeException("Failed to create assessment in database");
        }
        
        assessment.setAssessmentId(assessmentId);
        saveAnswersToDatabase(assessmentId, answers);
        
        logger.info(() -> "Assessment saved successfully with ID: " + assessmentId);
        return assessment;
    }
    
    private void validateAnswers(List<Integer> answers) {
        if (answers == null || answers.size() != QUESTIONS.length) {
            logger.severe("Invalid answers list size: " + (answers != null ? answers.size() : "null"));
            throw new IllegalArgumentException("Invalid answers list. Expected " + QUESTIONS.length + " answers.");
        }
        
        for (int i = 0; i < answers.size(); i++) {
            Integer answer = answers.get(i);
            if (answer == null) {
                logger.severe("Null answer at index " + i);
                throw new IllegalArgumentException("All questions must be answered. Missing question " + (i + 1));
            }
            if (answer < 0 || answer > 3) {
                logger.severe("Invalid answer value at index " + i + ": " + answer);
                throw new IllegalArgumentException("Invalid answer value for question " + (i + 1) + ". Must be between 0-3.");
            }
        }
    }
    
    private void setAssessmentProperties(DassAssessment assessment, Integer userId, 
                                       int depressionScore, int anxietyScore, int stressScore,
                                       String depressionSeverity, String anxietySeverity, 
                                       String stressSeverity, String overallSeverity) {
        assessment.setUserId(userId);
        assessment.setAssessmentDate(new Date());
        assessment.setDepressionScore(depressionScore);
        assessment.setAnxietyScore(anxietyScore);
        assessment.setStressScore(stressScore);
        assessment.setDepressionSeverity(depressionSeverity);
        assessment.setAnxietySeverity(anxietySeverity);
        assessment.setStressSeverity(stressSeverity);
        assessment.setOverallSeverity(overallSeverity);
        assessment.setCompleted(true);
    }
    
    private void saveAnswersToDatabase(Integer assessmentId, List<Integer> answers) {
        List<DassAnswer> dassAnswers = new ArrayList<>();
        for (int i = 0; i < answers.size(); i++) {
            DassAnswer answer = new DassAnswer();
            answer.setAssessmentId(assessmentId);
            answer.setQuestionNumber(i + 1);
            answer.setAnswerValue(answers.get(i));
            answer.setQuestionType(QUESTION_TYPES[i]);
            dassAnswers.add(answer);
        }
        
        boolean answersSaved = dassAssessmentDAO.saveAnswers(assessmentId, dassAnswers);
        if (!answersSaved) {
            logger.warning("Failed to save answers to database for assessment ID: " + assessmentId);
        }
    }
    
    public Map<String, Object> validateAndProcessAnswers(List<Integer> answers) {
        Map<String, Object> result = new HashMap<>();

        if (answers == null || answers.size() != QUESTIONS.length) {
            result.put("valid", false);
            result.put("error", "Invalid number of answers. Expected " + QUESTIONS.length + ", got " + 
                      (answers != null ? answers.size() : "null"));
            return result;
        }

        List<String> validationErrors = new ArrayList<>();
        int answeredCount = 0;
        
        for (int i = 0; i < answers.size(); i++) {
            Integer answer = answers.get(i);
            if (answer == null) {
                continue;
            } else if (answer < 0 || answer > 3) {
                validationErrors.add("Question " + (i + 1) + " has invalid value: " + answer);
            } else {
                answeredCount++;
            }
        }
        
        if (!validationErrors.isEmpty()) {
            result.put("valid", false);
            result.put("errors", validationErrors);
            return result;
        }
        
        int depressionScore = calculateScore(answers, "depression");
        int anxietyScore = calculateScore(answers, "anxiety");
        int stressScore = calculateScore(answers, "stress");
        
        result.put("valid", true);
        result.put("answeredCount", answeredCount);
        result.put("depressionScore", depressionScore);
        result.put("anxietyScore", anxietyScore);
        result.put("stressScore", stressScore);
        result.put("depressionSeverity", determineSeverity(depressionScore, "depression"));
        result.put("anxietySeverity", determineSeverity(anxietyScore, "anxiety"));
        result.put("stressSeverity", determineSeverity(stressScore, "stress"));
        result.put("overallSeverity", determineOverallSeverity(depressionScore, anxietyScore, stressScore));
        
        return result;
    }
    
    public List<String> getProgressRecommendations(List<Integer> answers) {
        List<String> recommendations = new ArrayList<>();
        
        if (answers == null || answers.size() != QUESTIONS.length) {
            recommendations.add("Please complete all questions for accurate results.");
            return recommendations;
        }
        
        int answeredCount = (int) answers.stream().filter(a -> a != null).count();
        int totalQuestions = answers.size();
        int progressPercentage = (answeredCount * 100) / totalQuestions;
        
        recommendations.add("You have completed " + answeredCount + " out of " + totalQuestions + 
                           " questions (" + progressPercentage + "%)");
        
        if (progressPercentage == 0) {
            recommendations.add("Get started by answering the first question above.");
        } else if (progressPercentage < 25) {
            recommendations.add("You're just getting started! Keep going to get accurate results.");
        } else if (progressPercentage < 50) {
            recommendations.add("Great progress! You're almost halfway through.");
        } else if (progressPercentage < 75) {
            recommendations.add("More than halfway there! Your results are becoming clearer.");
        } else if (progressPercentage < 100) {
            recommendations.add("Almost done! Just a few more questions to go.");
        } else {
            recommendations.add("All questions answered! Ready to submit.");
        }
        
        if (answeredCount > 0 && answeredCount < totalQuestions) {
            Map<String, Object> validation = validateAndProcessAnswers(answers);
            if ((boolean) validation.get("valid")) {
                int depressionScore = (int) validation.get("depressionScore");
                int anxietyScore = (int) validation.get("anxietyScore");
                int stressScore = (int) validation.get("stressScore");
                
                recommendations.add("Current scores (partial): Depression: " + depressionScore + 
                                  ", Anxiety: " + anxietyScore + ", Stress: " + stressScore);
            }
        }
        
        return recommendations;
    }
    
    public List<DassAssessment> getAssessmentsByUser(int userId) {
        return dassAssessmentDAO.getAssessmentsByUserId(userId);
    }
    
    public List<DassAssessment> getAllAssessments() {
        return dassAssessmentDAO.getAllAssessments();
    }
    
    public DassAssessment getAssessmentById(int assessmentId) {
        return dassAssessmentDAO.getAssessmentById(assessmentId);
    }
    
    public boolean deleteAssessment(int assessmentId, Integer userId) {
        return dassAssessmentDAO.deleteAssessment(assessmentId, userId);
    }
    
    public List<DassAssessment> searchAssessments(String searchTerm, String severity) {
        return dassAssessmentDAO.searchAssessments(searchTerm, severity);
    }
    
    public Map<String, Double> getAverageScores() {
        return dassAssessmentDAO.getAverageScores();
    }
    
    public Map<String, Integer> getSeverityDistribution() {
        return dassAssessmentDAO.getSeverityDistribution();
    }

    public Map<String, Object> getAssessmentComparison(int userId) {
        Map<String, Object> comparison = new HashMap<>();
        List<DassAssessment> assessments = getAssessmentsByUser(userId);
        
        if (assessments.size() >= 2) {
            DassAssessment latest = assessments.get(0);
            DassAssessment previous = assessments.get(1);
            
            comparison.put("latest", latest);
            comparison.put("previous", previous);
            
            Map<String, String> changes = new HashMap<>();
            changes.put("depression", getChangeText(latest.getDepressionScore() - previous.getDepressionScore(), 
                                                    previous.getDepressionScore(), latest.getDepressionScore()));
            changes.put("anxiety", getChangeText(latest.getAnxietyScore() - previous.getAnxietyScore(), 
                                                 previous.getAnxietyScore(), latest.getAnxietyScore()));
            changes.put("stress", getChangeText(latest.getStressScore() - previous.getStressScore(), 
                                                previous.getStressScore(), latest.getStressScore()));
            changes.put("overallSeverity", getSeverityChange(latest.getOverallSeverity(), previous.getOverallSeverity()));
            
            comparison.put("changes", changes);
            
            int totalDiff = (latest.getDepressionScore() - previous.getDepressionScore()) +
                          (latest.getAnxietyScore() - previous.getAnxietyScore()) +
                          (latest.getStressScore() - previous.getStressScore());
            comparison.put("trend", totalDiff < 0 ? "improving" : totalDiff > 0 ? "deteriorating" : "stable");
        }
        
        return comparison;
    }

    private String getChangeText(int diff, int previous, int latest) {
        if (diff > 0) {
            return String.format("Increased by %d points (from %d to %d)", diff, previous, latest);
        } else if (diff < 0) {
            return String.format("Decreased by %d points (from %d to %d)", Math.abs(diff), previous, latest);
        } else {
            return String.format("No change (%d points)", latest);
        }
    }

    private String getSeverityChange(String latest, String previous) {
        if (latest.equals(previous)) {
            return "Remained " + latest;
        } else {
            return "Changed from " + previous + " to " + latest;
        }
    }

    public List<Map<String, Object>> getAssessmentTimeline(int userId) {
        List<Map<String, Object>> timeline = new ArrayList<>();
        List<DassAssessment> assessments = getAssessmentsByUser(userId);
        
        for (int i = 0; i < assessments.size(); i++) {
            DassAssessment assessment = assessments.get(i);
            Map<String, Object> timelineItem = new HashMap<>();
            
            timelineItem.put("assessmentId", assessment.getAssessmentId());
            timelineItem.put("date", assessment.getAssessmentDate());
            timelineItem.put("depressionScore", assessment.getDepressionScore());
            timelineItem.put("anxietyScore", assessment.getAnxietyScore());
            timelineItem.put("stressScore", assessment.getStressScore());
            timelineItem.put("overallSeverity", assessment.getOverallSeverity());
            
            if (i > 0) {
                DassAssessment prev = assessments.get(i - 1);
                timelineItem.put("depressionChange", assessment.getDepressionScore() - prev.getDepressionScore());
                timelineItem.put("anxietyChange", assessment.getAnxietyScore() - prev.getAnxietyScore());
                timelineItem.put("stressChange", assessment.getStressScore() - prev.getStressScore());
            }
            
            timeline.add(timelineItem);
        }
        
        return timeline;
    }
    
    public List<Map<String, Object>> getAssessmentHistory(int assessmentId) {
        return dassAssessmentDAO.getAssessmentHistory(assessmentId);
    }
    
    public Map<String, Object> getUserQuickStats(int userId) {
        return dassAssessmentDAO.getUserQuickStats(userId);
    }
}