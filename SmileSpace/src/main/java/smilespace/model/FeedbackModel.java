package smilespace.model;

import java.util.Date;

public class FeedbackModel {
    private int id;
    private String name;
    private String message;
    private String category;
    private String sentiment;
    private boolean resolved;
    private String replyMessage;
    private Date replyDate;

    // Getters and setters for all fields

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getSentiment() {
        return sentiment;
    }

    public void setSentiment(String sentiment) {
        this.sentiment = sentiment;
    }

    public boolean isResolved() {
        return resolved;
    }

    public void setResolved(boolean resolved) {
        this.resolved = resolved;
    }

    public String getReplyMessage() {
        return replyMessage;
    }

    public void setReplyMessage(String replyMessage) {
        this.replyMessage = replyMessage;
    }

    public Date getReplyDate() {
        return replyDate;
    }

    public void setReplyDate(Date replyDate) {
        this.replyDate = replyDate;
    }

    // Optional: Override toString() for better logging and debugging
    @Override
    public String toString() {
        return "FeedbackModel{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", message='" + message + '\'' +
                ", category='" + category + '\'' +
                ", sentiment='" + sentiment + '\'' +
                ", resolved=" + resolved +
                ", replyMessage='" + replyMessage + '\'' +
                ", replyDate=" + replyDate +
                '}';
    }
}
