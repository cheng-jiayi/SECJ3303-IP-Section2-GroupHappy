<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="smilespace.model.LearningModule" %>
<%
    LearningModule module = (LearningModule) request.getAttribute("module");
    String action = (String) request.getAttribute("action");
    
    if (module == null) {
        response.sendRedirect("admin-module-dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Save as Draft - SmileSpace</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .confirmation-container {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border: 3px solid #F0D5B8;
            max-width: 500px;
            width: 100%;
            text-align: center;
        }
        
        .confirmation-icon {
            font-size: 60px;
            color: #F0A548;
            margin-bottom: 20px;
        }
        
        h2 {
            color: #713C0B;
            margin-bottom: 15px;
            font-size: 24px;
        }
        
        p {
            color: #8B7355;
            margin-bottom: 25px;
            line-height: 1.6;
        }
        
        .module-info {
            background: #FFF9F0;
            padding: 15px;
            border-radius: 10px;
            margin: 20px 0;
            text-align: left;
            border: 2px solid #F0D5B8;
        }
        
        .module-title {
            font-weight: 600;
            color: #713C0B;
            margin-bottom: 5px;
        }
        
        .module-id {
            color: #C7A178;
            font-size: 14px;
        }
        
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 25px;
            justify-content: center;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        
        .btn-primary {
            background: #F0A548;
            color: white;
        }
        
        .btn-primary:hover {
            background: #D18A2C;
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: #F0D5B8;
            color: #713C0B;
            border: 2px solid #713C0B;
        }
        
        .btn-secondary:hover {
            background: #713C0B;
            color: #FBF6EA;
        }
        
        .btn-draft {
            background: #FFF4C8;
            color: #B88414;
            border: 2px solid #B88414;
        }
        
        .btn-draft:hover {
            background: #B88414;
            color: white;
        }
        
        form {
            display: inline;
        }
        
        .top-right {
            position: absolute;
            right: 40px;
            top: 20px;
            font-size: 20px;
            font-weight: bold;
        }
        
        .home-link {
            text-decoration: none;
            color: inherit;
        }
        
        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
            display: flex;
            align-items: center;
            gap: 8px;
        }
    </style>
</head>
<body>
    <div class="top-right">
        <a href="<%= request.getContextPath() %>/admin-module-dashboard" class="home-link">
            <div class="logo">
                <i class="fas fa-home"></i>
                SmileSpace
            </div>
        </a>
    </div>
    
    <div class="confirmation-container">
        <div class="confirmation-icon">
            <i class="fas fa-save"></i>
        </div>
        
        <h2>Save as Draft?</h2>
        
        <p>You have unsaved changes for module:</p>
        
        <div class="module-info">
            <div class="module-title"><%= module.getTitle() %></div>
            <div class="module-id">ID: <%= module.getId() %></div>
            <div class="module-id">Current Status: <span style="font-weight: 600; color: #F0A548;"><%= module.getStatus() %></span></div>
        </div>
        
        <p>Would you like to save your changes as draft or discard them?</p>
        
        <div class="button-group">
            <form action="handle-draft-action" method="POST">
                <input type="hidden" name="id" value="<%= module.getId() %>">
                <input type="hidden" name="action" value="<%= action %>">
                <input type="hidden" name="saveAsDraft" value="true">
                <button type="submit" class="btn btn-draft">
                    <i class="fas fa-save"></i>
                    Save as Draft
                </button>
            </form>
            
            <form action="handle-draft-action" method="POST">
                <input type="hidden" name="id" value="<%= module.getId() %>">
                <input type="hidden" name="action" value="<%= action %>">
                <button type="submit" class="btn btn-secondary">
                    <i class="fas fa-times"></i>
                    Discard Changes
                </button>
            </form>
            
            <a href="admin-module-dashboard" class="btn btn-primary">
                <i class="fas fa-arrow-left"></i>
                Back to Dashboard
            </a>
        </div>
    </div>
    
    <script>
        setTimeout(function() {
            if (confirm('You have been inactive for 30 seconds. Would you like to save as draft?')) {
                document.querySelector('form [name="saveAsDraft"]').value = "true";
                document.querySelector('form').submit();
            } else {
                window.location.href = 'admin-module-dashboard';
            }
        }, 30000);
    </script>
</body>
</html>