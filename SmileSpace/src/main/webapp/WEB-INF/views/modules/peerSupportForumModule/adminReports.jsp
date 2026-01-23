<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String userRole = (String) session.getAttribute("userRole");
    String userFullName = (String) session.getAttribute("userFullName");
    if (userRole == null || !"admin".equals(userRole)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Reports - SmileSpace</title>
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
        
        /* Filter Bar - Updated to match your design */
        .filter-bar {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 40px;
            flex-wrap: wrap;
        }
        
        .filter-btn {
            padding: 10px 25px;
            border-radius: 25px;
            border: 2px solid var(--primary-color);
            background: var(--white);
            color: var(--text-color);
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
            font-family: inherit;
        }
        
        .filter-btn:hover {
            background: var(--background-medium);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(215, 146, 59, 0.2);
        }
        
        .filter-btn.active {
            background: var(--primary-color);
            color: var(--white);
            border-color: var(--primary-color);
        }
        
        /* Reports Card */
        .reports-card {
            background: var(--white);
            border-radius: var(--radius-xl);
            padding: 30px;
            box-shadow: var(--shadow);
            border: 2px solid var(--border-color);
            overflow-x: auto;
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
        
        .status-reported {
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
        
        /* Form Styles */
        .update-form {
            display: flex;
            flex-direction: column;
            gap: 10px;
            min-width: 300px;
        }
        
        .update-form select,
        .update-form input[type="text"] {
            padding: 8px 12px;
            border: 2px solid var(--border-color);
            border-radius: var(--radius-sm);
            font-size: 14px;
            font-family: inherit;
            background: var(--white);
        }
        
        .update-form select:focus,
        .update-form input[type="text"]:focus {
            outline: none;
            border-color: var(--primary-color);
        }
        
        .update-form button {
            align-self: flex-start;
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
        
        /* Quick Actions */
        .quick-actions {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        /* Dashboard Link */
        .dashboard-link {
            text-align: center;
            margin-top: 30px;
        }
        
        /* Completed Report Style */
        .completed-report {
            background-color: #f9f9f9;
        }
        
        .completed-report:hover {
            background-color: #f5f5f5;
        }
        
        /* Status Message */
        .status-message {
            font-size: 12px;
            color: var(--text-light);
            font-style: italic;
            margin-top: 5px;
        }
        
        /* Responsive */
        @media (max-width: 1200px) {
            .container {
                padding: 30px 20px;
            }
            
            .reports-card {
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
            
            .update-form {
                min-width: 250px;
            }
            
            .filter-bar {
                gap: 10px;
            }
        }
        
        @media (max-width: 768px) {
            .header {
                padding: 15px 20px;
            }
            
            .logo h1 {
                font-size: 24px;
            }
            
            .filter-bar {
                gap: 10px;
            }
            
            .filter-btn {
                padding: 8px 15px;
                font-size: 13px;
            }
            
            .welcome h2 {
                font-size: 24px;
            }
            
            .welcome p {
                font-size: 14px;
            }
            
            .update-form {
                min-width: 200px;
            }
            
            .update-form select,
            .update-form input[type="text"] {
                font-size: 13px;
                padding: 6px 10px;
            }
            
            .btn {
                padding: 6px 12px;
                font-size: 13px;
                min-height: 36px;
            }
        }
        
        @media (max-width: 480px) {
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .filter-bar {
                flex-direction: column;
                align-items: center;
            }
            
            .filter-btn {
                width: 100%;
                justify-content: center;
            }
            
            .quick-actions {
                flex-direction: column;
                align-items: center;
            }
            
            .quick-actions .btn {
                width: 100%;
                justify-content: center;
            }
            
            .reports-card {
                padding: 15px 10px;
            }
            
            .update-form {
                min-width: 100%;
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
                    <div class="user-role">Administrator</div>
                </div>
                <a href="${pageContext.request.contextPath}/dashboard" class="menu-item">
                    <i class="fas fa-home"></i> Dashboard
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

    <!-- Main Content -->
    <div class="container">
        <div class="welcome">
            <h2>Admin Reports Dashboard</h2>
            <p>Review and manage all user reports</p>
        </div>

        <!-- Filter Bar - Updated with better styling -->
        <div class="filter-bar">
            <form method="get" style="display: contents;">
                <button type="submit" name="status" value="" class="filter-btn ${empty param.status ? 'active' : ''}">
                    <i class="fas fa-list"></i> All Reports
                </button>
                <button type="submit" name="status" value="REPORTED" class="filter-btn ${param.status == 'REPORTED' ? 'active' : ''}">
                    <i class="fas fa-flag"></i> Reported
                </button>
                <button type="submit" name="status" value="RESOLVED" class="filter-btn ${param.status == 'RESOLVED' ? 'active' : ''}">
                    <i class="fas fa-check-circle"></i> Resolved
                </button>
                <button type="submit" name="status" value="DISMISSED" class="filter-btn ${param.status == 'DISMISSED' ? 'active' : ''}">
                    <i class="fas fa-times-circle"></i> Dismissed
                </button>
            </form>
        </div>

        <!-- Reports Card -->
        <div class="reports-card">
            <c:choose>
                <c:when test="${empty reports}">
                    <div class="empty-state">
                        <i class="fas fa-flag"></i>
                        <h3>No Reports Found</h3>
                        <c:choose>
                            <c:when test="${not empty param.status}">
                                <p>There are no ${param.status.toLowerCase()} reports.</p>
                            </c:when>
                            <c:otherwise>
                                <p>There are currently no reports to review.</p>
                            </c:otherwise>
                        </c:choose>
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
                                <th>Created At</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="report" items="${reports}">
                                <tr class="${report.status != 'REPORTED' ? 'completed-report' : ''}">
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
                                            <c:when test="${report.status == 'REPORTED'}">
                                                <span class="status-badge status-reported">Reported</span>
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
                                    <td>
                                        <!-- ONLY show update form for REPORTED status -->
                                        <c:choose>
                                            <c:when test="${report.status == 'REPORTED'}">
                                                <form action="${pageContext.request.contextPath}/reports/admin/update" method="post" class="update-form">
                                                    <input type="hidden" name="reportId" value="${report.reportId}">
                                                    <select name="status">
                                                        <option value="RESOLVED">Resolve</option>
                                                        <option value="DISMISSED">Dismiss</option>
                                                    </select>
                                                    <input type="text" name="actionTaken" placeholder="Action taken (required)" required>
                                                    <button type="submit" class="btn btn-primary">
                                                        <i class="fas fa-save"></i> Update
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Show completed status message for RESOLVED/DISMISSED -->
                                                <div class="status-message">
                                                    <c:choose>
                                                        <c:when test="${report.status == 'RESOLVED'}">
                                                            <i class="fas fa-check-circle" style="color: var(--success-color);"></i>
                                                            Report resolved
                                                        </c:when>
                                                        <c:when test="${report.status == 'DISMISSED'}">
                                                            <i class="fas fa-times-circle" style="color: var(--gray-color);"></i>
                                                            Report dismissed
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
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

        // Auto-refresh page when filter changes (optional)
        document.addEventListener('DOMContentLoaded', function() {
            const filterButtons = document.querySelectorAll('.filter-btn');
            filterButtons.forEach(button => {
                button.addEventListener('click', function() {
                    // The form will handle the submission
                });
            });
            
            // Highlight completed reports
            const completedRows = document.querySelectorAll('.completed-report');
            completedRows.forEach(row => {
                row.style.opacity = '0.9';
            });
        });
    </script>
</body>
</html>