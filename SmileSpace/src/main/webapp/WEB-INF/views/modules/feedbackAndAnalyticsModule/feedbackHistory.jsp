<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback History - SmileSpace</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: #FBF6EA;
            color: #713C0B;
            font-family: 'Fredoka', sans-serif;
            padding: 20px;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #F0D5B8;
        }
        .header h1 {
            color: #F0A548;
            font-size: 32px;
            margin: 0;
        }
        .btn {
            padding: 10px 20px;
            background: #D7923B;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn:hover {
            background: #C77D2F;
        }
        .feedback-header {
            background: white;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 25px;
            border: 2px solid #F0D5B8;
        }
        .feedback-header h3 {
            color: #713C0B;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .feedback-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 15px;
        }
        .meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
            color: #A06A2F;
            font-size: 14px;
        }
        .feedback-content {
            background: #FBF6EA;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #D7923B;
            margin: 15px 0;
            line-height: 1.6;
            white-space: pre-wrap;
        }
        .history-section {
            margin-top: 30px;
        }
        .section-title {
            color: #713C0B;
            font-size: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .history-list {
            list-style: none;
            padding: 0;
        }
        .history-item {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 15px;
            border: 2px solid #F0D5B8;
            display: flex;
            gap: 15px;
            transition: all 0.3s ease;
        }
        .history-item:hover {
            border-color: #D7923B;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .history-icon {
            width: 40px;
            height: 40px;
            background: #F0D5B8;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: #713C0B;
        }
        .history-content {
            flex: 1;
        }
        .history-action {
            font-weight: 600;
            color: #713C0B;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .history-details {
            color: #5D4037;
            margin-bottom: 10px;
            padding: 10px;
            background: #FBF6EA;
            border-radius: 8px;
            border-left: 3px solid #E2D5C1;
        }
        .history-meta {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            color: #888;
        }
        .no-history {
            text-align: center;
            padding: 50px;
            color: #A06A2F;
        }
        .action-CREATE { color: #27AE60; }
        .action-UPDATE { color: #F39C12; }
        .action-REPLY { color: #3498DB; }
        .action-RESOLVE { color: #9B59B6; }
        .action-USER_REPLY { color: #2ECC71; }
        .rating-stars {
            display: inline-flex;
            gap: 2px;
            margin-left: 5px;
        }
        .star-filled {
            color: #FFD700;
        }
        .star-empty {
            color: #E2D5C1;
        }
        .sentiment-badge {
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
            margin-left: 10px;
        }
        .sentiment-positive { background: #2ECC71; color: white; }
        .sentiment-neutral { background: #F39C12; color: white; }
        .sentiment-negative { background: #E74C3C; color: white; }
        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            background: #D7923B;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }
        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .alert-warning {
            background: #FFF3CD;
            color: #856404;
            border: 1px solid #FFEEBA;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-history"></i> Feedback History</h1>
            <a href="${pageContext.request.contextPath}/feedback/analytics" class="btn">
                <i class="fas fa-arrow-left"></i> Back to Analytics
            </a>
        </div>
        
        <c:choose>
            <c:when test="${not empty feedback}">
                <div class="feedback-header">
                    <h3><i class="fas fa-comment-dots"></i> Original Feedback #${feedbackId}</h3>
                    
                    <div class="user-info">
                        <div class="user-avatar">
                            <c:choose>
                                <c:when test="${not empty feedback.userFullName}">
                                    ${fn:substring(feedback.userFullName, 0, 1)}
                                </c:when>
                                <c:when test="${not empty feedback.name}">
                                    ${fn:substring(feedback.name, 0, 1)}
                                </c:when>
                                <c:otherwise>A</c:otherwise>
                            </c:choose>
                        </div>
                        <div>
                            <strong>
                                <c:choose>
                                    <c:when test="${not empty feedback.userFullName}">
                                        ${feedback.userFullName}
                                    </c:when>
                                    <c:when test="${not empty feedback.name}">
                                        ${feedback.name}
                                    </c:when>
                                    <c:otherwise>Anonymous User</c:otherwise>
                                </c:choose>
                            </strong>
                            <c:if test="${not empty feedback.userRole}">
                                <span style="color: #A06A2F; font-size: 13px; margin-left: 10px;">
                                    (${feedback.userRole})
                                </span>
                            </c:if>
                        </div>
                    </div>
                    
                    <div class="feedback-meta">
                        <div class="meta-item">
                            <i class="far fa-calendar"></i>
                            Submitted: 
                            <c:choose>
                                <c:when test="${not empty feedback.createdAt}">
                                    <fmt:formatDate value="${feedback.createdAt}" pattern="dd MMM yyyy, HH:mm" />
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #888;">Date not available</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-tag"></i>
                            Category: <strong>${not empty feedback.category ? feedback.category : 'General'}</strong>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-star"></i>
                            Rating: 
                            <c:choose>
                                <c:when test="${not empty feedback.rating}">
                                    <span class="rating-stars">
                                        <c:forEach begin="1" end="5" var="star">
                                            <c:choose>
                                                <c:when test="${star <= feedback.rating}">
                                                    <i class="fas fa-star star-filled"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-star star-empty"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </span>
                                    <span style="font-weight: 600; margin-left: 5px;">(${feedback.rating}/5)</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #888; font-style: italic;">No rating</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <c:if test="${not empty feedback.sentiment}">
                            <div class="meta-item">
                                <i class="fas fa-smile"></i>
                                Sentiment: 
                                <span class="sentiment-badge sentiment-${feedback.sentiment.toLowerCase()}">
                                    ${feedback.sentiment}
                                </span>
                            </div>
                        </c:if>
                        <div class="meta-item">
                            <i class="fas fa-check-circle"></i>
                            Status: 
                            <c:choose>
                                <c:when test="${feedback.resolved}">
                                    <span style="color: #27AE60; font-weight: 600;">Resolved</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #F39C12; font-weight: 600;">Pending</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <div class="feedback-content">
                        ${feedback.message}
                    </div>
                    
                    <c:if test="${not empty feedback.replyMessage}">
                        <div style="margin-top: 20px; padding: 15px; background: #F0F9FF; border-radius: 8px; border-left: 4px solid #3498DB;">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                                <strong style="color: #2980B9;">
                                    <i class="fas fa-user-shield"></i> Admin Response
                                </strong>
                                <c:if test="${not empty feedback.replyDate}">
                                    <span style="color: #7F8C8D; font-size: 13px;">
                                        <i class="far fa-clock"></i>
                                        <fmt:formatDate value="${feedback.replyDate}" pattern="dd MMM yyyy, HH:mm" />
                                    </span>
                                </c:if>
                            </div>
                            <p style="margin: 0; color: #34495E; line-height: 1.5;">${feedback.replyMessage}</p>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty feedback.userReply}">
                        <div style="margin-top: 15px; padding: 15px; background: #F0FFE8; border-radius: 8px; border-left: 4px solid #2ECC71;">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                                <strong style="color: #27AE60;">
                                    <i class="fas fa-reply"></i> User Follow-up Reply
                                </strong>
                                <c:if test="${not empty feedback.userReplyDate}">
                                    <span style="color: #7F8C8D; font-size: 13px;">
                                        <i class="far fa-clock"></i>
                                        <fmt:formatDate value="${feedback.userReplyDate}" pattern="dd MMM yyyy, HH:mm" />
                                    </span>
                                </c:if>
                            </div>
                            <p style="margin: 0; color: #27AE60; line-height: 1.5;">${feedback.userReply}</p>
                        </div>
                    </c:if>
                </div>
                
                <div class="history-section">
                    <h3 class="section-title">
                        <i class="fas fa-stream"></i> Activity Timeline
                    </h3>
                    
                    <c:choose>
                        <c:when test="${not empty history}">
                            <ul class="history-list">
                                <c:forEach var="item" items="${history}">
                                    <li class="history-item">
                                        <div class="history-icon">
                                            <c:choose>
                                                <c:when test="${item.action_type == 'CREATE'}">
                                                    <i class="fas fa-plus action-CREATE"></i>
                                                </c:when>
                                                <c:when test="${item.action_type == 'UPDATE'}">
                                                    <i class="fas fa-edit action-UPDATE"></i>
                                                </c:when>
                                                <c:when test="${item.action_type == 'REPLY'}">
                                                    <i class="fas fa-reply action-REPLY"></i>
                                                </c:when>
                                                <c:when test="${item.action_type == 'RESOLVE'}">
                                                    <i class="fas fa-check action-RESOLVE"></i>
                                                </c:when>
                                                <c:when test="${item.action_type == 'USER_REPLY'}">
                                                    <i class="fas fa-user action-USER_REPLY"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-history"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="history-content">
                                            <div class="history-action">
                                                <c:choose>
                                                    <c:when test="${item.action_type == 'CREATE'}">
                                                        <i class="fas fa-plus action-CREATE"></i> Feedback Submitted
                                                    </c:when>
                                                    <c:when test="${item.action_type == 'UPDATE'}">
                                                        <i class="fas fa-edit action-UPDATE"></i> Feedback Updated
                                                    </c:when>
                                                    <c:when test="${item.action_type == 'REPLY'}">
                                                        <i class="fas fa-reply action-REPLY"></i> Admin Replied
                                                    </c:when>
                                                    <c:when test="${item.action_type == 'RESOLVE'}">
                                                        <i class="fas fa-check action-RESOLVE"></i> Marked as Resolved
                                                    </c:when>
                                                    <c:when test="${item.action_type == 'USER_REPLY'}">
                                                        <i class="fas fa-user action-USER_REPLY"></i> User Replied
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-history"></i> ${item.action_type}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <c:if test="${not empty item.action_details}">
                                                <div class="history-details">
                                                    ${item.action_details}
                                                </div>
                                            </c:if>
                                            <div class="history-meta">
                                                <span>
                                                    <c:if test="${not empty item.performed_by}">
                                                        <i class="fas fa-user"></i> ${item.performed_by}
                                                    </c:if>
                                                </span>
                                                <span>
                                                    <i class="far fa-clock"></i> 
                                                    <fmt:formatDate value="${item.performed_at}" pattern="dd MMM yyyy, HH:mm:ss" />
                                                </span>
                                            </div>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <div class="no-history">
                                <i class="fas fa-history" style="font-size: 64px; opacity: 0.5; margin-bottom: 20px;"></i>
                                <h3>No activity history found</h3>
                                <p>No additional activity has been recorded for this feedback item.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle"></i>
                    <strong>Feedback not found!</strong> The feedback with ID #${feedbackId} could not be found or you don't have permission to view it.
                </div>
                <div style="text-align: center; margin-top: 30px;">
                    <a href="${pageContext.request.contextPath}/feedback/analytics" class="btn">
                        <i class="fas fa-arrow-left"></i> Back to Analytics
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const feedbackContent = document.querySelector('.feedback-content');
            if (feedbackContent && feedbackContent.textContent.length > 500) {
                const originalText = feedbackContent.textContent;
                const shortText = originalText.substring(0, 500) + '...';
                
                feedbackContent.textContent = shortText;
                
                const showMoreBtn = document.createElement('button');
                showMoreBtn.textContent = 'Show More';
                showMoreBtn.style.cssText = 'background: none; border: none; color: #D7923B; cursor: pointer; font-weight: 600; margin-top: 10px;';
                showMoreBtn.addEventListener('click', function() {
                    if (feedbackContent.textContent === shortText) {
                        feedbackContent.textContent = originalText;
                        showMoreBtn.textContent = 'Show Less';
                    } else {
                        feedbackContent.textContent = shortText;
                        showMoreBtn.textContent = 'Show More';
                    }
                });
                
                feedbackContent.parentNode.insertBefore(showMoreBtn, feedbackContent.nextSibling);
            }
        });
    </script>
</body>
</html>