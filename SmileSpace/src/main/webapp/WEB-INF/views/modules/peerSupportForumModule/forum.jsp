<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    // Check if user is logged in and is a student
    String userRole = (String) session.getAttribute("userRole");
    String userFullName = (String) session.getAttribute("userFullName");
    
    if (userRole == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Peer Support Forum - SmileSpace</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #D7923B;
            --primary-dark: #CF8224;
            --secondary-color: #6B4F36;
            --secondary-light: #8B7355;
            --background-light: #FFF8E8;
            --background-medium: #FFF3C8;
            --border-color: #E8D4B9;
            --success-color: #27AE60;
            --success-dark: #219653;
            --danger-color: #E74C3C;
            --danger-dark: #C0392B;
            --info-color: #3498DB;
            --info-dark: #2980B9;
            --gray-color: #8B7355;
            --gray-dark: #6B4F36;
            --white: #FFFFFF;
            --text-color: #6B4F36;
            --text-light: #8B7355;
            --shadow: 0 5px 15px rgba(0,0,0,0.1);
            --shadow-hover: 0 8px 20px rgba(107, 79, 54, 0.15);
            --radius-sm: 6px;
            --radius-md: 8px;
            --radius-lg: 10px;
            --radius-xl: 15px;
        }
        
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
        }
        
        body {
            background: var(--background-light);
            font-family: Arial, sans-serif;
            color: var(--text-color);
            min-height: 100vh;
        }
        
        /* Header - UNCHANGED */
        .header {
            background: var(--background-medium);
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(107, 79, 54, 0.1);
        }
        .logo h1 {
            color: var(--primary-color);
            font-size: 32px;
        }
        .user-menu {
            position: relative;
        }
        .user-btn {
            background: var(--primary-color);
            color: var(--white);
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: none;
            cursor: pointer;
            font-size: 20px;
        }
        .dropdown {
            position: absolute;
            top: 60px;
            right: 0;
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            min-width: 200px;
            display: none;
            z-index: 1000;
        }
        .dropdown.show { display: block; }
        .user-info {
            padding: 15px;
            background: var(--background-medium);
            border-bottom: 2px solid var(--border-color);
        }
        .user-name { font-weight: bold; }
        .user-role {
            background: var(--primary-color);
            color: var(--white);
            padding: 3px 10px;
            border-radius: 15px;
            font-size: 12px;
            display: inline-block;
            margin-top: 5px;
        }
        .menu-item {
            padding: 12px 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            color: var(--text-color);
            border-bottom: 1px solid #eee;
        }
        .menu-item:hover { background: var(--background-light); }
        .menu-item.logout { color: var(--danger-color); }
        
        /* Button Base Styles */
        .btn {
            padding: 8px 16px;
            border-radius: var(--radius-md);
            font-weight: bold;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            border: none;
            font-size: 14px;
            min-height: 40px;
            justify-content: center;
        }
        
        .btn-primary {
            background: var(--primary-color);
            color: var(--white);
        }
        
        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
        }
        
        .btn-success {
            background: var(--success-color);
            color: var(--white);
        }
        
        .btn-success:hover {
            background: var(--success-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
        }
        
        .btn-danger {
            background: var(--danger-color);
            color: var(--white);
        }
        
        .btn-danger:hover {
            background: var(--danger-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
        }
        
        .btn-info {
            background: var(--info-color);
            color: var(--white);
        }
        
        .btn-info:hover {
            background: var(--info-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
        }
        
        .btn-gray {
            background: var(--gray-color);
            color: var(--white);
        }
        
        .btn-gray:hover {
            background: var(--gray-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
        }
        
        /* Action Buttons */
        .btn-action {
            padding: 6px 12px;
            border-radius: var(--radius-sm);
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 5px;
            cursor: pointer;
            border: 1px solid;
            background: var(--white);
            transition: all 0.3s ease;
            font-weight: 500;
        }
        
        .btn-edit {
            color: var(--info-color);
            border-color: var(--info-color);
        }
        
        .btn-edit:hover {
            background: var(--info-color);
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
        }
        
        .btn-delete {
            color: var(--danger-color);
            border-color: var(--danger-color);
        }
        
        .btn-delete:hover {
            background: var(--danger-color);
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
        }
        
        /* Container */
        .container {
            padding: 40px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        /* Welcome Section */
        .welcome {
            margin-bottom: 40px;
            text-align: center;
        }
        
        .welcome h2 {
            color: var(--primary-color);
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .welcome p {
            color: var(--text-light);
            font-size: 16px;
        }
        
        /* Forum Layout */
        .forum-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }
        
        /* Cards */
        .create-post-card,
        .posts-container,
        .sidebar-card {
            background: var(--background-medium);
            border-radius: var(--radius-xl);
            padding: 25px;
            box-shadow: var(--shadow);
            border: 2px solid var(--border-color);
        }
        
        .create-post-card {
            margin-bottom: 30px;
        }
        
        /* Headers */
        .create-post-card h3,
        .posts-header h2,
        .sidebar-card h3,
        .modal-header h3,
        .replies-header,
        .empty-state h3 {
            color: var(--primary-color);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .create-post-card h3 {
            font-size: 20px;
            margin-bottom: 20px;
        }
        
        .posts-header {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--border-color);
        }
        
        .posts-header h2 {
            font-size: 24px;
        }
        
        /* Forms */
        .post-form textarea,
        .reply-form textarea,
        .modal-body textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid var(--border-color);
            border-radius: var(--radius-lg);
            font-family: Arial, sans-serif;
            font-size: 16px;
            resize: vertical;
            font-family: inherit;
            background: var(--white);
        }
        
        .post-form textarea:focus,
        .reply-form textarea:focus,
        .modal-body textarea:focus {
            outline: none;
            border-color: var(--primary-color);
        }
        
        .post-form textarea {
            min-height: 120px;
            margin-bottom: 15px;
        }
        
        .reply-form textarea {
            min-height: 80px;
            margin-bottom: 10px;
        }
        
        .modal-body textarea {
            min-height: 150px;
            margin-bottom: 20px;
            background: var(--background-light);
        }
        
        /* Form Options */
        .form-options,
        .reply-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        /* Checkbox */
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }
        
        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: var(--primary-color);
            cursor: pointer;
        }
        
        /* Post Item */
        .post-item {
            background: var(--background-light);
            border-radius: var(--radius-xl);
            padding: 25px;
            margin-bottom: 25px;
            border: 2px solid var(--border-color);
            transition: all 0.3s ease;
        }
        
        .post-item:hover {
            box-shadow: var(--shadow-hover);
        }
        
        .post-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid var(--border-color);
        }
        
        .post-author {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .author-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: var(--primary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            font-weight: bold;
            font-size: 20px;
        }
        
        .author-details {
            display: flex;
            flex-direction: column;
        }
        
        .author-name {
            font-weight: bold;
            color: var(--text-color);
            font-size: 16px;
        }
        
        .post-time,
        .reply-time {
            font-size: 14px;
            color: var(--text-light);
        }
        
        /* Post Content */
        .post-content {
            font-size: 16px;
            line-height: 1.6;
            color: var(--text-color);
            margin-bottom: 25px;
            padding: 20px;
            background: var(--white);
            border-radius: var(--radius-lg);
            border-left: 4px solid var(--primary-color);
            white-space: pre-wrap;
        }
        
        /* Reply Form */
        .reply-form {
            background: var(--background-medium);
            padding: 20px;
            border-radius: var(--radius-lg);
            margin-top: 20px;
            margin-bottom: 25px;
        }
        
        /* Replies Section */
        .replies-section {
            margin-top: 25px;
            padding-top: 20px;
            border-top: 2px solid var(--border-color);
        }
        
        .replies-header {
            font-size: 18px;
            margin-bottom: 15px;
        }
        
        .reply-item {
            background: var(--white);
            border-radius: var(--radius-lg);
            padding: 20px;
            margin-bottom: 15px;
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }
        
        .reply-item:hover {
            border-color: var(--primary-color);
            background: #FFFEF5;
        }
        
        .reply-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .reply-author {
            font-weight: bold;
            color: var(--text-color);
            font-size: 15px;
        }
        
        .reply-content {
            font-size: 15px;
            line-height: 1.5;
            color: var(--text-color);
            white-space: pre-wrap;
            padding: 10px;
            background: var(--background-light);
            border-radius: var(--radius-md);
        }
        
        /* Sidebar */
        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .sidebar-card h3 {
            font-size: 18px;
            margin-bottom: 20px;
        }
        
        .community-guidelines {
            list-style: none;
        }
        
        .community-guidelines li {
            padding: 10px 0;
            border-bottom: 1px solid var(--border-color);
            color: var(--text-color);
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        
        .community-guidelines li:last-child {
            border-bottom: none;
        }
        
        .community-guidelines i {
            color: var(--success-color);
            margin-top: 3px;
        }
        
        .user-stats {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        
        .stat-item-sidebar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 15px;
            background: var(--background-light);
            border-radius: var(--radius-md);
            transition: all 0.3s ease;
        }
        
        .stat-item-sidebar:hover {
            background: var(--border-color);
        }
        
        .stat-label-sidebar {
            color: var(--text-color);
            font-weight: 500;
        }
        
        .stat-value-sidebar {
            font-weight: bold;
            color: var(--primary-color);
        }
        
        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 2000;
            align-items: center;
            justify-content: center;
        }
        
        .modal-content {
            background: var(--white);
            border-radius: var(--radius-xl);
            padding: 30px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            border: 2px solid var(--primary-color);
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .close-btn {
            background: none;
            border: none;
            font-size: 24px;
            color: var(--danger-color);
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .close-btn:hover {
            transform: scale(1.1);
        }
        
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
        }
        
        /* Report Styles */
        .report-input {
            flex: 1;
            padding: 8px 12px;
            border-radius: var(--radius-sm);
            border: 1px solid var(--border-color);
            font-size: 14px;
            font-family: inherit;
        }
        
        .report-input:focus {
            outline: none;
            border-color: var(--primary-color);
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--text-light);
        }
        
        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            color: var(--border-color);
        }
        
        .empty-state h3 {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            font-size: 16px;
            line-height: 1.6;
            max-width: 500px;
            margin: 0 auto 30px;
        }
        
        /* Responsive */
        @media (max-width: 992px) {
            .forum-container {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }
            
            .post-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .post-actions {
                width: 100%;
                justify-content: flex-end;
            }
            
            .form-options,
            .reply-options {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
        }
        
        @media (max-width: 480px) {
            .header {
                padding: 15px 20px;
            }
            
            .logo h1 {
                font-size: 24px;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="logo">
            <h1>SmileSpace</h1>
        </div>
        <div class="user-menu">
            <button class="user-btn" id="userBtn">
                <i class="fas fa-user"></i>
            </button>
            <div class="dropdown" id="dropdown">
                <div class="user-info">
                    <div class="user-name"><%= userFullName %></div>
                </div>
                <a href="${pageContext.request.contextPath}/dashboard" class="menu-item">
                    <i class="fas fa-home"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/reports/my" class="menu-item">
                    <i class="fas fa-flag"></i> My Reports
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="menu-item">
                    <i class="fas fa-user-edit"></i> Manage Profile
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="menu-item logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container">
        <div class="welcome">
            <h2>Peer Support Forum</h2>
            <p>Share your thoughts, ask questions, and support each other</p>
        </div>

        <div class="forum-container">
            <!-- Main Content -->
            <div class="main-content">
                <!-- Create Post -->
                <div class="create-post-card">
                    <h3><i class="fas fa-edit"></i> Create New Post</h3>
                    <form action="${pageContext.request.contextPath}/forum/post" method="post" class="post-form">
                        <textarea name="content" placeholder="What's on your mind? Share your thoughts, ask for advice, or offer support to others..." required></textarea>
                        <div class="form-options">
                            <div class="checkbox-group">
                                <input type="checkbox" id="anonymousPost" name="anonymous">
                                <label for="anonymousPost">Post Anonymously</label>
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-paper-plane"></i> Publish Post
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Posts Container -->
                <div class="posts-container">
                    <div class="posts-header">
                        <h2><i class="fas fa-comments"></i> Community Posts</h2>
                    </div>

                    <c:choose>
                        <c:when test="${empty posts}">
                            <div class="empty-state">
                                <i class="fas fa-comments"></i>
                                <h3>No posts yet</h3>
                                <p>Be the first to start a conversation! Share your thoughts, ask questions, or offer support to others in the community.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="post" items="${posts}">
                                <div class="post-item" id="post-${post.postId}">
                                    <!-- Post Header -->
                                    <div class="post-header">
                                        <div class="post-author">
                                            <div class="author-avatar">
                                                <c:choose>
                                                    <c:when test="${post.anonymous}">
                                                        <i class="fas fa-user-secret"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${fn:toUpperCase(fn:substring(post.user.fullName, 0, 1))}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="author-details">
                                                <div class="author-name">
                                                    <c:choose>
                                                        <c:when test="${post.anonymous}">Anonymous</c:when>
                                                        <c:otherwise>${fn:escapeXml(post.user.fullName)}</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="post-time">
                                                    <i class="far fa-clock"></i> ${post.createdAt}
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <c:if test="${user != null && user.userId == post.user.userId}">
                                            <div class="post-actions">
                                                <button class="btn-action btn-edit edit-post-btn" 
                                                        data-type="post" 
                                                        data-id="${post.postId}" 
                                                        data-content="${fn:escapeXml(post.content)}">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                                <form action="${pageContext.request.contextPath}/forum/post/delete" method="post" style="display:inline;">
                                                    <input type="hidden" name="postId" value="${post.postId}">
                                                    <button type="submit" class="btn-action btn-delete" onclick="return confirm('Are you sure you want to delete this post?')">
                                                        <i class="fas fa-trash"></i> Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <!-- Post Content -->
                                    <div class="post-content">
                                        ${fn:escapeXml(post.content)}
                                    </div>

                                    <!-- REPORT POST FORM (COMPATIBLE WITH NEW SQL) -->
                                    <c:if test="${user != null && user.userId != post.user.userId}">
                                        <form action="${pageContext.request.contextPath}/reports/submit" method="post" style="margin-top: 10px; display:flex; gap: 5px;">
                                            <input type="hidden" name="type" value="post">
                                            <input type="hidden" name="targetId" value="${post.postId}">
                                            <input type="text" name="reason" placeholder="Reason for reporting..." class="report-input" required>
                                            <button type="submit" class="btn btn-danger">
                                                <i class="fas fa-flag"></i> Report
                                            </button>
                                        </form>
                                    </c:if>

                                    <!-- Reply Form -->
                                    <div class="reply-form">
                                        <form action="${pageContext.request.contextPath}/forum/reply" method="post">
                                            <input type="hidden" name="postId" value="${post.postId}">
                                            <textarea name="content" placeholder="Write a supportive reply..." required></textarea>
                                            <div class="reply-options">
                                                <div class="checkbox-group">
                                                    <input type="checkbox" id="anonymousReply-${post.postId}" name="anonymous">
                                                    <label for="anonymousReply-${post.postId}">Reply Anonymously</label>
                                                </div>
                                                <button type="submit" class="btn btn-success">
                                                    <i class="fas fa-reply"></i> Post Reply
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                    
                                    <!-- REPLIES SECTION -->
                                    <c:if test="${not empty post.replies}">
                                        <div class="replies-section">
                                            <div class="replies-header">
                                                <i class="fas fa-reply"></i> Replies (${fn:length(post.replies)})
                                            </div>
                                            <c:forEach var="reply" items="${post.replies}">
                                                <div class="reply-item">
                                                    <div class="reply-header">
                                                        <div class="reply-author">
                                                            <c:choose>
                                                                <c:when test="${reply.anonymous}">
                                                                    <i class="fas fa-user-secret"></i> Anonymous
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="fas fa-user"></i> ${fn:escapeXml(reply.user.fullName)}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="reply-time">
                                                            <i class="far fa-clock"></i> ${reply.createdAt}
                                                        </div>
                                                    </div>
                                                    <div class="reply-content">
                                                        ${fn:escapeXml(reply.content)}
                                                    </div>

                                                    <!-- REPORT REPLY FORM -->
                                                    <c:if test="${user != null && user.userId != reply.user.userId}">
                                                        <form action="${pageContext.request.contextPath}/reports/submit" method="post" style="margin-top: 5px; display:flex; gap: 5px;">
                                                            <input type="hidden" name="type" value="reply">
                                                            <input type="hidden" name="targetId" value="${reply.replyId}">
                                                            <input type="text" name="reason" placeholder="Reason for reporting..." class="report-input" required>
                                                            <button type="submit" class="btn btn-danger">
                                                                <i class="fas fa-flag"></i> Report
                                                            </button>
                                                        </form>
                                                    </c:if>

                                                    <c:if test="${user != null && user.userId == reply.user.userId}">
                                                        <div style="margin-top: 10px; display: flex; gap: 8px; justify-content: flex-end;">
                                                            <button class="btn-action btn-edit edit-reply-btn" 
                                                                    data-type="reply" 
                                                                    data-id="${reply.replyId}" 
                                                                    data-content="${fn:escapeXml(reply.content)}"
                                                                    style="font-size: 12px; padding: 4px 8px;">
                                                                <i class="fas fa-edit"></i> Edit
                                                            </button>
                                                            <form action="${pageContext.request.contextPath}/forum/reply/delete" method="post" style="display:inline;">
                                                                <input type="hidden" name="replyId" value="${reply.replyId}">
                                                                <button type="submit" class="btn-action btn-delete" 
                                                                        onclick="return confirm('Are you sure you want to delete this reply?')"
                                                                        style="font-size: 12px; padding: 4px 8px;">
                                                                    <i class="fas fa-trash"></i> Delete
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="sidebar">
                <!-- Community Guidelines -->
                <div class="sidebar-card">
                    <h3><i class="fas fa-handshake"></i> Community Guidelines</h3>
                    <ul class="community-guidelines">
                        <li><i class="fas fa-check"></i> Be kind and respectful</li>
                        <li><i class="fas fa-check"></i> Maintain confidentiality</li>
                        <li><i class="fas fa-check"></i> Offer constructive support</li>
                        <li><i class="fas fa-check"></i> Share your experiences</li>
                        <li><i class="fas fa-check"></i> Report concerns to moderators</li>
                    </ul>
                </div>

                <!-- Your Activity -->
                <div class="sidebar-card">
                    <h3><i class="fas fa-chart-bar"></i> Your Activity</h3>
                    <div class="user-stats">
                        <c:set var="userPostCount" value="0" />
                        <c:forEach var="post" items="${posts}">
                            <c:if test="${user != null && user.userId == post.user.userId}">
                                <c:set var="userPostCount" value="${userPostCount + 1}" />
                            </c:if>
                        </c:forEach>

                        <c:set var="userReplyCount" value="0" />
                        <c:forEach var="post" items="${posts}">
                            <c:forEach var="reply" items="${post.replies}">
                                <c:if test="${user != null && user.userId == reply.user.userId}">
                                    <c:set var="userReplyCount" value="${userReplyCount + 1}" />
                                </c:if>
                            </c:forEach>
                        </c:forEach>

                        <div class="stat-item-sidebar">
                            <span class="stat-label-sidebar">Your Posts</span>
                            <span class="stat-value-sidebar">${userPostCount}</span>
                        </div>
                        <div class="stat-item-sidebar">
                            <span class="stat-label-sidebar">Your Replies</span>
                            <span class="stat-value-sidebar">${userReplyCount}</span>
                        </div>
                        <div class="stat-item-sidebar">
                            <span class="stat-label-sidebar">Support Given</span>
                            <span class="stat-value-sidebar">${userPostCount + userReplyCount}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Content</h3>
                <button class="close-btn" onclick="closeEditModal()">&times;</button>
            </div>
            <form id="editForm" method="post">
                <input type="hidden" id="editId" name="editId">
                <div class="modal-body">
                    <textarea id="editContent" name="content" required></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-gray" onclick="closeEditModal()">Cancel</button>
                    <button type="submit" class="btn btn-success">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // User dropdown
        const userBtn = document.getElementById('userBtn');
        const dropdown = document.getElementById('dropdown');

        userBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            dropdown.classList.toggle('show');
        });

        document.addEventListener('click', function() {
            dropdown.classList.remove('show');
        });

        dropdown.addEventListener('click', function(e) {
            e.stopPropagation();
        });

        // Edit modal functionality
        document.addEventListener('DOMContentLoaded', function() {
            document.addEventListener('click', function(e) {
                const editBtn = e.target.closest('.btn-edit');
                if (!editBtn) return;

                e.preventDefault();

                const type = editBtn.dataset.type;
                const id = editBtn.dataset.id;
                const content = editBtn.dataset.content;
                openEditModal(type, id, content);
            });

            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    const textarea = this.querySelector('textarea[name="content"]');
                    if (textarea && textarea.value.trim().length === 0) {
                        e.preventDefault();
                        alert('Please enter some content before posting.');
                        textarea.focus();
                    }
                });
            });

            const textareas = document.querySelectorAll('textarea');
            textareas.forEach(textarea => {
                textarea.addEventListener('input', function() {
                    this.style.height = 'auto';
                    this.style.height = (this.scrollHeight) + 'px';
                });
            });
        });

        function openEditModal(type, id, content) {
            const modal = document.getElementById('editModal');
            const form = document.getElementById('editForm');
            const contentTextarea = document.getElementById('editContent');
            const editIdInput = document.getElementById('editId');

            modal.style.display = 'flex';
            contentTextarea.value = content;

            if (type === 'post') {
                form.action = '${pageContext.request.contextPath}/forum/post/edit';
                editIdInput.name = 'postId';
            } else {
                form.action = '${pageContext.request.contextPath}/forum/reply/edit';
                editIdInput.name = 'replyId';
            }
            editIdInput.value = id;

            setTimeout(() => {
                contentTextarea.focus();
                contentTextarea.select();
            }, 100);
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeEditModal();
            }
        });

        window.addEventListener('click', function(event) {
            const modal = document.getElementById('editModal');
            if (event.target === modal) {
                closeEditModal();
            }
        });
    </script>
</body>
</html>