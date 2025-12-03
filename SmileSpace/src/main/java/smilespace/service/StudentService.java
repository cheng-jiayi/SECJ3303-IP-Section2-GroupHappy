package smilespace.service;

import smilespace.model.*;
import java.util.*;

public class StudentService {
    private List<Student> students = new ArrayList<>();
    
    public StudentService() {
        // Sample data
        initializeSampleData();
    }
    
    private void initializeSampleData() {
        // Add ALL students that match the session IDs from CounselingService
        // These must match the student IDs in your sample sessions: STU001, STU002, STU003, STU004, STU005
        
        Student student1 = new Student();
        student1.setStudentId("STU001");
        student1.setName("Tan Wei Ling");
        student1.setMatricNumber("A23CS0001");
        student1.setPhone("012-3456789");
        student1.setEmail("tanweiling@graduate.utm.my");
        student1.setProgram("Computer Science");
        student1.setYear(3);
        student1.setRecentMood("Stressed, Anxious");
        student1.setRiskLevel("High");
        student1.setFrequentTags("Coursework, Deadlines, Exam Stress");
        student1.setMoodStability(30.0);
        student1.setAssessmentCategory("Stress, Anxiety");
        students.add(student1);
        
        Student student2 = new Student();
        student2.setStudentId("STU002");
        student2.setName("Amy Tan");
        student2.setMatricNumber("A23CS0002");
        student2.setPhone("012-3456000");
        student2.setEmail("amytan@graduate.utm.my");
        student2.setProgram("Computer Science");
        student2.setYear(3);
        student2.setRecentMood("Stressed, Anxious, Warm");
        student2.setRiskLevel("Medium");
        student2.setFrequentTags("Group Project, Presentation");
        student2.setMoodStability(60.0);
        student2.setAssessmentCategory("Academic Pressure");
        students.add(student2);

        Student student3 = new Student();
        student3.setStudentId("STU003");
        student3.setName("John Lim");
        student3.setMatricNumber("A23CS0003");
        student3.setPhone("012-3456111");
        student3.setEmail("johnlim@graduate.utm.my");
        student3.setProgram("Software Engineering");
        student3.setYear(2);
        student3.setRecentMood("Happy, Relaxed");
        student3.setRiskLevel("Low");
        student3.setFrequentTags("Social, Friends, Activities");
        student3.setMoodStability(80.0);
        student3.setAssessmentCategory("Good Mental Health");
        students.add(student3);

        // Add the missing students that are in your sessions
        Student student4 = new Student();
        student4.setStudentId("STU004");
        student4.setName("Sarah Chen");
        student4.setMatricNumber("A23CS0004");
        student4.setPhone("012-3456222");
        student4.setEmail("sarahchen@graduate.utm.my");
        student4.setProgram("Data Science");
        student4.setYear(2);
        student4.setRecentMood("Overwhelmed");
        student4.setRiskLevel("Medium");
        student4.setFrequentTags("Financial, Part-time Work");
        student4.setMoodStability(45.0);
        student4.setAssessmentCategory("Financial Stress");
        students.add(student4);

        Student student5 = new Student();
        student5.setStudentId("STU005");
        student5.setName("Michael Wong");
        student5.setMatricNumber("A23CS0005");
        student5.setPhone("012-3456333");
        student5.setEmail("michaelwong@graduate.utm.my");
        student5.setProgram("Information Technology");
        student5.setYear(1);
        student5.setRecentMood("Neutral");
        student5.setRiskLevel("Low");
        student5.setFrequentTags("Adjustment, New Environment");
        student5.setMoodStability(70.0);
        student5.setAssessmentCategory("General Wellness");
        students.add(student5);
    }
    
    public List<Student> getAtRiskStudents() {
        List<Student> atRisk = new ArrayList<>();
        for (Student student : students) {
            if ("High".equals(student.getRiskLevel()) || "Medium".equals(student.getRiskLevel())) {
                atRisk.add(student);
            }
        }
        return atRisk;
    }
    
    public Student getStudentById(String studentId) {
        for (Student student : students) {
            if (student.getStudentId().equals(studentId)) {
                return student;
            }
        }
        // If student not found, create a basic student to avoid null
        System.out.println("Student not found for ID: " + studentId);
        Student basicStudent = new Student();
        basicStudent.setStudentId(studentId);
        basicStudent.setName("Student " + studentId);
        basicStudent.setMatricNumber("N/A");
        basicStudent.setProgram("Unknown");
        return basicStudent;
    }
    
    // Add this method to get all students
    public List<Student> getAllStudents() {
        return new ArrayList<>(students);
    }
}