package smilespace.model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class MoodEntry {
    private int id;
    private List<String> feelings; // Multiple feelings
    private String reflection; // What made you feel like this
    private LocalDate entryDate;
    private Set<String> tags;
    private String imagePath;

    public MoodEntry() {
        this.feelings = new ArrayList<>();
        this.tags = new HashSet<>();
        this.entryDate = LocalDate.now();
    }

    public MoodEntry(List<String> feelings, String reflection, Set<String> tags, String imagePath) {
        this();
        this.feelings = feelings;
        this.reflection = reflection;
        this.tags = tags;
        this.imagePath = imagePath;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public List<String> getFeelings() { return feelings; }
    public void setFeelings(List<String> feelings) { this.feelings = feelings; }
    public void addFeeling(String feeling) { this.feelings.add(feeling); }

    public String getReflection() { return reflection; }
    public void setReflection(String reflection) { this.reflection = reflection; }

    public LocalDate getEntryDate() { return entryDate; }
    public void setEntryDate(LocalDate entryDate) { this.entryDate = entryDate; }

    public Set<String> getTags() { return tags; }
    public void setTags(Set<String> tags) { this.tags = tags; }
    public void addTag(String tag) { this.tags.add(tag); }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public String getFormattedDate() {
        return entryDate.format(DateTimeFormatter.ofPattern("d MMM yyyy"));
    }

    public String getFeelingsAsString() {
        return String.join(", ", feelings);
    }

    public String getTagsAsString() {
        return String.join(", ", tags);
    }
}