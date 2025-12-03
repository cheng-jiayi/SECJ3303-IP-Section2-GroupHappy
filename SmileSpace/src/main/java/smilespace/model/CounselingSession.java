package smilespace.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class CounselingSession {
    private String sessionId;
    private String studentId;
    private String sessionType;
    private LocalDateTime sessionDateTime;
    private String currentMood;
    private String reason;
    private String additionalNotes;
    private String followUpMethod;
    private String status;
    private String summary;
    private String progressNotes;
    private String followUpActions;
    private String nextSessionSuggested;
    private LocalDateTime documentedDate;

    // Constructors
    public CounselingSession() {}

    public CounselingSession(String sessionId, String studentId, String sessionType, 
                           LocalDateTime sessionDateTime, String currentMood, String reason, 
                           String additionalNotes, String followUpMethod, String status) {
        this.sessionId = sessionId;
        this.studentId = studentId;
        this.sessionType = sessionType;
        this.sessionDateTime = sessionDateTime;
        this.currentMood = currentMood;
        this.reason = reason;
        this.additionalNotes = additionalNotes;
        this.followUpMethod = followUpMethod;
        this.status = status;
    }

    // Getters and Setters
    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public String getSessionType() { return sessionType; }
    public void setSessionType(String sessionType) { this.sessionType = sessionType; }

    public LocalDateTime getSessionDateTime() { return sessionDateTime; }
    public void setSessionDateTime(LocalDateTime sessionDateTime) { this.sessionDateTime = sessionDateTime; }

    public String getCurrentMood() { return currentMood; }
    public void setCurrentMood(String currentMood) { this.currentMood = currentMood; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getAdditionalNotes() { return additionalNotes; }
    public void setAdditionalNotes(String additionalNotes) { this.additionalNotes = additionalNotes; }

    public String getFollowUpMethod() { return followUpMethod; }
    public void setFollowUpMethod(String followUpMethod) { this.followUpMethod = followUpMethod; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }

    public String getProgressNotes() { return progressNotes; }
    public void setProgressNotes(String progressNotes) { this.progressNotes = progressNotes; }

    public String getFollowUpActions() { return followUpActions; }
    public void setFollowUpActions(String followUpActions) { this.followUpActions = followUpActions; }

    public String getNextSessionSuggested() { return nextSessionSuggested; }
    public void setNextSessionSuggested(String nextSessionSuggested) { this.nextSessionSuggested = nextSessionSuggested; }

    public LocalDateTime getDocumentedDate() { return documentedDate; }
    public void setDocumentedDate(LocalDateTime documentedDate) { this.documentedDate = documentedDate; }

    // Helper methods
    public String getFormattedDateTime() {
        if (sessionDateTime != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMM yyyy, h:mm a");
            return sessionDateTime.format(formatter);
        }
        return "";
    }

    public String getFormattedDate() {
        if (sessionDateTime != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMM yyyy");
            return sessionDateTime.format(formatter);
        }
        return "";
    }

    public String getFormattedTime() {
        if (sessionDateTime != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("h:mm a");
            return sessionDateTime.format(formatter);
        }
        return "";
    }

    public String getDocumentedDateFormatted() {
        if (documentedDate != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMM yyyy, h:mm a");
            return documentedDate.format(formatter);
        }
        return "";
    }
    
    public boolean isUpcoming() {
        if (sessionDateTime == null) return false;
        return ("Scheduled".equals(status) || "Upcoming".equals(status)) 
               && sessionDateTime.isAfter(LocalDateTime.now());
    }

    public boolean isCompleted() {
        return "Completed".equals(status);
    }

    public boolean isCancelled() {
        return "Cancelled".equals(status);
    }
}