package smilespace.service;

import java.util.ArrayList;
import java.util.List;

import smilespace.model.Feedback;

public class FeedbackService {

    private static final List<Feedback> feedbackList = new ArrayList<>();

    public void saveFeedback(Feedback fb) {
        feedbackList.add(fb);
    }

    public List<Feedback> getAllFeedback() {
        return feedbackList;
    }
}
