package smilespace.controller;

import smilespace.model.*;
import smilespace.service.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;

@WebServlet(name = "ReferralServlet", urlPatterns = {
    "/referral", "/counseling", 
    "/facultyreferral", "/mhpreferral", "/studentcounseling"
})
public class ReferralServlet extends HttpServlet {
    private CounselingService counselingService;
    private StudentService studentService;

    @Override
    public void init() {
        counselingService = new CounselingService();
        studentService = new StudentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String userType = (String) request.getSession().getAttribute("userType");
        String path = request.getServletPath();
        
        // Handle direct entry points
        if ("/facultyreferral".equals(path)) {
            showFacultyEntry(request, response);
            return;
        } else if ("/mhpreferral".equals(path)) {
            showMHPEntry(request, response);
            return;
        } else if ("/studentcounseling".equals(path)) {
            showStudentEntry(request, response);
            return;
        }
        
        // Auto-login if accessing specific URLs directly
        if (userType == null) {
            if (action != null && (action.equals("viewStudents") || action.equals("showReferralForm"))) {
                // Faculty URLs
                request.getSession().setAttribute("userType", "faculty");
                request.getSession().setAttribute("userId", "FAC001");
                userType = "faculty";
            } else if (action != null && (action.equals("professionalSessions") || action.equals("sessionDetails") || action.equals("documentSession"))) {
                // Mental Health Professional URLs
                request.getSession().setAttribute("userType", "professional");
                request.getSession().setAttribute("userId", "MHP001");
                userType = "professional";
            } else if (action != null && (action.equals("viewSessions") || action.equals("bookSession") || action.equals("sessionDetails"))) {
                // Student URLs - ADDED sessionDetails here
                request.getSession().setAttribute("userType", "student");
                request.getSession().setAttribute("userId", "STU001");
                userType = "student";
            }
        }
        
        if ("viewStudents".equals(action) && "faculty".equals(userType)) {
            showStudentsList(request, response);
        } else if ("showReferralForm".equals(action) && "faculty".equals(userType)) {
            showReferralForm(request, response);
        } else if ("viewSessions".equals(action) && "student".equals(userType)) {
            showStudentSessions(request, response);
        } else if ("bookSession".equals(action) && "student".equals(userType)) {
            showBookingForm(request, response);
        } else if ("professionalSessions".equals(action) && "professional".equals(userType)) {
            showProfessionalSessions(request, response);
        } else if ("sessionDetails".equals(action)) {
            // REMOVED user type restriction - allow both students and professionals to view session details
            showSessionDetails(request, response);
        } else if ("documentSession".equals(action) && "professional".equals(userType)) {
            showDocumentForm(request, response);
        } else {
            // Show welcome page with all entry points
            showWelcomePage(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String userType = (String) request.getSession().getAttribute("userType");
        
        if ("submitReferral".equals(action) && "faculty".equals(userType)) {
            submitReferral(request, response);
        } else if ("submitBooking".equals(action) && "student".equals(userType)) {
            submitBooking(request, response);
        } else if ("submitDocumentation".equals(action) && "professional".equals(userType)) {
            submitDocumentation(request, response);
        } else if ("deleteSession".equals(action)) {
            deleteSession(request, response);
        } else {
            showWelcomePage(request, response);
        }
    }

    // Direct Entry Point Methods
    private void showFacultyEntry(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getSession().setAttribute("userType", "faculty");
        request.getSession().setAttribute("userId", "FAC001");
        response.sendRedirect("referral?action=viewStudents");
    }

    private void showMHPEntry(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getSession().setAttribute("userType", "professional");
        request.getSession().setAttribute("userId", "MHP001");
        response.sendRedirect("counseling?action=professionalSessions");
    }

    private void showStudentEntry(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getSession().setAttribute("userType", "student");
        request.getSession().setAttribute("userId", "STU001");
        response.sendRedirect("counseling?action=viewSessions");
    }

    private void showWelcomePage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Create a simple welcome page since we don't have the JSP yet
        response.setContentType("text/html");
        response.getWriter().println("<h1>SmileSpace Counseling System</h1>");
        response.getWriter().println("<p>Choose your role:</p>");
        response.getWriter().println("<ul>");
        response.getWriter().println("<li><a href='facultyreferral'>Faculty Portal</a></li>");
        response.getWriter().println("<li><a href='studentcounseling'>Student Portal</a></li>");
        response.getWriter().println("<li><a href='mhpreferral'>Mental Health Professional Portal</a></li>");
        response.getWriter().println("</ul>");
    }

    // UC020 Methods - Faculty
    private void showStudentsList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Student> atRiskStudents = studentService.getAtRiskStudents();
        request.setAttribute("students", atRiskStudents);
        request.getRequestDispatcher("/modules/virtualCounselingModule/faculty/studentsList.jsp").forward(request, response);
    }

    private void showReferralForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentId = request.getParameter("studentId");
        Student student = studentService.getStudentById(studentId);
        
        if (student != null) {
            request.setAttribute("student", student);
            request.getRequestDispatcher("/modules/virtualCounselingModule/faculty/referralForm.jsp").forward(request, response);
        } else {
            response.sendRedirect("referral?action=viewStudents");
        }
    }
    
    private void submitReferral(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String studentId = request.getParameter("studentId");
            String reason = request.getParameter("reason");
            String otherReason = request.getParameter("otherReason");
            String urgency = request.getParameter("urgency");
            String notify = request.getParameter("notify");
            String notes = request.getParameter("notes");
            String facultyId = (String) request.getSession().getAttribute("userId");
            
            // If "Other" was selected, use the custom reason
            if ("Other".equals(reason) && otherReason != null && !otherReason.trim().isEmpty()) {
                reason = "Other: " + otherReason;
            }
            
            System.out.println("Submitting referral for student: " + studentId);
            System.out.println("Reason: " + reason + ", Urgency: " + urgency);
            
            Referral referral = new Referral();
            referral.setStudentId(studentId);
            referral.setFacultyId(facultyId);
            referral.setReason(reason);
            referral.setUrgency(urgency);
            referral.setNotify(notify);
            referral.setNotes(notes);
            referral.setReferralDate(LocalDateTime.now());
            referral.setStatus("Pending");
            
            counselingService.submitReferral(referral);
            
            request.setAttribute("referral", referral);
            request.setAttribute("student", studentService.getStudentById(studentId));
            request.getRequestDispatcher("/modules/virtualCounselingModule/faculty/referralConfirmation.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("Error submitting referral: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error submitting referral: " + e.getMessage());
            showReferralForm(request, response);
        }
    }

    // UC021 Methods - Student
    private void showStudentSessions(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentId = (String) request.getSession().getAttribute("userId");
        List<CounselingSession> sessions = counselingService.getStudentSessions(studentId);
        request.setAttribute("sessions", sessions);
        
        request.getRequestDispatcher("/modules/virtualCounselingModule/student/studentSessions.jsp").forward(request, response);
    }

    private void showBookingForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/modules/virtualCounselingModule/student/bookingForm.jsp").forward(request, response);
    }

    private void submitBooking(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String studentId = (String) request.getSession().getAttribute("userId");
            String sessionType = request.getParameter("sessionType");
            String sessionDate = request.getParameter("sessionDate");
            String sessionTime = request.getParameter("sessionTime");
            String currentMood = request.getParameter("currentMood");
            String reason = request.getParameter("reason");
            String additionalNotes = request.getParameter("additionalNotes");
            String followUpMethod = request.getParameter("followUpMethod");
            
            CounselingSession session = new CounselingSession();
            session.setStudentId(studentId);
            session.setSessionType(sessionType);
            session.setSessionDateTime(LocalDateTime.parse(sessionDate + "T" + sessionTime));
            session.setCurrentMood(currentMood);
            session.setReason(reason);
            session.setAdditionalNotes(additionalNotes);
            session.setFollowUpMethod(followUpMethod);
            session.setStatus("Scheduled");
            
            counselingService.bookSession(session);
            
            request.setAttribute("session", session);
            request.setAttribute("student", studentService.getStudentById(studentId));
            
            request.getRequestDispatcher("/modules/virtualCounselingModule/student/bookingConfirmation.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error booking session: " + e.getMessage());
            showBookingForm(request, response);
        }
    }

    // UC022 Methods - Mental Health Professional
    private void showProfessionalSessions(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<CounselingSession> sessions = counselingService.getAllSessions();
        request.setAttribute("sessions", sessions);
        
        request.getRequestDispatcher("/modules/virtualCounselingModule/professional/professionalSessions.jsp").forward(request, response);
    }

    private void showSessionDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String sessionId = request.getParameter("sessionId");
        CounselingSession session = counselingService.getSessionById(sessionId);
        String userType = (String) request.getSession().getAttribute("userType");
        
        if (session != null) {
            request.setAttribute("session", session);
            request.setAttribute("student", studentService.getStudentById(session.getStudentId()));
            
            // Determine which JSP to use based on user type
            if ("student".equals(userType)) {
                // Student viewing their own session details
                request.getRequestDispatcher("/modules/virtualCounselingModule/student/sessionDetails.jsp").forward(request, response);
            } else if ("professional".equals(userType)) {
                // Professional viewing session details
                request.getRequestDispatcher("/modules/virtualCounselingModule/professional/sessionDetails.jsp").forward(request, response);
            } else {
                // Fallback - redirect to appropriate page
                response.sendRedirect("counseling?action=viewSessions");
            }
        } else {
            // Redirect based on user type
            if ("student".equals(userType)) {
                response.sendRedirect("counseling?action=viewSessions");
            } else {
                response.sendRedirect("counseling?action=professionalSessions");
            }
        }
    }

    private void showDocumentForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String sessionId = request.getParameter("sessionId");
        CounselingSession session = counselingService.getSessionById(sessionId);
        
        if (session != null) {
            request.setAttribute("session", session);
            request.setAttribute("student", studentService.getStudentById(session.getStudentId()));
            
            request.getRequestDispatcher("/modules/virtualCounselingModule/professional/documentSession.jsp").forward(request, response);
        } else {
            response.sendRedirect("counseling?action=professionalSessions");
        }
    }

    private void submitDocumentation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String sessionId = request.getParameter("sessionId");
            String summary = request.getParameter("summary");
            String progressNotes = request.getParameter("progressNotes");
            String followUpActions = request.getParameter("followUpActions");
            String nextSessionSuggested = request.getParameter("nextSessionSuggested");
            
            counselingService.documentSession(sessionId, summary, progressNotes, followUpActions, 
                                            "completed", nextSessionSuggested);
            
            response.sendRedirect("counseling?action=professionalSessions");
            
        } catch (Exception e) {
            request.setAttribute("error", "Error documenting session: " + e.getMessage());
            showDocumentForm(request, response);
        }
    }

    private void deleteSession(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String sessionId = request.getParameter("sessionId");
        String userType = (String) request.getSession().getAttribute("userType");
        
        counselingService.deleteSession(sessionId);
        
        if ("student".equals(userType)) {
            response.sendRedirect("counseling?action=viewSessions");
        } else {
            response.sendRedirect("counseling?action=professionalSessions");
        }
    }
}