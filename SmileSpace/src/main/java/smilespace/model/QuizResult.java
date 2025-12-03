package smilespace.model;

import java.util.List;
import java.util.Map;

public class QuizResult {
    private int score;
    private int totalQuestions;
    private List<Question> questions;
    private Map<Integer, Boolean> userAnswers;
    private String moduleName;
    
    public QuizResult() {}
    
    public QuizResult(int score, int totalQuestions, List<Question> questions, 
                     Map<Integer, Boolean> userAnswers, String moduleName) {
        this.score = score;
        this.totalQuestions = totalQuestions;
        this.questions = questions;
        this.userAnswers = userAnswers;
        this.moduleName = moduleName;
    }
    
    // Getters and Setters
    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }
    
    public int getTotalQuestions() { return totalQuestions; }
    public void setTotalQuestions(int totalQuestions) { this.totalQuestions = totalQuestions; }
    
    public List<Question> getQuestions() { return questions; }
    public void setQuestions(List<Question> questions) { this.questions = questions; }
    
    public Map<Integer, Boolean> getUserAnswers() { return userAnswers; }
    public void setUserAnswers(Map<Integer, Boolean> userAnswers) { this.userAnswers = userAnswers; }
    
    public String getModuleName() { return moduleName; }
    public void setModuleName(String moduleName) { this.moduleName = moduleName; }
}