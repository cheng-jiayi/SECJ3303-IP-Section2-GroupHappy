<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in
    String userRole = (String) session.getAttribute("userRole");
    String userFullName = (String) session.getAttribute("userFullName");
    
    if (userRole == null) {
        response.sendRedirect("../userManagementModule/loginPage.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create New Post - SmileSpace Forum</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: #FFF8E8;
            font-family: Arial, sans-serif;
            color: #6B4F36;
        }
        .header {
            background: #FFF3C8;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(107, 79, 54, 0.1);
        }
        .logo h1 {
            color: #2C7873;
            font-size: 28px;
        }
        .nav-links a {
            color: #6B4F36;
            text-decoration: none;
            margin-left: 20px;
            font-weight: bold;
        }
        .nav-links a:hover {
            color: #2C7873;
        }
        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .page-header {
            margin-bottom: 30px;
        }
        .page-header h2 {
            color: #2C7873;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .form-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 25px;
        }
        label {
            display: block;
            font-weight: bold;
            margin-bottom: 8px;
            color: #6B4F36;
        }
        input, textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #E8D4B9;
            border-radius: 8px;
            font-size: 16px;
            font-family: Arial, sans-serif;
        }
        input:focus, textarea:focus {
            outline: none;
            border-color: #2C7873;
        }
        textarea {
            min-height: 200px;
            resize: vertical;
        }
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .checkbox-group input {
            width: auto;
        }
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #E8D4B9;
        }
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        .btn-primary {
            background: #2C7873;
            color: white;
        }
        .btn-primary:hover {
            background: #245E5A;
        }
        .btn-secondary {
            background: #8B7355;
            color: white;
        }
        .btn-secondary:hover {
            background: #6B4F36;
        }
        .guidelines {
            background: #FFF3C8;
            padding: 20px;
            border-radius: 10px;
            margin-top: 30px;
            border-left: 4px solid #2C7873;
        }
        .guidelines h4 {
            color: #6B4F36;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .guidelines ul {
            padding-left: 20px;
            color: #8B7355;
        }
        .guidelines li {
            margin-bottom: 5px;
        }
        .character-count {
            text-align: right;
            font-size: 12px;
            color: #8B7355;
            margin-top: 5px;
        }
    </style>
    <script>
        function updateCharacterCount(textareaId, maxLength) {
            const textarea = document.getElementById(textareaId);
            const count = document.getElementById(textareaId + 'Count');
            const remaining = maxLength - textarea.value.length;
            count.textContent = remaining + ' characters remaining';
            count.style.color = remaining < 50 ? '#E74C3C' : '#8B7355';
        }
    </script>
</head>
<body>
    <div class="header">
        <div class="logo">
            <h1>Create New Discussion</h1>
        </div>
        <div class="nav-links">
            <a href="forumHome.jsp"><i class="fas fa-arrow-left"></i> Back to Forum</a>
            <a href="#"><i class="fas fa-user"></i> <%= userFullName %></a>
        </div>
    </div>

    <div class="container">
        <div class="page-header">
            <h2><i class="fas fa-edit"></i> Start a New Discussion</h2>
        </div>

        <div class="form-card">
            <form action="confirmAction.jsp" method="post">
            <input type="hidden" name="action" value="create">
                <div class="form-group">
                    <label for="title">Post Title *</label>
                    <input type="text" id="title" name="title" 
                           placeholder="Enter a descriptive title for your post (e.g., 'Struggling with exam stress')" 
                           maxlength="200" required
                           oninput="updateCharacterCount('title', 200)">
                    <div id="titleCount" class="character-count">200 characters remaining</div>
                </div>

                <div class="form-group">
                    <label for="content">Post Content *</label>
                    <textarea id="content" name="content" 
                              placeholder="Share your thoughts, questions, or experiences. Be as detailed as you feel comfortable."
                              maxlength="5000" required
                              oninput="updateCharacterCount('content', 5000)"></textarea>
                    <div id="contentCount" class="character-count">5000 characters remaining</div>
                </div>

                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" id="anonymous" name="anonymous" value="true">
                        <label for="anonymous" style="margin-bottom: 0; font-weight: normal;">
                            Post anonymously
                        </label>
                    </div>
                    <div style="font-size: 13px; color: #8B7355; margin-top: 5px;">
                        <i class="fas fa-user-secret"></i> Your identity will be hidden from other users
                    </div>
                </div>

                <div class="form-actions">
                    <a href="forumHome.jsp" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i> Create Post
                    </button>
                </div>
            </form>
        </div>

        <div class="guidelines">
            <h4><i class="fas fa-lightbulb"></i> Community Guidelines</h4>
            <ul>
                <li><strong>Be respectful:</strong> Treat others with kindness and empathy</li>
                <li><strong>Stay supportive:</strong> Offer constructive advice and encouragement</li>
                <li><strong>Respect privacy:</strong> Don't share personal information about others</li>
                <li><strong>No harassment:</strong> Bullying or hate speech will not be tolerated</li>
                <li><strong>Seek help:</strong> For urgent concerns, contact professional services</li>
                <li><strong>Report issues:</strong> Use the report feature for inappropriate content</li>
            </ul>
        </div>
    </div>

    <script>
        function validateForm() {
            const title = document.getElementById('title').value.trim();
            const content = document.getElementById('content').value.trim();
            
            if (title.length < 10) {
                alert('Title should be at least 10 characters long');
                return false;
            }
            
            if (content.length < 20) {
                alert('Please provide more details in your post (at least 20 characters)');
                return false;
            }
            
            return true;
        }
        
        // Initialize character counts
        document.addEventListener('DOMContentLoaded', function() {
            updateCharacterCount('title', 200);
            updateCharacterCount('content', 5000);
        });
    </script>
</body>
</html>