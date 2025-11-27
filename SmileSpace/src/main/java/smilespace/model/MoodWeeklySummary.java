package smilespace.model;

import java.time.LocalDate;
import java.util.List;

public class MoodWeeklySummary {
    private LocalDate weekStart;
    private LocalDate weekEnd;
    private int totalEntries;
    private String dominantMood;
    private List<String> mostFrequentTags;
    private double moodStability;

    // Getters and Setters
    public LocalDate getWeekStart() {
        return weekStart;
    }

    public void setWeekStart(LocalDate weekStart) {
        this.weekStart = weekStart;
    }

    public LocalDate getWeekEnd() {
        return weekEnd;
    }

    public void setWeekEnd(LocalDate weekEnd) {
        this.weekEnd = weekEnd;
    }

    public int getTotalEntries() {
        return totalEntries;
    }

    public void setTotalEntries(int totalEntries) {
        this.totalEntries = totalEntries;
    }

    public String getDominantMood() {
        return dominantMood;
    }

    public void setDominantMood(String dominantMood) {
        this.dominantMood = dominantMood;
    }

    public List<String> getMostFrequentTags() {
        return mostFrequentTags;
    }

    public void setMostFrequentTags(List<String> mostFrequentTags) {
        this.mostFrequentTags = mostFrequentTags;
    }

    public double getMoodStability() {
        return moodStability;
    }

    public void setMoodStability(double moodStability) {
        this.moodStability = moodStability;
    }
}