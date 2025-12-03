package smilespace.controller.CompleteQuiz;

import smilespace.model.LearningModule;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "StressModuleController", value = "/student-module")
public class StressModuleController extends HttpServlet {
    
    private String convertToEmbedUrl(String youtubeUrl) {
        if (youtubeUrl == null || youtubeUrl.isEmpty()) {
            return "";
        }
        
        // Extract video ID from different YouTube URL formats
        String videoId = "";
        
        // Format 1: https://www.youtube.com/watch?v=VIDEO_ID
        if (youtubeUrl.contains("youtube.com/watch?v=")) {
            String[] parts = youtubeUrl.split("v=");
            if (parts.length > 1) {
                videoId = parts[1].split("&")[0]; // Remove any additional parameters
            }
        }
        // Format 2: https://youtu.be/VIDEO_ID
        else if (youtubeUrl.contains("youtu.be/")) {
            String[] parts = youtubeUrl.split("youtu.be/");
            if (parts.length > 1) {
                videoId = parts[1].split("\\?")[0]; // Remove any query parameters
            }
        }
        // Format 3: Already an embed URL
        else if (youtubeUrl.contains("youtube.com/embed/")) {
            return youtubeUrl; // Already correct format
        }
        
        if (!videoId.isEmpty()) {
            return "https://www.youtube.com/embed/" + videoId;
        }
        
        return ""; // Return empty if couldn't parse
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String moduleId = request.getParameter("id");
        String action = request.getParameter("action");
        
        // YouTube video URL
        String youtubeUrl = "https://www.youtube.com/watch?v=zYzFUBMJO9E";
        String embedUrl = convertToEmbedUrl(youtubeUrl);
        
        if ("content".equals(action) && "UC006".equals(moduleId)) {
            // Show module content with video
            LearningModule module = new LearningModule("UC006", "Managing Stress in Daily Life", 
                "Learn how to identify sources of everyday stress and build healthy coping strategies to maintain balance between study, relationships, and rest.",
                "Stress", "Beginner", "Dr Aisha", "8 minutes", 
                "stress-module-cover.jpg", "stress-module-video.mp4", 
                "Daily stress management techniques", 245, "03 / 12 / 2025");
            
            request.setAttribute("module", module);
            request.setAttribute("videoUrl", embedUrl);
            request.setAttribute("originalVideoUrl", youtubeUrl); // Optional: store original URL
            RequestDispatcher dispatcher = request.getRequestDispatcher("/modules/completeQuiz/module-content.jsp");
            dispatcher.forward(request, response);
            
        } else if ("UC006".equals(moduleId)) {
            // Show module overview (existing all-quiz.jsp)
            LearningModule module = new LearningModule("UC006", "Managing Stress in Daily Life", 
                "Learn how to identify sources of everyday stress and build healthy coping strategies to maintain balance between study, relationships, and rest.",
                "Stress", "Beginner", "Dr Aisha", "8 minutes", 
                null, null, null, 0, "03 / 12 / 2025");
            
            request.setAttribute("module", module);
            request.setAttribute("contentOutline", new String[]{
                "Common daily stressors (academic, social, time pressure)",
                "Recognizing physical and emotional stress signals",
                "Simple relaxation techniques (breathing, music, short meditation)",
                "\"Three-Minute Relax Routine\" daily practice"
            });
            request.setAttribute("learningGuide", new String[]{
                "Estimated time: 8 minutes",
                "Includes short video + interactive quiz",
                "Tip: Take short notes while learning and reflect at the end"
            });
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/modules/completeQuiz/quiz-intro.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendRedirect("quiz-dashboard");
        }
    }
}