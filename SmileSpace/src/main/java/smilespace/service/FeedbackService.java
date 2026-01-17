package smilespace.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import smilespace.dao.FeedbackDAO;
import smilespace.model.Feedback;

@Service
@Transactional
public class FeedbackService {
    
    @Autowired
    private FeedbackDAO feedbackDAO;
    
    public boolean saveFeedback(Feedback feedback, Integer userId) {
        return feedbackDAO.createFeedback(feedback, userId);
    }
    
    public List<Feedback> getFeedbackByUser(int userId) {
        return feedbackDAO.getFeedbackByUserId(userId);
    }
    
    public List<Feedback> getAllFeedback() {
        return feedbackDAO.getAllFeedback();
    }
        
    public int getUnseenReplyCount(int userId) {
        return feedbackDAO.getUnseenReplyCount(userId);
    }
    
    public boolean markRepliesAsSeen(int feedbackId, int userId) {
        return feedbackDAO.markRepliesAsSeen(feedbackId, userId);
    }
    
    public boolean addUserReply(int feedbackId, String replyMessage, int userId) {
        return feedbackDAO.addUserReply(feedbackId, replyMessage, userId);
    }

    public List<Feedback> getFilteredUserFeedback(int userId, String searchTerm, String status) {
        return feedbackDAO.getUserFeedbackWithFilters(userId, searchTerm, status);
    }
}