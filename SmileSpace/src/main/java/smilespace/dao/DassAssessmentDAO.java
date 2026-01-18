package smilespace.dao;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import smilespace.model.DassAnswer;
import smilespace.model.DassAssessment;

@Repository
@Transactional
public class DassAssessmentDAO {
    
    private static final String ASSESSMENTS_TABLE = "dass_assessments";
    private static final String ANSWERS_TABLE = "dass_answers";
    private static final String USERS_TABLE = "users";
    private static final String HISTORY_TABLE = "assessment_history";
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    private final RowMapper<DassAssessment> assessmentRowMapper = (rs, rowNum) -> {
        DassAssessment assessment = new DassAssessment();
        assessment.setAssessmentId(rs.getInt("assessment_id"));
        assessment.setUserId(rs.getInt("user_id"));
        
        Timestamp assessmentTimestamp = rs.getTimestamp("assessment_date");
        if (assessmentTimestamp != null) {
            assessment.setAssessmentDate(new Date(assessmentTimestamp.getTime()));
        }
        
        assessment.setDepressionScore(rs.getInt("depression_score"));
        assessment.setAnxietyScore(rs.getInt("anxiety_score"));
        assessment.setStressScore(rs.getInt("stress_score"));
        assessment.setDepressionSeverity(rs.getString("depression_severity"));
        assessment.setAnxietySeverity(rs.getString("anxiety_severity"));
        assessment.setStressSeverity(rs.getString("stress_severity"));
        assessment.setOverallSeverity(rs.getString("overall_severity"));
        assessment.setCompleted(rs.getBoolean("is_completed"));
        
        try {
            assessment.setUserFullName(rs.getString("full_name"));
            assessment.setUserName(rs.getString("username"));
        } catch (Exception e) {
            // Ignore if columns don't exist
        }
        
        return assessment;
    };
    
    private final RowMapper<DassAnswer> answerRowMapper = (rs, rowNum) -> {
        DassAnswer answer = new DassAnswer();
        answer.setAnswerId(rs.getInt("answer_id"));
        answer.setAssessmentId(rs.getInt("assessment_id"));
        answer.setQuestionNumber(rs.getInt("question_number"));
        answer.setAnswerValue(rs.getInt("answer_value"));
        answer.setQuestionType(rs.getString("question_type"));
        return answer;
    };
    
    @Transactional
    public Integer createAssessment(DassAssessment assessment) {
        String sql = "INSERT INTO " + ASSESSMENTS_TABLE + " " +
                    "(user_id, assessment_date, depression_score, anxiety_score, stress_score, " +
                    "depression_severity, anxiety_severity, stress_severity, overall_severity, is_completed) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try {
            GeneratedKeyHolder keyHolder = new GeneratedKeyHolder();
            
            int affectedRows = jdbcTemplate.update(connection -> {
                java.sql.PreparedStatement ps = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, assessment.getUserId());
                ps.setTimestamp(2, new java.sql.Timestamp(assessment.getAssessmentDate().getTime()));
                ps.setInt(3, assessment.getDepressionScore());
                ps.setInt(4, assessment.getAnxietyScore());
                ps.setInt(5, assessment.getStressScore());
                ps.setString(6, assessment.getDepressionSeverity());
                ps.setString(7, assessment.getAnxietySeverity());
                ps.setString(8, assessment.getStressSeverity());
                ps.setString(9, assessment.getOverallSeverity());
                ps.setBoolean(10, true);
                return ps;
            }, keyHolder);
            
            if (affectedRows > 0) {
                Number generatedId = keyHolder.getKey();
                if (generatedId != null) {
                    int assessmentId = generatedId.intValue();
                    assessment.setAssessmentId(assessmentId);
                    return assessmentId;
                } else {
                    int assessmentId = jdbcTemplate.queryForObject("SELECT LAST_INSERT_ID()", Integer.class);
                    assessment.setAssessmentId(assessmentId);
                    return assessmentId;
                }
            }
            return null;
            
        } catch (Exception e) {
            throw new RuntimeException("Error creating assessment", e);
        }
    }
    
    @Transactional
    public boolean saveAnswers(int assessmentId, List<DassAnswer> answers) {
        if (answers == null || answers.isEmpty()) {
            return false;
        }
        
        try {
            deleteExistingAnswers(assessmentId);
            return insertAnswers(assessmentId, answers);
            
        } catch (Exception e) {
            throw new RuntimeException("Error saving answers for assessment ID: " + assessmentId, e);
        }
    }
    
    private void deleteExistingAnswers(int assessmentId) {
        String deleteSql = "DELETE FROM " + ANSWERS_TABLE + " WHERE assessment_id = ?";
        jdbcTemplate.update(deleteSql, assessmentId);
    }
    
    private boolean insertAnswers(int assessmentId, List<DassAnswer> answers) {
        String insertSql = "INSERT INTO " + ANSWERS_TABLE + " (assessment_id, question_number, answer_value, question_type) " +
                          "VALUES (?, ?, ?, ?)";
        
        List<Object[]> batchArgs = new ArrayList<>();
        for (DassAnswer answer : answers) {
            batchArgs.add(new Object[]{
                assessmentId,
                answer.getQuestionNumber(),
                answer.getAnswerValue(),
                answer.getQuestionType()
            });
        }
        
        int[] batchResults = jdbcTemplate.batchUpdate(insertSql, batchArgs);
        int successCount = 0;
        for (int result : batchResults) {
            if (result >= 0) {
                successCount++;
            }
        }
        
        return successCount == answers.size();
    }
    
    public DassAssessment getAssessmentById(int assessmentId) {
        String sql = "SELECT da.*, u.full_name, u.username " +
                    "FROM " + ASSESSMENTS_TABLE + " da " +
                    "LEFT JOIN " + USERS_TABLE + " u ON da.user_id = u.user_id " +
                    "WHERE da.assessment_id = ?";
        
        try {
            DassAssessment assessment = jdbcTemplate.queryForObject(sql, assessmentRowMapper, assessmentId);
            if (assessment != null) {
                assessment.setAnswers(getAnswersByAssessmentId(assessmentId));
            }
            return assessment;
        } catch (Exception e) {
            return null;
        }
    }
    
    public List<DassAssessment> getAssessmentsByUserId(int userId) {
        String sql = "SELECT * FROM " + ASSESSMENTS_TABLE + " WHERE user_id = ? ORDER BY assessment_date DESC";
        
        try {
            return jdbcTemplate.query(sql, assessmentRowMapper, userId);
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    public List<DassAssessment> getAllAssessments() {
        String sql = "SELECT da.*, u.full_name, u.username " +
                    "FROM " + ASSESSMENTS_TABLE + " da " +
                    "LEFT JOIN " + USERS_TABLE + " u ON da.user_id = u.user_id " +
                    "ORDER BY da.assessment_date DESC";
        
        try {
            return jdbcTemplate.query(sql, assessmentRowMapper);
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    public List<DassAnswer> getAnswersByAssessmentId(int assessmentId) {
        String sql = "SELECT * FROM " + ANSWERS_TABLE + " WHERE assessment_id = ? ORDER BY question_number";
        
        try {
            return jdbcTemplate.query(sql, answerRowMapper, assessmentId);
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    @Transactional
    public boolean deleteAssessment(int assessmentId, Integer userId) {
        try {
            logHistory(assessmentId, userId, "DELETE", "Assessment deleted");
            
            String sql = "DELETE FROM " + ASSESSMENTS_TABLE + " WHERE assessment_id = ?";
            int affectedRows = jdbcTemplate.update(sql, assessmentId);
            return affectedRows > 0;
        } catch (Exception e) {
            throw new RuntimeException("Error deleting assessment ID: " + assessmentId, e);
        }
    }
    
    public List<DassAssessment> searchAssessments(String searchTerm, String severity) {
        StringBuilder sql = new StringBuilder(
            "SELECT da.*, u.full_name, u.username " +
            "FROM " + ASSESSMENTS_TABLE + " da " +
            "LEFT JOIN " + USERS_TABLE + " u ON da.user_id = u.user_id " +
            "WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR u.username LIKE ?)");
            String searchParam = "%" + searchTerm + "%";
            params.add(searchParam);
            params.add(searchParam);
        }
        
        if (severity != null && !"All Severities".equals(severity) && !severity.isEmpty()) {
            sql.append(" AND da.overall_severity = ?");
            params.add(severity);
        }
        
        sql.append(" ORDER BY da.assessment_date DESC");
        
        try {
            return jdbcTemplate.query(sql.toString(), assessmentRowMapper, params.toArray());
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    public Map<String, Double> getAverageScores() {
        Map<String, Double> averages = new HashMap<>();
        String sql = "SELECT " +
                    "AVG(depression_score) as avg_depression, " +
                    "AVG(anxiety_score) as avg_anxiety, " +
                    "AVG(stress_score) as avg_stress " +
                    "FROM " + ASSESSMENTS_TABLE + " WHERE is_completed = TRUE";
        
        try {
            Map<String, Object> result = jdbcTemplate.queryForMap(sql);
            
            averages.put("depression", getDoubleValue(result.get("avg_depression")));
            averages.put("anxiety", getDoubleValue(result.get("avg_anxiety")));
            averages.put("stress", getDoubleValue(result.get("avg_stress")));
            
        } catch (Exception e) {
            averages.put("depression", 0.0);
            averages.put("anxiety", 0.0);
            averages.put("stress", 0.0);
        }
        
        return averages;
    }
    
    private double getDoubleValue(Object value) {
        return value != null ? ((Number) value).doubleValue() : 0.0;
    }
    
    public Map<String, Integer> getSeverityDistribution() {
        Map<String, Integer> distribution = new HashMap<>();
        String sql = "SELECT overall_severity, COUNT(*) as count " +
                    "FROM " + ASSESSMENTS_TABLE + " " +
                    "WHERE is_completed = TRUE " +
                    "GROUP BY overall_severity";
        
        try {
            List<Map<String, Object>> results = jdbcTemplate.queryForList(sql);
            for (Map<String, Object> row : results) {
                String severity = (String) row.get("overall_severity");
                Integer count = ((Number) row.get("count")).intValue();
                distribution.put(severity, count);
            }
            
            ensureAllSeverityLevels(distribution);
            
        } catch (Exception e) {
            initializeSeverityDistribution(distribution);
        }
        
        return distribution;
    }
    
    private void ensureAllSeverityLevels(Map<String, Integer> distribution) {
        String[] severities = {"Normal", "Mild", "Moderate", "Severe", "Extremely Severe"};
        for (String severity : severities) {
            distribution.putIfAbsent(severity, 0);
        }
    }
    
    private void initializeSeverityDistribution(Map<String, Integer> distribution) {
        distribution.put("Normal", 0);
        distribution.put("Mild", 0);
        distribution.put("Moderate", 0);
        distribution.put("Severe", 0);
        distribution.put("Extremely Severe", 0);
    }
    
    public Map<String, Object> getUserQuickStats(int userId) {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            int totalAssessments = getTotalAssessmentsForUser(userId);
            stats.put("totalAssessments", totalAssessments);
            
            DassAssessment latest = getLatestAssessment(userId);
            stats.put("latestAssessment", latest);
            
            if (totalAssessments > 1 && latest != null) {
                DassAssessment previous = getPreviousAssessment(userId);
                if (previous != null) {
                    stats.put("previousAssessment", previous);
                    stats.put("trends", calculateTrends(latest, previous));
                }
            }
            
        } catch (Exception e) {
            // Return empty stats on error
        }
        
        return stats;
    }
    
    private int getTotalAssessmentsForUser(int userId) {
        String sql = "SELECT COUNT(*) FROM " + ASSESSMENTS_TABLE + " WHERE user_id = ? AND is_completed = TRUE";
        Integer result = jdbcTemplate.queryForObject(sql, Integer.class, userId);
        return result != null ? result : 0;
    }
    
    private DassAssessment getLatestAssessment(int userId) {
        String sql = "SELECT * FROM " + ASSESSMENTS_TABLE + " WHERE user_id = ? AND is_completed = TRUE " +
                    "ORDER BY assessment_date DESC LIMIT 1";
        try {
            return jdbcTemplate.queryForObject(sql, assessmentRowMapper, userId);
        } catch (Exception e) {
            return null;
        }
    }
    
    private DassAssessment getPreviousAssessment(int userId) {
        String sql = "SELECT * FROM " + ASSESSMENTS_TABLE + " WHERE user_id = ? AND is_completed = TRUE " +
                    "ORDER BY assessment_date DESC LIMIT 1, 1";
        try {
            return jdbcTemplate.queryForObject(sql, assessmentRowMapper, userId);
        } catch (Exception e) {
            return null;
        }
    }
    
    private Map<String, String> calculateTrends(DassAssessment latest, DassAssessment previous) {
        Map<String, String> trends = new HashMap<>();
        
        trends.put("depression", getTrendDescription(latest.getDepressionScore(), previous.getDepressionScore()));
        trends.put("anxiety", getTrendDescription(latest.getAnxietyScore(), previous.getAnxietyScore()));
        trends.put("stress", getTrendDescription(latest.getStressScore(), previous.getStressScore()));
        
        return trends;
    }
    
    private String getTrendDescription(int currentScore, int previousScore) {
        int diff = currentScore - previousScore;
        return diff > 0 ? "increased" : diff < 0 ? "decreased" : "unchanged";
    }
    
    private void logHistory(Integer assessmentId, Integer userId, String actionType, String details) {
        String sql = "INSERT INTO " + HISTORY_TABLE + " (assessment_id, user_id, action_type, action_details) " +
                    "VALUES (?, ?, ?, ?)";
        
        try {
            jdbcTemplate.update(sql, assessmentId, userId, actionType, details);
        } catch (Exception e) {
            // Log silently - history logging failure shouldn't break main operation
        }
    }
    
    public List<Map<String, Object>> getAssessmentHistory(int assessmentId) {
        String sql = "SELECT ah.*, u.full_name as performed_by " +
                    "FROM " + HISTORY_TABLE + " ah " +
                    "LEFT JOIN " + USERS_TABLE + " u ON ah.user_id = u.user_id " +
                    "WHERE ah.assessment_id = ? " +
                    "ORDER BY ah.performed_at DESC";
        
        try {
            return jdbcTemplate.queryForList(sql, assessmentId);
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    public Map<String, Object> getAssessmentStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        stats.put("totalAssessments", getTotalAssessmentsCount());
        stats.put("todayAssessments", getTodayAssessmentsCount());
        stats.put("weekAssessments", getWeekAssessmentsCount());
        
        Map<String, Object> commonSeverity = getMostCommonSeverity();
        stats.putAll(commonSeverity);
        
        return stats;
    }
    
    private int getTotalAssessmentsCount() {
        String sql = "SELECT COUNT(*) as total FROM " + ASSESSMENTS_TABLE + " WHERE is_completed = TRUE";
        Integer result = jdbcTemplate.queryForObject(sql, Integer.class);
        return result != null ? result : 0;
    }
    
    private int getTodayAssessmentsCount() {
        String sql = "SELECT COUNT(*) as today FROM " + ASSESSMENTS_TABLE + " " +
                    "WHERE DATE(assessment_date) = CURDATE() AND is_completed = TRUE";
        Integer result = jdbcTemplate.queryForObject(sql, Integer.class);
        return result != null ? result : 0;
    }
    
    private int getWeekAssessmentsCount() {
        String sql = "SELECT COUNT(*) as week FROM " + ASSESSMENTS_TABLE + " " +
                    "WHERE YEARWEEK(assessment_date) = YEARWEEK(CURDATE()) AND is_completed = TRUE";
        Integer result = jdbcTemplate.queryForObject(sql, Integer.class);
        return result != null ? result : 0;
    }
    
    private Map<String, Object> getMostCommonSeverity() {
        Map<String, Object> result = new HashMap<>();
        String sql = "SELECT overall_severity, COUNT(*) as count " +
                    "FROM " + ASSESSMENTS_TABLE + " " +
                    "WHERE is_completed = TRUE " +
                    "GROUP BY overall_severity " +
                    "ORDER BY count DESC " +
                    "LIMIT 1";
        
        try {
            Map<String, Object> commonSeverity = jdbcTemplate.queryForMap(sql);
            result.put("mostCommonSeverity", commonSeverity.get("overall_severity"));
            result.put("mostCommonSeverityCount", commonSeverity.get("count"));
        } catch (Exception e) {
            result.put("mostCommonSeverity", "No data");
            result.put("mostCommonSeverityCount", 0);
        }
        
        return result;
    }
}