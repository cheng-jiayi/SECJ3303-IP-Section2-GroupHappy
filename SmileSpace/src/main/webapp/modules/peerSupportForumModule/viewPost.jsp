<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%
    // Check if user is logged in
    String userRole = (String) session.getAttribute("userRole");
    String userFullName = (String) session.getAttribute("userFullName");
    
    if (userRole == null) {
        response.sendRedirect("../userManagementModule/loginPage.jsp");
        return;
    }
    
    String postId = request.getParameter("id");
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
    
    // Get post from simulated database
    List<Map<String, String>> posts = (List<Map<String, String>>) application.getAttribute("forumPosts");
    Map<String, String> post = null;
    
    if (posts != null) {
        for (Map<String, String> p : posts) {
            String postIdInList = p.get("id");
            // Try both string and numeric comparison
            if (postId.equals(postIdInList) || 
                postId.equals(String.valueOf(postIdInList)) ||
                String.valueOf(postId).equals(postIdInList)) {
                post = p;
                break;
            }
        }
    }
    
    if (post == null) {
        response.sendRedirect("forumHome.jsp");
        return;
    }
    
    // Get replies for this post
    Map<String, List<Map<String, String>>> allReplies = 
        (Map<String, List<Map<String, String>>>) application.getAttribute("forumReplies");
    List<Map<String, String>> replies = allReplies != null ? allReplies.get(postId) : new ArrayList<>();
    
    SimpleDateFormat displayFormat = new SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a");
    SimpleDateFormat parseFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= post.get("title") %> - SmileSpace Forum</title>
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
            max-width: 900px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .page-header h2 {
            color: #2C7873;
            font-size: 24px;
        }
        .btn {
            padding: 10px 20px;
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
        .btn-danger {
            background: #E74C3C;
            color: white;
        }
        .btn-danger:hover {
            background: #C0392B;
        }
        .post-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-left: 5px solid #2C7873;
        }
        .post-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #FFF3C8;
        }
        .post-title {
            font-size: 24px;
            color: #6B4F36;
            margin: 0 0 10px 0;
        }
        .post-meta {
            display: flex;
            align-items: center;
            gap: 15px;
            font-size: 14px;
            color: #8B7355;
            flex-wrap: wrap;
        }
        .author-info {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .author-role {
            font-size: 12px;
            color: #8B7355;
            background: #E8D4B9;
            padding: 2px 8px;
            border-radius: 10px;
        }
        .anonymous {
            color: #888;
            font-style: italic;
        }
        .post-content {
            line-height: 1.6;
            color: #6B4F36;
            font-size: 16px;
            margin-bottom: 25px;
            white-space: pre-line;
        }
        .post-actions {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }
        .replies-section {
            margin-top: 40px;
        }
        .replies-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .replies-header h3 {
            color: #2C7873;
            font-size: 20px;
        }
        .reply-count {
            color: #2C7873;
            font-weight: bold;
        }
        .reply-card {
            background: #FFF8E8;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            border-left: 4px solid #D7923B;
        }
        .reply-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .reply-author {
            font-weight: bold;
            color: #6B4F36;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .reply-date {
            font-size: 12px;
            color: #8B7355;
        }
        .reply-content {
            line-height: 1.5;
            color: #6B4F36;
            white-space: pre-line;
        }
        .no-replies {
            text-align: center;
            padding: 40px;
            color: #8B7355;
            background: #FFF8E8;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .new-reply-form {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-top: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 20px;
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
            min-height: 120px;
            resize: vertical;
        }
        textarea:focus {
            outline: none;
            border-color: #2C7873;
        }
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
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
        .character-count {
            text-align: right;
            font-size: 12px;
            color: #8B7355;
            margin-top: 5px;
        }
        .reply-stats {
            background: #E8F4F8;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            gap: 20px;
        }
        .stat {
            text-align: center;
        }
        .stat-number {
            font-size: 18px;
            font-weight: bold;
            color: #2C7873;
        }
        .stat-label {
            font-size: 12px;
            color: #8B7355;
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
            <h1><i class="fas fa-comments"></i> Peer Support Forum</h1>
        </div>
        <div class="nav-links">
            <a href="forumHome.jsp"><i class="fas fa-arrow-left"></i> Back to Forum</a>
            <a href="#"><i class="fas fa-user"></i> <%= userFullName %></a>
        </div>
    </div>

    <div class="container">
        <div class="page-header">
            <h2>Discussion Details</h2>
            <div style="display: flex; gap: 10px;">
                <a href="editPost.jsp?id=<%= postId %>" class="btn btn-primary">
                    <i class="fas fa-edit"></i> Edit Post
                </a>
                <a href="replyPost.jsp?postId=<%= postId %>" class="btn btn-primary">
                    <i class="fas fa-reply"></i> Reply
                </a>
                <form action="<%= request.getContextPath() %>/modules/peerSupportForumModule/confirmAction.jsp" method="POST" style="display:inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= post.get("id") %>">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                </form>
            </div>
        </div>

        <!-- Main Post -->
        <div class="post-card">
            <div class="post-header">
                <div style="flex: 1;">
                    <h3 class="post-title"><%= post.get("title") %></h3>
                    <div class="post-meta">
                        <div class="author-info">
                            <% if ("true".equals(post.get("isAnonymous"))) { %>
                                <span class="anonymous"><i class="fas fa-user-secret"></i> Anonymous</span>
                            <% } else { %>
                                <span><i class="fas fa-user"></i> <%= post.get("author") %></span>
                                <% if (!post.get("authorRole").isEmpty()) { %>
                                    <span class="author-role"><%= post.get("authorRole") %></span>
                                <% } %>
                            <% } %>
                        </div>
                        <%
                            Date postDate = new Date(); // Default to current time
                            try {
                                postDate = parseFormat.parse(post.get("createdAt"));
                            } catch (Exception e) {
                                System.out.println("ERROR parsing date for post " + postId + ": " + e.getMessage());
                                // Keep default current time
                            }
                        %>
                        <span><i class="far fa-clock"></i> <%= displayFormat.format(postDate) %></span>
                        <span><i class="fas fa-comment"></i> <%= post.get("replyCount") %> replies</span>
                    </div>
                </div>
            </div>
            
            <div class="post-content">
                <%= post.get("content") %>
            </div>
            
            <div class="post-actions">
                <a href="editPost.jsp?id=<%= postId %>" class="btn btn-primary">
                    <i class="fas fa-edit"></i> Edit Post
                </a>
                <a href="replyPost.jsp?postId=<%= postId %>" class="btn btn-primary">
                    <i class="fas fa-reply"></i> Reply to Post
                </a>
                <form action="<%= request.getContextPath() %>/modules/peerSupportForumModule/confirmAction.jsp" method="POST" style="display:inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= post.get("id") %>">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                </form>
            </div>
        </div>

        <!-- Replies Section -->
        <div class="replies-section">
            <div class="replies-header">
                <h3>Community Responses <span class="reply-count">(<%= replies.size() %>)</span></h3>
            </div>

            <% if (replies.isEmpty()) { %>
                <div class="no-replies">
                    <i class="far fa-comment-dots fa-2x" style="margin-bottom: 15px; color: #2C7873;"></i>
                    <h3>No replies yet</h3>
                    <p>Be the first to respond to this discussion!</p>
                    <a href="replyPost.jsp?postId=<%= postId %>" class="btn btn-primary" style="margin-top: 15px;">
                        <i class="fas fa-reply"></i> Be the First to Reply
                    </a>
                </div>
            <% } else { 
                // Show reply statistics
                int anonymousReplies = 0;
                for (Map<String, String> reply : replies) {
                    if ("true".equals(reply.get("isAnonymous"))) {
                        anonymousReplies++;
                    }
                }
            %>
                <div class="reply-stats">
                    <div class="stat">
                        <div class="stat-number"><%= replies.size() %></div>
                        <div class="stat-label">Total Replies</div>
                    </div>
                    <div class="stat">
                        <div class="stat-number"><%= anonymousReplies %></div>
                        <div class="stat-label">Anonymous</div>
                    </div>
                    <div class="stat">
                        <div class="stat-number"><%= replies.size() - anonymousReplies %></div>
                        <div class="stat-label">With Identity</div>
                    </div>
                </div>
                
                <% for (Map<String, String> reply : replies) { 
                    try {
                        Date replyDate = parseFormat.parse(reply.get("createdAt"));
                %>
                    <div class="reply-card">
                        <div class="reply-header">
                            <div class="reply-author">
                                <% if ("true".equals(reply.get("isAnonymous"))) { %>
                                    <i class="fas fa-user-secret"></i> <span class="anonymous">Anonymous</span>
                                <% } else { %>
                                    <i class="fas fa-user"></i> <%= reply.get("author") %>
                                    <% if (!reply.get("authorRole").isEmpty()) { %>
                                        <span class="author-role"><%= reply.get("authorRole") %></span>
                                    <% } %>
                                <% } %>
                            </div>
                            <div class="reply-date">
                                <i class="far fa-clock"></i> <%= displayFormat.format(replyDate) %>
                            </div>
                        </div>
                        <div class="reply-content">
                            <%= reply.get("content") %>
                        </div>
                    </div>
                <% 
                    } catch (Exception e) {
                        // Handle date parsing error
                    }
                } 
               } %>

            <!-- Reply Form -->
            <div class="new-reply-form">
                <h3 style="color: #2C7873; margin-bottom: 20px;">
                    <i class="fas fa-reply"></i> Add Your Reply
                </h3>
                <p style="color: #8B7355; margin-bottom: 15px; font-size: 14px;">
                    Or <a href="replyPost.jsp?postId=<%= postId %>" style="color: #2C7873; font-weight: bold;">
                        click here for a dedicated reply page
                    </a>
                </p>
                <form action="confirmAction.jsp?action=reply&id=<%= postId %>" method="post" onsubmit="return validateReply()">
                    <div class="form-group">
                        <textarea id="replyContent" name="replyContent" 
                                  placeholder="Share your thoughts, advice, or support. Be respectful and constructive."
                                  maxlength="2000" required
                                  oninput="updateCharacterCount('replyContent', 2000)"></textarea>
                        <div id="replyContentCount" class="character-count">2000 characters remaining</div>
                    </div>
                    
                    <div class="checkbox-group">
                        <input type="checkbox" id="anonymousReply" name="anonymous" value="true">
                        <label for="anonymousReply" style="margin-bottom: 0; font-weight: normal;">
                            Reply anonymously
                        </label>
                    </div>
                    <div style="font-size: 13px; color: #8B7355; margin-top: 5px;">
                        <i class="fas fa-info-circle"></i> Your name and role will be hidden
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane"></i> Post Reply
                        </button>
                    </div>
                </form>
            </div>
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
            
            return true;
        }
        
        // Initialize character count
        document.addEventListener('DOMContentLoaded', function() {
            updateCharacterCount('replyContent', 2000);
        });
    </script>
</body>
</html>