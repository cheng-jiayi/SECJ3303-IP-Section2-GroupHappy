package smilespace.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Referral {
    private String referralId;
    private String studentId;
    private String facultyId;
    private String reason;
    private String urgency;
    private String notify;
    private String notes;
    private LocalDateTime referralDate;
    private String status;

    // Constructors
    public Referral() {}

    public Referral(String referralId, String studentId, String facultyId, String reason, 
                   String urgency, String notify, String notes, LocalDateTime referralDate, 
                   String status) {
        this.referralId = referralId;
        this.studentId = studentId;
        this.facultyId = facultyId;
        this.reason = reason;
        this.urgency = urgency;
        this.notify = notify;
        this.notes = notes;
        this.referralDate = referralDate;
        this.status = status;
    }

    // Getters and Setters
    public String getReferralId() { return referralId; }
    public void setReferralId(String referralId) { this.referralId = referralId; }

    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public String getFacultyId() { return facultyId; }
    public void setFacultyId(String facultyId) { this.facultyId = facultyId; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getUrgency() { return urgency; }
    public void setUrgency(String urgency) { this.urgency = urgency; }

    public String getNotify() { return notify; }
    public void setNotify(String notify) { this.notify = notify; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public LocalDateTime getReferralDate() { return referralDate; }
    public void setReferralDate(LocalDateTime referralDate) { this.referralDate = referralDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getFormattedDate() {
        if (referralDate != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMM yyyy, h:mm a");
            return referralDate.format(formatter);
        }
        return "";
    }
}