<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
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
    <title>My Reports - SmileSpace</title>
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
            --warning-color: #F39C12;
            --warning-dark: #D68910;
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
        
        /* Header - Consistent with other pages */
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
        
        .dropdown.show { 
            display: block; 
        }
        
        .user-info {
            padding: 15px;
            background: var(--background-medium);
            border-bottom: 2px solid var(--border-color);
        }
        
        .user-name { 
            font-weight: bold; 
        }
        
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
        
        .menu-item:hover { 
            background: var(--background-light); 
        }
        
        .menu-item.logout { 
            color: var(--danger-color); 
        }
        
        /* Main Container */
        .container {
            padding: 40px;
            max-width: 1400px;
            margin: 0 auto;
        }
        
        /* Welcome Section */
        .welcome {
            text-align: center;
            margin-bottom: 40px;
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
        
        /* Button Base Styles */
        .btn {
            padding: 8px 16px;
            border-radius: var(--radius-md);
            font-weight: bold;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            border: none;
            font-size: 14px;
            min-height: 40px;
            justify-content: center;
            text-decoration: none;
            font-family: inherit;
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
        
        /* Reports Sections */
        .reports-container {
            display: grid;
            grid-template-columns: 1fr;
            gap: 40px;
            margin-bottom: 40px;
        }
        
        .reports-section {
            background: var(--white);
            border-radius: var(--radius-xl);
            padding: 30px;
            box-shadow: var(--shadow);
            border: 2px solid var(--border-color);
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--border-color);
        }
        
        .section-header h3 {
            color: var(--primary-color);
            font-size: 22px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .section-count {
            background: var(--primary-color);
            color: var(--white);
            padding: 4px 12px;
            border-radius: var(--radius-sm);
            font-size: 14px;
            font-weight: bold;
        }
        
        /* Table Styles */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th {
            background: var(--background-medium);
            color: var(--text-color);
            font-weight: 600;
            text-align: left;
            padding: 18px 15px;
            border-bottom: 2px solid var(--border-color);
            font-size: 14px;
            white-space: nowrap;
        }
        
        td {
            padding: 18px 15px;
            border-bottom: 1px solid var(--border-color);
            color: var(--text-color);
            font-size: 14px;
            vertical-align: top;
        }
        
        tr:hover {
            background: var(--background-light);
        }
        
        tr:last-child td {
            border-bottom: none;
        }
        
        /* Status Badges */
        .status-badge {
            padding: 6px 12px;
            border-radius: var(--radius-sm);
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            display: inline-block;
            white-space: nowrap;
        }
        
        .status-pending {
            background: var(--warning-color);
            color: var(--white);
        }
        
        .status-resolved {
            background: var(--success-color);
            color: var(--white);
        }
        
        .status-dismissed {
            background: var(--gray-color);
            color: var(--white);
        }
        
        .status-under-review {
            background: var(--info-color);
            color: var(--white);
        }
        
        /* Content Type Badge */
        .content-badge {
            padding: 4px 8px;
            border-radius: var(--radius-sm);
            font-size: 11px;
            font-weight: 600;
            background: var(--background-medium);
            color: var(--text-color);
            display: inline-block;
            margin-left: 5px;
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
            color: var(--primary-color);
        }
        
        .empty-state p {
            font-size: 16px;
            line-height: 1.6;
            max-width: 500px;
            margin: 0 auto;
        }
        
        /* Dashboard Link */
        .dashboard-link {
            text-align: center;
            margin-top: 30px;
        }
        
        /* Quick Actions */
        .quick-actions {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        /* Responsive */
        @media (max-width: 1200px) {
            .container {
                padding: 30px 20px;
            }
            
            .reports-section {
                padding: 20px;
            }
        }
        
        @media (max-width: 992px) {
            table {
                display: block;
                overflow-x: auto;
            }
            
            th, td {
                padding: 15px 12px;
                font-size: 13px;
            }
            
            .section-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
        }
        
        @media (max-width: 768px) {
            .header {
                padding: 15px 20px;
            }
            
            .logo h1 {
                font-size: 24px;
            }
            
            .welcome h2 {
                font-size: 24px;
            }
            
            .welcome p {
                font-size: 14px;
            }
            
            .section-header h3 {
                font-size: 20px;
            }
            
            .btn {
                padding: 6px 12px;
                font-size: 13px;
                min-height: 36px;
            }
            
            .quick-actions {
                flex-direction: column;
                align-items: center;
            }
            
            .quick-actions .btn {
                width: 100%;
                justify-content: center;
            }
        }
        
        @media (max-width: 480px) {
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .reports-section {
                padding: 15px 10px;
            }
            
            .section-header {
                text-align: center;
                align-items: center;
            }
            
            .empty-state {
                padding: 40px 15px;
            }
            
            .empty-state i {
                font-size: 48px;
            }
            
            .empty-state h3 {
                font-size: 20px;
            }
            
            .empty-state p {
                font-size: 14px;
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
                    <div class="user-role">
                        <c:choose>
                            <c:when test="${userRole == 'admin'}">Administrator</c:when>
                            <c:when test="${userRole == 'student'}">Student</c:when>
                            <c:when test="${userRole == 'faculty'}">Faculty</c:when>
                            <c:when test="${userRole == 'professional'}">Professional</c:when>
                        </c:choose>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/dashboard" class="menu-item">
                    <i class="fas fa-home"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/forum" class="menu-item">
                    <i class="fas fa-home"></i> Forum
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
            <h2>My Reports</h2>
            <p>Track all reports you've submitted and reports made against your content</p>
        </div>

        <div class="reports-container">
            <!-- Reports You Submitted -->
            <div class="reports-section">
                <div class="section-header">
                    <h3><i class="fas fa-paper-plane"></i> Reports You Submitted</h3>
                    <c:if test="${not empty myReports}">
                        <span class="section-count">${fn:length(myReports)} report(s)</span>
                    </c:if>
                </div>
                
                <c:choose>
                    <c:when test="${empty myReports}">
                        <div class="empty-state">
                            <i class="fas fa-inbox"></i>
                            <h3>No Reports Submitted</h3>
                            <p>You haven't submitted any reports yet. Reports you make on forum posts or replies will appear here.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                                <tr>
                                    <th>Report ID</th>
                                    <th>Content Type</th>
                                    <th>Target ID</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                    <th>Action Taken</th>
                                    <th>Reported At</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="report" items="${myReports}">
                                    <tr>
                                        <td>${report.reportId}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${report.postId != 0}">
                                                    Post
                                                    <span class="content-badge">ID: ${report.postId}</span>
                                                </c:when>
                                                <c:when test="${report.replyId != 0}">
                                                    Reply
                                                    <span class="content-badge">ID: ${report.replyId}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    Unknown
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${report.postId != 0}">
                                                    ${report.postId}
                                                </c:when>
                                                <c:otherwise>
                                                    ${report.replyId}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="max-width: 200px;">${report.reason}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${report.status == 'PENDING'}">
                                                    <span class="status-badge status-pending">Pending</span>
                                                </c:when>
                                                <c:when test="${report.status == 'UNDER_REVIEW'}">
                                                    <span class="status-badge status-under-review">Under Review</span>
                                                </c:when>
                                                <c:when test="${report.status == 'RESOLVED'}">
                                                    <span class="status-badge status-resolved">Resolved</span>
                                                </c:when>
                                                <c:when test="${report.status == 'DISMISSED'}">
                                                    <span class="status-badge status-dismissed">Dismissed</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge">${report.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="max-width: 200px;">
                                            <c:choose>
                                                <c:when test="${not empty report.actionTaken}">
                                                    ${report.actionTaken}
                                                </c:when>
                                                <c:otherwise>
                                                    <em style="color: var(--text-light); font-size: 12px;">No action taken</em>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${report.createdAt}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Reports Against Your Content -->
            <div class="reports-section">
                <div class="section-header">
                    <h3><i class="fas fa-exclamation-triangle"></i> Reports Against Your Content</h3>
                    <c:if test="${not empty againstMe}">
                        <span class="section-count">${fn:length(againstMe)} report(s)</span>
                    </c:if>
                </div>
                
                <c:choose>
                    <c:when test="${empty againstMe}">
                        <div class="empty-state">
                            <i class="fas fa-check-circle"></i>
                            <h3>No Reports Against You</h3>
                            <p>Great news! There are no reports against your posts or replies.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                                <tr>
                                    <th>Report ID</th>
                                    <th>Reporter</th>
                                    <th>Content Type</th>
                                    <th>Target ID</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                    <th>Action Taken</th>
                                    <th>Reported At</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="report" items="${againstMe}">
                                    <tr>
                                        <td>${report.reportId}</td>
                                        <td>${report.reporterName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${report.postId != 0}">
                                                    Post
                                                    <span class="content-badge">ID: ${report.postId}</span>
                                                </c:when>
                                                <c:when test="${report.replyId != 0}">
                                                    Reply
                                                    <span class="content-badge">ID: ${report.replyId}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    Unknown
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${report.postId != 0}">
                                                    ${report.postId}
                                                </c:when>
                                                <c:otherwise>
                                                    ${report.replyId}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="max-width: 200px;">${report.reason}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${report.status == 'PENDING'}">
                                                    <span class="status-badge status-pending">Pending</span>
                                                </c:when>
                                                <c:when test="${report.status == 'UNDER_REVIEW'}">
                                                    <span class="status-badge status-under-review">Under Review</span>
                                                </c:when>
                                                <c:when test="${report.status == 'RESOLVED'}">
                                                    <span class="status-badge status-resolved">Resolved</span>
                                                </c:when>
                                                <c:when test="${report.status == 'DISMISSED'}">
                                                    <span class="status-badge status-dismissed">Dismissed</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge">${report.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="max-width: 200px;">
                                            <c:choose>
                                                <c:when test="${not empty report.actionTaken}">
                                                    ${report.actionTaken}
                                                </c:when>
                                                <c:otherwise>
                                                    <em style="color: var(--text-light); font-size: 12px;">No action taken</em>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${report.createdAt}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
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

        // Add some interactivity
        document.addEventListener('DOMContentLoaded', function() {
            // Add hover effect to table rows
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.transition = 'all 0.2s ease';
                });
            });
            
            // Update page title based on report counts
            const myReportsCount = document.querySelectorAll('.reports-section:first-child tbody tr').length;
            const againstMeCount = document.querySelectorAll('.reports-section:last-child tbody tr').length;
            const totalReports = myReportsCount + againstMeCount;
            
            if (totalReports > 0) {
                document.title = 'My Reports (' + totalReports + ') - SmileSpace';
            }
        });
    </script>
</body>
</html>