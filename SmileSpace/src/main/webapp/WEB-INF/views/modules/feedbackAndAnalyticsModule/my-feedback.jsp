<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    Integer unseenCount = (Integer) request.getAttribute("unseenCount");
    Boolean hasFeedback = (Boolean) request.getAttribute("hasFeedback");
    if (unseenCount == null) unseenCount = 0;
    if (hasFeedback == null) hasFeedback = false;
    
    String searchTerm = request.getParameter("search");
    String statusFilter = request.getParameter("status");
    if (searchTerm == null) searchTerm = "";
    if (statusFilter == null) statusFilter = "all";
    
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    Integer resolvedCount = (Integer) request.getAttribute("resolvedCount");
    Integer pendingCount = (Integer) request.getAttribute("pendingCount");
    if (totalCount == null) totalCount = 0;
    if (resolvedCount == null) resolvedCount = 0;
    if (pendingCount == null) pendingCount = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Feedback - SmileSpace</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
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

        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 22px 40px;
            background: #FBF6EA;
            border-bottom: 2px solid #F0D5B8;
        }

        .logo {
            font-size: 28px;
            font-weight: 700;
            color: #F0A548;
            text-decoration: none;
        }

        .logo:hover {
            color: #D7923B;
        }

        .nav-container {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .nav-links {
            display: flex;
            gap: 10px;
        }
        
        .nav-link {
            color: #713C0B;
            text-decoration: none;
            font-weight: 600;
            padding: 10px 20px;
            border-radius: 10px;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-link:hover {
            background: #F0D5B8;
        }

        .nav-link.active {
            background: #D7923B;
            color: white;
        }
       
        .notification-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background: #E74C3C;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 12px;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: pulse 2s infinite;
        }
       
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }

        .user-menu {
            position: relative;
        }
       
        .user-btn {
            background: #D7923B;
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: none;
            cursor: pointer;
            font-size: 20px;
            transition: all 0.3s ease;
        }
       
        .user-btn:hover {
            background: #C77D2F;
            transform: scale(1.05);
        }
       
        .dropdown {
            position: absolute;
            top: 60px;
            right: 0;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            min-width: 220px;
            display: none;
            z-index: 1000;
        }
       
        .dropdown.show {
            display: block;
        }
       
        .user-info {
            padding: 15px;
            background: #FFF3C8;
            border-bottom: 2px solid #E8D4B9;
        }
       
        .user-name {
            font-weight: bold;
            font-size: 16px;
        }
       
        .user-role {
            background: #D7923B;
            color: white;
            padding: 4px 12px;
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
            color: #6B4F36;
            border-bottom: 1px solid #eee;
            transition: background 0.2s;
        }
       
        .menu-item:hover {
            background: #FFF8E8;
        }
       
        .menu-item.logout {
            color: #E74C3C;
        }

        .page-header {
            text-align: center;
            margin: 35px 0 30px;
            padding: 0 20px;
        }

        .page-header h1 {
            color: #F0A548;
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .page-header p {
            font-size: 18px;
            color: #A06A2F;
            max-width: 600px;
            margin: 0 auto;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 20px 40px;
        }

        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 25px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            border: 2px solid #F0D5B8;
            text-align: center;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            border-color: #D7923B;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #713C0B;
            margin: 10px 0;
        }

        .stat-label {
            font-size: 14px;
            color: #A06A2F;
        }

        .stat-icon {
            font-size: 24px;
            color: #D7923B;
            margin-bottom: 10px;
        }

        .filter-section {
            background: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 30px;
            border: 2px solid #F0D5B8;
        }

        .filter-title {
            color: #713C0B;
            margin-bottom: 20px;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-form {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr auto auto;
            gap: 15px;
            align-items: end;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
        }

        .filter-group label {
            font-weight: 600;
            margin-bottom: 8px;
            color: #713C0B;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .filter-input, .filter-select {
            padding: 12px 15px;
            border-radius: 10px;
            border: 2px solid #E2D5C1;
            background: #FBF6EA;
            font-size: 14px;
            color: #713C0B;
            transition: all 0.3s ease;
            width: 100%;
        }

        .filter-input:focus, .filter-select:focus {
            outline: none;
            border-color: #D7923B;
            background: #FFFFFF;
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.1);
        }

        .filter-btn {
            padding: 12px 25px;
            background: #D7923B;
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            white-space: nowrap;
        }

        .filter-btn:hover {
            background: #C77D2F;
            transform: translateY(-2px);
        }

        .clear-btn {
            padding: 12px 25px;
            background: #6B4F36;
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            white-space: nowrap;
        }

        .clear-btn:hover {
            background: #5A2F08;
            transform: translateY(-2px);
        }

        .results-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding: 15px 20px;
            background: #FFF9F0;
            border-radius: 10px;
            border: 1px solid #F0D5B8;
        }

        .results-count {
            font-size: 16px;
            color: #713C0B;
            font-weight: 600;
        }

        .active-filters {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .filter-tag {
            background: #FFEBC8;
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 13px;
            font-weight: 600;
            color: #713C0B;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .remove-filter {
            background: none;
            border: none;
            color: #E74C3C;
            cursor: pointer;
            font-size: 14px;
            padding: 0;
        }

        .alert {
            max-width: 800px;
            margin: 0 auto 20px;
            padding: 15px 20px;
            border-radius: 10px;
            font-weight: 600;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 20px;
            border: 2px dashed #F0D5B8;
            margin: 20px 0;
        }

        .empty-state i {
            font-size: 64px;
            color: #E2D5C1;
            margin-bottom: 20px;
        }

        .empty-state h3 {
            color: #713C0B;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #A06A2F;
            margin-bottom: 25px;
        }

        .btn-primary {
            background: #D7923B;
            color: white;
            padding: 12px 30px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: #C77D2F;
            transform: translateY(-2px);
        }

        .feedback-list {
            display: flex;
            flex-direction: column;
            gap: 25px;
            margin-top: 30px;
        }

        .feedback-card {
            background: white;
            border-radius: 18px;
            border: 2px solid #F0D5B8;
            padding: 25px;
            transition: all 0.3s ease;
        }

        .feedback-card:hover {
            border-color: #D7923B;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }

        .feedback-card.has-unseen {
            border-left: 6px solid #E74C3C;
            background: #FFF9F0;
        }

        .feedback-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .feedback-title {
            flex: 1;
            min-width: 300px;
        }

        .feedback-title h3 {
            color: #713C0B;
            font-size: 20px;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .feedback-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: center;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
            color: #A06A2F;
            font-size: 14px;
        }

        .category-badge {
            background: #FFEBC8;
            padding: 6px 14px;
            border-radius: 15px;
            font-weight: 600;
            font-size: 13px;
        }

        .status-badge {
            padding: 6px 14px;
            border-radius: 15px;
            font-weight: 600;
            font-size: 13px;
        }

        .status-resolved {
            background: #BDF5C6;
            color: #27AE60;
        }

        .status-pending {
            background: #FFCE8A;
            color: #D35400;
        }

        .unseen-badge {
            background: #E74C3C;
            color: white;
            padding: 6px 14px;
            border-radius: 15px;
            font-weight: 600;
            font-size: 13px;
            animation: pulse 2s infinite;
        }

        .feedback-content {
            margin: 20px 0;
            padding: 20px;
            background: #FBF6EA;
            border-radius: 12px;
            border-left: 4px solid #D7923B;
        }

        .feedback-message {
            line-height: 1.6;
            color: #5D4037;
            white-space: pre-wrap;
        }

        .admin-reply-section {
            margin-top: 25px;
            padding: 20px;
            background: #F0F9FF;
            border-radius: 12px;
            border-left: 4px solid #3498DB;
        }

        .admin-reply-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .admin-reply-header h4 {
            color: #2980B9;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .admin-reply-date {
            color: #7F8C8D;
            font-size: 13px;
        }

        .admin-reply-message {
            line-height: 1.6;
            color: #34495E;
        }

        .user-reply-section {
            margin-top: 20px;
            padding: 20px;
            background: #F0FFE8;
            border-radius: 12px;
            border-left: 4px solid #2ECC71;
        }

        .user-reply-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .user-reply-header h4 {
            color: #27AE60;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .user-reply-date {
            color: #7F8C8D;
            font-size: 13px;
        }

        .user-reply-message {
            line-height: 1.6;
            color: #27AE60;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 25px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            font-size: 14px;
        }

        .btn-reply {
            background: #BDF5C6;
            color: #27AE60;
        }

        .btn-reply:hover {
            background: #A0EFB4;
            transform: translateY(-2px);
        }

        .btn-mark-read {
            background: #E3F2FD;
            color: #2980B9;
        }

        .btn-mark-read:hover {
            background: #BBDEFB;
            transform: translateY(-2px);
        }

        .no-results {
            text-align: center;
            padding: 40px 20px;
            background: white;
            border-radius: 15px;
            border: 2px solid #F0D5B8;
            margin: 20px 0;
        }

        .no-results i {
            font-size: 48px;
            color: #E2D5C1;
            margin-bottom: 20px;
        }

        .no-results h3 {
            color: #713C0B;
            margin-bottom: 10px;
        }

        .no-results p {
            color: #A06A2F;
            margin-bottom: 20px;
        }

        .no-unseen {
            text-align: center;
            padding: 30px;
            color: #A06A2F;
            font-style: italic;
        }

        @media (max-width: 992px) {
            .filter-form {
                grid-template-columns: 1fr 1fr;
            }
            
            .stats-section {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .top-nav {
                padding: 15px 20px;
                flex-direction: column;
                gap: 15px;
            }
           
            .nav-container {
                order: 3;
                width: 100%;
                justify-content: center;
                margin-top: 10px;
            }
           
            .nav-links {
                flex-direction: column;
                width: 100%;
                align-items: center;
            }
           
            .nav-link {
                width: 100%;
                text-align: center;
                justify-content: center;
            }
           
            .filter-form {
                grid-template-columns: 1fr;
            }
           
            .feedback-header {
                flex-direction: column;
            }
           
            .feedback-meta {
                justify-content: flex-start;
                width: 100%;
            }
           
            .action-buttons {
                flex-direction: column;
            }
           
            .btn {
                width: 100%;
                justify-content: center;
            }
           
            .stats-section {
                grid-template-columns: 1fr;
            }
           
            .results-info {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <div class="top-nav">
        <a href="${pageContext.request.contextPath}/dashboard" class="logo">SmileSpace</a>
        
        <div class="nav-container">
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/feedback" class="nav-link">
                    <i class="fas fa-comment"></i> Give Feedback
                </a>
                
                <a href="${pageContext.request.contextPath}/feedback/my-feedback" class="nav-link active">
                    <i class="fas fa-history"></i> My Feedback
                    <c:if test="${unseenCount > 0}">
                        <span class="notification-badge">${unseenCount}</span>
                    </c:if>
                </a>
            </div>
            
            <div class="user-menu">
                <button class="user-btn" id="userBtn">
                    <i class="fas fa-user"></i>
                </button>
                <div class="dropdown" id="dropdown">
                    <div class="user-info">
                        <div class="user-name">${sessionScope.userFullName}</div>
                        <div class="user-role">${sessionScope.userRole}</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/dashboard" class="menu-item">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/profile" class="menu-item">
                        <i class="fas fa-user-edit"></i> My Profile
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="menu-item logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>
       
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
    </div>

    <div class="page-header">
        <h1>
            <i class="fas fa-comments"></i>
            My Feedback History
            <c:if test="${unseenCount > 0}">
                <span class="notification-badge" style="position: static; margin-left: 10px;">${unseenCount} new</span>
            </c:if>
        </h1>
        <p>View and manage your submitted feedback</p>
    </div>

    <div class="container">
        <div class="stats-section">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-comment-dots"></i>
                </div>
                <div class="stat-value">${totalCount}</div>
                <div class="stat-label">Total Feedback</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-check-circle" style="color:#27AE60;"></i>
                </div>
                <div class="stat-value">${resolvedCount}</div>
                <div class="stat-label">Resolved</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-clock" style="color:#F39C12;"></i>
                </div>
                <div class="stat-value">${pendingCount}</div>
                <div class="stat-label">Pending</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-bell" style="color:#E74C3C;"></i>
                </div>
                <div class="stat-value">${unseenCount}</div>
                <div class="stat-label">Unseen Replies</div>
            </div>
        </div>

        <div class="filter-section">
            <h3 class="filter-title">
                <i class="fas fa-filter"></i> Filter Your Feedback
            </h3>
            
            <form method="get" action="${pageContext.request.contextPath}/feedback/my-feedback" class="filter-form" id="filterForm">
                <div class="filter-group">
                    <label for="searchInput"><i class="fas fa-search"></i> Search</label>
                    <input type="text" 
                           name="search" 
                           id="searchInput" 
                           class="filter-input" 
                           placeholder="Search in your feedback..."
                           value="<%= searchTerm %>">
                </div>
                
                <div class="filter-group">
                    <label for="statusSelect"><i class="fas fa-check-circle"></i> Status</label>
                    <select name="status" id="statusSelect" class="filter-select">
                        <option value="all" <%= "all".equals(statusFilter) ? "selected" : "" %>>All Status</option>
                        <option value="resolved" <%= "resolved".equals(statusFilter) ? "selected" : "" %>>Resolved</option>
                        <option value="pending" <%= "pending".equals(statusFilter) ? "selected" : "" %>>Pending</option>
                    </select>
                </div>
                
                <button type="submit" class="filter-btn">
                    <i class="fas fa-filter"></i> Apply Filters
                </button>
                
                <c:if test="${not empty searchTerm or not statusFilter.equals('all')}">
                    <a href="${pageContext.request.contextPath}/feedback/my-feedback" class="clear-btn">
                        <i class="fas fa-redo"></i> Clear All
                    </a>
                </c:if>
            </form>
        </div>

        <c:if test="${not empty searchTerm or not statusFilter.equals('all')}">
            <div class="results-info">
                <div class="results-count">
                    <c:choose>
                        <c:when test="${empty feedbackList}">
                            No feedback found
                        </c:when>
                        <c:otherwise>
                            Showing ${feedbackList.size()} feedback <c:if test="${feedbackList.size() == 1}">item</c:if><c:if test="${feedbackList.size() != 1}">items</c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div class="active-filters">
                    <c:if test="${not empty searchTerm}">
                        <span class="filter-tag">
                            Search: "<%= searchTerm %>"
                            <button type="button" class="remove-filter" onclick="removeSearchFilter()">
                                <i class="fas fa-times"></i>
                            </button>
                        </span>
                    </c:if>
                    
                    <c:if test="${not statusFilter.equals('all')}">
                        <span class="filter-tag">
                            Status: <%= "resolved".equals(statusFilter) ? "Resolved" : "Pending" %>
                            <button type="button" class="remove-filter" onclick="removeStatusFilter()">
                                <i class="fas fa-times"></i>
                            </button>
                        </span>
                    </c:if>
                </div>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${hasFeedback}">
                <c:choose>
                    <c:when test="${not empty feedbackList}">
                        <div class="feedback-list">
                            <c:forEach var="feedback" items="${feedbackList}">
                                <div class="feedback-card ${feedback.hasUnseenReply ? 'has-unseen' : ''}" 
                                     id="feedback-${feedback.id}">
                                    
                                    <div class="feedback-header">
                                        <div class="feedback-title">
                                            <h3>
                                                Feedback #${feedback.id}
                                                <c:if test="${feedback.hasUnseenReply}">
                                                    <span class="unseen-badge">NEW REPLY</span>
                                                </c:if>
                                            </h3>
                                            <div class="meta-item">
                                                <i class="far fa-calendar"></i>
                                                Submitted: 
                                                <fmt:formatDate value="${feedback.createdAt}" pattern="dd MMM yyyy, HH:mm" />
                                            </div>
                                            <div class="meta-item">
                                                <i class="fas fa-tag"></i>
                                                <span class="category-badge">${feedback.category}</span>
                                            </div>
                                        </div>
                                        
                                        <div class="feedback-meta">
                                            <c:choose>
                                                <c:when test="${feedback.resolved}">
                                                    <span class="status-badge status-resolved">
                                                        <i class="fas fa-check-circle"></i> Resolved
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-pending">
                                                        <i class="fas fa-clock"></i> Pending
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                            
                                            <div class="meta-item">
                                                <i class="fas fa-star"></i>
                                                Rating: ${feedback.rating}/5
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="feedback-content">
                                        <strong>Your Original Feedback:</strong>
                                        <div class="feedback-message">${feedback.message}</div>
                                    </div>
                                    
                                    <c:if test="${not empty feedback.replyMessage}">
                                        <div class="admin-reply-section">
                                            <div class="admin-reply-header">
                                                <h4>
                                                    <i class="fas fa-user-shield"></i>
                                                    Administrator Response
                                                </h4>
                                                <c:if test="${not empty feedback.replyDate}">
                                                    <span class="admin-reply-date">
                                                        <i class="far fa-clock"></i>
                                                        <fmt:formatDate value="${feedback.replyDate}" pattern="dd MMM yyyy, HH:mm" />
                                                    </span>
                                                </c:if>
                                            </div>
                                            <div class="admin-reply-message">${feedback.replyMessage}</div>
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${not empty feedback.userReply}">
                                        <div class="user-reply-section">
                                            <div class="user-reply-header">
                                                <h4>
                                                    <i class="fas fa-reply"></i>
                                                    Your Follow-up Reply
                                                </h4>
                                                <c:if test="${not empty feedback.userReplyDate}">
                                                    <span class="user-reply-date">
                                                        <i class="far fa-clock"></i>
                                                        <fmt:formatDate value="${feedback.userReplyDate}" pattern="dd MMM yyyy, HH:mm" />
                                                    </span>
                                                </c:if>
                                            </div>
                                            <div class="user-reply-message">${feedback.userReply}</div>
                                        </div>
                                    </c:if>
                                    
                                    <div class="action-buttons">
                                        <c:if test="${not empty feedback.replyMessage and empty feedback.userReply}">
                                            <a href="${pageContext.request.contextPath}/feedback/my-feedback/reply?id=${feedback.id}" 
                                               class="btn btn-reply"
                                               onclick="return confirm('Are you sure? Replying will mark this feedback as unresolved.')">
                                                <i class="fas fa-reply"></i> Reply to Admin
                                            </a>
                                        </c:if>
                                        
                                        <c:if test="${feedback.hasUnseenReply}">
                                            <form action="${pageContext.request.contextPath}/feedback/my-feedback/mark-seen" 
                                                  method="post" style="display:inline;">
                                                <input type="hidden" name="feedbackId" value="${feedback.id}">
                                                <button type="submit" class="btn btn-mark-read">
                                                    <i class="fas fa-eye"></i> Mark as Read
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <c:if test="${unseenCount == 0}">
                            <div class="no-unseen">
                                <i class="fas fa-check-circle" style="color:#27AE60;"></i>
                                <p>You have no unseen replies from administrators.</p>
                            </div>
                        </c:if>
                    </c:when>
                    
                    <c:otherwise>
                        <div class="no-results">
                            <i class="fas fa-search" style="color:#E2D5C1;"></i>
                            <h3>No Feedback Found</h3>
                            <p>No feedback matches your search criteria. Try adjusting your filters.</p>
                            <a href="${pageContext.request.contextPath}/feedback/my-feedback" class="btn-primary">
                                <i class="fas fa-redo"></i> Clear Filters
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:when>
            
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-comment-slash"></i>
                    <h3>No Feedback Submitted Yet</h3>
                    <p>You haven't submitted any feedback yet. Share your thoughts and suggestions with us!</p>
                    <a href="${pageContext.request.contextPath}/feedback" class="btn-primary">
                        <i class="fas fa-plus"></i> Submit Your First Feedback
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        const userBtn = document.getElementById('userBtn');
        const dropdown = document.getElementById('dropdown');
       
        if (userBtn && dropdown) {
            userBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                dropdown.classList.toggle('show');
            });
           
            document.addEventListener('click', () => dropdown.classList.remove('show'));
            dropdown.addEventListener('click', (e) => e.stopPropagation());
        }
        
        setTimeout(() => {
            document.querySelectorAll('.alert').forEach(alert => {
                alert.style.transition = 'opacity 0.5s ease-out';
                alert.style.opacity = '0';
                setTimeout(() => alert.style.display = 'none', 500);
            });
        }, 5000);
        
        document.querySelectorAll('.btn-reply').forEach(link => {
            link.addEventListener('click', (e) => {
                if (!confirm('Replying will mark this feedback as unresolved. Are you sure you want to continue?')) {
                    e.preventDefault();
                }
            });
        });
        
        if (window.location.hash) {
            const targetElement = document.getElementById(window.location.hash.substring(1));
            if (targetElement) {
                setTimeout(() => {
                    targetElement.scrollIntoView({ behavior: 'smooth' });
                    targetElement.style.boxShadow = '0 0 0 3px rgba(215, 146, 59, 0.3)';
                    setTimeout(() => targetElement.style.boxShadow = '', 2000);
                }, 500);
            }
        }
        
        function removeSearchFilter() {
            const url = new URL(window.location.href);
            url.searchParams.delete('search');
            window.location.href = url.toString();
        }
        
        function removeStatusFilter() {
            const url = new URL(window.location.href);
            url.searchParams.delete('status');
            window.location.href = url.toString();
        }
    </script>
</body>
</html>