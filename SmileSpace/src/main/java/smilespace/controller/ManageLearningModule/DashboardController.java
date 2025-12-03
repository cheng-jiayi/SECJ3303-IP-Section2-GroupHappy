package smilespace.controller.ManageLearningModule;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;
import smilespace.model.LearningModule;  // IMPORT ADDED HERE

@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {
    
    private static List<LearningModule> modules = new ArrayList<>();
    private static int nextId = 6;
    
    @Override
    public void init() throws ServletException {
        if (modules.isEmpty()) {
            modules.add(new LearningModule("LM001", "Managing Stress", "Stress", "Beginner", 156, "10 / 09 / 2025"));
            modules.add(new LearningModule("LM002", "Sleep Better", "Sleep", "Intermediate", 89, "15 / 09 / 2025"));
            modules.add(new LearningModule("LM003", "Understanding Anxiety", "Anxiety", "Beginner", 210, "23 / 09 / 2025"));
            modules.add(new LearningModule("LM004", "Building Self-Esteem", "Self-Esteem", "Advance", 45, "03 / 10 / 2025"));
            modules.add(new LearningModule("LM005", "Mindfulness for Daily Life", "Mindfulness", "Intermediate", 178, "19 / 10 / 2025"));
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String search = request.getParameter("search");
        String category = request.getParameter("category");
        String level = request.getParameter("level");
        
        List<LearningModule> filteredModules = filterModules(search, category, level);
        
        request.setAttribute("modules", filteredModules);
        request.setAttribute("searchTerm", search != null ? search : "");
        request.setAttribute("selectedCategory", category != null ? category : "all");
        request.setAttribute("selectedLevel", level != null ? level : "all");
        
        // Forward to the JSP in your modules/manageLearningModule folder
        request.getRequestDispatcher("/modules/manageLearningModule/dashboard.jsp").forward(request, response);
    }
    
    private List<LearningModule> filterModules(String search, String category, String level) {
        List<LearningModule> result = new ArrayList<>();
        
        for (LearningModule module : modules) {
            boolean matches = true;
            
            if (search != null && !search.trim().isEmpty()) {
                String searchLower = search.toLowerCase();
                if (!module.getTitle().toLowerCase().contains(searchLower) && 
                    !module.getCategory().toLowerCase().contains(searchLower)) {
                    matches = false;
                }
            }
            
            if (category != null && !"all".equals(category) && 
                !module.getCategory().equals(category)) {
                matches = false;
            }
            
            if (level != null && !"all".equals(level) && 
                !module.getLevel().equals(level)) {
                matches = false;
            }
            
            if (matches) {
                result.add(module);
            }
        }
        
        return result;
    }
    
    // Static methods for other controllers
    public static List<LearningModule> getAllModules() {
        return new ArrayList<>(modules);
    }
    
    public static LearningModule getModuleById(String id) {
        for (LearningModule module : modules) {
            if (module.getId().equals(id)) {
                return module;
            }
        }
        return null;
    }
    
    public static void addModule(LearningModule module) {
        module.setId("LM" + String.format("%03d", nextId++));
        modules.add(module);
    }
    
    public static void updateModule(String id, LearningModule updatedModule) {
        for (int i = 0; i < modules.size(); i++) {
            if (modules.get(i).getId().equals(id)) {
                updatedModule.setId(id);
                modules.set(i, updatedModule);
                break;
            }
        }
    }
    
    public static boolean deleteModule(String id) {
        return modules.removeIf(module -> module.getId().equals(id));
    }
}