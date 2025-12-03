package smilespace.controller.CompleteQuiz;

import smilespace.model.LearningModule;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "QuizDashboardController", value = "/quiz-dashboard")
public class QuizDashboardController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Create modules as shown in screenshot
        List<LearningModule> allModules = new ArrayList<>();
        
        // UC006 - Managing Stress in Daily Life (First in screenshot)
        LearningModule module1 = new LearningModule("UC006", "Managing Stress in Daily Life", 
            "Stress", "Beginner", 245, "03 / 12 / 2025");
        module1.setDescription("Learn how to identify sources of everyday stress and build healthy coping strategies.");
        
        // UC007 - Dealing with Academic Pressure
        LearningModule module2 = new LearningModule("UC007", "Dealing with Academic Pressure", 
            "Stress", "Intermediate", 189, "01 / 12 / 2025");
        module2.setDescription("Learn strategies to manage exam stress, assignment overload, and academic competition effectively.");
        
        // UC008 - Time Management to Reduce Stress
        LearningModule module3 = new LearningModule("UC008", "Time Management to Reduce Stress", 
            "Stress", "Beginner", 167, "28 / 11 / 2025");
        module3.setDescription("Understand how effective time management can lower academic stress.");
        
        // UC009 - Emotional Regulation under Stress
        LearningModule module4 = new LearningModule("UC009", "Emotional Regulation under Stress", 
            "Stress", "Advanced", 112, "25 / 11 / 2025");
        module4.setDescription("Gain skills to handle emotions such as frustration, anger, or anxiety during stressful moments.");
        
        allModules.add(module1);
        allModules.add(module2);
        allModules.add(module3);
        allModules.add(module4);
        
        request.setAttribute("stressModules", allModules);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/modules/completeQuiz/quiz-dashboard.jsp");
        dispatcher.forward(request, response);
    }
}