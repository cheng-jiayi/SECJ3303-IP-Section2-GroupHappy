package smilespace.model;

import java.util.List;
import java.util.Set;

public class Student {
    private String studentId;
    private String name;
    private String matricNumber;
    private String phone;
    private String email;
    private String program;
    private int year;
    private String recentMood;
    private String riskLevel;
    private String frequentTags;
    private double moodStability;
    private String assessmentCategory;

    // Constructors
    public Student() {}

    public Student(String studentId, String name, String matricNumber, String phone, 
                  String email, String program, int year, String recentMood, 
                  String riskLevel, String frequentTags, double moodStability, 
                  String assessmentCategory) {
        this.studentId = studentId;
        this.name = name;
        this.matricNumber = matricNumber;
        this.phone = phone;
        this.email = email;
        this.program = program;
        this.year = year;
        this.recentMood = recentMood;
        this.riskLevel = riskLevel;
        this.frequentTags = frequentTags;
        this.moodStability = moodStability;
        this.assessmentCategory = assessmentCategory;
    }

    // Getters and Setters
    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getMatricNumber() { return matricNumber; }
    public void setMatricNumber(String matricNumber) { this.matricNumber = matricNumber; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getProgram() { return program; }
    public void setProgram(String program) { this.program = program; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public String getRecentMood() { return recentMood; }
    public void setRecentMood(String recentMood) { this.recentMood = recentMood; }

    public String getRiskLevel() { return riskLevel; }
    public void setRiskLevel(String riskLevel) { this.riskLevel = riskLevel; }

    public String getFrequentTags() { return frequentTags; }
    public void setFrequentTags(String frequentTags) { this.frequentTags = frequentTags; }

    public double getMoodStability() { return moodStability; }
    public void setMoodStability(double moodStability) { this.moodStability = moodStability; }

    public String getAssessmentCategory() { return assessmentCategory; }
    public void setAssessmentCategory(String assessmentCategory) { this.assessmentCategory = assessmentCategory; }

    public String getProgramYear() {
        return program + " / Year " + year;
    }
    
    public String getMoodStabilityText() {
        if (moodStability >= 70) return "Low fluctuations";
        else if (moodStability >= 50) return "Moderate fluctuations"; // Changed from 40 to 50
        else return "High fluctuations";
    }
}