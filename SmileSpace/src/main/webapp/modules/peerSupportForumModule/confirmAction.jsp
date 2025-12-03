<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Initialize global variables
    String message = "";
    String actionType = "";
    String redirectPage = "forumHome.jsp";

    List<Map<String, String>> posts = (List<Map<String, String>>) application.getAttribute("forumPosts");
    if (posts == null) {
        posts = new ArrayList<>();
        application.setAttribute("forumPosts", posts);
    }

    Map<String, List<Map<String, String>>> replies = 
        (Map<String, List<Map<String, String>>>) application.getAttribute("forumReplies");
    if (replies == null) {
        replies = new HashMap<>();
        application.setAttribute("forumReplies", replies);
    }

    String userFullName = (String) session.getAttribute("userFullName");
    String userRole = (String) session.getAttribute("userRole");

    // Current date-time
    String currentDateTime = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

    // Handle POST requests
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String action = request.getParameter("action");

        if ("create".equals(action)) {
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

                // Initialize replies for this post
                replies.put(newPost.get("id"), new ArrayList<>());
                application.setAttribute("forumReplies", replies);

                message = "✅ Your post has been created successfully!";
                actionType = "create";
                redirectPage = "viewPost.jsp?id=" + newPost.get("id");
            } else {
                message = "❌ Please fill in both title and content";
                actionType = "create";
            }

        } else if ("edit".equals(action)) {
            String id = request.getParameter("id");
            String title = request.getParameter("title");
            String content = request.getParameter("content");

            boolean found = false;
            for (Map<String, String> post : posts) {
                if (post.get("id").equals(id)) {
                    post.put("title", title);
                    post.put("content", content);
                    found = true;
                    break;
                }
            }

            if (found) {
                application.setAttribute("forumPosts", posts);
                message = "✅ Post updated successfully!";
                actionType = "edit";
                redirectPage = "viewPost.jsp?id=" + id;
            } else {
                message = "❌ Post not found!";
                actionType = "edit";
            }

        } else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            boolean removed = posts.removeIf(p -> p.get("id").equals(id));
            if (removed) {
                if (replies.containsKey(id)) {
                    replies.remove(id);
                }
                application.setAttribute("forumPosts", posts);
                application.setAttribute("forumReplies", replies);

                message = "✅ Post deleted successfully!";
                actionType = "delete";
                redirectPage = "forumHome.jsp";
            } else {
                message = "❌ Post not found!";
                actionType = "delete";
                redirectPage = "forumHome.jsp";
            }

        } else if ("reply".equals(action)) {
            String postId = request.getParameter("id");
            String replyContent = request.getParameter("replyContent");
            String anonymous = request.getParameter("anonymous");

            if (postId != null && replyContent != null && !replyContent.trim().isEmpty()) {
                Map<String, String> reply = new HashMap<>();
                reply.put("id", String.valueOf(replies.get(postId).size() + 1));
                reply.put("content", replyContent.trim());
                reply.put("author", userFullName);
                reply.put("authorRole", userRole);
                reply.put("isAnonymous", "true".equals(anonymous) ? "true" : "false");
                reply.put("createdAt", currentDateTime);

                replies.get(postId).add(reply);
                application.setAttribute("forumReplies", replies);

                // Increment reply count
                for (Map<String, String> post : posts) {
                    if (post.get("id").equals(postId)) {
                        int count = Integer.parseInt(post.get("replyCount"));
                        post.put("replyCount", String.valueOf(count + 1));
                        break;
                    }
                }
                application.setAttribute("forumPosts", posts);

                message = "✅ Reply posted successfully!";
                actionType = "reply";
                redirectPage = "viewPost.jsp?id=" + postId;
            } else {
                message = "❌ Reply cannot be empty!";
                actionType = "reply";
            }

        } else {
            message = "❌ Unknown action";
            actionType = "invalid";
            redirectPage = "forumHome.jsp";
        }

    } else { // Non-POST request
        message = "❌ Invalid request method";
        actionType = "invalid";
        redirectPage = "forumHome.jsp";
    }

    // Determine message CSS class
    String messageClass = message.startsWith("✅") ? "success" : "error";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Action Result - SmileSpace Forum</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { font-family: Arial, sans-serif; background: #FFF8E8; color: #6B4F36; text-align: center; padding: 50px; }
        .message.success { color: #2C7873; }
        .message.error { color: #E74C3C; }
        .btn { text-decoration: none; padding: 12px 25px; border-radius: 8px; font-weight: bold; margin: 10px; display: inline-block; }
        .btn-primary { background: #2C7873; color: white; }
        .btn-secondary { background: #8B7355; color: white; }
    </style>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const messageText = "<%= message %>";
            const redirectUrl = "<%= redirectPage %>";
            if (messageText.startsWith("✅")) {
                let seconds = 3;
                const countdown = document.getElementById("countdown");
                const interval = setInterval(() => {
                    seconds--;
                    if (countdown) countdown.textContent = seconds;
                    if (seconds <= 0) {
                        clearInterval(interval);
                        window.location.href = redirectUrl;
                    }
                }, 1000);
            }
        });
    </script>
</head>
<body>
    <div class="icon">
        <% if (message.startsWith("✅")) { %>
            <i class="fas fa-check-circle fa-3x"></i>
        <% } else { %>
            <i class="fas fa-exclamation-circle fa-3x"></i>
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
        <% } else { %>
            Action Result
        <% } %>
    </h1>

    <div class="message <%= messageClass %>"><%= message %></div>

    <div class="buttons">
        <a href="<%= redirectPage %>" class="btn btn-primary"><i class="fas fa-arrow-left"></i> Continue</a>
        <a href="forumHome.jsp" class="btn btn-secondary">Home</a>
    </div>

    <% if (message.startsWith("✅")) { %>
    <div class="auto-redirect">
        You will be automatically redirected in <span id="countdown">3</span> seconds...
    </div>
    <% } %>
</body>
</html>