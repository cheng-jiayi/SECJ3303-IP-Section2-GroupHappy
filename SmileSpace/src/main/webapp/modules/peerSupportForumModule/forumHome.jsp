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
    
    // Initialize forum data
    if (application.getAttribute("forumPosts") == null) {
%>
    <jsp:include page="forumData.jsp" />
<%
    }
    
    List<Map<String, String>> posts = (List<Map<String, String>>) application.getAttribute("forumPosts");
    SimpleDateFormat displayFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
    SimpleDateFormat parseFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Peer Support Forum - SmileSpace</title>
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
            font-size: 32px;
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 30px 20px;
        }
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .page-header h2 {
            color: #2C7873;
            font-size: 28px;
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
        .forum-stats {
            background: #FFF3C8;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 30px;
            display: flex;
            gap: 30px;
        }
        .stat-item {
            text-align: center;
        }
        .stat-number {
            font-size: 24px;
            font-weight: bold;
            color: #2C7873;
        }
        .stat-label {
            font-size: 14px;
            color: #8B7355;
        }
        .posts-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .post-header {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr;
            background: #FFF3C8;
            padding: 15px 20px;
            font-weight: bold;
            color: #6B4F36;
            border-bottom: 2px solid #E8D4B9;
        }
        .post-row {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            align-items: center;
        }
        .post-row:hover {
            background: #FFF8E8;
        }
        .post-title {
            font-weight: bold;
            color: #6B4F36;
            text-decoration: none;
            font-size: 16px;
        }
        .post-title:hover {
            color: #2C7873;
            text-decoration: underline;
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
        .reply-count {
            color: #2C7873;
            font-weight: bold;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        .no-posts {
            padding: 40px;
            text-align: center;
            color: #8B7355;
        }
        .footer {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 2px solid #E8D4B9;
            color: #8B7355;
        }
        .forum-description {
            background: #E8F4F8;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border-left: 4px solid #2C7873;
        }
        .forum-description h3 {
            color: #2C7873;
            margin-bottom: 10px;
        }
        .forum-description p {
            color: #6B4F36;
            line-height: 1.5;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">
            <h1><i class="fas fa-users"></i> SmileSpace Peer Support Forum</h1>
        </div>
        <div class="nav-links">
            <a href="../userManagementModule/dashboards/<%= userRole %>Dashboard.jsp">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
            <a href="#"><i class="fas fa-user"></i> <%= userFullName %></a>
        </div>
    </div>

    <div class="container">
        <div class="page-header">
            <h2><i class="fas fa-comments"></i> Community Discussions</h2>
            <a href="createPost.jsp" class="btn btn-primary">
                <i class="fas fa-plus"></i> New Post
            </a>
        </div>

        <div class="forum-description">
            <h3><i class="fas fa-heart"></i> Welcome to Our Support Community</h3>
            <p>This is a safe space to share experiences, ask for advice, and offer support. 
               All discussions are confidential and respectful. Remember to be kind and empathetic to others.</p>
        </div>

        <div class="forum-stats">
            <div class="stat-item">
                <div class="stat-number"><%= posts.size() %></div>
                <div class="stat-label">Total Discussions</div>
            </div>
            <div class="stat-item">
                <%
                    int totalReplies = 0;
                    for (Map<String, String> post : posts) {
                        totalReplies += Integer.parseInt(post.get("replyCount"));
                    }
                %>
                <div class="stat-number"><%= totalReplies %></div>
                <div class="stat-label">Total Replies</div>
            </div>
            <div class="stat-item">
                <div class="stat-number"><%= userFullName.split(" ")[0] %></div>
                <div class="stat-label">Welcome!</div>
            </div>
        </div>

        <div class="posts-container">
            <div class="post-header">
                <div>Discussion Topic</div>
                <div>Posted By</div>
                <div>Date Posted</div>
                <div>Replies</div>
            </div>

            <% if (posts.isEmpty()) { %>
                <div class="no-posts">
                    <i class="fas fa-comments fa-2x" style="margin-bottom: 15px; color: #2C7873;"></i>
                    <h3>No discussions yet</h3>
                    <p>Be the first to start a conversation!</p>
                    <a href="createPost.jsp" class="btn btn-primary" style="margin-top: 15px;">
                        <i class="fas fa-plus"></i> Create First Post
                    </a>
                </div>
            <% } else { 
                for (Map<String, String> post : posts) { 
                    try {
                        Date postDate = parseFormat.parse(post.get("createdAt"));
            %>
                <div class="post-row">
                    <div>
                        <a href="viewPost.jsp?id=<%= post.get("id") %>" class="post-title">
                            <%= post.get("title") %>
                            <% if (Integer.parseInt(post.get("replyCount")) > 10) { %>
                                <span style="color: #D7923B; font-size: 12px; margin-left: 5px;">
                                    <i class="fas fa-fire"></i> Hot
                                </span>
                            <% } %>
                        </a>
                    </div>
                    <div class="author-info">
                        <% if ("true".equals(post.get("isAnonymous"))) { %>
                            <span class="anonymous">Anonymous</span>
                        <% } else { %>
                            <span><%= post.get("author") %></span>
                            <% if (!post.get("authorRole").isEmpty()) { %>
                                <span class="author-role"><%= post.get("authorRole") %></span>
                            <% } %>
                        <% } %>
                    </div>
                    <div><%= displayFormat.format(postDate) %></div>
                    <div>
                        <span class="reply-count"><i class="fas fa-comment"></i> <%= post.get("replyCount") %></span>
                    </div>
                </div>
            <% 
                    } catch (Exception e) {
                        // Handle date parsing error
                    }
                } 
               } %>
        </div>

        <div class="footer">
            <p><i class="fas fa-shield-alt"></i> SmileSpace Peer Support Forum - A safe space for sharing and support</p>
            <p style="font-size: 12px; margin-top: 10px;">
                <i class="fas fa-info-circle"></i> Remember to be respectful and kind in all discussions
            </p>
            <p style="font-size: 11px; margin-top: 5px; color: #888;">
                Need immediate help? Contact campus counseling services.
            </p>
        </div>
    </div>
</body>
</html>