-- ASSESSMENT MODULE TABLES
-- DASS-21 Assessments Table
CREATE TABLE IF NOT EXISTS dass_assessments (
    assessment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    assessment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    depression_score INT NOT NULL,
    anxiety_score INT NOT NULL,
    stress_score INT NOT NULL,
    depression_severity VARCHAR(50),
    anxiety_severity VARCHAR(50),
    stress_severity VARCHAR(50),
    overall_severity VARCHAR(50),
    is_completed BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_assessment_date (assessment_date)
);

-- DASS-21 Answers Table
CREATE TABLE IF NOT EXISTS dass_answers (
    answer_id INT PRIMARY KEY AUTO_INCREMENT,
    assessment_id INT NOT NULL,
    question_number INT NOT NULL,
    answer_value INT NOT NULL CHECK (answer_value BETWEEN 0 AND 3),
    question_type ENUM('depression', 'anxiety', 'stress') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (assessment_id) REFERENCES dass_assessments(assessment_id) ON DELETE CASCADE,
    UNIQUE KEY unique_assessment_question (assessment_id, question_number),
    INDEX idx_assessment_id (assessment_id),
    INDEX idx_question_type (question_type)
);

-- Assessment History Table
CREATE TABLE IF NOT EXISTS assessment_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    assessment_id INT,
    user_id INT,
    action_type VARCHAR(50) NOT NULL,
    action_details TEXT,
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (assessment_id) REFERENCES dass_assessments(assessment_id) ON DELETE SET NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_assessment_id (assessment_id),
    INDEX idx_user_id (user_id)
);

-- Assessment Sessions Table
CREATE TABLE IF NOT EXISTS assessment_sessions (
    session_id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP NULL,
    status ENUM('in_progress', 'completed', 'abandoned') DEFAULT 'in_progress',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_session (user_id, start_time)
);

-- Add indexes for better performance on common queries
CREATE INDEX IF NOT EXISTS idx_dass_user_completed ON dass_assessments(user_id, is_completed, assessment_date DESC);
CREATE INDEX IF NOT EXISTS idx_dass_overall_severity ON dass_assessments(overall_severity);
CREATE INDEX IF NOT EXISTS idx_dass_completed_date ON dass_assessments(is_completed, assessment_date DESC);

-- Ensure assessment_date column is properly set up
ALTER TABLE dass_assessments 
MODIFY COLUMN assessment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- VIEWS FOR REPORTING
-- View for user assessment summary
CREATE OR REPLACE VIEW user_assessment_summary AS
SELECT 
    u.user_id,
    u.full_name,
    u.username,
    COUNT(da.assessment_id) as assessment_count,
    MAX(da.assessment_date) as last_assessment_date,
    MIN(da.assessment_date) as first_assessment_date,
    AVG(da.depression_score) as avg_depression,
    AVG(da.anxiety_score) as avg_anxiety,
    AVG(da.stress_score) as avg_stress,
    CASE 
        WHEN COUNT(da.assessment_id) = 0 THEN 'Never assessed'
        WHEN DATEDIFF(CURDATE(), MAX(da.assessment_date)) <= 7 THEN 'Recently assessed'
        WHEN DATEDIFF(CURDATE(), MAX(da.assessment_date)) <= 30 THEN 'Assessed this month'
        ELSE 'Needs follow-up'
    END as assessment_status
FROM users u
LEFT JOIN dass_assessments da ON u.user_id = da.user_id AND da.is_completed = TRUE
WHERE u.user_role = 'student'
GROUP BY u.user_id, u.full_name, u.username;

-- View for assessment statistics dashboard
CREATE OR REPLACE VIEW assessment_dashboard_stats AS
SELECT 
    DATE(assessment_date) as assessment_date,
    COUNT(*) as daily_count,
    AVG(depression_score) as avg_depression,
    AVG(anxiety_score) as avg_anxiety,
    AVG(stress_score) as avg_stress,
    SUM(CASE WHEN overall_severity = 'Normal' THEN 1 ELSE 0 END) as normal_count,
    SUM(CASE WHEN overall_severity = 'Mild' THEN 1 ELSE 0 END) as mild_count,
    SUM(CASE WHEN overall_severity = 'Moderate' THEN 1 ELSE 0 END) as moderate_count,
    SUM(CASE WHEN overall_severity = 'Severe' THEN 1 ELSE 0 END) as severe_count,
    SUM(CASE WHEN overall_severity = 'Extremely Severe' THEN 1 ELSE 0 END) as extremely_severe_count
FROM dass_assessments 
WHERE is_completed = TRUE
GROUP BY DATE(assessment_date)
ORDER BY assessment_date DESC;

-- STORED PROCEDURES
DELIMITER //

-- Get user assessment statistics
CREATE PROCEDURE GetUserAssessmentStats(IN user_id_param INT)
BEGIN
    SELECT 
        COUNT(*) as total_assessments,
        MAX(assessment_date) as last_assessment,
        MIN(assessment_date) as first_assessment,
        AVG(depression_score) as avg_depression,
        AVG(anxiety_score) as avg_anxiety,
        AVG(stress_score) as avg_stress,
        overall_severity as most_recent_severity
    FROM dass_assessments 
    WHERE user_id = user_id_param 
    AND is_completed = TRUE
    GROUP BY user_id;
END //

-- Get assessment history
CREATE PROCEDURE GetAssessmentHistory(IN assessment_id_param INT)
BEGIN
    SELECT ah.*, u.full_name as performed_by 
    FROM assessment_history ah 
    LEFT JOIN users u ON ah.user_id = u.user_id 
    WHERE ah.assessment_id = assessment_id_param 
    ORDER BY ah.performed_at DESC;
END //

DELIMITER ;

-- TRIGGERS
DELIMITER //

-- Trigger to automatically update user risk level based on assessment results
CREATE TRIGGER after_dass_assessment_insert
AFTER INSERT ON dass_assessments
FOR EACH ROW
BEGIN
    DECLARE risk_level VARCHAR(10);
    
    -- Determine risk level based on overall severity
    IF NEW.overall_severity = 'Extremely Severe' OR NEW.overall_severity = 'Severe' THEN
        SET risk_level = 'HIGH';
    ELSEIF NEW.overall_severity = 'Moderate' THEN
        SET risk_level = 'MEDIUM';
    ELSE
        SET risk_level = 'LOW';
    END IF;
    
    -- Update user's risk level
    UPDATE users 
    SET risk_level = risk_level,
        assessment_category = NEW.overall_severity
    WHERE user_id = NEW.user_id;
    
    -- Log the assessment action
    INSERT INTO assessment_history (assessment_id, user_id, action_type, action_details)
    VALUES (NEW.assessment_id, NEW.user_id, 'ASSESSMENT_COMPLETED', 
            CONCAT('DASS-21 Assessment completed with overall severity: ', NEW.overall_severity));
END //

DELIMITER ;

-- INSERT SAMPLE DASS ASSESSMENT DATA
-- Function to determine severity based on DASS-21 scores
-- Depression: 0-9 Normal, 10-13 Mild, 14-20 Moderate, 21-27 Severe, 28+ Extremely Severe
-- Anxiety: 0-7 Normal, 8-9 Mild, 10-14 Moderate, 15-19 Severe, 20+ Extremely Severe
-- Stress: 0-14 Normal, 15-18 Mild, 19-25 Moderate, 26-33 Severe, 34+ Extremely Severe

-- Helper function to get overall severity (worst of the three)
DELIMITER //
CREATE FUNCTION get_overall_severity(dep_score INT, anx_score INT, str_score INT) 
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE dep_sev, anx_sev, str_sev, overall VARCHAR(50);
    
    -- Depression severity
    SET dep_sev = CASE
        WHEN dep_score >= 28 THEN 'Extremely Severe'
        WHEN dep_score >= 21 THEN 'Severe'
        WHEN dep_score >= 14 THEN 'Moderate'
        WHEN dep_score >= 10 THEN 'Mild'
        ELSE 'Normal'
    END;
    
    -- Anxiety severity
    SET anx_sev = CASE
        WHEN anx_score >= 20 THEN 'Extremely Severe'
        WHEN anx_score >= 15 THEN 'Severe'
        WHEN anx_score >= 10 THEN 'Moderate'
        WHEN anx_score >= 8 THEN 'Mild'
        ELSE 'Normal'
    END;
    
    -- Stress severity
    SET str_sev = CASE
        WHEN str_score >= 34 THEN 'Extremely Severe'
        WHEN str_score >= 26 THEN 'Severe'
        WHEN str_score >= 19 THEN 'Moderate'
        WHEN str_score >= 15 THEN 'Mild'
        ELSE 'Normal'
    END;
    
    -- Determine overall severity (worst of three)
    SET overall = CASE
        WHEN dep_sev = 'Extremely Severe' OR anx_sev = 'Extremely Severe' OR str_sev = 'Extremely Severe' THEN 'Extremely Severe'
        WHEN dep_sev = 'Severe' OR anx_sev = 'Severe' OR str_sev = 'Severe' THEN 'Severe'
        WHEN dep_sev = 'Moderate' OR anx_sev = 'Moderate' OR str_sev = 'Moderate' THEN 'Moderate'
        WHEN dep_sev = 'Mild' OR anx_sev = 'Mild' OR str_sev = 'Mild' THEN 'Mild'
        ELSE 'Normal'
    END;
    
    RETURN overall;
END //
DELIMITER ;

-- Insert sample DASS assessments for students
INSERT INTO dass_assessments (user_id, assessment_date, depression_score, anxiety_score, stress_score, 
                             depression_severity, anxiety_severity, stress_severity, overall_severity, is_completed) VALUES
-- Student 1 (Ali bin Ahmad) - Multiple assessments showing progression
(1, DATE_SUB(CURDATE(), INTERVAL 30 DAY), 25, 22, 28, 'Severe', 'Extremely Severe', 'Severe', 'Extremely Severe', TRUE),
(1, DATE_SUB(CURDATE(), INTERVAL 15 DAY), 18, 16, 22, 'Moderate', 'Severe', 'Moderate', 'Severe', TRUE),
(1, CURDATE(), 12, 10, 16, 'Mild', 'Moderate', 'Mild', 'Moderate', TRUE),

-- Student 2 (Siti binti Mohd) - Consistent moderate stress
(2, DATE_SUB(CURDATE(), INTERVAL 20 DAY), 8, 12, 18, 'Normal', 'Moderate', 'Mild', 'Moderate', TRUE),
(2, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 10, 14, 20, 'Mild', 'Moderate', 'Moderate', 'Moderate', TRUE),

-- Student 3 (Ahmad bin Ismail) - Healthy student
(3, DATE_SUB(CURDATE(), INTERVAL 10 DAY), 4, 5, 10, 'Normal', 'Normal', 'Normal', 'Normal', TRUE),

-- Student 4 (Fatimah binti Ali) - High risk student
(4, DATE_SUB(CURDATE(), INTERVAL 25 DAY), 30, 25, 32, 'Extremely Severe', 'Extremely Severe', 'Severe', 'Extremely Severe', TRUE),
(4, DATE_SUB(CURDATE(), INTERVAL 10 DAY), 32, 28, 35, 'Extremely Severe', 'Extremely Severe', 'Extremely Severe', 'Extremely Severe', TRUE),

-- Student 5 (Rajesh Kumar) - Mild to moderate issues
(5, DATE_SUB(CURDATE(), INTERVAL 15 DAY), 12, 9, 17, 'Mild', 'Mild', 'Mild', 'Mild', TRUE),
(5, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 15, 11, 19, 'Moderate', 'Moderate', 'Moderate', 'Moderate', TRUE);

-- Insert sample DASS answers for the latest assessment of each student
-- Note: DASS-21 has 21 questions (1-21). Questions are categorized as:
-- Depression: 3, 5, 10, 13, 16, 17, 21
-- Anxiety: 2, 4, 7, 9, 15, 19, 20
-- Stress: 1, 6, 8, 11, 12, 14, 18

-- Insert answers for student 1's latest assessment (assessment_id = 3)
INSERT INTO dass_answers (assessment_id, question_number, answer_value, question_type) VALUES
-- Depression questions
(3, 3, 1, 'depression'), (3, 5, 2, 'depression'), (3, 10, 1, 'depression'),
(3, 13, 1, 'depression'), (3, 16, 2, 'depression'), (3, 17, 1, 'depression'), (3, 21, 1, 'depression'),
-- Anxiety questions
(3, 2, 2, 'anxiety'), (3, 4, 1, 'anxiety'), (3, 7, 2, 'anxiety'),
(3, 9, 1, 'anxiety'), (3, 15, 1, 'anxiety'), (3, 19, 2, 'anxiety'), (3, 20, 1, 'anxiety'),
-- Stress questions
(3, 1, 2, 'stress'), (3, 6, 1, 'stress'), (3, 8, 2, 'stress'),
(3, 11, 1, 'stress'), (3, 12, 2, 'stress'), (3, 14, 1, 'stress'), (3, 18, 1, 'stress');

-- Insert answers for student 2's latest assessment (assessment_id = 5)
INSERT INTO dass_answers (assessment_id, question_number, answer_value, question_type) VALUES
-- Depression questions
(5, 3, 1, 'depression'), (5, 5, 1, 'depression'), (5, 10, 0, 'depression'),
(5, 13, 1, 'depression'), (5, 16, 1, 'depression'), (5, 17, 0, 'depression'), (5, 21, 0, 'depression'),
-- Anxiety questions
(5, 2, 2, 'anxiety'), (5, 4, 2, 'anxiety'), (5, 7, 2, 'anxiety'),
(5, 9, 1, 'anxiety'), (5, 15, 1, 'anxiety'), (5, 19, 2, 'anxiety'), (5, 20, 1, 'anxiety'),
-- Stress questions
(5, 1, 2, 'stress'), (5, 6, 1, 'stress'), (5, 8, 3, 'stress'),
(5, 11, 1, 'stress'), (5, 12, 2, 'stress'), (5, 14, 1, 'stress'), (5, 18, 1, 'stress');

-- Insert sample assessment history records
INSERT INTO assessment_history (assessment_id, user_id, action_type, action_details) VALUES
(1, 1, 'ASSESSMENT_COMPLETED', 'Initial DASS-21 assessment completed with extremely severe symptoms'),
(1, 1, 'RISK_FLAGGED', 'Student flagged as high risk based on assessment results'),
(2, 1, 'ASSESSMENT_COMPLETED', 'Follow-up assessment showing improvement from extremely severe to severe'),
(3, 1, 'ASSESSMENT_COMPLETED', 'Latest assessment shows continued improvement to moderate severity'),
(4, 2, 'ASSESSMENT_COMPLETED', 'First assessment completed - moderate symptoms detected'),
(5, 2, 'ASSESSMENT_COMPLETED', 'Follow-up assessment - consistent moderate symptoms'),
(7, 4, 'ASSESSMENT_COMPLETED', 'Assessment completed - extremely severe symptoms detected'),
(7, 4, 'REFERRAL_CREATED', 'Automatic referral created due to extremely severe assessment results'),
(8, 4, 'ASSESSMENT_COMPLETED', 'Follow-up assessment shows worsening symptoms'),
(8, 4, 'CRISIS_ALERT', 'Crisis alert triggered due to extremely severe scores'),
(11, 5, 'ASSESSMENT_COMPLETED', 'Latest assessment shows progression from mild to moderate symptoms');

-- Insert sample assessment sessions (in-progress and completed)
INSERT INTO assessment_sessions (session_id, user_id, start_time, end_time, status) VALUES
-- Completed sessions
('sess_001', 1, DATE_SUB(NOW(), INTERVAL 35 DAY), DATE_SUB(NOW(), INTERVAL 34 DAY), 'completed'),
('sess_002', 1, DATE_SUB(NOW(), INTERVAL 16 DAY), DATE_SUB(NOW(), INTERVAL 15 DAY), 'completed'),
('sess_003', 1, DATE_SUB(NOW(), INTERVAL 1 HOUR), NOW(), 'completed'),
('sess_004', 2, DATE_SUB(NOW(), INTERVAL 22 DAY), DATE_SUB(NOW(), INTERVAL 21 DAY), 'completed'),
('sess_005', 2, DATE_SUB(NOW(), INTERVAL 6 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY), 'completed'),
('sess_006', 3, DATE_SUB(NOW(), INTERVAL 11 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY), 'completed'),
('sess_007', 4, DATE_SUB(NOW(), INTERVAL 26 DAY), DATE_SUB(NOW(), INTERVAL 25 DAY), 'completed'),
('sess_008', 4, DATE_SUB(NOW(), INTERVAL 11 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY), 'completed'),
('sess_009', 5, DATE_SUB(NOW(), INTERVAL 16 DAY), DATE_SUB(NOW(), INTERVAL 15 DAY), 'completed'),
('sess_010', 5, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY), 'completed'),

-- Abandoned sessions
('sess_011', 4, DATE_SUB(NOW(), INTERVAL 2 DAY), NULL, 'abandoned'),
('sess_012', 1, DATE_SUB(NOW(), INTERVAL 5 DAY), NULL, 'abandoned'),

-- In-progress session (student started but hasn't completed)
('sess_013', 2, DATE_SUB(NOW(), INTERVAL 30 MINUTE), NULL, 'in_progress');

-- VIEW: Assessment trend analysis
CREATE OR REPLACE VIEW assessment_trends AS
SELECT 
    u.user_id,
    u.full_name,
    u.faculty,
    da.assessment_date,
    da.depression_score,
    da.anxiety_score,
    da.stress_score,
    da.overall_severity,
    LAG(da.depression_score) OVER (PARTITION BY u.user_id ORDER BY da.assessment_date) as prev_depression,
    LAG(da.anxiety_score) OVER (PARTITION BY u.user_id ORDER BY da.assessment_date) as prev_anxiety,
    LAG(da.stress_score) OVER (PARTITION BY u.user_id ORDER BY da.assessment_date) as prev_stress,
    CASE 
        WHEN LAG(da.depression_score) OVER (PARTITION BY u.user_id ORDER BY da.assessment_date) IS NOT NULL 
        THEN da.depression_score - LAG(da.depression_score) OVER (PARTITION BY u.user_id ORDER BY da.assessment_date)
        ELSE NULL
    END as depression_change,
    CASE 
        WHEN LAG(da.anxiety_score) OVER (PARTITION BY u.user_id ORDER BY da.assessment_date) IS NOT NULL 
        THEN da.anxiety_score - LAG(da.anxiety_score) OVER (PARTition BY u.user_id ORDER BY da.assessment_date)
        ELSE NULL
    END as anxiety_change,
    CASE 
        WHEN LAG(da.stress_score) OVER (PARTITION BY u.user_id ORDER BY da.assessment_date) IS NOT NULL 
        THEN da.stress_score - LAG(da.stress_score) OVER (PARTITION BY u.user_id ORDER BY da.assessment_date)
        ELSE NULL
    END as stress_change
FROM users u
JOIN dass_assessments da ON u.user_id = da.user_id
WHERE u.user_role = 'student'
AND da.is_completed = TRUE
ORDER BY u.user_id, da.assessment_date DESC;

-- VIEW: Students needing assessment follow-up
CREATE OR REPLACE VIEW students_needing_followup AS
SELECT 
    u.user_id,
    u.full_name,
    u.matric_number,
    u.faculty,
    u.risk_level,
    u.assessment_category,
    da.assessment_date as last_assessment_date,
    da.overall_severity as last_severity,
    DATEDIFF(CURDATE(), da.assessment_date) as days_since_assessment,
    CASE 
        WHEN da.overall_severity IN ('Extremely Severe', 'Severe') AND DATEDIFF(CURDATE(), da.assessment_date) > 7 THEN 'URGENT_FOLLOWUP'
        WHEN da.overall_severity = 'Moderate' AND DATEDIFF(CURDATE(), da.assessment_date) > 14 THEN 'NEEDS_FOLLOWUP'
        WHEN da.overall_severity IN ('Mild', 'Normal') AND DATEDIFF(CURDATE(), da.assessment_date) > 30 THEN 'ROUTINE_FOLLOWUP'
        ELSE 'NO_ACTION_NEEDED'
    END as followup_status
FROM users u
LEFT JOIN dass_assessments da ON u.user_id = da.user_id 
    AND da.assessment_date = (SELECT MAX(assessment_date) FROM dass_assessments WHERE user_id = u.user_id)
WHERE u.user_role = 'student'
AND u.is_active = TRUE
ORDER BY 
    CASE 
        WHEN da.overall_severity = 'Extremely Severe' THEN 1
        WHEN da.overall_severity = 'Severe' THEN 2
        WHEN da.overall_severity = 'Moderate' THEN 3
        WHEN da.overall_severity = 'Mild' THEN 4
        ELSE 5
    END,
    days_since_assessment DESC;