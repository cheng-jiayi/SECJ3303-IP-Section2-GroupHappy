<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%
    // Check if user is logged in
    String userRole = (String) session.getAttribute("userRole");
    String userFullName = (String) session.getAttribute("userFullName");
    
    if (userRole == null) {
        response.sendRedirect("../../userManagementModule/loginPage.jsp");
        return;
    }
    
    String action = request.getParameter("action");
    String postId = request.getParameter("id");
    
    if (action == null) {
        response.sendRedirect("forumHome.jsp");
        return;
    }
    
    // Initialize forum data if needed
    if (application.getAttribute("forumPosts") == null) {
%>
    <jsp:include page="forumData.jsp" />
<%
    }
    
    // Process actions
    List<Map<String, String>> posts = (List<Map<String, String>>) application.getAttribute("forumPosts");
    Map<String, List<Map<String, String>>> replies = 
        (Map<String, List<Map<String, String>>>) application.getAttribute("forumReplies");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String currentDateTime = dateFormat.format(new java.util.Date());
    String message = "";
    String redirectPage = "forumHome.jsp";
    String actionType = "";
    
    if ("POST".equals(request.getMethod()) || "delete".equals(action) || "deleteReply".equals(action)) {
        if ("create".equals(action)) {
            // Create new post
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String anonymous = request.getParameter("anonymous");
            
            if (title != null && content != null && !title.trim().isEmpty() && !content.trim().isEmpty()) {
                Map<String, String> newPost = new HashMap<>();
                newPost.put("id", String.valueOf(posts.size() + 1));
                newPost.put("title", title.trim());
                newPost.put("content", content.trim());
                newPost.put("author", userFullName);
                newPost.put("authorRole", userRole);
                newPost.put("isAnonymous", "true".equals(anonymous) ? "true" : "false");
                newPost.put("createdAt", currentDateTime);
                newPost.put("replyCount", "0");
                
                posts.add(newPost);
                application.setAttribute("forumPosts", posts);
                message = "✅ Your post has been created successfully!";
                actionType = "create";
            } else {
                message = "❌ Please fill in both title and content";
            }
            
        } else if ("edit".equals(action) && postId != null) {
            // Edit existing post
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String anonymous = request.getParameter("anonymous");
            
            if (title != null && content != null && !title.trim().isEmpty() && !content.trim().isEmpty()) {
                boolean updated = false;
                for (Map<String, String> post : posts) {
                    if (post.get("id").equals(postId) && post.get("author").equals(userFullName)) {
                        post.put("title", title.trim());
                        post.put("content", content.trim());
                        post.put("isAnonymous", "true".equals(anonymous) ? "true" : "false");
                        post.put("updatedAt", currentDateTime);
                        updated = true;
                        message = "✅ Post updated successfully!";
                        actionType = "edit";
                        break;
                    }
                }
                if (updated) {
                    application.setAttribute("forumPosts", posts);
                } else {
                    message = "❌ You can only edit your own posts";
                }
            } else {
                message = "❌ Please fill in both title and content";
            }
            
        } else if ("delete".equals(action) && postId != null) {
            // Delete post
            boolean deleted = false;
            Iterator<Map<String, String>> iterator = posts.iterator();
            while (iterator.hasNext()) {
                Map<String, String> post = iterator.next();
                if (post.get("id").equals(postId) && post.get("author").equals(userFullName)) {
                    iterator.remove();
                    // Also delete associated replies
                    if (replies != null) {
                        replies.remove(postId);
                    }
                    deleted = true;
                    message = "✅ Post deleted successfully!";
                    actionType = "delete";
                    break;
                }
            }
            if (deleted) {
                application.setAttribute("forumPosts", posts);
                if (replies != null) {
                    application.setAttribute("forumReplies", replies);
                }
            } else {
                message = "❌ You can only delete your own posts";
            }
            
        } else if ("reply".equals(action) && postId != null) {
            // Add reply to post - FIXED PARAMETER NAME
            String replyContent = request.getParameter("replyContent");
            if (replyContent == null) {
                replyContent = request.getParameter("content");
            }
            String anonymous = request.getParameter("anonymous");
            
            if (replyContent != null && !replyContent.trim().isEmpty()) {
                // Initialize replies map if null
                if (replies == null) {
                    replies = new HashMap<>();
                    application.setAttribute("forumReplies", replies);
                }
                
                // Initialize replies list for this post if doesn't exist
                if (!replies.containsKey(postId)) {
                    replies.put(postId, new ArrayList<>());
                }
                
                List<Map<String, String>> postReplies = replies.get(postId);
                Map<String, String> newReply = new HashMap<>();
                newReply.put("id", String.valueOf(postReplies.size() + 1));
                newReply.put("content", replyContent.trim());
                newReply.put("author", userFullName);
                newReply.put("authorRole", userRole);
                newReply.put("isAnonymous", "true".equals(anonymous) ? "true" : "false");
                newReply.put("createdAt", currentDateTime);
                
                postReplies.add(newReply);
                
                // Update reply count in original post
                for (Map<String, String> post : posts) {
                    if (post.get("id").equals(postId)) {
                        int replyCount = Integer.parseInt(post.getOrDefault("replyCount", "0"));
                        post.put("replyCount", String.valueOf(replyCount + 1));
                        break;
                    }
                }
                
                // Save both posts and replies
                application.setAttribute("forumPosts", posts);
                application.setAttribute("forumReplies", replies);
                
                message = "✅ Your reply has been posted!";
                actionType = "reply";
                redirectPage = "viewPost.jsp?id=" + postId;
            } else {
                message = "❌ Please enter reply content";
            }
            
        } else if ("deleteReply".equals(action)) {
            String replyId = request.getParameter("replyId");
            
            if (postId != null && replyId != null && replies != null && replies.containsKey(postId)) {
                List<Map<String, String>> postReplies = replies.get(postId);
                Iterator<Map<String, String>> iterator = postReplies.iterator();
                boolean deleted = false;
                
                while (iterator.hasNext()) {
                    Map<String, String> reply = iterator.next();
                    if (reply.get("id").equals(replyId) && reply.get("author").equals(userFullName)) {
                        iterator.remove();
                        deleted = true;
                        
                        // Update reply count in original post
                        for (Map<String, String> post : posts) {
                            if (post.get("id").equals(postId)) {
                                int replyCount = Integer.parseInt(post.getOrDefault("replyCount", "0"));
                                post.put("replyCount", String.valueOf(Math.max(0, replyCount - 1)));
                                break;
                            }
                        }
                        
                        message = "✅ Reply deleted successfully!";
                        actionType = "deleteReply";
                        redirectPage = "viewPost.jsp?id=" + postId;
                        break;
                    }
                }
                
                if (deleted) {
                    application.setAttribute("forumPosts", posts);
                    application.setAttribute("forumReplies", replies);
                } else {
                    message = "❌ You can only delete your own replies";
                }
            }
        }
    } else {
        // Not a POST request
        message = "❌ Invalid request method";
    }
    
    // Determine message class for CSS
    String messageClass = "error";
    if (message.startsWith("✅")) {
        messageClass = "success";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Confirm Action - SmileSpace Forum</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: #FFF8E8;
            font-family: Arial, sans-serif;
            color: #6B4F36;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        .icon {
            font-size: 64px;
            color: #6C5CE7;
            margin-bottom: 20px;
        }
        h1 {
            color: #6C5CE7;
            margin-bottom: 10px;
        }
        .message {
            padding: 15px;
            border-radius: 10px;
            margin: 20px 0;
            border-left: 5px solid;
        }
        .message.success {
            background: #E8F5E9;
            border-color: #4CAF50;
            color: #2E7D32;
        }
        .message.error {
            background: #FFEBEE;
            border-color: #F44336;
            color: #C62828;
        }
        .buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: transform 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        .btn-primary {
            background: #6C5CE7;
            color: white;
        }
        .btn-secondary {
            background: #F3E8FF;
            color: #6C5CE7;
        }
        .btn:hover {
            transform: translateY(-2px);
        }
        .auto-redirect {
            margin-top: 20px;
            color: #888;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="icon">
            <% if (message.startsWith("✅")) { %>
                <i class="fas fa-check-circle"></i>
            <% } else if (message.startsWith("❌")) { %>
                <i class="fas fa-exclamation-circle"></i>
            <% } else { %>
                <i class="fas fa-info-circle"></i>
            <% } %>
        </div>
        
        <h1>
            <% if ("create".equals(actionType)) { %>
                <%= message.startsWith("✅") ? "Post Created" : "Create Failed" %>
            <% } else if ("edit".equals(actionType)) { %>
                <%= message.startsWith("✅") ? "Post Updated" : "Update Failed" %>
            <% } else if ("delete".equals(actionType)) { %>
                <%= message.startsWith("✅") ? "Post Deleted" : "Delete Failed" %>
            <% } else if ("reply".equals(actionType)) { %>
                <%= message.startsWith("✅") ? "Reply Posted" : "Reply Failed" %>
            <% } else if ("deleteReply".equals(actionType)) { %>
                <%= message.startsWith("✅") ? "Reply Deleted" : "Delete Failed" %>
            <% } else { %>
                Action Result
            <% } %>
        </h1>
        
        <div class="message <%= messageClass %>">
            <%= message %>
        </div>
        
        <div class="buttons">
            <a href="<%= redirectPage %>" class="btn btn-primary">
                <i class="fas fa-arrow-left"></i> Continue
            </a>
            <a href="forumHome.jsp" class="btn btn-secondary">
                <i class="fas fa-home"></i> Forum Home
            </a>
        </div>
        
        <div class="auto-redirect">
            <% if (message.startsWith("✅")) { %>
                You will be automatically redirected in <span id="countdown">3</span> seconds...
            <% } %>
        </div>
    </div>
    
    <script>
        // Check if we should auto-redirect (for success messages)
        const messageText = "<%= message %>";
        const redirectUrl = "<%= redirectPage %>";
    
        if (messageText.startsWith("✅")) {
            let seconds = 3;
            const countdownElement = document.getElementById('countdown');
            const countdownInterval = setInterval(() => {
                seconds--;
                if (countdownElement) countdownElement.textContent = seconds;
                if (seconds <= 0) {
                    clearInterval(countdownInterval);
                    window.location.href = redirectUrl;
                }
            }, 1000);
        }
    </script>
</body>
</html>