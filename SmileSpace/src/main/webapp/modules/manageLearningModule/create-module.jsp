<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="smilespace.model.LearningModule" %>
<%
    LearningModule module = (LearningModule) request.getAttribute("module");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Delete Learning Module</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
            font-family: 'Fredoka', sans-serif; 
        }
        
        body { 
            background: #FBF6EA; 
            color: #713C0B; 
            min-height: 100vh;
        }
        
        /* Top Navigation */
        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 30px;
            background: #FBF6EA;
            border-bottom: 2px solid #F0D5B8;
        }
        
        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
            display: flex;
            align-items: center;
            gap: 8px;
            justify-content: flex-end;
            margin-left: auto; 
        }
        
        .logo i {
            color: #F0A548;
            font-size: 22px;
        }
        
        .container { 
            max-width: 800px; 
            margin: 20px auto;
            padding: 0 15px;
        }
        
        /* Page Title */
        .page-title {
            text-align: left;
            margin: 20px 0 30px 0;
        }
        
        .page-title h1 {
            font-size: 36px;
            font-weight: 700;
            color: #F0A548;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }
        
        .page-title p {
            font-size: 16px;
            color: #713C0B;
            opacity: 0.9;
        }
        
        /* Content */
        .content { 
            background: white; 
            border-radius: 20px; 
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            border: 2px solid #F0D5B8;
            margin-top: 10px;
        }
        
        /* Back Link */
        .back-link { 
            display: inline-flex; 
            align-items: center; 
            gap: 8px;
            margin-bottom: 25px; 
            color: #713C0B; 
            text-decoration: none; 
            font-weight: 500;
            padding: 8px 15px;
            border-radius: 8px;
            background: #F4DBAF;
            border: 2px solid #713C0B;
            transition: all 0.3s;
        }
        
        .back-link:hover { 
            background: #713C0B; 
            color: #FBF6EA;
            transform: translateX(-3px);
        }
        
        /* Warning Icon */
        .warning-icon {
            text-align: center;
            margin: 30px 0;
        }
        
        .warning-icon i {
            font-size: 80px;
            color: #FF4757;
            background: #FFE0E0;
            width: 120px;
            height: 120px;
            line-height: 120px;
            border-radius: 50%;
            display: inline-block;
            border: 4px solid #FF4757;
        }
        
        /* Warning Text */
        .warning-text {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .warning-text h2 {
            font-size: 28px;
            font-weight: 700;
            color: #FF4757;
            margin-bottom: 15px;
        }
        
        .warning-text p {
            font-size: 16px;
            color: #713C0B;
            line-height: 1.6;
        }
        
        /* Module Info Card */
        .module-card {
            background: #FFF9F0;
            padding: 25px;
            border-radius: 15px;
            border: 2px solid #F0D5B8;
            margin-bottom: 25px;
        }
        
        .module-card h3 {
            font-size: 20px;
            font-weight: 700;
            color: #713C0B;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #F0A548;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .module-card h3 i {
            color: #F0A548;
        }
        
        .info-row {
            display: flex;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px dashed #F0D5B8;
        }
        
        .info-row:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        
        .info-label {
            font-weight: 600;
            color: #713C0B;
            width: 160px;
            flex-shrink: 0;
        }
        
        .info-value {
            flex: 1;
            color: #713C0B;
        }
        
        .info-value strong {
            color: #F0A548;
        }
        
        /* Danger Alert */
        .danger-alert {
            background: #FFE0E0;
            padding: 20px;
            border-radius: 12px;
            border: 2px solid #FF4757;
            margin: 30px 0;
        }
        
        .danger-alert h4 {
            font-size: 18px;
            font-weight: 700;
            color: #FF4757;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .danger-alert p {
            color: #713C0B;
            line-height: 1.6;
            font-size: 15px;
        }
        
        /* Button Group */
        .button-group { 
            display: flex; 
            gap: 15px; 
            justify-content: center; 
            margin-top: 30px;
            padding-top: 25px;
            border-top: 2px solid #F0D5B8;
        }
        
        .btn { 
            padding: 14px 35px; 
            border: none; 
            border-radius: 12px; 
            font-weight: 600; 
            font-size: 16px; 
            cursor: pointer; 
            transition: all 0.3s; 
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        
        .btn-danger { 
            background: #FF4757; 
            color: white; 
        }
        
        .btn-danger:hover { 
            background: #E02C3D; 
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 71, 87, 0.25);
        }
        
        .btn-secondary { 
            background: #F0D5B8; 
            color: #713C0B; 
            border: 2px solid #713C0B;
        }
        
        .btn-secondary:hover { 
            background: #713C0B; 
            color: #FBF6EA;
            transform: translateY(-2px);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 0 10px;
            }
            
            .content {
                padding: 20px;
            }
            
            .info-row {
                flex-direction: column;
                gap: 5px;
            }
            
            .info-label {
                width: 100%;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <!-- Top Navigation -->
    <div class="top-nav">
        <div class="logo">
            <i class="fas fa-home"></i>
            SmileSpace
        </div>
    </div>
    
    <div class="container">
        <!-- Page Title -->
        <div class="page-title">
            <h1>Delete Learning Module</h1>
            <p>Permanently remove a learning module from the system</p>
        </div>
        
        <div class="content">
            <a href="dashboard" class="back-link">
                <i class="fas fa-arrow-left"></i>
                <span>Back to Dashboard</span>
            </a>
            
            <div class="warning-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            
            <div class="warning-text">
                <h2>Do you really want to delete this module?</h2>
                <p>Once deleted, it will be permanently removed from the system and cannot be recovered.</p>
            </div>
            
            <!-- Module Information Card -->
            <div class="module-card">
                <h3>
                    <i class="fas fa-info-circle"></i>
                    Module Information
                </h3>
                
                <div class="info-row">
                    <div class="info-label">Module ID:</div>
                    <div class="info-value"><strong><%= module.getId() %></strong></div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Title:</div>
                    <div class="info-value"><%= module.getTitle() %></div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Category:</div>
                    <div class="info-value">
                        <span class="badge <%= module.getCategory().toLowerCase().replace(" ", "-") %>" 
                              style="display: inline-block; padding: 4px 10px; border-radius: 12px; font-size: 13px; font-weight: 600; background: #F4DBAF; color: #713C0B;">
                            <%= module.getCategory() %>
                        </span>
                    </div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Learning Level:</div>
                    <div class="info-value">
                        <span class="badge level-<%= module.getLevel().toLowerCase() %>" 
                              style="display: inline-block; padding: 4px 10px; border-radius: 12px; font-size: 13px; font-weight: 600;">
                            <%= module.getLevel() %>
                        </span>
                    </div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Author:</div>
                    <div class="info-value"><%= module.getAuthorName() != null ? module.getAuthorName() : "N/A" %></div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Views:</div>
                    <div class="info-value"><%= module.getViews() %></div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Last Updated:</div>
                    <div class="info-value"><%= module.getLastUpdated() %></div>
                </div>
                
                <% if (module.getDescription() != null && !module.getDescription().isEmpty()) { %>
                <div class="info-row">
                    <div class="info-label">Description:</div>
                    <div class="info-value" style="font-style: italic; color: #C7A178;">
                        <%= module.getDescription().length() > 100 ? 
                            module.getDescription().substring(0, 100) + "..." : 
                            module.getDescription() %>
                    </div>
                </div>
                <% } %>
            </div>
            
            <!-- Danger Alert -->
            <div class="danger-alert">
                <h4>
                    <i class="fas fa-exclamation-circle"></i>
                    Warning: This action cannot be undone
                </h4>
                <p>
                    All associated data including cover images, resource files, and usage statistics will be permanently deleted. 
                    This module will be removed from all user dashboards and search results.
                </p>
            </div>
            
            <!-- Action Buttons -->
            <div class="button-group">
                <button type="button" class="btn btn-secondary" onclick="window.location.href='dashboard'">
                    <i class="fas fa-times"></i>
                    Cancel
                </button>
                
                <form action="delete-module" method="POST" style="display: inline;">
                    <input type="hidden" name="id" value="<%= module.getId() %>">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash"></i>
                        Confirm Delete
                    </button>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        // Add badge styles dynamically
        document.addEventListener('DOMContentLoaded', function() {
            // Define badge colors based on category
            const badgeStyles = `
                .badge.stress { background: #FFE0E0; color: #C73737; }
                .badge.sleep { background: #D7F7F7; color: #2A8989; }
                .badge.anxiety { background: #FFF4C8; color: #B88414; }
                .badge.self-esteem { background: #D1EBFF; color: #106C9E; }
                .badge.mindfulness { background: #CFFFE5; color: #17926E; }
                .badge.level-beginner { background: #CFFFE5; color: #136E52; }
                .badge.level-intermediate { background: #FFF0BE; color: #85620C; }
                .badge.level-advance { background: #FFD8E1; color: #A12B52; }
            `;
            
            // Create style element and add to head
            const style = document.createElement('style');
            style.textContent = badgeStyles;
            document.head.appendChild(style);
            
            // Confirmation dialog for delete
            document.querySelector('form[action="delete-module"]').addEventListener('submit', function(e) {
                if (!confirm('Are you absolutely sure you want to delete this module?\n\nThis action cannot be undone.')) {
                    e.preventDefault();
                    return false;
                }
                return true;
            });
        });
    </script>
</body>
</html>