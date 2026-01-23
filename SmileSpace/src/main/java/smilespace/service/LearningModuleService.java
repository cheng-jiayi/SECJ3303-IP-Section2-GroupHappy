package smilespace.service;

import smilespace.model.LearningModule;
import smilespace.model.Question;
import smilespace.dao.LearningModuleDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Map;
import java.text.SimpleDateFormat;
import java.util.Date;

@Service
@Transactional
public class LearningModuleService {
    
    @Autowired
    private LearningModuleDAO moduleDAO;
    
    
    public boolean createModule(LearningModule module, int createdBy) {
        String nextId = generateNextModuleId();
        module.setId(nextId);
        module.setCreatedBy(createdBy);
        module.setStatus("Draft");
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        module.setLastUpdated(sdf.format(new Date()));
        
        return moduleDAO.save(module);
    }
    
    public boolean updateModule(String id, LearningModule module) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        module.setLastUpdated(sdf.format(new Date()));
        module.setId(id);
        
        return moduleDAO.update(module);
    }
    
    public boolean deleteModule(String id) {
        return moduleDAO.delete(id);
    }
    
    public LearningModule getModuleById(String id) {
        return moduleDAO.findById(id);
    }
    
    public List<LearningModule> getAllModules() {
        return moduleDAO.findAll();
    }

    public boolean submitModule(String id) {
        return moduleDAO.updateStatus(id, "Submitted");
    }

    public boolean saveAsDraft(String id) {
        return moduleDAO.updateStatus(id, "Draft");
    }

    public List<LearningModule> getModulesByStatus(String status) {
        return moduleDAO.findByStatus(status);
    }

    public List<LearningModule> getModulesByCreator(int userId) {
        return moduleDAO.findByCreator(userId);
    }
    
    public List<LearningModule> getModulesByCategory(String category) {
        return moduleDAO.findByCategory(category);
    }
    
    public List<LearningModule> searchModules(String keyword, String category, String level, String status) {
        return moduleDAO.search(keyword, category, level, status);
    }
    
    public boolean recordModuleAccess(String moduleId, int userId, String accessType) {
        LearningModule module = moduleDAO.findById(moduleId);
        if (module != null) {
            moduleDAO.recordAccess(moduleId, userId, accessType, module.getStatus());
        }
        return moduleDAO.incrementViews(moduleId);
    }
    
    public Map<String, Object> getModuleStatistics() {
        return moduleDAO.getModuleStatistics();
    }
    
    public List<Map<String, Object>> getAccessHistory(String moduleId) {
        return moduleDAO.getAccessHistory(moduleId);
    }
    
    public boolean incrementModuleViews(String moduleId) {
        return moduleDAO.incrementViews(moduleId);
    }
    
    private String generateNextModuleId() {
        List<LearningModule> allModules = moduleDAO.findAll();
        int maxId = 0;
        
        for (LearningModule module : allModules) {
            String id = module.getId();
            if (id != null) {
                if (id.startsWith("LM")) {
                    try {
                        int idNum = Integer.parseInt(id.substring(2));
                        if (idNum > maxId) {
                            maxId = idNum;
                        }
                    } catch (NumberFormatException e) {
                    }
                } else if (id.startsWith("UC")) {
                    try {
                        int idNum = Integer.parseInt(id.substring(2));
                        if (idNum > maxId) {
                            maxId = idNum;
                        }
                    } catch (NumberFormatException e) {

                    }
                }
            }
        }
        
        if (maxId < 10) {
            maxId = 9; 
        }
        
        return "LM" + String.format("%03d", maxId + 1);
    }

    public boolean saveQuizQuestions(String moduleId, List<Question> questions) {
        return moduleDAO.saveQuizQuestions(moduleId, questions);
    }

    public List<Question> getQuizQuestionsByModule(String moduleId) {
        return moduleDAO.getQuizQuestionsByModule(moduleId);
    }

    public void updateModuleStatus(String moduleId, String status) {
        moduleDAO.updateStatus(moduleId, status);
    }

    public boolean hasNullStatus(String moduleId) {
        return moduleDAO.hasNullStatus(moduleId);
    }
}