CREATE DATABASE smilespace;
USE smilespace;

-- Users table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    user_role ENUM('student', 'faculty', 'admin', 'professional') NOT NULL,
    phone VARCHAR(20),
    matric_number VARCHAR(20),
    faculty VARCHAR(100),
    year INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    risk_level ENUM('HIGH', 'MEDIUM', 'LOW') DEFAULT 'LOW',
    recent_mood VARCHAR(100),
    mood_stability DECIMAL(5,2) DEFAULT 0.0,
    frequent_tags VARCHAR(255),
    assessment_category VARCHAR(100)
);

-- Insert users
INSERT INTO users (username, email, password_hash, full_name, user_role, matric_number, faculty, year, phone, risk_level, recent_mood, mood_stability, frequent_tags, assessment_category) VALUES
-- Students
('student1', 'student1@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Ali bin Ahmad', 'student', 'A123456', 'Faculty of Computing', 2, '012-3456789', 'HIGH', 'Anxious', 35.5, 'stress,anxious,overwhelmed', 'Needs Immediate Support'),
('student2', 'student2@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Siti binti Mohd', 'student', 'B234567', 'Faculty of Computing', 3, '013-4567890', 'MEDIUM', 'Stressed', 65.2, 'assignment_due,stressed', 'Monitor Closely'),
('student3', 'student3@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Ahmad bin Ismail', 'student', 'C345678', 'Faculty of Computing', 1, '014-5678901', 'LOW', 'Happy', 85.7, 'happy,content', 'Doing Well'),
('student4', 'student4@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Fatimah binti Ali', 'student', 'D456789', 'Faculty of Engineering', 2, '015-6789012', 'HIGH', 'Depressed', 25.8, 'lonely,depressed,withdrawn', 'High Risk - Immediate Attention'),
('student5', 'student5@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Rajesh Kumar', 'student', 'E567890', 'Faculty of Business', 3, '016-7890123', 'MEDIUM', 'Overwhelmed', 55.3, 'overwhelmed,assignment_due', 'Needs Support'),

-- Faculty
('faculty1', 'faculty1@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Dr. John Smith', 'faculty', NULL, 'Faculty of Computing', NULL, '011-1111111', NULL, NULL, NULL, NULL, NULL),
('faculty2', 'faculty2@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Prof. Sarah Lee', 'faculty', NULL, 'Faculty of Engineering', NULL, '012-2222222', NULL, NULL, NULL, NULL, NULL),

-- Mental Health Professionals
('mhp1', 'mhp1@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Dr. Sarah Johnson', 'professional', NULL, NULL, NULL, '013-3333333', NULL, NULL, NULL, NULL, NULL),
('mhp2', 'mhp2@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Dr. Michael Chen', 'professional', NULL, NULL, NULL, '014-4444444', NULL, NULL, NULL, NULL, NULL),

-- Admin
('admin1', 'admin1@email.com', '$2a$10$KSODLdL2mfTGJnIYJJf1zegCDkWW9Guvkzy6r0W/0grjSQuetomUG', 'Dr. Nurain Shafikah', 'admin', NULL, NULL, NULL, '011-3333333', NULL, NULL, NULL, NULL, NULL);
