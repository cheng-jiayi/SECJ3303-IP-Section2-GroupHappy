package smilespace.service;

import java.util.ArrayList;
import java.util.List;

import smilespace.model.FeedbackModel;

public class FeedbackAnalyticsService {

    // Sample method to return some feedback
    private List<FeedbackModel> feedbackList;

    public FeedbackAnalyticsService() {
        feedbackList = new ArrayList<>();
        // Example feedback data
        FeedbackModel feedback1 = new FeedbackModel();
        feedback1.setId(1);
        feedback1.setName("Sarah Johnson");
        feedback1.setCategory("Assessment Experience");
        feedback1.setSentiment("Positive");
        feedback1.setMessage("The platform is really helpful! I appreciate the detailed assessment results and the resources provided. It helped me understand my mental health better.");
        feedbackList.add(feedback1);

        FeedbackModel feedback2 = new FeedbackModel();
        feedback2.setId(2);
        feedback2.setName("Michael Chen");
        feedback2.setCategory("User Experience");
        feedback2.setSentiment("Neutral");
        feedback2.setMessage("The platform works well but can be a little slow at times.");
        feedbackList.add(feedback2);
    }

    // Method to return all feedbacks
    public List<FeedbackModel> getAllFeedback() {
        return feedbackList;
    }

    // Method to get a specific feedback by ID
    public FeedbackModel getFeedbackById(int feedbackId) {
        for (FeedbackModel feedback : feedbackList) {
            if (feedback.getId() == feedbackId) {
                return feedback;  // Return the feedback that matches the ID
            }
        }
        return null;  // Return null if feedback with the specified ID is not found
    }

    // Method to send a reply to a feedback
    public void sendReply(int feedbackId, String replyMessage) {
        // Fetch the feedback by ID
        FeedbackModel feedback = getFeedbackById(feedbackId);
        if (feedback != null) {
            // Set the reply message and date
            feedback.setReplyMessage(replyMessage);
            feedback.setReplyDate(new java.util.Date());  // Set the current date for the reply
            feedback.setResolved(true);  // Optionally mark as resolved
        }
    }
}
