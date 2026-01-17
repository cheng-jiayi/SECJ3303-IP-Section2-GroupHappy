package smilespace.controller.feedbackAndAnalytics;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itextpdf.io.font.constants.StandardFonts;
import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.SolidBorder;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.BorderRadius;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import smilespace.model.Feedback;
import smilespace.service.FeedbackAnalyticsService;
import smilespace.service.FeedbackService;

@Controller
@RequestMapping("/feedback")
public class FeedbackController {
   
    @Autowired
    private FeedbackService feedbackService;
   
    @Autowired
    private FeedbackAnalyticsService feedbackAnalyticsService;
   
    @GetMapping("")
    public String showFeedbackForm(Model model, HttpSession session) {
        String userFullName = (String) session.getAttribute("userFullName");
        String userEmail = (String) session.getAttribute("userEmail");
       
        model.addAttribute("userFullName", userFullName);
        model.addAttribute("userEmail", userEmail);
       
        return "feedbackAndAnalyticsModule/feedback";
    }
   
    @PostMapping("/submit")
    public String submitFeedback(
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String email,
            @RequestParam String message,
            @RequestParam String category,
            @RequestParam Integer rating,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
       
        String error = validateFeedback(message, rating);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            redirectAttributes.addFlashAttribute("name", name);
            redirectAttributes.addFlashAttribute("email", email);
            redirectAttributes.addFlashAttribute("message", message);
            redirectAttributes.addFlashAttribute("category", category);
            redirectAttributes.addFlashAttribute("rating", rating);
            return "redirect:/feedback";
        }
       
        Integer userId = getUserIdFromSession(session);
        String userFullName = (String) session.getAttribute("userFullName");
       
        if ((name == null || name.trim().isEmpty()) && userFullName != null) {
            name = userFullName;
        }
       
        String sentiment = calculateSentiment(rating);
       
        Feedback feedback = new Feedback();
        feedback.setName(name != null ? name.trim() : "");
        feedback.setEmail(email != null ? email.trim() : "");
        feedback.setMessage(message.trim());
        feedback.setCategory(category != null ? category : "General");
        feedback.setSentiment(sentiment);
        feedback.setRating(rating);
       
        boolean success = feedbackService.saveFeedback(feedback, userId);
       
        if (success) {
            redirectAttributes.addFlashAttribute("successMessage",
                "Your feedback has been submitted successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error",
                "Failed to submit feedback. Please try again.");
            redirectAttributes.addFlashAttribute("name", name);
            redirectAttributes.addFlashAttribute("email", email);
            redirectAttributes.addFlashAttribute("message", message);
            redirectAttributes.addFlashAttribute("category", category);
            redirectAttributes.addFlashAttribute("rating", rating);
        }
       
        return "redirect:/feedback";
    }
   
    @GetMapping("/my-feedback")
    public String showMyFeedback(
            @RequestParam(required = false) String search,
            @RequestParam(required = false, defaultValue = "all") String status,
            Model model,
            HttpSession session) {
       
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            return "redirect:/login";
        }
       
        List<Feedback> filteredFeedback = feedbackService.getFilteredUserFeedback(userId, search, status);
        List<Feedback> allUserFeedback = feedbackService.getFeedbackByUser(userId);
       
        int totalCount = allUserFeedback.size();
        int resolvedCount = 0;
        int pendingCount = 0;
        int unseenCount = 0;
       
        for (Feedback feedback : allUserFeedback) {
            if (feedback.isResolved()) {
                resolvedCount++;
            } else {
                pendingCount++;
            }
           
            if (feedback.isHasUnseenReply()) {
                unseenCount++;
            }
        }
       
        model.addAttribute("feedbackList", filteredFeedback);
        model.addAttribute("unseenCount", unseenCount);
        model.addAttribute("hasFeedback", !allUserFeedback.isEmpty());
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("resolvedCount", resolvedCount);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("search", search);
        model.addAttribute("status", status);
       
        return "feedbackAndAnalyticsModule/my-feedback";
    }
    
    @GetMapping("/my-feedback/reply")
    public String showUserReplyForm(
            @RequestParam Integer id,
            Model model,
            HttpSession session) {
        
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            return "redirect:/login";
        }
        
        List<Feedback> userFeedback = feedbackService.getFeedbackByUser(userId);
        Feedback feedback = userFeedback.stream()
            .filter(f -> f.getId() == id)
            .findFirst()
            .orElse(null);
        
        if (feedback == null) {
            return "redirect:/feedback/my-feedback?error=Feedback+not+found+or+not+authorized";
        }
        
        model.addAttribute("feedback", feedback);
        model.addAttribute("feedbackId", id);
        
        return "feedbackAndAnalyticsModule/userReply";
    }
    
    @PostMapping("/my-feedback/reply")
    public String submitUserReply(
            @RequestParam Integer feedbackId,
            @RequestParam String replyMessage,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            return "redirect:/login";
        }
        
        if (replyMessage == null || replyMessage.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Reply message cannot be empty");
            return "redirect:/feedback/my-feedback/reply?id=" + feedbackId;
        }
        
        boolean success = feedbackService.addUserReply(feedbackId, replyMessage.trim(), userId);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", 
                "Your reply has been sent! The feedback is now marked as unresolved.");
        } else {
            redirectAttributes.addFlashAttribute("error", 
                "Failed to send reply. Please try again.");
        }
        
        return "redirect:/feedback/my-feedback";
    }
    
    @PostMapping("/my-feedback/mark-seen")
    public String markRepliesAsSeen(
            @RequestParam Integer feedbackId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            return "redirect:/login";
        }
        
        boolean success = feedbackService.markRepliesAsSeen(feedbackId, userId);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", 
                "Marked all replies as read.");
        }
        
        return "redirect:/feedback/my-feedback";
    }
   
    private String validateFeedback(String message, Integer rating) {
        if (message == null || message.trim().length() < 10) {
            return "Message must be at least 10 characters long";
        }
       
        if (rating == null || rating < 1 || rating > 5) {
            return "Please select a valid rating (1-5 stars)";
        }
       
        return null;
    }
   
    private String calculateSentiment(Integer rating) {
        if (rating == null) return "Neutral";
       
        if (rating <= 2) {
            return "Negative";
        } else if (rating == 3) {
            return "Neutral";
        } else {
            return "Positive";
        }
    }
   
    @GetMapping("/analytics")
    public String showFeedbackAnalytics(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String sentiment,
            @RequestParam(required = false) String status,
            Model model,
            HttpSession session) {
       
        String userRole = (String) session.getAttribute("userRole");
        if (!"admin".equals(userRole)) {
            return "redirect:/dashboard?error=unauthorized";
        }
       
        List<Feedback> feedbackList;
        if ((search != null && !search.trim().isEmpty()) ||
            (sentiment != null && !sentiment.trim().isEmpty()) ||
            (status != null && !status.trim().isEmpty())) {
            feedbackList = feedbackAnalyticsService.searchFeedback(
                search != null ? search.trim() : null,
                sentiment != null ? sentiment.trim() : null,
                status != null ? status.trim() : null
            );
        } else {
            feedbackList = feedbackAnalyticsService.getAllFeedback();
        }
       
        Map<String, Integer> stats = feedbackAnalyticsService.getFeedbackStats();
       
        model.addAttribute("feedbackList", feedbackList);
        model.addAttribute("positiveCount", stats.getOrDefault("positive", 0));
        model.addAttribute("neutralCount", stats.getOrDefault("neutral", 0));
        model.addAttribute("negativeCount", stats.getOrDefault("negative", 0));
        model.addAttribute("resolvedCount", stats.getOrDefault("resolved", 0));
        model.addAttribute("totalFeedback", stats.getOrDefault("total", 0));
       
        int total = stats.getOrDefault("total", 0);
        if (total == 0) {
            model.addAttribute("positivePercent", 0);
            model.addAttribute("neutralPercent", 0);
            model.addAttribute("negativePercent", 0);
            model.addAttribute("resolvedPercent", 0);
        } else {
            model.addAttribute("positivePercent", (stats.getOrDefault("positive", 0) * 100) / total);
            model.addAttribute("neutralPercent", (stats.getOrDefault("neutral", 0) * 100) / total);
            model.addAttribute("negativePercent", (stats.getOrDefault("negative", 0) * 100) / total);
            model.addAttribute("resolvedPercent", (stats.getOrDefault("resolved", 0) * 100) / total);
        }
       
        model.addAttribute("search", search);
        model.addAttribute("sentiment", sentiment);
        model.addAttribute("status", status);
       
        return "feedbackAndAnalyticsModule/feedbackAnalytics";
    }
   
    @GetMapping("/reply")
    public String showReplyForm(
            @RequestParam Integer id,
            Model model,
            HttpSession session) {
       
        String userRole = (String) session.getAttribute("userRole");
        if (!"admin".equals(userRole)) {
            return "redirect:/dashboard?error=unauthorized";
        }
       
        Feedback feedback = feedbackAnalyticsService.getFeedbackById(id);
       
        if (feedback != null) {
            model.addAttribute("feedback", feedback);
            model.addAttribute("feedbackId", id);
            model.addAttribute("feedbackMessage", feedback.getMessage());
            model.addAttribute("userName", feedback.getName() != null ? feedback.getName() :
                feedback.getUserFullName() != null ? feedback.getUserFullName() : "Anonymous User");
           
            return "feedbackAndAnalyticsModule/feedbackReply";
        } else {
            return "redirect:/feedback/analytics?error=Feedback+not+found";
        }
    }
   
    @PostMapping("/reply")
    public String submitReply(
            @RequestParam Integer feedbackId,
            @RequestParam String replyMessage,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
       
        String userRole = (String) session.getAttribute("userRole");
        if (!"admin".equals(userRole)) {
            return "redirect:/dashboard?error=unauthorized";
        }
       
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            return "redirect:/login";
        }
       
        if (replyMessage == null || replyMessage.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Reply message cannot be empty");
            return "redirect:/feedback/reply?id=" + feedbackId;
        }
       
        boolean success = feedbackAnalyticsService.sendReply(feedbackId, replyMessage.trim(), userId);
       
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Reply sent successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to send reply");
        }
       
        return "redirect:/feedback/analytics";
    }
   
    @PostMapping("/resolve")
    public String resolveFeedback(
            @RequestParam Integer feedbackId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
       
        String userRole = (String) session.getAttribute("userRole");
        if (!"admin".equals(userRole)) {
            return "redirect:/dashboard?error=unauthorized";
        }
       
        Integer userId = getUserIdFromSession(session);
        if (userId == null) {
            return "redirect:/login";
        }
       
        boolean success = feedbackAnalyticsService.markAsResolved(feedbackId, userId);
       
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Feedback marked as resolved!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to mark as resolved");
        }
       
        return "redirect:/feedback/analytics";
    }
   
    @GetMapping("/report")
    public String showReport(
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Integer id,
            Model model,
            HttpSession session) {
       
        String userRole = (String) session.getAttribute("userRole");
        if (!"admin".equals(userRole)) {
            return "redirect:/dashboard?error=unauthorized";
        }
       
        if (type == null) {
            type = "summary";
        }
       
        if ("history".equals(type) && id != null) {
            List<Map<String, Object>> history = feedbackAnalyticsService.getFeedbackHistory(id);
            Feedback feedback = feedbackAnalyticsService.getFeedbackById(id);
            
            model.addAttribute("history", history);
            model.addAttribute("feedback", feedback);
            model.addAttribute("feedbackId", id);
            model.addAttribute("reportType", "history");
            return "feedbackAndAnalyticsModule/feedbackHistory";
        }
        else if ("detailed".equals(type)) {
            Map<String, Integer> stats = feedbackAnalyticsService.getFeedbackStats();
            List<Feedback> allFeedback = feedbackAnalyticsService.getAllFeedback();
           
            model.addAttribute("stats", stats);
            model.addAttribute("allFeedback", allFeedback);
            model.addAttribute("reportType", "detailed");
        }
        else {
            Map<String, Integer> stats = feedbackAnalyticsService.getFeedbackStats();
            model.addAttribute("stats", stats);
            model.addAttribute("reportType", "summary");
        }
       
        return "feedbackAndAnalyticsModule/feedbackReport";
    }
   
    @GetMapping("/export/csv")
    public void exportCSVReport(
            HttpServletResponse response,
            HttpSession session) throws IOException {
       
        String userRole = (String) session.getAttribute("userRole");
        if (!"admin".equals(userRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
       
        List<Feedback> allFeedback = feedbackAnalyticsService.getAllFeedback();
       
        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String filename = "feedback_report_" + timestamp + ".csv";
       
        response.setContentType("text/csv");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
       
        PrintWriter writer = response.getWriter();
       
        writer.println("ID,User Name,User Email,Message,Category,Sentiment,Rating,Status,Date Created,Reply Date,Resolved");
       
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        for (Feedback feedback : allFeedback) {
            writer.print(feedback.getId() + ",");
            writer.print(escapeCSV(feedback.getName()) + ",");
            writer.print(escapeCSV(feedback.getEmail()) + ",");
            writer.print(escapeCSV(feedback.getMessage()) + ",");
            writer.print(escapeCSV(feedback.getCategory()) + ",");
            writer.print(escapeCSV(feedback.getSentiment()) + ",");
            writer.print(feedback.getRating() != null ? feedback.getRating() : "" + ",");
            writer.print(feedback.isResolved() ? "Resolved" : "Pending" + ",");
            writer.print(feedback.getCreatedAt() != null ? dateFormat.format(feedback.getCreatedAt()) : "" + ",");
            writer.print(feedback.getReplyDate() != null ? dateFormat.format(feedback.getReplyDate()) : "" + ",");
            writer.print(feedback.isResolved() ? "Yes" : "No");
            writer.println();
        }
       
        writer.flush();
    }
   
    @GetMapping("/export/pdf")
    public void exportPDFReport(
            HttpServletResponse response,
            HttpSession session) throws IOException {
        
        String userRole = (String) session.getAttribute("userRole");
        if (!"admin".equals(userRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        List<Feedback> allFeedback = feedbackAnalyticsService.getAllFeedback();
        Map<String, Integer> stats = feedbackAnalyticsService.getFeedbackStats();
        
        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String filename = "feedback_report_" + timestamp + ".pdf";
        
        response.setContentType("application/pdf");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
        
        try {
            PdfWriter writer = new PdfWriter(response.getOutputStream());
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf, PageSize.A4);
            document.setMargins(40, 40, 40, 40);
            
            PdfFont boldFont = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);
            PdfFont regularFont = PdfFontFactory.createFont(StandardFonts.HELVETICA);
            
            Paragraph title = new Paragraph("SmileSpace Feedback Analytics Report")
                    .setFont(boldFont)
                    .setFontSize(24)
                    .setFontColor(new DeviceRgb(240, 165, 72))
                    .setTextAlignment(TextAlignment.CENTER)
                    .setMarginBottom(10);
            document.add(title);
            
            Paragraph reportInfo = new Paragraph()
                    .add("Generated on: " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + "\n")
                    .add("Report ID: " + timestamp + " | Total Records: " + stats.getOrDefault("total", 0))
                    .setFont(regularFont)
                    .setFontSize(10)
                    .setFontColor(new DeviceRgb(113, 60, 11))
                    .setTextAlignment(TextAlignment.CENTER)
                    .setMarginBottom(30);
            document.add(reportInfo);
            
            Paragraph summaryTitle = new Paragraph("Executive Summary")
                    .setFont(boldFont)
                    .setFontSize(16)
                    .setFontColor(new DeviceRgb(113, 60, 11))
                    .setMarginBottom(10);
            document.add(summaryTitle);
            
            Paragraph summaryContent = new Paragraph(
                    "This report provides comprehensive analysis of all feedback submitted to the SmileSpace platform. " +
                    "It includes sentiment analysis, resolution rates, and detailed feedback records for performance evaluation " +
                    "and quality improvement purposes.")
                    .setFont(regularFont)
                    .setFontSize(11)
                    .setFontColor(new DeviceRgb(93, 64, 55))
                    .setMarginBottom(25);
            document.add(summaryContent);
            
            Paragraph statsTitle = new Paragraph("Summary Statistics")
                    .setFont(boldFont)
                    .setFontSize(16)
                    .setFontColor(new DeviceRgb(113, 60, 11))
                    .setMarginBottom(20);
            document.add(statsTitle);
            
            float[] columnWidths = {1, 1, 1, 1, 1};
            Table statsTable = new Table(columnWidths);
            statsTable.setWidth(UnitValue.createPercentValue(100));
            statsTable.setMarginBottom(30);
            
            int total = stats.getOrDefault("total", 0);
            int positivePercent = total > 0 ? (stats.getOrDefault("positive", 0) * 100) / total : 0;
            int neutralPercent = total > 0 ? (stats.getOrDefault("neutral", 0) * 100) / total : 0;
            int negativePercent = total > 0 ? (stats.getOrDefault("negative", 0) * 100) / total : 0;
            int resolvedPercent = total > 0 ? (stats.getOrDefault("resolved", 0) * 100) / total : 0;
            
            addStatCard(statsTable, "Total Feedback", 
                    String.valueOf(stats.getOrDefault("total", 0)), "100%", 
                    new DeviceRgb(113, 60, 11), boldFont, regularFont);
            addStatCard(statsTable, "Positive", 
                    String.valueOf(stats.getOrDefault("positive", 0)), 
                    positivePercent + "%", new DeviceRgb(46, 204, 113), boldFont, regularFont);
            addStatCard(statsTable, "Neutral", 
                    String.valueOf(stats.getOrDefault("neutral", 0)), 
                    neutralPercent + "%", new DeviceRgb(243, 156, 18), boldFont, regularFont);
            addStatCard(statsTable, "Negative", 
                    String.valueOf(stats.getOrDefault("negative", 0)), 
                    negativePercent + "%", new DeviceRgb(231, 76, 60), boldFont, regularFont);
            addStatCard(statsTable, "Resolved", 
                    String.valueOf(stats.getOrDefault("resolved", 0)), 
                    resolvedPercent + "%", new DeviceRgb(39, 174, 96), boldFont, regularFont);
            
            document.add(statsTable);
            
            if (!allFeedback.isEmpty()) {
                Paragraph feedbackTitle = new Paragraph("Feedback Details")
                        .setFont(boldFont)
                        .setFontSize(16)
                        .setFontColor(new DeviceRgb(113, 60, 11))
                        .setMarginBottom(15);
                document.add(feedbackTitle);
                
                float[] feedbackColumnWidths = {0.8f, 2f, 3f, 1.5f, 1.2f, 1.2f, 1.5f, 1.5f};
                Table feedbackTable = new Table(feedbackColumnWidths);
                feedbackTable.setWidth(UnitValue.createPercentValue(100));
                
                String[] headers = {"ID", "User", "Message", "Category", "Sentiment", "Rating", "Status", "Date"};
                for (String header : headers) {
                    Cell headerCell = new Cell()
                        .add(new Paragraph(header)
                            .setFont(boldFont)
                            .setFontSize(10))
                        .setBackgroundColor(new DeviceRgb(240, 213, 184))
                        .setPadding(8)
                        .setTextAlignment(TextAlignment.CENTER)
                        .setFontColor(new DeviceRgb(113, 60, 11));
                    feedbackTable.addHeaderCell(headerCell);
                }
                
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                int count = 0;
                for (Feedback feedback : allFeedback) {
                    if (count++ >= 50) {
                        break;
                    }
                    
                    feedbackTable.addCell(createTableCell(String.valueOf(feedback.getId()), 
                            TextAlignment.CENTER, regularFont));
                    
                    String userName = getUserName(feedback);
                    feedbackTable.addCell(createTableCell(userName, TextAlignment.LEFT, regularFont));
                    
                    String messagePreview = truncate(feedback.getMessage(), 60);
                    feedbackTable.addCell(createTableCell(messagePreview, TextAlignment.LEFT, regularFont));
                    
                    feedbackTable.addCell(createTableCell(feedback.getCategory(), TextAlignment.CENTER, regularFont));
                    
                    Cell sentimentCell = createStyledCell(feedback.getSentiment(), TextAlignment.CENTER, regularFont);
                    if ("Positive".equalsIgnoreCase(feedback.getSentiment())) {
                        sentimentCell.setBackgroundColor(new DeviceRgb(46, 204, 113));
                    } else if ("Negative".equalsIgnoreCase(feedback.getSentiment())) {
                        sentimentCell.setBackgroundColor(new DeviceRgb(231, 76, 60));
                    } else {
                        sentimentCell.setBackgroundColor(new DeviceRgb(243, 156, 18));
                    }
                    feedbackTable.addCell(sentimentCell);
                    
                    String ratingText = feedback.getRating() != null ? 
                            feedback.getRating() + "/5" : "N/A";
                    Cell ratingCell = createTableCell(ratingText, TextAlignment.CENTER, regularFont);
                    if (feedback.getRating() != null) {
                        if (feedback.getRating() >= 4) {
                            ratingCell.setBackgroundColor(new DeviceRgb(255, 243, 200));
                        } else if (feedback.getRating() <= 2) {
                            ratingCell.setBackgroundColor(new DeviceRgb(255, 230, 230));
                        }
                    }
                    feedbackTable.addCell(ratingCell);
                    
                    Cell statusCell = createStyledCell(
                            feedback.isResolved() ? "Resolved" : "Pending", 
                            TextAlignment.CENTER, regularFont);
                    if (feedback.isResolved()) {
                        statusCell.setBackgroundColor(new DeviceRgb(39, 174, 96));
                    } else {
                        statusCell.setBackgroundColor(new DeviceRgb(243, 156, 18));
                    }
                    feedbackTable.addCell(statusCell);
                    
                    String dateStr = feedback.getCreatedAt() != null ? 
                            dateFormat.format(feedback.getCreatedAt()) : "";
                    feedbackTable.addCell(createTableCell(dateStr, TextAlignment.CENTER, regularFont));
                }
                
                document.add(feedbackTable);
                
                if (allFeedback.size() > 50) {
                    Paragraph note = new Paragraph(
                            "Note: Showing 50 of " + allFeedback.size() + " feedback entries. " +
                            "Export to CSV for complete data.")
                            .setFont(regularFont)
                            .setFontSize(10)
                            .setFontColor(new DeviceRgb(160, 106, 47))
                            .setItalic()
                            .setMarginTop(10);
                    document.add(note);
                }
            } else {
                Paragraph noData = new Paragraph("No feedback data available")
                        .setFont(regularFont)
                        .setFontSize(14)
                        .setFontColor(new DeviceRgb(160, 106, 47))
                        .setTextAlignment(TextAlignment.CENTER)
                        .setMarginTop(30);
                document.add(noData);
            }
            
            Paragraph footer = new Paragraph(
                    "________________________________________________________________\n" +
                    "Report generated by SmileSpace Feedback & Analytics System | " +
                    "Confidential - For internal use only")
                    .setFont(regularFont)
                    .setFontSize(8)
                    .setFontColor(new DeviceRgb(160, 106, 47))
                    .setTextAlignment(TextAlignment.CENTER)
                    .setMarginTop(30);
            document.add(footer);
            
            document.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error generating PDF: " + e.getMessage());
        }
    }
    
    private void addStatCard(Table table, String label, String value, String percentage, 
                           DeviceRgb color, PdfFont boldFont, PdfFont regularFont) {
        Cell cell = new Cell();
        cell.setPadding(15);
        cell.setBackgroundColor(new DeviceRgb(255, 255, 255));
        cell.setBorder(new SolidBorder(new DeviceRgb(226, 213, 193), 2));
        cell.setBorderRadius(new BorderRadius(8));
        cell.setTextAlignment(TextAlignment.CENTER);
        
        Paragraph labelPara = new Paragraph(label)
                .setFont(regularFont)
                .setFontSize(12)
                .setFontColor(new DeviceRgb(160, 106, 47))
                .setMarginBottom(8);
        cell.add(labelPara);
        
        Paragraph valuePara = new Paragraph(value)
                .setFont(boldFont)
                .setFontSize(24)
                .setFontColor(color)
                .setMarginBottom(8);
        cell.add(valuePara);
        
        Paragraph percentPara = new Paragraph(percentage)
                .setFont(boldFont)
                .setFontSize(14)
                .setFontColor(new DeviceRgb(215, 146, 59))
                .setBackgroundColor(new DeviceRgb(255, 243, 200))
                .setPadding(6)
                .setMargin(0);
        cell.add(percentPara);
        
        table.addCell(cell);
    }
    
    private Cell createTableCell(String text, TextAlignment alignment, PdfFont font) {
        return new Cell()
            .add(new Paragraph(text != null ? text : "")
                .setFont(font)
                .setFontSize(9))
            .setPadding(6)
            .setTextAlignment(alignment);
    }
    
    private Cell createStyledCell(String text, TextAlignment alignment, PdfFont font) {
        return new Cell()
            .add(new Paragraph(text != null ? text : "")
                .setFont(font)
                .setFontSize(9)
                .setFontColor(new DeviceRgb(255, 255, 255)))
            .setPadding(6)
            .setTextAlignment(alignment);
    }
    
    private String getUserName(Feedback feedback) {
        if (feedback.getUserFullName() != null && !feedback.getUserFullName().isEmpty()) {
            return feedback.getUserFullName();
        } else if (feedback.getName() != null && !feedback.getName().isEmpty()) {
            return feedback.getName();
        }
        return "Anonymous";
    }
    
    private String truncate(String text, int maxLength) {
        if (text == null) return "";
        if (text.length() <= maxLength) return text;
        return text.substring(0, maxLength - 3) + "...";
    }
    
    private String escapeCSV(String value) {
        if (value == null) {
            return "";
        }
        String escaped = value.replace("\"", "\"\"");
        if (escaped.contains(",") || escaped.contains("\"") || escaped.contains("\n") || escaped.contains("\r")) {
            return "\"" + escaped + "\"";
        }
        return escaped;
    }
    
    private Integer getUserIdFromSession(HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) return null;
        
        switch (userIdObj) {
            case Integer integer -> {
                return integer;
            }
            case String string -> {
                try {
                    return Integer.valueOf(string);
                } catch (NumberFormatException e) {
                    return null;
                }
            }
            default -> {
            }
        }
        return null;
    }
}