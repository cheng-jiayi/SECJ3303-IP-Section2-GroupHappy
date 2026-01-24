CREATE TABLE reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    reporter_id INT NOT NULL,
    reported_user_id INT NOT NULL,
    post_id INT DEFAULT NULL,
    reply_id INT DEFAULT NULL,
    reason VARCHAR(255) NOT NULL,
    status ENUM('REPORTED','DISMISSED','RESOLVED') DEFAULT 'REPORTED',
    action_taken VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reporter_id) REFERENCES users(user_id),
    FOREIGN KEY (reported_user_id) REFERENCES users(user_id),
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE SET NULL,
    FOREIGN KEY (reply_id) REFERENCES replies(reply_id) ON DELETE SET NULL
);
