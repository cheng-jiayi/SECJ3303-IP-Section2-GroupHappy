<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.model.LearningModule" %>
<%
    LearningModule module = (LearningModule) request.getAttribute("module");
%>
<!DOCTYPE html>
<html>
<head>
    <title>UC005 - Edit Module</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f8f9fa; color: #333; }
        
        .container { max-width: 800px; margin: 20px auto; background: white; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.08); overflow: hidden; }
        .header { background: linear-gradient(135deg, #ff9a9e 0%, #fad0c4 100%); color: #333; padding: 25px 30px; text-align: center; }
        .header h1 { font-size: 24px; font-weight: 600; }
        
        .content { padding: 30px; }
        
        .module-id { background: #f8f9fa; padding: 10px 15px; border-radius: 6px; margin-bottom: 20px; font-weight: 500; }
        .module-id span { color: #6a11cb; }
        
        .form-group { margin-bottom: 25px; }
        .form-label { display: block; margin-bottom: 8px; font-weight: 600; color: #495057; font-size: 15px; }
        .form-input, .form-textarea, .form-select { width: 100%; padding: 12px 15px; border: 2px solid #dee2e6; border-radius: 6px; font-size: 15px; transition: all 0.3s; }
        .form-input:focus, .form-textarea:focus, .form-select:focus { outline: none; border-color: #4dabf7; box-shadow: 0 0 0 3px rgba(77, 171, 247, 0.2); }
        .form-textarea { min-height: 120px; resize: vertical; }
        
        .file-upload { display: flex; align-items: center; gap: 10px; }
        .file-input { flex: 1; }
        .browse-btn { background: #e9ecef; border: 2px solid #dee2e6; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: 500; }
        
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        
        .file-types { font-size: 13px; color: #6c757d; margin-top: 5px; }
        
        .button-group { display: flex; gap: 15px; justify-content: flex-end; margin-top: 30px; }
        .btn { padding: 12px 30px; border: none; border-radius: 6px; font-weight: 600; font-size: 15px; cursor: pointer; transition: all 0.3s; }
        .btn-primary { background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%); color: white; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; }
        
        .back-link { display: inline-block; margin-bottom: 20px; color: #4dabf7; text-decoration: none; font-weight: 500; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>UC005 - Edit Module</h1>
            <p>Would you like to edit learning modules?</p>
        </div>
        
        <div class="content">
            <a href="dashboard" class="back-link">← Back to Dashboard</a>
            
            <div class="module-id">Editing: <span><%= module.getId() %> - <%= module.getTitle() %></span></div>
            
            <form action="edit-module" method="POST">
                <input type="hidden" name="id" value="<%= module.getId() %>">
                <input type="hidden" name="views" value="<%= module.getViews() %>">
                
                <div class="form-group">
                    <label class="form-label">Cover Page</label>
                    <div class="file-upload">
                        <input type="text" name="coverImage" class="form-input file-input" 
                               value="<%= module.getCoverImage() != null ? module.getCoverImage() : "" %>" 
                               placeholder="Upload cover image...">
                        <button type="button" class="browse-btn">Browse</button>
                    </div>
                    <div class="file-types">Supported file types: PNG, JPG, JPEG, GIF, BMP</div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Title *</label>
                    <input type="text" name="title" class="form-input" 
                           value="<%= module.getTitle() %>" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Description *</label>
                    <textarea name="description" class="form-textarea" required><%= module.getDescription() != null ? module.getDescription() : "" %></textarea>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Category *</label>
                        <select name="category" class="form-select" required>
                            <option value="Stress" <%= "Stress".equals(module.getCategory()) ? "selected" : "" %>>Stress</option>
                            <option value="Anxiety" <%= "Anxiety".equals(module.getCategory()) ? "selected" : "" %>>Anxiety</option>
                            <option value="Sleep" <%= "Sleep".equals(module.getCategory()) ? "selected" : "" %>>Sleep</option>
                            <option value="Self-Esteem" <%= "Self-Esteem".equals(module.getCategory()) ? "selected" : "" %>>Self-Esteem</option>
                            <option value="Mindfulness" <%= "Mindfulness".equals(module.getCategory()) ? "selected" : "" %>>Mindfulness</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Learning Level *</label>
                        <select name="level" class="form-select" required>
                            <option value="Beginner" <%= "Beginner".equals(module.getLevel()) ? "selected" : "" %>>Beginner</option>
                            <option value="Intermediate" <%= "Intermediate".equals(module.getLevel()) ? "selected" : "" %>>Intermediate</option>
                            <option value="Advance" <%= "Advance".equals(module.getLevel()) ? "selected" : "" %>>Advanced</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Author Name *</label>
                        <input type="text" name="authorName" class="form-input" 
                               value="<%= module.getAuthorName() != null ? module.getAuthorName() : "" %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Estimated Duration *</label>
                        <input type="text" name="estimatedDuration" class="form-input" 
                               value="<%= module.getEstimatedDuration() != null ? module.getEstimatedDuration() : "" %>" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Upload Resource File</label>
                    <div class="file-upload">
                        <input type="text" name="resourceFile" class="form-input file-input" 
                               value="<%= module.getResourceFile() != null ? module.getResourceFile() : "" %>" 
                               placeholder="Upload lecture slides, articles or recorded video...">
                        <button type="button" class="browse-btn">Browse</button>
                    </div>
                    <div class="file-types">Supported file types: MP4, PDF, DOCX, PPT, PNG, JPG, JPEG</div>
                </div>
                
                <div class="button-group">
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='dashboard'">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Module</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>