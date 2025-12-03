<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.model.LearningModule" %>
<%
    LearningModule module = (LearningModule) request.getAttribute("module");
%>
<!DOCTYPE html>
<html>
<head>
    <title>UC005 - Preview Module</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f8f9fa; color: #333; }
        
        .container { max-width: 900px; margin: 20px auto; background: white; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.08); overflow: hidden; }
        .header { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white; padding: 25px 30px; }
        .header h1 { font-size: 24px; font-weight: 600; display: flex; align-items: center; gap: 12px; }
        .header-icon { font-size: 28px; }
        
        .content { padding: 30px; }
        
        .back-link { display: inline-block; margin-bottom: 20px; color: #4dabf7; text-decoration: none; font-weight: 500; }
        .back-link:hover { text-decoration: underline; }
        
        .module-preview { display: grid; grid-template-columns: 300px 1fr; gap: 30px; }
        
        .cover-section { background: #f8f9fa; border-radius: 8px; padding: 20px; text-align: center; }
        .cover-placeholder { width: 100%; height: 200px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 6px; display: flex; align-items: center; justify-content: center; color: white; font-size: 18px; font-weight: 600; margin-bottom: 15px; }
        .cover-info { font-size: 14px; color: #6c757d; }
        
        .details-section { padding: 10px; }
        .module-id { background: #f1f3f4; padding: 8px 15px; border-radius: 6px; display: inline-block; margin-bottom: 20px; font-weight: 500; }
        
        .detail-group { margin-bottom: 25px; }
        .detail-label { font-weight: 600; color: #495057; margin-bottom: 8px; font-size: 15px; }
        .detail-value { padding: 12px 15px; background: #f8f9fa; border-radius: 6px; border-left: 4px solid #4dabf7; }
        
        .badge { display: inline-block; padding: 6px 12px; border-radius: 15px; font-size: 13px; font-weight: 500; margin-right: 8px; }
        .category-badge { background: #e3f2fd; color: #1976d2; }
        .level-beginner { background: #e8f5e9; color: #2e7d32; }
        .level-intermediate { background: #fff3e0; color: #ef6c00; }
        .level-advance { background: #ffebee; color: #c62828; }
        
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 15px; margin: 30px 0; }
        .stat-box { background: #f8f9fa; padding: 20px; border-radius: 8px; text-align: center; border-top: 4px solid #4dabf7; }
        .stat-value { font-size: 24px; font-weight: 600; color: #333; }
        .stat-label { font-size: 14px; color: #6c757d; margin-top: 5px; }
        
        .resource-section { background: #f1f8ff; padding: 20px; border-radius: 8px; margin: 20px 0; border: 2px dashed #4dabf7; }
        .resource-icon { font-size: 24px; margin-bottom: 10px; }
        
        .action-buttons { display: flex; gap: 15px; margin-top: 30px; }
        .action-btn { padding: 12px 25px; border: 2px solid #dee2e6; background: white; border-radius: 6px; font-weight: 600; cursor: pointer; transition: all 0.3s; text-decoration: none; display: inline-block; }
        .action-btn:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .edit-btn { border-color: #ff9800; color: #ff9800; }
        .edit-btn:hover { background: #ff9800; color: white; }
        .delete-btn { border-color: #f44336; color: #f44336; }
        .delete-btn:hover { background: #f44336; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>
                <span class="header-icon">👁️</span>
                UC005 - Preview Module
            </h1>
        </div>
        
        <div class="content">
            <a href="dashboard" class="back-link">← Back to Dashboard</a>
            
            <div class="module-id">Module ID: <strong><%= module.getId() %></strong></div>
            
            <div class="module-preview">
                <div class="cover-section">
                    <div class="cover-placeholder">
                        <%= module.getTitle() %>
                    </div>
                    <div class="cover-info">
                        <p><strong>Cover Image:</strong></p>
                        <p><%= module.getCoverImage() != null ? module.getCoverImage() : "No cover image uploaded" %></p>
                    </div>
                </div>
                
                <div class="details-section">
                    <div class="detail-group">
                        <div class="detail-label">Title</div>
                        <div class="detail-value"><h3><%= module.getTitle() %></h3></div>
                    </div>
                    
                    <div class="detail-group">
                        <div class="detail-label">Description</div>
                        <div class="detail-value"><%= module.getDescription() != null ? module.getDescription() : "No description provided" %></div>
                    </div>
                    
                    <div class="stats-grid">
                        <div class="stat-box">
                            <div class="stat-value"><%= module.getViews() %></div>
                            <div class="stat-label">Total Views</div>
                        </div>
                        <div class="stat-box">
                            <div class="stat-value"><%= module.getEstimatedDuration() != null ? module.getEstimatedDuration() : "N/A" %></div>
                            <div class="stat-label">Duration</div>
                        </div>
                        <div class="stat-box">
                            <div class="stat-value"><%= module.getLastUpdated() %></div>
                            <div class="stat-label">Last Updated</div>
                        </div>
                    </div>
                    
                    <div class="detail-group">
                        <div class="detail-label">Category & Level</div>
                        <div class="detail-value">
                            <span class="badge category-badge"><%= module.getCategory() %></span>
                            <span class="badge level-<%= module.getLevel().toLowerCase() %>"><%= module.getLevel() %></span>
                        </div>
                    </div>
                    
                    <div class="detail-group">
                        <div class="detail-label">Author</div>
                        <div class="detail-value"><%= module.getAuthorName() != null ? module.getAuthorName() : "Unknown" %></div>
                    </div>
                    
                    <% if (module.getResourceFile() != null && !module.getResourceFile().isEmpty()) { %>
                    <div class="resource-section">
                        <div class="resource-icon">📎</div>
                        <div class="detail-label">Resource File</div>
                        <div class="detail-value">
                            <strong><%= module.getResourceFile() %></strong>
                            <p style="margin-top: 10px; font-size: 14px; color: #6c757d;">Click to download or view the resource file</p>
                        </div>
                    </div>
                    <% } %>
                    
                    <div class="action-buttons">
                        <a href="edit-module?id=<%= module.getId() %>" class="action-btn edit-btn">✏️ Edit Module</a>
                        <a href="delete-module?id=<%= module.getId() %>" class="action-btn delete-btn">🗑️ Delete Module</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>