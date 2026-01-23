<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <title>View Module - ${module.title}</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600&display=swap" rel="stylesheet">
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
            padding: 20px 30px;
            background: #FBF6EA;
            border-bottom: 2px solid #F0D5B8;
        }

        .top-right {
            position: absolute;
            right: 40px;
            top: 20px;
            font-size: 20px;
            font-weight: bold;
        }
        
        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .home-link {
            text-decoration: none;
        }
        
        .container { 
            max-width: 1200px; 
            margin: 30px auto;
            padding: 0 20px;
        }

        .page-title {
            text-align: left;
            margin-bottom: 30px;
        }
        
        .page-title h1 {
            font-size: 32px;
            font-weight: 700;
            color: #F0A548;
            margin-bottom: 10px;
        }
        
        .page-title p {
            font-size: 16px;
            color: #713C0B;
            opacity: 0.9;
        }
        
        .content { 
            background: white; 
            border-radius: 20px; 
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            border: 2px solid #F0D5B8;
            margin-top: 10px;
        }
        
        .back-link { 
            display: inline-flex; 
            align-items: center; 
            gap: 8px;
            margin-bottom: 25px; 
            color: #713C0B; 
            text-decoration: none; 
            font-weight: 500;
            padding: 10px 20px;
            border-radius: 10px;
            background: #F4DBAF;
            border: 2px solid #713C0B;
            transition: all 0.3s;
        }
        
        .back-link:hover { 
            background: #713C0B; 
            color: #FBF6EA;
            transform: translateX(-3px);
        }
        
        .module-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        @media (max-width: 768px) {
            .module-info {
                grid-template-columns: 1fr;
            }
        }
        
        .info-card {
            background: #FFF9F0;
            border-radius: 15px;
            padding: 25px;
            border: 2px solid #F0D5B8;
        }
        
        .info-title {
            color: #F0A548;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-detail {
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #F0D5B8;
        }
        
        .info-detail:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        
        .detail-label {
            font-weight: 600;
            color: #713C0B;
            margin-bottom: 5px;
            font-size: 14px;
        }
        
        .detail-value {
            color: #8B7355;
            font-size: 16px;
            line-height: 1.5;
        }
        
        .module-id-badge {
            display: inline-block;
            background: #F0A548;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .module-title {
            color: #713C0B;
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .badge {
            display: inline-block;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            text-transform: capitalize;
        }
        
        .stress { background: #FFE0E0; color: #C73737; }
        .sleep { background: #D7F7F7; color: #2A8989; }
        .anxiety { background: #FFF4C8; color: #B88414; }
        .self-esteem { background: #D1EBFF; color: #106C9E; }
        .mindfulness { background: #CFFFE5; color: #17926E; }
        
        .level-beginner { background: #4ECDC4; color: white; }
        .level-intermediate { background: #FFD166; color: #713C0B; }
        .level-advance { background: #EF476F; color: white; }
        
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-draft {
            background: #6c757d;
            color: white;
        }
        
        .status-submitted {
            background: #ffc107;
            color: #212529;
        }
        
        .status-approved {
            background: #28a745;
            color: white;
        }
        
        .status-published {
            background: #007bff;
            color: white;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        
        .stat-item {
            background: white;
            padding: 15px;
            border-radius: 10px;
            border: 2px solid #F0D5B8;
            text-align: center;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 13px;
            color: #8B7355;
        }
        
        .file-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #F0A548;
            text-decoration: none;
            font-weight: 500;
            background: #FFF3C8;
            padding: 8px 15px;
            border-radius: 8px;
            border: 1px solid #F0A548;
            transition: all 0.3s;
        }
        
        .file-link:hover {
            background: #F0A548;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #F0D5B8;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .btn-primary {
            background: #F0A548;
            color: white;
        }
        
        .btn-primary:hover {
            background: #D18A2C;
        }
        
        .btn-secondary {
            background: #F0D5B8;
            color: #713C0B;
            border: 2px solid #713C0B;
        }
        
        .btn-secondary:hover {
            background: #713C0B;
            color: #FBF6EA;
        }
        
        .btn-success {
            background: #28a745;
            color: white;
        }
        
        .btn-success:hover {
            background: #218838;
        }
        
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        
        .btn-danger:hover {
            background: #c82333;
        }
        
        .access-history {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #F0D5B8;
        }
        
        .history-table {
            overflow-x: auto;
            margin-top: 15px;
        }
        
        .history-table table {
            width: 100%;
            border-collapse: collapse;
            background: #FFF9F0;
            border-radius: 10px;
            overflow: hidden;
        }
        
        .history-table th {
            background: #F0A548;
            color: white;
            padding: 12px 15px;
            text-align: left;
            font-weight: 600;
        }
        
        .history-table td {
            padding: 10px 15px;
            border-bottom: 1px solid #F0D5B8;
            color: #713C0B;
        }
        
        .history-table tr:hover {
            background: #F9EEDB;
        }
        
        .section {
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 1.5em;
            color: #F0A548;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #F0A548;
        }
        
        .outline-item, .guide-item, .point-item {
            background: #FFF9F0;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 10px;
            border-left: 4px solid #F0A548;
        }
        
        .youtube-video {
            position: relative;
            padding-bottom: 56.25%;
            height: 0;
            overflow: hidden;
            border-radius: 10px;
            margin-top: 15px;
            border: 2px solid #F0D5B8;
        }
        
        .youtube-video iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: 0;
            border-radius: 10px;
        }
        
        .learning-tip-box {
            font-style: italic;
            padding: 20px;
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border-radius: 10px;
            border-left: 5px solid #F0A548;
            font-size: 1.1em;
            line-height: 1.6;
            border: 2px solid #F0D5B8;
        }
        
        .resource-link:hover {
            background: #218838;
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
        }
        
        .cover-image-container {
            margin-bottom: 30px;
            text-align: center;
        }
        
        .cover-image {
            max-width: 100%;
            max-height: 400px;
            height: auto;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            object-fit: contain;
            border: 2px solid #F0D5B8;
        }
        
        .no-image {
            background: #FFF9F0;
            height: 300px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #8B7355;
            font-size: 1.2em;
            border: 2px dashed #F0D5B8;
        }
        
        .empty-state {
            text-align: center;
            padding: 30px;
            color: #8B7355;
            background: #FFF9F0;
            border-radius: 10px;
            border: 2px dashed #F0D5B8;
        }
        
        .empty-state i {
            font-size: 40px;
            margin-bottom: 15px;
            color: #F0D5B8;
        }
        
        .detail-list {
            list-style: none;
            padding: 0;
        }
        
        .detail-list li {
            padding: 12px 0;
            border-bottom: 1px solid #F0D5B8;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .detail-list li:last-child {
            border-bottom: none;
        }
        
        .module-meta {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-top: 20px;
        }
        
        .meta-item {
            background: #F4DBAF;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            border: 1px solid #F0D5B8;
            color: #713C0B;
        }
        
        .content-list {
            padding-left: 20px;
            margin-top: 10px;
        }
        
        .content-list li {
            margin-bottom: 8px;
            color: #8B7355;
        }
        
        .key-points-container {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 10px;
        }
        
        .key-point-badge {
            background: #E8F4FC;
            padding: 8px 15px;
            border-radius: 15px;
            border: 1px solid #A7C7E7;
            color: #106C9E;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .image-preview {
            margin-bottom: 10px;
        }
        
        .image-preview img {
            max-width: 200px;
            max-height: 150px;
            border-radius: 10px;
            border: 2px solid #F0D5B8;
        }
        
        @media (max-width: 768px) {
            .module-meta {
                gap: 10px;
            }
            
            .meta-item {
                padding: 6px 12px;
                font-size: 0.8em;
            }
            
            .btn {
                padding: 10px 15px;
                font-size: 0.9em;
            }
            
            .image-preview img {
                max-width: 150px;
                max-height: 100px;
            }
        }
        
        form {
            display: inline;
        }
    </style>
</head>
<body>
    <div class="top-right">
        <a href="${pageContext.request.contextPath}/admin-module-dashboard" class="home-link">
            <div class="logo">
                <i class="fas fa-home"></i>
                SmileSpace
            </div>
        </a>
    </div>
    
    <div class="container">
        <div class="page-title">
            <h1>${module.title}</h1>
            <p>${module.description}</p>
        </div>
        
        <div class="content">
            <div class="module-info">
                <div class="info-card">
                    <div class="info-title">
                        <i class="fas fa-info-circle"></i>
                        Basic Information
                    </div>
                    
                    <div class="module-id-badge">
                        ${module.id}
                    </div>
                    
                    <div class="module-title">
                        ${module.title}
                    </div>
                    
                    <div class="info-detail">
                        <div class="detail-label">Category</div>
                        <div class="detail-value">
                            <span class="badge ${fn:toLowerCase(fn:replace(module.category, ' ', '-'))}">
                                ${module.category}
                            </span>
                        </div>
                    </div>
                    
                    <div class="info-detail">
                        <div class="detail-label">Learning Level</div>
                        <div class="detail-value">
                            <c:set var="displayLevel" value="${module.level}" />
                            <c:if test="${displayLevel == 'Advance'}">
                                <c:set var="displayLevel" value="Advanced" />
                            </c:if>
                            <span class="badge level-${fn:toLowerCase(module.level)}">
                                ${displayLevel}
                            </span>
                        </div>
                    </div>
                    
                    <div class="info-detail">
                        <div class="detail-label">Author</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${not empty module.authorName}">
                                    ${module.authorName}
                                </c:when>
                                <c:otherwise>
                                    Not specified
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <div class="info-detail">
                        <div class="detail-label">Estimated Duration</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${not empty module.estimatedDuration}">
                                    ${module.estimatedDuration}
                                </c:when>
                                <c:otherwise>
                                    Not specified
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <c:if test="${not empty module.contentOutline}">
                    <div class="info-detail">
                        <div class="detail-label">Content Outline</div>
                        <div class="detail-value">
                            <ul class="content-list">
                                <c:set var="outlineItems" value="${fn:split(module.contentOutline, '$$')}" />
                                <c:forEach var="point" items="${outlineItems}" varStatus="status">
                                    <c:if test="${not empty fn:trim(point)}">
                                        <li>${fn:trim(point)}</li>
                                    </c:if>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                    </c:if>

                    <c:if test="${not empty module.learningGuide}">
                    <div class="info-detail">
                        <div class="detail-label">Learning Guide</div>
                        <div class="detail-value">
                            <ol class="content-list">
                                <c:set var="guideSteps" value="${fn:split(module.learningGuide, '$$')}" />
                                <c:forEach var="step" items="${guideSteps}" varStatus="status">
                                    <c:if test="${not empty fn:trim(step)}">
                                        <li>${fn:trim(step)}</li>
                                    </c:if>
                                </c:forEach>
                            </ol>
                        </div>
                    </div>
                    </c:if>
                </div>
                
                <div class="info-card">
                    <div class="info-title">
                        <i class="fas fa-chart-bar"></i>
                        Statistics & Resources
                    </div>
                    
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-value">${module.views}</div>
                            <div class="stat-label">Total Views</div>
                        </div>
                        
                        <div class="stat-item">
                            <div class="stat-value">
                                <c:choose>
                                    <c:when test="${not empty module.lastUpdated}">
                                        ${module.lastUpdated}
                                    </c:when>
                                    <c:otherwise>
                                        N/A
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="stat-label">Last Updated</div>
                        </div>
                    </div>
                    
                    <div class="info-detail">
                        <div class="detail-label">Description</div>
                        <div class="detail-value" style="line-height: 1.6;">
                            <c:choose>
                                <c:when test="${not empty module.description}">
                                    ${module.description}
                                </c:when>
                                <c:otherwise>
                                    <div class='empty-state' style='padding: 10px; font-size: 14px;'>
                                        No description available
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <c:if test="${not empty module.coverImage}">
                    <div class="info-detail">
                        <div class="detail-label">Cover Image</div>
                        <div class="detail-value">
                            <a href="${module.coverImage}" class="file-link" target="_blank">
                                <i class="fas fa-image"></i>
                                View Full Image
                            </a>
                        </div>
                    </div>
                    </c:if>

                    <c:if test="${not empty module.videoUrl}">
                    <div class="info-detail">
                        <div class="detail-label">Video Instruction</div>
                        <div class="detail-value">
                            <a href="${module.videoUrl}" class="file-link" target="_blank">
                                <i class="fas fa-video"></i>
                                Watch Video
                            </a>
                        </div>
                    </div>
                    </c:if>

                    <c:if test="${not empty module.resourceFile}">
                    <div class="info-detail">
                        <div class="detail-label">Resource File</div>
                        <div class="detail-value">
                            <a href="${module.resourceFile}" class="file-link" target="_blank" download>
                                <i class="fas fa-file-download"></i>
                                Download Resource
                            </a>
                            <div style="margin-top: 5px; font-size: 12px; color: #8B7355;">
                                <c:choose>
                                    <c:when test="${fn:contains(module.resourceFile, '.pdf')}">PDF Document</c:when>
                                    <c:when test="${fn:contains(module.resourceFile, '.doc')}">Word Document</c:when>
                                    <c:when test="${fn:contains(module.resourceFile, '.ppt')}">PowerPoint</c:when>
                                    <c:otherwise>Resource File</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    </c:if>

                    <c:if test="${not empty module.learningTip}">
                    <div class="info-detail">
                        <div class="detail-label">Learning Tip</div>
                        <div class="detail-value" style="background: #FFF3C8; padding: 10px; border-radius: 8px;">
                            <i class="fas fa-lightbulb" style="color: #F0A548; margin-right: 8px;"></i>
                            ${module.learningTip}
                        </div>
                    </div>
                    </c:if>

                    <c:if test="${not empty module.keyPoints}">
                    <div class="info-detail">
                        <div class="detail-label">Key Points</div>
                        <div class="detail-value">
                            <div class="key-points-container">
                                <c:set var="keyPoints" value="${fn:split(module.keyPoints, '$$')}" />
                                <c:forEach var="point" items="${keyPoints}" varStatus="status">
                                    <c:if test="${not empty fn:trim(point)}">
                                        <span class="key-point-badge">
                                            <i class="fas fa-check-circle"></i>
                                            ${fn:trim(point)}
                                        </span>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                    </c:if>
                    
                    <div class="info-detail">
                        <div class="detail-label">Created By</div>
                        <div class="detail-value">User ID: ${module.createdBy}</div>
                    </div>
                    
                    <div class="info-detail">
                        <div class="detail-label">Created On</div>
                        <div class="detail-value">${module.createdAt}</div>
                    </div>
                </div>
            </div>
            
            
            <div class="action-buttons">
                <a href="admin-module-dashboard" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i>
                    Back to Dashboard
                </a>

                <a href="view-quiz?moduleId=${module.id}" class="btn btn-secondary">
                    <i class="fas fa-eye"></i>
                    View Current Quiz
                </a>
                
                <c:if test="${userRole == 'admin' || userRole == 'faculty'}">
                    <a href="edit-module?id=${module.id}" class="btn btn-primary">
                        <i class="fas fa-edit"></i>
                        Edit Module
                    </a>
                    
                    <c:if test="${module.status == 'Draft'}">
                        <form action="/submit-module" method="post">
                            <input type="hidden" name="id" value="${module.id}">
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-paper-plane"></i>
                                Submit for Review
                            </button>
                        </form>
                    </c:if>
                    
                    <c:if test="${module.status == 'submitted' && userRole == 'admin'}">
                        <form action="/approve-module" method="post">
                            <input type="hidden" name="id" value="${module.id}">
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-check-circle"></i>
                                Approve Module
                            </button>
                        </form>
                    </c:if>
                    
                    <c:if test="${userRole == 'admin'}">
                        <form action="/delete-module" method="post">
                            <input type="hidden" name="id" value="${module.id}">
                            <button type="submit" class="btn btn-danger" 
                                    onclick="return confirm('Are you sure you want to delete this module? This action cannot be undone.');">
                                <i class="fas fa-trash"></i>
                                Delete Module
                            </button>
                        </form>
                    </c:if>
                </c:if>
            </div>
            
            <c:if test="${not empty accessHistory && (userRole == 'admin' || userRole == 'faculty' || userRole == 'professional')}">
                <div class="access-history">
                    <div class="info-title">
                        <i class="fas fa-history"></i>
                        Access History (Last 50)
                    </div>
                    
                    <div class="history-table">
                        <table>
                            <thead>
                                <tr>
                                    <th>User</th>
                                    <th>Username</th>
                                    <th>Access Type</th>
                                    <th>Module Status</th>
                                    <th>Access Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="record" items="${accessHistory}">
                                    <tr>
                                        <td>${record.full_name}</td>
                                        <td>${record.username}</td>
                                        <td>
                                            <span class="badge ${record.access_type}">
                                                ${record.access_type}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="status-badge status-${fn:toLowerCase(record.module_status)}">
                                                ${record.module_status}
                                            </span>
                                        </td>
                                        <td>${record.access_date}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Module view page loaded for: ${module.title}');
            
            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                form.addEventListener('submit', function() {
                    const button = this.querySelector('button[type="submit"]');
                    if (button) {
                        const originalText = button.innerHTML;
                        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
                        button.disabled = true;
                        
                        setTimeout(() => {
                            button.innerHTML = originalText;
                            button.disabled = false;
                        }, 5000);
                    }
                });
            });
            
            const style = document.createElement('style');
            style.textContent = `
                @keyframes spin {
                    0% { transform: rotate(0deg); }
                    100% { transform: rotate(360deg); }
                }
                .fa-spin {
                    animation: spin 1s linear infinite;
                    display: inline-block;
                }
            `;
            document.head.appendChild(style);
        });
    </script>
</body>
</html>