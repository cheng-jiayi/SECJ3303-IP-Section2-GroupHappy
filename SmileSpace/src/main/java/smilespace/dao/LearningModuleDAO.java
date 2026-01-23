package smilespace.dao;

import smilespace.model.LearningModule;
import smilespace.model.Question;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.sql.*;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.*;

@Repository
@Transactional
public class LearningModuleDAO {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private javax.sql.DataSource dataSource;
    
    private final RowMapper<LearningModule> learningModuleRowMapper = (rs, rowNum) -> {
        LearningModule module = new LearningModule();
        module.setId(rs.getString("id"));
        module.setTitle(rs.getString("title"));
        module.setDescription(rs.getString("description"));
        module.setCategory(rs.getString("category"));
        module.setLevel(rs.getString("level"));
        module.setAuthorName(rs.getString("author_name"));
        module.setEstimatedDuration(rs.getString("estimated_duration"));
        
        module.setCoverImagePath(rs.getString("cover_image_path"));
        module.setResourceFilePath(rs.getString("resource_file_path"));
        
        module.setVideoUrl(rs.getString("video_url"));
        module.setContentOutline(rs.getString("content_outline"));
        module.setLearningGuide(rs.getString("learning_guide"));
        module.setLearningTip(rs.getString("learning_tip"));
        module.setKeyPoints(rs.getString("key_points"));
        module.setViews(rs.getInt("views"));
        module.setStatus(rs.getString("status")); 
        
        java.sql.Date lastUpdatedDate = rs.getDate("last_updated");
        if (lastUpdatedDate != null) {
            module.setLastUpdated(lastUpdatedDate.toString());
        } else {
            module.setLastUpdated("N/A");
        }
        
        module.setCreatedBy(rs.getInt("created_by"));
        module.setCreatedAt(rs.getTimestamp("created_at"));
        
        return module;
    };
    
    public boolean save(LearningModule module) {
        String sql = "INSERT INTO learning_modules (id, title, description, category, level, author_name, " +
                    "estimated_duration, video_url, content_outline, learning_guide, learning_tip, key_points, " +
                    "views, last_updated, created_by, cover_image_path, resource_file_path, status, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try {
            int rowsAffected = jdbcTemplate.update(sql,
                module.getId(),
                module.getTitle(),
                module.getDescription(),
                module.getCategory(),
                module.getLevel(),
                module.getAuthorName(),
                module.getEstimatedDuration(),
                module.getVideoUrl(),
                module.getContentOutline(),
                module.getLearningGuide(),
                module.getLearningTip(),
                module.getKeyPoints(),
                module.getViews(),
                java.sql.Date.valueOf(module.getLastUpdated()),
                module.getCreatedBy() != null ? module.getCreatedBy() : 1,
                module.getCoverImagePath(),
                module.getResourceFilePath(),
                module.getStatus(),
                module.getCreatedAt()
            );
            
            System.out.println("Saved module " + module.getId() + " with cover image path: " + module.getCoverImagePath());
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("ERROR in save(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean update(LearningModule module) {
        String sql = "UPDATE learning_modules SET title = ?, description = ?, category = ?, level = ?, " +
                    "author_name = ?, estimated_duration = ?, video_url = ?, content_outline = ?, " +
                    "learning_guide = ?, learning_tip = ?, key_points = ?, views = ?, last_updated = ?, " +
                    "cover_image_path = ?, resource_file_path = ?, status = ? " + 
                    "WHERE id = ?";
        
        try {
            int rowsAffected = jdbcTemplate.update(sql,
                module.getTitle(),
                module.getDescription(),
                module.getCategory(),
                module.getLevel(),
                module.getAuthorName(),
                module.getEstimatedDuration(),
                module.getVideoUrl(),
                module.getContentOutline(),
                module.getLearningGuide(),
                module.getLearningTip(),
                module.getKeyPoints(),
                module.getViews(),
                java.sql.Date.valueOf(module.getLastUpdated()),
                module.getCoverImagePath(),
                module.getResourceFilePath(),
                module.getStatus(),
                module.getId()
            );
            
            System.out.println("Updated module " + module.getId() + " with cover image path: " + module.getCoverImagePath());
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("ERROR in update(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStatus(String moduleId, String status) {
        System.out.println("Updating module " + moduleId + " status to: " + status);
        
        if (status == null || status.trim().isEmpty()) {
            System.out.println("Cannot update to null/empty status");
            return false;
        }
        
        String sql = "UPDATE learning_modules SET status = ? WHERE id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setString(2, moduleId);
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("Error updating module status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean delete(String id) {
        String sql = "DELETE FROM learning_modules WHERE id = ?";
        
        try {
            int rowsAffected = jdbcTemplate.update(sql, id);
            System.out.println("Deleted module " + id + ": " + (rowsAffected > 0));
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("ERROR in delete(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public List<LearningModule> findAll() {
        String sql = "SELECT * FROM learning_modules ORDER BY last_updated DESC";
        
        try {
            List<LearningModule> modules = jdbcTemplate.query(sql, learningModuleRowMapper);
            System.out.println("Total modules loaded from database: " + modules.size());
            return modules;
            
        } catch (Exception e) {
            System.err.println("ERROR in findAll(): " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<LearningModule> findByStatus(String status) {
        String sql = "SELECT * FROM learning_modules WHERE status = ? ORDER BY last_updated DESC";
        
        try {
            return jdbcTemplate.query(sql, learningModuleRowMapper, status);
        } catch (Exception e) {
            System.err.println("ERROR in findByStatus(): " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public List<LearningModule> findByCreator(int userId) {
        String sql = "SELECT * FROM learning_modules WHERE created_by = ? ORDER BY last_updated DESC";
        
        try {
            return jdbcTemplate.query(sql, learningModuleRowMapper, userId);
        } catch (Exception e) {
            System.err.println("ERROR in findByCreator(): " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    public LearningModule findById(String id) {
        System.out.println("DAO.findById called for module: " + id);
        String sql = "SELECT * FROM learning_modules WHERE id = ?";
        
        try {
            LearningModule module = jdbcTemplate.queryForObject(sql, learningModuleRowMapper, id);
            if (module != null) {
                System.out.println("Found module: " + module.getId() + " - " + module.getTitle());
                System.out.println("Cover image path: " + module.getCoverImagePath());
                System.out.println("Resource file path: " + module.getResourceFilePath());
            }
            return module;
        } catch (Exception e) {
            System.err.println("ERROR in findById() for module " + id + ": " + e.getMessage());
            return null;
        }
    }
    
    public List<LearningModule> findByCategory(String category) {
        String sql = "SELECT * FROM learning_modules WHERE category = ? ORDER BY last_updated DESC";
        
        try {
            return jdbcTemplate.query(sql, learningModuleRowMapper, category);
        } catch (Exception e) {
            System.err.println("ERROR in findByCategory(): " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    public boolean incrementViews(String moduleId) {
        String sql = "UPDATE learning_modules SET views = views + 1 WHERE id = ?";
        
        try {
            int rowsAffected = jdbcTemplate.update(sql, moduleId);
            System.out.println("Incremented views for module " + moduleId + ": " + (rowsAffected > 0));
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("ERROR in incrementViews(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public List<LearningModule> search(String keyword, String category, String level, String status) {
        List<LearningModule> modules = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM learning_modules WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR description LIKE ?)");
            String searchTerm = "%" + keyword + "%";
            params.add(searchTerm);
            params.add(searchTerm);
        }
        
        if (category != null && !"all".equals(category)) {
            sql.append(" AND category = ?");
            params.add(category);
        }
        
        if (level != null && !"all".equals(level)) {
            sql.append(" AND level = ?");
            params.add(level);
        }
        
        if (status != null && !"all".equals(status)) {
            sql.append(" AND status = ?");
            params.add(status);
        }
        
        sql.append(" ORDER BY last_updated DESC");
        
        try {
            return jdbcTemplate.query(sql.toString(), learningModuleRowMapper, params.toArray());
        } catch (Exception e) {
            System.err.println("ERROR in search(): " + e.getMessage());
            e.printStackTrace();
            return modules;
        }
    }
    
    public Map<String, Object> getModuleStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            Integer totalModules = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) as total FROM learning_modules", Integer.class);
            stats.put("totalModules", totalModules != null ? totalModules : 0);
            
            List<Map<String, Object>> categoryStats = jdbcTemplate.queryForList(
                "SELECT category, COUNT(*) as count FROM learning_modules GROUP BY category");
            Map<String, Integer> categoryMap = new HashMap<>();
            for (Map<String, Object> row : categoryStats) {
                categoryMap.put((String) row.get("category"), ((Number) row.get("count")).intValue());
            }
            stats.put("categoryStats", categoryMap);
            
            List<Map<String, Object>> levelStats = jdbcTemplate.queryForList(
                "SELECT level, COUNT(*) as count FROM learning_modules GROUP BY level");
            Map<String, Integer> levelMap = new HashMap<>();
            for (Map<String, Object> row : levelStats) {
                levelMap.put((String) row.get("level"), ((Number) row.get("count")).intValue());
            }
            stats.put("levelStats", levelMap);
            
            Integer totalViews = jdbcTemplate.queryForObject(
                "SELECT SUM(views) as totalViews FROM learning_modules", Integer.class);
            stats.put("totalViews", totalViews != null ? totalViews : 0);
            
            List<LearningModule> recentModules = jdbcTemplate.query(
                "SELECT * FROM learning_modules ORDER BY created_at DESC LIMIT 5", 
                learningModuleRowMapper);
            stats.put("recentModules", recentModules);
            
            System.out.println("Module statistics retrieved");
            
        } catch (Exception e) {
            System.err.println("ERROR in getModuleStatistics(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return stats;
    }
    
    public boolean recordAccess(String moduleId, int userId, String accessType, String moduleStatus) {
        String sql = "INSERT INTO module_access_history (module_id, user_id, access_type, module_status) VALUES (?, ?, ?, ?)";
        
        try {
            int rowsAffected = jdbcTemplate.update(sql, moduleId, userId, accessType, moduleStatus);
            System.out.println("Recorded access for module " + moduleId + " with status: " + moduleStatus);
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("ERROR in recordAccess(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Map<String, Object>> getAccessHistory(String moduleId) {
        List<Map<String, Object>> history = new ArrayList<>();
        
        try {
            Integer tableExists = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'smilespace' AND table_name = 'module_access_history'", 
                Integer.class);
            
            if (tableExists == null || tableExists == 0) {
                System.out.println("module_access_history table does not exist");
                return history;
            }
        } catch (Exception e) {
            System.err.println("ERROR checking if table exists: " + e.getMessage());
            return history;
        }
        
        String sql = "SELECT mah.*, u.full_name, u.username " +
                     "FROM module_access_history mah " +
                     "JOIN users u ON mah.user_id = u.user_id " +
                     "WHERE mah.module_id = ? " +
                     "ORDER BY mah.access_date DESC " +
                     "LIMIT 50";
        
        try {
            history = jdbcTemplate.queryForList(sql, moduleId);
            System.out.println("Retrieved " + history.size() + " access records for module " + moduleId);
        } catch (Exception e) {
            System.err.println("ERROR in getAccessHistory(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return history;
    }

    public List<Question> getQuizQuestionsByModule(String moduleId) {
        System.out.println("=== DAO.getQuizQuestionsByModule called for module: " + moduleId + " ===");
        
        String sql = "SELECT * FROM quiz_questions WHERE module_id = ? ORDER BY question_order";
        
        try {
            List<Question> questions = jdbcTemplate.query(sql, (rs, rowNum) -> {
                Question question = new Question();
                question.setId(rs.getInt("question_id"));
                question.setModuleId(rs.getString("module_id"));
                question.setText(rs.getString("question_text"));
                question.setCorrectAnswer(rs.getBoolean("correct_answer"));
                question.setExplanation(rs.getString("explanation"));
                question.setOrder(rs.getInt("question_order"));
                
                System.out.println("DAO: Retrieved question " + question.getOrder() + 
                                 " - Text: " + (question.getText() != null ? 
                                 question.getText().substring(0, Math.min(50, question.getText().length())) + "..." : "null"));
                
                return question;
            }, moduleId);
        
            System.out.println("DAO: Total questions retrieved for module " + moduleId + ": " + questions.size());
            return questions;
        
        } catch (Exception e) {
            System.err.println("ERROR in getQuizQuestionsByModule for module " + moduleId + ": " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public boolean saveQuizQuestions(String moduleId, List<Question> questions) {
        System.out.println("=== DAO.saveQuizQuestions called for module: " + moduleId + " ===");
        System.out.println("Number of questions to save: " + questions.size());
        
        try {
            String deleteSql = "DELETE FROM quiz_questions WHERE module_id = ?";
            int deleted = jdbcTemplate.update(deleteSql, moduleId);
            System.out.println("Deleted " + deleted + " existing questions for module " + moduleId);
            
            String insertSql = "INSERT INTO quiz_questions (module_id, question_text, correct_answer, explanation, question_order) " +
                            "VALUES (?, ?, ?, ?, ?)";
            
            int inserted = 0;
            for (int i = 0; i < questions.size(); i++) {
                Question q = questions.get(i);
                System.out.println("Saving question " + (i+1) + ": " + 
                                 (q.getText() != null && !q.getText().isEmpty() ? q.getText().substring(0, Math.min(50, q.getText().length())) + "..." : "empty"));
                
                int rows = jdbcTemplate.update(insertSql,
                    moduleId,
                    q.getText(),
                    q.isTrue(),
                    q.getExplanation(),
                    i + 1
                );
                inserted += rows;
            }
            
            System.out.println("Successfully saved " + inserted + " questions for module " + moduleId);
            return true;
            
        } catch (Exception e) {
            System.err.println("ERROR in saveQuizQuestions for module " + moduleId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasNullStatus(String moduleId) {
        String sql = "SELECT status FROM learning_modules WHERE id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, moduleId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String status = rs.getString("status");
                return status == null;
            }
            return false;
            
        } catch (Exception e) {
            System.err.println("Error checking module status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}