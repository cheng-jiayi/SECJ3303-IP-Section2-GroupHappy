package smilespace.model;

public class LearningModule {
    private String id;
    private String title;
    private String category;
    private String level;
    private int views;
    private String lastUpdated;
    private String description;
    private String authorName;
    private String estimatedDuration;
    private String coverImage;
    private String resourceFile;
    
    // Constructors
    public LearningModule() {}
    
    public LearningModule(String id, String title, String category, String level, 
                         int views, String lastUpdated) {
        this.id = id;
        this.title = title;
        this.category = category;
        this.level = level;
        this.views = views;
        this.lastUpdated = lastUpdated;
    }
    
    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }
    
    public int getViews() { return views; }
    public void setViews(int views) { this.views = views; }
    
    public String getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(String lastUpdated) { this.lastUpdated = lastUpdated; }
    
    // Additional fields getters and setters
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }
    
    public String getEstimatedDuration() { return estimatedDuration; }
    public void setEstimatedDuration(String estimatedDuration) { this.estimatedDuration = estimatedDuration; }
    
    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }
    
    public String getResourceFile() { return resourceFile; }
    public void setResourceFile(String resourceFile) { this.resourceFile = resourceFile; }
}