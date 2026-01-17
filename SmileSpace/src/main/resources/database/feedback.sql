USE smilespace;

CREATE TABLE IF NOT EXISTS feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    name VARCHAR(100),
    email VARCHAR(100),
    message TEXT NOT NULL,
    category VARCHAR(50) DEFAULT 'General',
    sentiment VARCHAR(20) DEFAULT 'Neutral',
    rating INT NULL,
    is_resolved BOOLEAN DEFAULT FALSE,
    reply_message TEXT,
    reply_date TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    has_unseen_reply BOOLEAN DEFAULT FALSE,
    user_reply TEXT NULL,
    user_reply_date TIMESTAMP NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS feedback_analytics (
    analytics_date DATE PRIMARY KEY,
    total_feedback INT DEFAULT 0,
    positive_count INT DEFAULT 0,
    neutral_count INT DEFAULT 0,
    negative_count INT DEFAULT 0,
    resolved_count INT DEFAULT 0,
    pending_count INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS feedback_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    feedback_id INT,
    user_id INT,
    action_type VARCHAR(20) NOT NULL, -- CREATE, UPDATE, REPLY, RESOLVE
    action_details TEXT,
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (feedback_id) REFERENCES feedback(feedback_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Sample feedback data
INSERT INTO feedback (user_id, name, email, message, category, sentiment, rating, created_at) VALUES
(1, 'Ali bin Ahmad', 'student1@email.com', 'The platform is really helpful! I appreciate the detailed assessment results and the resources provided. It helped me understand my mental health better.', 'Assessment Experience', 'Positive', 5, '2025-01-15 10:30:00'),
(2, 'Siti binti Mohd', 'student2@email.com', 'The platform works well but can be a little slow at times.', 'User Experience', 'Neutral', 3, '2025-01-16 14:15:00'),
(3, 'Ahmad bin Ismail', 'student3@email.com', 'I found a bug in the mood tracker where it doesnt save my entries properly.', 'Technical Issues', 'Negative', 2, '2025-01-17 09:45:00'),
(1, 'Ali bin Ahmad', 'student1@email.com', 'Great new features! The learning modules are very useful.', 'Features', 'Positive', 4, '2025-01-18 16:20:00'),
(2, NULL, NULL, 'Can we have more customization options for the dashboard?', 'Suggestions', 'Neutral', 3, '2025-01-19 11:10:00'),
(4, 'Fatimah binti Ali', 'student4@email.com', 'The counseling session scheduling feature is excellent. Very easy to use!', 'Features', 'Positive', 5, '2025-01-20 13:25:00'),
(5, 'Rajesh Kumar', 'student5@email.com', 'Sometimes the notifications dont come through. Please fix this issue.', 'Technical Issues', 'Negative', 1, '2025-01-21 15:40:00'),
(3, 'Ahmad bin Ismail', 'student3@email.com', 'The mobile app needs improvement. It crashes occasionally.', 'Technical Issues', 'Negative', 2, '2025-01-22 09:15:00'),
(1, 'Ali bin Ahmad', 'student1@email.com', 'The mental health assessments are very insightful. Thank you!', 'Assessment Experience', 'Positive', 5, '2025-01-23 11:50:00'),
(2, 'Siti binti Mohd', 'student2@email.com', 'Would love to have more learning modules on stress management.', 'Suggestions', 'Positive', 4, '2025-01-24 14:30:00');

-- Sample replies to feedback
UPDATE feedback SET 
    reply_message = 'Thank you for your positive feedback! We are glad the platform is helping you.',
    reply_date = '2025-01-16 14:00:00',
    is_resolved = TRUE,
    has_unseen_reply = TRUE
WHERE feedback_id = 1;

UPDATE feedback SET 
    reply_message = 'We are working on optimizing the platform performance. Thank you for reporting this.',
    reply_date = '2025-01-17 11:00:00',
    is_resolved = TRUE,
    has_unseen_reply = TRUE
WHERE feedback_id = 2;

UPDATE feedback SET 
    reply_message = 'We have identified the bug in the mood tracker and will fix it in the next update.',
    reply_date = '2025-01-18 10:00:00',
    is_resolved = FALSE,
    has_unseen_reply = TRUE
WHERE feedback_id = 3;

UPDATE feedback SET 
    user_reply = 'Thank you for the reply. When can we expect the fix?',
    user_reply_date = '2025-01-19 09:30:00',
    is_resolved = FALSE,
    has_unseen_reply = TRUE
WHERE feedback_id = 3;

UPDATE feedback SET 
    reply_message = 'Dashboard customization is in our roadmap for Q2 2025.',
    reply_date = '2025-01-20 16:00:00',
    is_resolved = TRUE,
    has_unseen_reply = FALSE
WHERE feedback_id = 5;

UPDATE feedback SET 
    reply_message = 'Thank you for your suggestion! We will consider adding more stress management modules.',
    reply_date = '2025-01-25 10:00:00',
    is_resolved = TRUE,
    has_unseen_reply = TRUE
WHERE feedback_id = 10;

CREATE INDEX idx_feedback_user ON feedback(user_id);
CREATE INDEX idx_feedback_sentiment ON feedback(sentiment);
CREATE INDEX idx_feedback_resolved ON feedback(is_resolved);
CREATE INDEX idx_feedback_category ON feedback(category);
CREATE INDEX idx_feedback_created ON feedback(created_at);
CREATE INDEX idx_feedback_has_unseen ON feedback(has_unseen_reply);
CREATE INDEX idx_feedback_last_updated ON feedback(last_updated);

-- Sample feedback history data
INSERT INTO feedback_history (feedback_id, user_id, action_type, action_details, performed_at) VALUES
(1, 1, 'CREATE', 'Feedback submitted with sentiment: Positive', '2025-01-15 10:30:00'),
(1, 8, 'REPLY', 'Reply sent: Thank you for your positive feedback! We are glad...', '2025-01-16 14:00:00'),
(2, 2, 'CREATE', 'Feedback submitted with sentiment: Neutral', '2025-01-16 14:15:00'),
(2, 8, 'REPLY', 'Reply sent: We are working on optimizing the platform performance...', '2025-01-17 11:00:00'),
(3, 3, 'CREATE', 'Feedback submitted with sentiment: Negative', '2025-01-17 09:45:00'),
(3, 8, 'REPLY', 'Reply sent: We have identified the bug in the mood tracker...', '2025-01-18 10:00:00'),
(3, 3, 'USER_REPLY', 'User replied: Thank you for the reply. When can we expect the fix?', '2025-01-19 09:30:00'),
(4, 1, 'CREATE', 'Feedback submitted with sentiment: Positive', '2025-01-18 16:20:00'),
(5, 2, 'CREATE', 'Feedback submitted with sentiment: Neutral', '2025-01-19 11:10:00'),
(5, 8, 'REPLY', 'Reply sent: Dashboard customization is in our roadmap...', '2025-01-20 16:00:00'),
(10, 2, 'CREATE', 'Feedback submitted with sentiment: Positive', '2025-01-24 14:30:00'),
(10, 8, 'REPLY', 'Reply sent: Thank you for your suggestion! We will consider...', '2025-01-25 10:00:00');