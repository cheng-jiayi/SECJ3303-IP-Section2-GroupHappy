CREATE TABLE reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    reporter_id INT NOT NULL,        -- user who reports
    post_id INT DEFAULT NULL,        -- reported post (if applicable)
    reply_id INT DEFAULT NULL,       -- reported reply (if applicable)
    reason VARCHAR(255) NOT NULL,    -- reason user entered
    status ENUM('REPORTED','DISMISSED','RESOLVED') DEFAULT 'REPORTED', -- current report status
    action_taken VARCHAR(255) DEFAULT NULL,  -- optional note from admin
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reporter_id) REFERENCES users(user_id),
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE SET NULL,
    FOREIGN KEY (reply_id) REFERENCES replies(reply_id) ON DELETE SET NULL
);