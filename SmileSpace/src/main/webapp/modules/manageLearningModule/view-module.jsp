<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="smilespace.model.LearningModule" %>
<%
    LearningModule module = (LearningModule) request.getAttribute("module");
%>
<!DOCTYPE html>
<html>
<head>
    <title>UC005 - View Module</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f8f9fa; color: #333; }
        
        .container { max-width: 800px; margin: 20px auto; background: white; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.08); overflow: hidden; }
        .header { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white; padding: 25px 30px; }
        .header h1 { font-size: 24px; font-weight: 600; }
        
        .content { padding: 30px; }
        
        .back-link { display: inline-block; margin-bottom: 20px; color: #4dabf7; text-decoration: none; font-weight: 500; }
        .back-link:hover { text-decoration: underline; }
        
        .module-details { background: #f8f9fa; padding: 25px; border-radius: 8px; }
        .detail-row { display: flex; margin-bottom: 15px; padding-bottom: 15px; border-bottom: 1px solid #dee2e6; }
        .detail-label { font-weight: 600; width: 180px; color: #495057; }
        .detail-value { flex: 1; }
        
        .badge { display: inline-block; padding: 5px 12px; border-radius: 15px; font-size: 14px; font-weight: 500; }
        .stress { background: #e3f2fd; color: #1976d2; }
        .sleep { background: #e8f5e9; color: #2e7d32; }
        .anxiety { background: #fff3e0; color: #ef6c00; }
        .self-esteem { background: #f3e5f5; color: #7b1fa2; }
        .mindfulness { background: #e0f2f1; color: #00796b; }
        
        .level-beginner { background: #e8f5e9; color: #2e7d32; }
        .level-intermediate { background: #fff3e0; color: #ef6c00; }
        .level-advance { background: #ffebee; color: #c62828; }
        
        .button-group { display: flex; gap: 15px; margin-top: 30px; }
        .btn { padding: 12px 25px; border: none; border-radius: 6px; font-weight: 600; font-size: 15px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-primary { background: #4dabf7; color: white; }
        .btn-primary:hover { background: #2196f3; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; }
        .btn-danger { background: #f44336; color: white; }
        .btn-danger:hover { background: #d32f2f; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>UC005 - View Module Details</h1>
        </div>
        
        <div class="content">
            <a href="dashboard" class="back-link">← Back to Dashboard</a>
            
            <div class="module-details">
                <div class="detail-row">
                    <div class="detail-label">Module ID:</div>
                    <div class="detail-value"><strong><%= module.getId() %></strong></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Title:</div>
                    <div class="detail-value"><h3><%= module.getTitle() %></h3></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Description:</div>
                    <div class="detail-value"><%= module.getDescription() != null ? module.getDescription() : "No description available" %></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Category:</div>
                    <div class="detail-value">
                        <span class="badge <%= module.getCategory().toLowerCase().replace(" ", "-") %>">
                            <%= module.getCategory() %>
                        </span>
                    </div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Learning Level:</div>
                    <div class="detail-value">
                        <span class="badge level-<%= module.getLevel().toLowerCase() %>">
                            <%= module.getLevel() %>
                        </span>
                    </div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Author:</div>
                    <div class="detail-value"><%= module.getAuthorName() != null ? module.getAuthorName() : "Not specified" %></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Estimated Duration:</div>
                    <div class="detail-value"><%= module.getEstimatedDuration() != null ? module.getEstimatedDuration() : "Not specified" %></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Views:</div>
                    <div class="detail-value"><%= module.getViews() %></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Last Updated:</div>
                    <div class="detail-value"><%= module.getLastUpdated() %></div>
                </div>
                
                <% if (module.getCoverImage() != null && !module.getCoverImage().isEmpty()) { %>
                <div class="detail-row">
                    <div class="detail-label">Cover Image:</div>
                    <div class="detail-value"><%= module.getCoverImage() %></div>
                </div>
                <% } %>
                
                <% if (module.getResourceFile() != null && !module.getResourceFile().isEmpty()) { %>
                <div class="detail-row">
                    <div class="detail-label">Resource File:</div>
                    <div class="detail-value"><%= module.getResourceFile() %></div>
                </div>
                <% } %>
            </div>
            
            <div class="button-group">
                <a href="edit-module?id=<%= module.getId() %>" class="btn btn-primary">Edit Module</a>
                <a href="delete-module?id=<%= module.getId() %>" class="btn btn-danger">Delete Module</a>
                <a href="dashboard" class="btn btn-secondary">Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>