<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Check if user is logged in
    String userRole = (String) session.getAttribute("userRole");
    String userFullName = (String) session.getAttribute("userFullName");
    
    if (userRole == null) {
        response.sendRedirect("../userManagementModule/loginPage.jsp");
        return;
    }
    
    String postId = request.getParameter("postId");
    if (postId == null) {
        response.sendRedirect("forumHome.jsp");
        return;
    }
    
    // Initialize forum data if needed
    if (application.getAttribute("forumPosts") == null) {
%>
    <jsp:include page="forumData.jsp" />
<%
    }
    
    // Get post to show its title
    List<Map<String, String>> posts = (List<Map<String, String>>) application.getAttribute("forumPosts");
    Map<String, String> post = null;
    
    if (posts != null) {
        for (Map<String, String> p : posts) {
            if (postId.equals(p.get("id"))) {
                post = p;
                break;
            }
        }
    }
    
    if (post == null) {
        response.sendRedirect("forumHome.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reply to Post - SmileSpace Forum</title>
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
        .post-preview {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            border-left: 4px solid #2C7873;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        .post-title {
            font-size: 18px;
            font-weight: bold;
            color: #6B4F36;
            margin-bottom: 10px;
        }
        .post-meta {
            font-size: 14px;
            color: #8B7355;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .post-content {
            color: #6B4F36;
            line-height: 1.5;
            padding: 15px 0;
            border-top: 1px solid #eee;
            border-bottom: 1px solid #eee;
            margin: 15px 0;
            white-space: pre-line;
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
        textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #E8D4B9;
            border-radius: 8px;
            font-size: 16px;
            font-family: Arial, sans-serif;
            min-height: 150px;
            resize: vertical;
        }
        textarea:focus {
            outline: none;
            border-color: #2C7873;
        }
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
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
            border-left: 4px solid #D7923B;
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
        .reply-prompt {
            background: #E8F4F8;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            color: #2C7873;
            font-size: 14px;
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
            <h1>Reply to Discussion</h1>
        </div>
        <div class="nav-links">
            <a href="viewPost.jsp?id=<%= postId %>"><i class="fas fa-arrow-left"></i> Back to Post</a>
            <a href="#"><i class="fas fa-user"></i> <%= userFullName %></a>
        </div>
    </div>

    <div class="container">
        <div class="page-header">
            <h2><i class="fas fa-reply"></i> Add Your Response</h2>
        </div>

        <div class="reply-prompt">
            <i class="fas fa-lightbulb"></i> Your reply can make a difference. Share your thoughts, experiences, or support.
        </div>

        <!-- Post Preview -->
        <div class="post-preview">
            <div class="post-title"><%= post.get("title") %></div>
            <div class="post-meta">
                <span>
                    <i class="fas fa-user"></i> 
                    <% if ("true".equals(post.get("isAnonymous"))) { %>
                        Anonymous
                    <% } else { %>
                        <%= post.get("author") %>
                        <% if (!post.get("authorRole").isEmpty()) { %>
                            (<span style="color: #2C7873;"><%= post.get("authorRole") %></span>)
                        <% } %>
                    <% } %>
                </span>
                <span><i class="far fa-clock"></i> <%= post.get("createdAt") %></span>
                <span><i class="fas fa-comment"></i> <%= post.get("replyCount") %> replies</span>
            </div>
            <div class="post-content">
                <%= post.get("content") %>
            </div>
        </div>

        <!-- Reply Form -->
        <div class="form-card">
            <form action="confirmAction.jsp" method="post" onsubmit="return validateReply()">
                <input type="hidden" name="action" value="reply">
                <input type="hidden" name="id" value="<%= postId %>">
                <div class="form-group">
                    <label for="replyContent">Your Reply *</label>
                    <textarea id="replyContent" name="replyContent" 
                              placeholder="Share your thoughts, advice, or support. Be respectful and constructive. What would be helpful for the original poster to hear?"
                              maxlength="2000" required
                              oninput="updateCharacterCount('replyContent', 2000)"></textarea>
                    <div id="replyContentCount" class="character-count">2000 characters remaining</div>
                </div>

                <div class="checkbox-group">
                    <input type="checkbox" id="anonymous" name="anonymous" value="true">
                    <label for="anonymous" style="margin-bottom: 0; font-weight: normal;">
                        <i class="fas fa-user-secret"></i> Post reply anonymously
                    </label>
                </div>
                <div style="font-size: 13px; color: #8B7355; margin-top: 5px;">
                    <i class="fas fa-info-circle"></i> Your identity will be hidden from other users
                </div>

                <div class="form-actions">
                    <a href="viewPost.jsp?id=<%= postId %>" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i> Post Reply
                    </button>
                </div>
            </form>
        </div>

        <!-- Reply Guidelines -->
        <div class="guidelines">
            <h4><i class="fas fa-heart"></i> Tips for Helpful Replies</h4>
            <ul>
                <li><strong>Be empathetic:</strong> Acknowledge the poster's feelings</li>
                <li><strong>Share experiences:</strong> "I've been through something similar..."</li>
                <li><strong>Offer practical advice:</strong> Suggest actionable steps when appropriate</li>
                <li><strong>Validate feelings:</strong> "It's understandable to feel that way..."</li>
                <li><strong>Ask questions:</strong> "Have you tried...?" or "What helped you before?"</li>
                <li><strong>Encourage professional help:</strong> When needed, suggest campus resources</li>
                <li><strong>Avoid judgment:</strong> Focus on support, not criticism</li>
            </ul>
        </div>
    </div>

    <script>
        function validateReply() {
            const content = document.getElementById('replyContent').value.trim();
            
            if (content.length < 10) {
                alert('Please provide a meaningful reply (at least 10 characters)');
                return false;
            }
            
            if (content.length > 2000) {
                alert('Reply is too long (maximum 2000 characters)');
                return false;
            }
            
            // Check for common issues
            const allCaps = (content.match(/[A-Z]/g) || []).length;
            if (allCaps > content.length * 0.5) {
                if (!confirm('Your reply contains many capital letters. This can seem like shouting. Continue anyway?')) {
                    return false;
                }
            }
            
            return true;
        }
        
        // Initialize character count
        document.addEventListener('DOMContentLoaded', function() {
            updateCharacterCount('replyContent', 2000);
        });
    </script>
</body>
</html>