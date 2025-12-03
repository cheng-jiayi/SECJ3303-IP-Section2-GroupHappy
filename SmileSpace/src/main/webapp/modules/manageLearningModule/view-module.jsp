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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Preahvihear&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Preahvihear', sans-serif; }
        body { background: #FBF6EA; color: #713C0B; }
        
        .container { max-width: 800px; margin: 40px auto; background: white; border-radius: 15px; box-shadow: 0 8px 25px rgba(107, 79, 54, 0.1); overflow: hidden; }
        .header { background: linear-gradient(135deg, #4ECDC4 0%, #6DECE4 100%); padding: 30px; text-align: center; }
        .header h1 { font-size: 28px; font-weight: 600; color: #713C0B; }
        
        .content { padding: 35px; }
        
        .back-link { 
            display: inline-flex; align-items: center; gap: 8px; margin-bottom: 25px; 
            color: #713C0B; text-decoration: none; font-weight: 500; font-size: 15px;
            padding: 8px 16px; border-radius: 20px; background: #F4DBAF; transition: all 0.3s;
        }
        .back-link:hover { background: #F0A548; text-decoration: none; color: white; }
        
        .module-details { 
            background: #FFFBF0; 
            padding: 30px; 
            border-radius: 12px; 
            border: 2px solid #F0A548; 
            margin-bottom: 25px;
        }
        
        .module-details h3 { 
            color: #713C0B; 
            margin-bottom: 25px; 
            font-size: 22px; 
            padding-bottom: 15px; 
            border-bottom: 2px solid #F0A548; 
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .detail-row { 
            display: flex; 
            margin-bottom: 18px; 
            padding-bottom: 18px; 
            border-bottom: 1px solid #F4DBAF; 
            align-items: flex-start;
        }
        .detail-label { 
            font-weight: 600; 
            width: 200px; 
            color: #713C0B; 
            font-size: 16px; 
            min-width: 200px;
        }
        .detail-value { 
            flex: 1; 
            color: #8B7355; 
            font-size: 16px; 
            line-height: 1.5;
        }
        .detail-value strong { color: #CF8224; }
        
        .module-title { 
            color: #CF8224; 
            font-size: 24px; 
            font-weight: 600;
            margin: 0;
            padding: 0;
        }
        
        /* Badge styles matching delete-module format */
        .badge { 
            display: inline-block; 
            padding: 6px 15px; 
            border-radius: 20px; 
            font-size: 14px; 
            font-weight: 600; 
            text-transform: capitalize;
        }
        .stress { background: linear-gradient(135deg, #FF6B6B, #FF8E8E); color: white; }
        .sleep { background: linear-gradient(135deg, #4ECDC4, #6DECE4); color: white; }
        .anxiety { background: linear-gradient(135deg, #FFD166, #FFE299); color: #713C0B; }
        .self-esteem { background: linear-gradient(135deg, #118AB2, #1BA4D6); color: white; }
        .mindfulness { background: linear-gradient(135deg, #06D6A0, #3AE8C0); color: white; }
        
        .level-beginner { background: #4ECDC4; color: white; }
        .level-intermediate { background: #FFD166; color: #713C0B; }
        .level-advance { background: #EF476F; color: white; }
        
        .button-group { 
            display: flex; 
            gap: 15px; 
            margin-top: 30px;
            justify-content: center;
        }
        .btn { 
            padding: 14px 30px; 
            border: none; 
            border-radius: 10px; 
            font-weight: 600; 
            font-size: 16px; 
            cursor: pointer; 
            text-decoration: none; 
            display: inline-block; 
            text-align: center; 
            transition: all 0.3s;
            min-width: 160px;
        }
        .btn-primary { 
            background: linear-gradient(135deg, #F0A548 0%, #CF8224 100%); 
            color: white; 
        }
        .btn-primary:hover { 
            transform: translateY(-3px); 
            box-shadow: 0 5px 15px rgba(240, 165, 72, 0.3); 
        }
        .btn-secondary { 
            background: #713C0B; 
            color: white; 
        }
        .btn-secondary:hover { 
            background: #5A2F09; 
            transform: translateY(-3px); 
        }
        .btn-danger { 
            background: linear-gradient(135deg, #FF6B6B 0%, #E74C3C 100%); 
            color: white; 
        }
        .btn-danger:hover { 
            transform: translateY(-3px); 
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3); 
        }
        
        .file-link {
            color: #F0A548;
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #FFF8E8;
            padding: 8px 15px;
            border-radius: 8px;
            border: 1px solid #F0A548;
            transition: all 0.3s;
        }
        .file-link:hover {
            background: #F0A548;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(240, 165, 72, 0.2);
        }
        
        /* Stats highlight */
        .stats-highlight {
            background: #E8F5F4;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            border-left: 4px solid #4ECDC4;
        }
        .stats-highlight h4 {
            color: #713C0B;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .stat-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px dashed #4ECDC4;
        }
        .stat-label { color: #713C0B; font-weight: 500; }
        .stat-value { color: #CF8224; font-weight: 600; }
        
        /* Empty state */
        .empty-state {
            color: #8B7355;
            font-style: italic;
            background: #F9F9F9;
            padding: 10px 15px;
            border-radius: 8px;
            border: 1px dashed #E0D6C5;
        }
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
                <h3>📋 Module Information</h3>
                
                <div class="detail-row">
                    <div class="detail-label">Module ID:</div>
                    <div class="detail-value"><strong><%= module.getId() %></strong></div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Title:</div>
                    <div class="detail-value">
                        <div class="module-title"><%= module.getTitle() %></div>
                    </div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Description:</div>
                    <div class="detail-value">
                        <%= module.getDescription() != null && !module.getDescription().isEmpty() ? 
                            module.getDescription() : 
                            "<span class='empty-state'>No description available</span>" %>
                    </div>
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
                    <div class="detail-value">
                        <%= module.getAuthorName() != null && !module.getAuthorName().isEmpty() ? 
                            module.getAuthorName() : 
                            "<span class='empty-state'>Not specified</span>" %>
                    </div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label">Estimated Duration:</div>
                    <div class="detail-value">
                        <%= module.getEstimatedDuration() != null && !module.getEstimatedDuration().isEmpty() ? 
                            module.getEstimatedDuration() : 
                            "<span class='empty-state'>Not specified</span>" %>
                    </div>
                </div>
                
                <div class="stats-highlight">
                    <h4>📊 Module Statistics</h4>
                    <div class="stat-item">
                        <span class="stat-label">Views:</span>
                        <span class="stat-value"><%= module.getViews() %></span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Last Updated:</span>
                        <span class="stat-value"><%= module.getLastUpdated() %></span>
                    </div>
                </div>
                
                <% if (module.getCoverImage() != null && !module.getCoverImage().isEmpty()) { %>
                <div class="detail-row">
                    <div class="detail-label">Cover Image:</div>
                    <div class="detail-value">
                        <a href="<%= module.getCoverImage() %>" class="file-link" target="_blank">
                            📷 View Image
                        </a>
                    </div>
                </div>
                <% } %>
                
                <% if (module.getResourceFile() != null && !module.getResourceFile().isEmpty()) { %>
                <div class="detail-row">
                    <div class="detail-label">Resource File:</div>
                    <div class="detail-value">
                        <a href="<%= module.getResourceFile() %>" class="file-link" target="_blank">
                            📎 Download Resource
                        </a>
                    </div>
                </div>
                <% } %>
            </div>
            
            <div class="button-group">
                <a href="dashboard" class="btn btn-secondary">← Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>