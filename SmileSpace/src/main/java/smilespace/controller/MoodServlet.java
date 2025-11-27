package smilespace.controller;

import smilespace.model.MoodEntry;
import smilespace.model.MoodWeeklySummary;
import smilespace.service.MoodService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet(name = "MoodServlet", urlPatterns = {"/mood", "/recordMood", "/moodTrends"})
public class MoodServlet extends HttpServlet {
    private MoodService moodService;

    @Override
    public void init() {
        moodService = new MoodService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("viewTrends".equals(action)) {
            showMoodTrends(request, response);
        } else if ("add".equals(action)) {
            showAddMoodFeelings(request, response);
        } else if ("viewDaily".equals(action)) {
            showDailyMood(request, response);
        } else if ("edit".equals(action)) {
            showEditMood(request, response);
        } else {
            showMainPage(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("addMoodDetails".equals(action)) {
            showAddMoodDetails(request, response);
        } else if ("addMood".equals(action)) {
            addNewMoodEntry(request, response);
        } else if ("updateMood".equals(action)) {
            updateMoodEntry(request, response);
        } else if ("deleteMood".equals(action)) {
            deleteMoodEntry(request, response);
        } else if ("edit".equals(action)) {
            // Handle the edit flow from feelings page to details page
            String idParam = request.getParameter("id");
            String[] feelings = request.getParameterValues("feelings");
            
            if (idParam != null && feelings != null) {
                try {
                    int moodId = Integer.parseInt(idParam);
                    
                    // Find the mood entry to edit
                    MoodEntry moodToEdit = null;
                    for (MoodEntry entry : moodService.getAllMoodEntries()) {
                        if (entry.getId() == moodId) {
                            moodToEdit = entry;
                            break;
                        }
                    }
                    
                    if (moodToEdit != null) {
                        request.setAttribute("selectedFeelings", feelings);
                        request.setAttribute("moodToEdit", moodToEdit);
                        request.setAttribute("isEdit", true);
                        request.getRequestDispatcher("/modules/moodAndWellness/addMoodDetails.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect("mood?action=viewTrends");
        } else {
            showMainPage(request, response);
        }
    }

    private void showMainPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        MoodEntry latestMood = moodService.getLatestMoodEntry();
        
        if (latestMood != null) {
            request.setAttribute("lastMood", latestMood.getFeelingsAsString());
            request.setAttribute("lastDate", latestMood.getFormattedDate());
        } else {
            request.setAttribute("lastMood", "No mood recorded yet");
            request.setAttribute("lastDate", "Never");
        }
        
        if ("true".equals(request.getParameter("success"))) {
            request.setAttribute("successMessage", "Mood entry added successfully!");
        }
        
        request.getRequestDispatcher("/modules/moodAndWellness/recordMood.jsp").forward(request, response);
    }

    private void showAddMoodFeelings(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get selected feelings from parameters (when coming back from details)
        String[] selectedFeelings = request.getParameterValues("feelings");
        if (selectedFeelings != null) {
            request.setAttribute("selectedFeelings", selectedFeelings);
        }
        
        request.getRequestDispatcher("/modules/moodAndWellness/addMoodFeelings.jsp").forward(request, response);
    }

    private void showAddMoodDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String[] selectedFeelings = request.getParameterValues("feelings");
        
        // Validate that at least one feeling is selected
        if (selectedFeelings == null || selectedFeelings.length == 0) {
            response.sendRedirect("mood?action=add");
            return;
        }
        
        request.setAttribute("selectedFeelings", selectedFeelings);
        request.getRequestDispatcher("/modules/moodAndWellness/addMoodDetails.jsp").forward(request, response);
    }

    private void showMoodTrends(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
        String period = request.getParameter("period");
        if (period == null) {
                period = "week"; // default to week
        }
    
        // Store the selected period in request attribute
        request.setAttribute("selectedPeriod", period);
    
        // Get ALL mood entries from the service
        List<MoodEntry> allEntries = moodService.getAllMoodEntries();

        // Use the proper service method to get weekly summary
        MoodWeeklySummary summary = moodService.getWeeklySummary(LocalDate.now());
    
        request.setAttribute("weeklySummary", summary);
        request.setAttribute("allMoodEntries", allEntries != null ? allEntries : new ArrayList<>());
        request.setAttribute("moodTrends", moodService.getMoodTrends());
    
        request.getRequestDispatcher("/modules/moodAndWellness/viewMoodTrends.jsp").forward(request, response);
    }

    private void showDailyMood(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String dateParam = request.getParameter("date");
        if (dateParam != null) {
            try {
                LocalDate date = LocalDate.parse(dateParam);
                
                // Find mood entry for this date
                MoodEntry dailyMood = null;
                for (MoodEntry entry : moodService.getAllMoodEntries()) {
                    if (entry.getEntryDate().equals(date)) {
                        dailyMood = entry;
                        break;
                    }
                }
                
                if (dailyMood != null) {
                    request.setAttribute("dailyMood", dailyMood);
                    request.getRequestDispatcher("/modules/moodAndWellness/viewDailyMood.jsp").forward(request, response);
                } else {
                    // No mood found for this date, redirect to trends
                    response.sendRedirect("mood?action=viewTrends");
                }
            } catch (Exception e) {
                // Invalid date format, redirect to trends
                response.sendRedirect("mood?action=viewTrends");
            }
        } else {
            response.sendRedirect("mood?action=viewTrends");
        }
    }
    
    private void showEditMood(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        String referrer = request.getParameter("referrer");
        
        if (idParam != null) {
            try {
                int moodId = Integer.parseInt(idParam);
                
                // Find the mood entry to edit
                MoodEntry moodToEdit = null;
                for (MoodEntry entry : moodService.getAllMoodEntries()) {
                    if (entry.getId() == moodId) {
                        moodToEdit = entry;
                        break;
                    }
                }
                
                if (moodToEdit != null) {
                    // Store the original referring page in session
                    String referer = request.getHeader("Referer");
                    if (referer != null && !referer.contains("addMoodFeelings")) {
                        request.getSession().setAttribute("moodOriginalReferer", referer);
                    }
                    
                    // Always start with feelings page when clicking Edit
                    request.setAttribute("selectedFeelings", moodToEdit.getFeelings().toArray(new String[0]));
                    request.setAttribute("moodToEdit", moodToEdit);
                    request.setAttribute("isEdit", true);
                    request.setAttribute("referrer", referrer);
                    request.getRequestDispatcher("/modules/moodAndWellness/addMoodFeelings.jsp").forward(request, response);
                } else {
                    response.sendRedirect("mood?action=viewTrends");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("mood?action=viewTrends");
            }
        } else {
            response.sendRedirect("mood?action=viewTrends");
        }
    }
    
    private void addNewMoodEntry(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get multiple feelings
        String[] feelingArray = request.getParameterValues("feelings");
        String reflection = request.getParameter("reflection");
        String[] tags = request.getParameterValues("tags");
        String imagePath = request.getParameter("imagePath");
        String referrer = request.getParameter("referrer");
    
        try {
            // Process feelings
            List<String> feelingList = new ArrayList<>();
            if (feelingArray != null) {
                for (String feeling : feelingArray) {
                    if (feeling != null && !feeling.trim().isEmpty()) {
                        feelingList.add(feeling.trim());
                    }
                }
            }
    
            // Validate required fields
            if (feelingList.isEmpty()) {
                request.setAttribute("error", "Please select at least one feeling");
                showAddMoodFeelings(request, response);
                return;
            }
    
            // Process tags
            Set<String> tagSet = new HashSet<>();
            if (tags != null) {
                for (String tag : tags) {
                    if (tag != null && !tag.trim().isEmpty()) {
                        tagSet.add(tag.trim());
                    }
                }
            }
    
            // Create and save mood entry
            MoodEntry newEntry = new MoodEntry();
            newEntry.setFeelings(feelingList);
            newEntry.setReflection(reflection != null ? reflection.trim() : "");
            newEntry.setTags(tagSet);
            newEntry.setImagePath(imagePath != null ? imagePath.trim() : null);
    
            moodService.addMoodEntry(newEntry);
    
            // Redirect based on referrer
            if ("trends".equals(referrer)) {
                // For trends referrer, go to daily view of the new entry
                response.sendRedirect("mood?action=viewDaily&date=" + newEntry.getEntryDate());
            } else {
                // For recordMood referrer, go to thank you page
                request.setAttribute("savedEntry", newEntry);
                request.getRequestDispatcher("/modules/moodAndWellness/moodThankYou.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            showAddMoodFeelings(request, response);
        }
    }
    
    private void updateMoodEntry(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("mood?action=viewTrends");
            return;
        }
    
        try {
            int moodId = Integer.parseInt(idParam);
            String referrer = request.getParameter("referrer");
            
            // Get form data
            String[] feelingArray = request.getParameterValues("feelings");
            String reflection = request.getParameter("reflection");
            String[] tags = request.getParameterValues("tags");
            String imagePath = request.getParameter("imagePath");
    
            // Process feelings
            List<String> feelingList = new ArrayList<>();
            if (feelingArray != null) {
                for (String feeling : feelingArray) {
                    if (feeling != null && !feeling.trim().isEmpty()) {
                        feelingList.add(feeling.trim());
                    }
                }
            }
    
            if (feelingList.isEmpty()) {
                request.setAttribute("error", "Please select at least one feeling");
                showEditMood(request, response);
                return;
            }
    
            // Process tags
            Set<String> tagSet = new HashSet<>();
            if (tags != null) {
                for (String tag : tags) {
                    if (tag != null && !tag.trim().isEmpty()) {
                        tagSet.add(tag.trim());
                    }
                }
            }
    
            // Find and update the mood entry
            MoodEntry updatedEntry = null;
            for (MoodEntry entry : moodService.getAllMoodEntries()) {
                if (entry.getId() == moodId) {
                    entry.setFeelings(feelingList);
                    entry.setReflection(reflection != null ? reflection.trim() : "");
                    entry.setTags(tagSet);
                    entry.setImagePath(imagePath != null ? imagePath.trim() : null);
                    updatedEntry = entry;
                    break;
                }
            }
    
            if (updatedEntry != null) {
                // Redirect based on referrer
                if ("trends".equals(referrer)) {
                    // For trends referrer, go to daily view of the updated entry
                    response.sendRedirect("mood?action=viewDaily&date=" + updatedEntry.getEntryDate());
                } else {
                    // For recordMood referrer, go to thank you page
                    request.setAttribute("savedEntry", updatedEntry);
                    request.getRequestDispatcher("/modules/moodAndWellness/moodThankYou.jsp").forward(request, response);
                }
            } else {
                response.sendRedirect("mood?action=viewTrends");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            showEditMood(request, response);
        }
    }

    private void deleteMoodEntry(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int moodId = Integer.parseInt(idParam);
                
                // Remove the mood entry
                moodService.getAllMoodEntries().removeIf(entry -> entry.getId() == moodId);
                
                // Redirect to trends page after successful deletion
                response.sendRedirect("mood?action=viewTrends");
                
            } catch (NumberFormatException e) {
                response.sendRedirect("mood?action=viewTrends");
            }
        } else {
            response.sendRedirect("mood?action=viewTrends");
        }
    }
}