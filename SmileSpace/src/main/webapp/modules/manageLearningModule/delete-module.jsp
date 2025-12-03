<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="smilespace.model.LearningModule" %>  <!-- FIXED IMPORT -->
<%
    LearningModule module = (LearningModule) request.getAttribute("module");
%>
<!DOCTYPE html>
<html>
<head>
    <title>UC005 - Delete Module</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f8f9fa; color: #333; }
        
        .container { max-width: 800px; margin: 20px auto; background: white; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.08); overflow: hidden; }
        .header { background: linear-gradient(135deg, #ff6b6b 0%, #ff8e8e 100%); color: white; padding: 25px 30px; text-align: center; }
        .header h1 { font-size: 24px; font-weight: 600; }
        
        .content { padding: 40px; text-align: center; }
        
        .warning-icon { font-size: 64px; color: #ff6b6b; margin-bottom: 20px; }
        
        .module-info { background: #fff5f5; padding: 25px; border-radius: 8px; margin: 30px 0; text-align: left; border-left: 4px solid #ff6b6b; }
        .module-info h3 { margin-bottom: 15px; color: #c92a2a; }
        .module-detail { display: flex; margin-bottom: 10px; }
        .detail-label { font-weight: 600; width: 120px; color: #495057; }
        .detail-value { flex: 1; }
        
        .warning-text { background: #fff3cd; padding: 15px; border-radius: 6px; margin: 20px 0; border: 1px solid #ffeaa7; }
        .warning-text h4 { color: #856404; margin-bottom: 10px; }
        
        .button-group { display: flex; gap: 15px; justify-content: center; margin-top: 30px; }
        .btn { padding: 12px 30px; border: none; border-radius: 6px; font-weight: 600; font-size: 15px; cursor: pointer; transition: all 0.3s; }
        .btn-danger { background: linear-gradient(135deg, #ff6b6b 0%, #c92a2a 100%); color: white; }
        .btn-danger:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(201, 42, 42, 0.2); }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; }
        
        .back-link { display: inline-block; margin-bottom: 20px; color: #4dabf7; text-decoration: none; font-weight: 500; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>UC005 - Delete Module</h1>
        </div>
        
        <div class="content">
            <a href="dashboard" class="back-link">← Back to Dashboard</a>
            
            <div class="warning-icon">⚠️</div>
            <h2>Do you really want to delete this module?</h2>
            <p>Once deleted, it will be permanently removed from the system.</p>
            
            <div class="module-info">
                <h3>Module Information</h3>
                <div class="module-detail">
                    <div class="detail-label">ID:</div>
                    <div class="detail-value"><strong><%= module.getId() %></strong></div>
                </div>
                <div class="module-detail">
                    <div class="detail-label">Title:</div>
                    <div class="detail-value"><%= module.getTitle() %></div>
                </div>
                <div class="module-detail">
                    <div class="detail-label">Category:</div>
                    <div class="detail-value"><%= module.getCategory() %></div>
                </div>
                <div class="module-detail">
                    <div class="detail-label">Learning Level:</div>
                    <div class="detail-value"><%= module.getLevel() %></div>
                </div>
                <div class="module-detail">
                    <div class="detail-label">Views:</div>
                    <div class="detail-value"><%= module.getViews() %></div>
                </div>
                <div class="module-detail">
                    <div class="detail-label">Last Updated:</div>
                    <div class="detail-value"><%= module.getLastUpdated() %></div>
                </div>
            </div>
            
            <div class="warning-text">
                <h4>⚠️ Warning</h4>
                <p>This action cannot be undone. All associated data including cover images, resource files, and usage statistics will be permanently deleted.</p>
            </div>
            
            <div class="button-group">
                <form action="delete-module" method="POST" style="display: inline;">
                    <input type="hidden" name="id" value="<%= module.getId() %>">
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='dashboard'">Cancel</button>
                    <button type="submit" class="btn btn-danger">Confirm Delete</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>