package smilespace.model;

public class Question {
    private int id;
    private String text;
    private boolean isTrue;
    private String module;
    
    public Question() {}
    
    public Question(int id, String text, boolean isTrue, String module) {
        this.id = id;
        this.text = text;
        this.isTrue = isTrue;
        this.module = module;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getText() { return text; }
    public void setText(String text) { this.text = text; }
    
    public boolean isTrue() { return isTrue; }
    public void setTrue(boolean isTrue) { this.isTrue = isTrue; }
    
    public String getModule() { return module; }
    public void setModule(String module) { this.module = module; }
}