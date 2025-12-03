package smilespace.service;

import smilespace.model.*;
import java.time.LocalDateTime;
import java.util.*;

public class CounselingService {
    private List<CounselingSession> sessions = new ArrayList<>();
    private List<Referral> referrals = new ArrayList<>();
    private int referralCounter = 1;
    private int sessionCounter = 1;
    
    // Add this constructor to initialize sample sessions
    public CounselingService() {
        initializeSampleSessions();
    }
    
    // Add this method to create sample sessions for professionals
    private void initializeSampleSessions() {
        if (sessions.isEmpty()) {
            // Sample session 1 - Scheduled
            CounselingSession session1 = new CounselingSession();
            session1.setSessionId("SESSION" + sessionCounter++);
            session1.setStudentId("STU001");
            session1.setSessionType("In-Person");
            session1.setSessionDateTime(LocalDateTime.now().plusDays(2).withHour(10).withMinute(0));
            session1.setCurrentMood("Anxious, Stressed");
            session1.setReason("Academic pressure and exam stress");
            session1.setAdditionalNotes("Student has been struggling with time management");
            session1.setFollowUpMethod("Email");
            session1.setStatus("Scheduled");
            sessions.add(session1);
            
            // Sample session 2 - Scheduled
            CounselingSession session2 = new CounselingSession();
            session2.setSessionId("SESSION" + sessionCounter++);
            session2.setStudentId("STU002");
            session2.setSessionType("Video Call");
            session2.setSessionDateTime(LocalDateTime.now().plusDays(3).withHour(14).withMinute(30));
            session2.setCurrentMood("Overwhelmed, Confused");
            session2.setReason("Career direction and major selection");
            session2.setAdditionalNotes("Unsure about future career path");
            session2.setFollowUpMethod("WhatsApp");
            session2.setStatus("Scheduled");
            sessions.add(session2);
            
            // Sample session 3 - Completed
            CounselingSession session3 = new CounselingSession();
            session3.setSessionId("SESSION" + sessionCounter++);
            session3.setStudentId("STU003");
            session3.setSessionType("Phone Call");
            session3.setSessionDateTime(LocalDateTime.now().minusDays(1).withHour(11).withMinute(0));
            session3.setCurrentMood("Sad, Lonely");
            session3.setReason("Relationship issues and social isolation");
            session3.setAdditionalNotes("Feeling homesick and having difficulty making friends");
            session3.setFollowUpMethod("Phone Call");
            session3.setStatus("Completed");
            session3.setSummary("Discussed coping strategies for homesickness and social anxiety");
            session3.setProgressNotes("Student agreed to join campus clubs and practice social interactions");
            session3.setFollowUpActions("Follow up in 2 weeks to check progress");
            session3.setNextSessionSuggested("Yes");
            session3.setDocumentedDate(LocalDateTime.now().minusDays(1));
            sessions.add(session3);
            
            // Sample session 4 - Completed
            CounselingSession session4 = new CounselingSession();
            session4.setSessionId("SESSION" + sessionCounter++);
            session4.setStudentId("STU004");
            session4.setSessionType("In-Person");
            session4.setSessionDateTime(LocalDateTime.now().minusDays(3).withHour(15).withMinute(0));
            session4.setCurrentMood("Stressed, Anxious");
            session4.setReason("Financial stress and part-time work balance");
            session4.setAdditionalNotes("Working 20 hours/week while taking full course load");
            session4.setFollowUpMethod("Email");
            session4.setStatus("Completed");
            session4.setSummary("Addressed time management and financial planning");
            session4.setProgressNotes("Created weekly schedule and budget plan");
            session4.setFollowUpActions("Monitor workload and check in monthly");
            session4.setNextSessionSuggested("No");
            session4.setDocumentedDate(LocalDateTime.now().minusDays(3));
            sessions.add(session4);
            
            // Sample session 5 - Cancelled
            CounselingSession session5 = new CounselingSession();
            session5.setSessionId("SESSION" + sessionCounter++);
            session5.setStudentId("STU005");
            session5.setSessionType("Video Call");
            session5.setSessionDateTime(LocalDateTime.now().plusDays(5).withHour(16).withMinute(0));
            session5.setCurrentMood("Neutral");
            session5.setReason("General wellness check");
            session5.setAdditionalNotes("Preventive mental health session");
            session5.setFollowUpMethod("SMS");
            session5.setStatus("Cancelled");
            sessions.add(session5);
        }
    }
    
    // UC020 Methods
    public void submitReferral(Referral referral) {
        referral.setReferralId("REF" + referralCounter++);
        referrals.add(referral);
    }
    
    public List<Referral> getReferralsByStudent(String studentId) {
        List<Referral> result = new ArrayList<>();
        for (Referral ref : referrals) {
            if (ref.getStudentId().equals(studentId)) {
                result.add(ref);
            }
        }
        return result;
    }
    
    // UC021 Methods
    public void bookSession(CounselingSession session) {
        session.setSessionId("SESSION" + sessionCounter++);
        sessions.add(session);
    }
    
    public List<CounselingSession> getStudentSessions(String studentId) {
        List<CounselingSession> result = new ArrayList<>();
        for (CounselingSession session : sessions) {
            if (session.getStudentId().equals(studentId)) {
                result.add(session);
            }
        }
        return result;
    }
    
    // UC022 Methods
    public List<CounselingSession> getAllSessions() {
        return new ArrayList<>(sessions);
    }
    
    public CounselingSession getSessionById(String sessionId) {
        for (CounselingSession session : sessions) {
            if (session.getSessionId().equals(sessionId)) {
                return session;
            }
        }
        return null;
    }
    
    public void documentSession(String sessionId, String summary, String progressNotes, 
                              String followUpActions, String status, String nextSessionSuggested) {
        CounselingSession session = getSessionById(sessionId);
        if (session != null) {
            session.setSummary(summary);
            session.setProgressNotes(progressNotes);
            session.setFollowUpActions(followUpActions);
            session.setStatus(status);
            session.setNextSessionSuggested(nextSessionSuggested);
            session.setDocumentedDate(LocalDateTime.now());
        }
    }
    
    public void deleteSession(String sessionId) {
        sessions.removeIf(session -> session.getSessionId().equals(sessionId));
    }
    
    // Additional Service Methods
    public List<CounselingSession> getUpcomingSessions() {
        List<CounselingSession> upcoming = new ArrayList<>();
        LocalDateTime now = LocalDateTime.now();
        
        for (CounselingSession session : sessions) {
            if (session.getSessionDateTime().isAfter(now) && 
                !"Completed".equals(session.getStatus()) && 
                !"Cancelled".equals(session.getStatus())) {
                upcoming.add(session);
            }
        }
        
        // Sort by date
        upcoming.sort((s1, s2) -> s1.getSessionDateTime().compareTo(s2.getSessionDateTime()));
        return upcoming;
    }
    
    public List<CounselingSession> getCompletedSessions() {
        List<CounselingSession> completed = new ArrayList<>();
        
        for (CounselingSession session : sessions) {
            if ("Completed".equals(session.getStatus())) {
                completed.add(session);
            }
        }
        
        // Sort by date (most recent first)
        completed.sort((s1, s2) -> s2.getSessionDateTime().compareTo(s1.getSessionDateTime()));
        return completed;
    }
    
    public int getSessionCountByStatus(String status) {
        int count = 0;
        for (CounselingSession session : sessions) {
            if (session.getStatus().equals(status)) {
                count++;
            }
        }
        return count;
    }
    
    // Additional helper methods
    public List<CounselingSession> getSessionsByStatus(String status) {
        List<CounselingSession> result = new ArrayList<>();
        for (CounselingSession session : sessions) {
            if (session.getStatus().equals(status)) {
                result.add(session);
            }
        }
        return result;
    }
    
    public boolean hasUpcomingSession(String studentId) {
        for (CounselingSession session : sessions) {
            if (session.getStudentId().equals(studentId) && session.isUpcoming()) {
                return true;
            }
        }
        return false;
    }
    
    // Add this method to get session statistics for dashboard
    public Map<String, Integer> getSessionStatistics() {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("total", sessions.size());
        stats.put("scheduled", getSessionCountByStatus("Scheduled"));
        stats.put("completed", getSessionCountByStatus("Completed"));
        stats.put("cancelled", getSessionCountByStatus("Cancelled"));
        return stats;
    }
}