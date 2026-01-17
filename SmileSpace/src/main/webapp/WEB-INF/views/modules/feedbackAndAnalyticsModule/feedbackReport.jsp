<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Report - SmileSpace</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            background: #FBF6EA;
            color: #713C0B;
            font-family: 'Fredoka', sans-serif;
            padding: 20px;
            margin: 0;
        }
        .container {
            max-width: 1400px;
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
        .export-options {
            display: flex;
            gap: 10px;
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
        .btn-export {
            background: #27AE60;
        }
        .btn-export:hover {
            background: #219653;
        }
        .report-type {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border: 2px solid #F0D5B8;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .report-content {
            background: white;
            padding: 30px;
            border-radius: 10px;
            border: 2px solid #F0D5B8;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            text-align: center;
            border: 2px solid #E2D5C1;
            box-shadow: 0 4px 8px rgba(0,0,0,0.08);
            transition: transform 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            border-color: #D7923B;
        }
        .stat-value {
            font-size: 42px;
            font-weight: 700;
            color: #713C0B;
            margin: 15px 0;
            line-height: 1;
        }
        .stat-label {
            font-size: 16px;
            color: #A06A2F;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .stat-percentage {
            font-size: 18px;
            font-weight: 700;
            color: #D7923B;
            margin-top: 10px;
            padding: 8px 15px;
            background: #FFF3C8;
            border-radius: 20px;
            display: inline-block;
        }
        .chart-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 50px;
        }
        .chart-container {
            height: 350px;
            background: white;
            padding: 25px;
            border-radius: 12px;
            border: 2px solid #F0D5B8;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .chart-container h4 {
            color: #713C0B;
            margin: 0 0 20px 0;
            font-size: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #F0D5B8;
        }
        .chart-wrapper {
            height: calc(100% - 60px);
            width: 100%;
        }
        .feedback-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            border: 2px solid #F0D5B8;
        }
        .feedback-table th, .feedback-table td {
            border: 1px solid #E2D5C1;
            padding: 15px;
            text-align: left;
        }
        .feedback-table th {
            background: #F0D5B8;
            font-weight: 600;
            color: #713C0B;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .feedback-table tbody tr:hover {
            background: #FFF9F0;
        }
        .sentiment-badge {
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
            min-width: 90px;
            text-align: center;
        }
        .sentiment-positive { background: #2ECC71; color: white; }
        .sentiment-neutral { background: #F39C12; color: white; }
        .sentiment-negative { background: #E74C3C; color: white; }
        .report-summary {
            background: #FFF3C8;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 30px;
            border: 2px solid #F0D5B8;
        }
        .report-summary h3 {
            color: #713C0B;
            margin: 0 0 15px 0;
            font-size: 22px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .no-data {
            text-align: center;
            padding: 60px 40px;
            color: #A06A2F;
            background: white;
            border-radius: 12px;
            border: 2px dashed #F0D5B8;
            margin: 30px 0;
        }
        .no-data i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        .no-data h3 {
            margin-bottom: 15px;
            color: #713C0B;
            font-size: 24px;
        }
        .export-note {
            background: #E8F4FD;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #3498DB;
            margin: 20px 0;
            font-size: 15px;
        }
        .export-note i {
            color: #3498DB;
            margin-right: 10px;
            font-size: 18px;
        }
        
        @media (max-width: 1200px) {
            .chart-row {
                grid-template-columns: 1fr;
            }
            .chart-container {
                height: 320px;
            }
        }
        
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 20px;
                text-align: center;
            }
            .export-options {
                flex-wrap: wrap;
                justify-content: center;
            }
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .chart-container {
                height: 300px;
                padding: 20px;
            }
            .stat-value {
                font-size: 36px;
            }
        }
        
        @media (max-width: 576px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .chart-container {
                height: 280px;
            }
            .feedback-table {
                display: block;
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>
                <i class="fas fa-chart-bar"></i>
                Feedback Analytics Report
                <c:if test="${not empty reportType}">
                    <small style="font-size: 16px; color: #A06A2F; margin-left: 10px;">
                        (${reportType} report)
                    </small>
                </c:if>
            </h1>
            <div class="export-options">
                <a href="${pageContext.request.contextPath}/feedback/export/csv" class="btn btn-export">
                    <i class="fas fa-file-csv"></i> Export CSV
                </a>
                <a href="${pageContext.request.contextPath}/feedback/export/pdf" class="btn btn-export">
                    <i class="fas fa-file-pdf"></i> Export PDF
                </a>
                <a href="${pageContext.request.contextPath}/feedback/analytics" class="btn">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            </div>
        </div>

        <div class="export-note">
            <i class="fas fa-info-circle"></i>
            <strong>Export Notes:</strong> CSV exports include all feedback data. PDF exports include summary statistics and the first 20 feedback entries.
        </div>

        <div class="report-type">
            <p>
                <strong>Report Generated:</strong> <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd MMM yyyy, HH:mm:ss" /> |
                <strong>Report Type:</strong> 
                <c:choose>
                    <c:when test="${reportType == 'summary'}">Summary Statistics</c:when>
                    <c:when test="${reportType == 'detailed'}">Detailed Analytics</c:when>
                    <c:when test="${reportType == 'history'}">Feedback History</c:when>
                    <c:otherwise>Unknown</c:otherwise>
                </c:choose> |
                <strong>Total Records:</strong> ${stats.total}
            </p>
        </div>

        <c:choose>
            <c:when test="${reportType == 'detailed' || reportType == 'summary'}">
                <div class="report-summary">
                    <h3><i class="fas fa-chart-line"></i> Executive Summary</h3>
                    <p>This report provides analysis of all feedback submitted to the SmileSpace platform. 
                       It includes sentiment analysis, resolution rates, and detailed feedback records.</p>
                </div>
                
                <c:set var="positiveVal" value="${stats.positive != null ? stats.positive : 0}" />
                <c:set var="neutralVal" value="${stats.neutral != null ? stats.neutral : 0}" />
                <c:set var="negativeVal" value="${stats.negative != null ? stats.negative : 0}" />
                <c:set var="resolvedVal" value="${stats.resolved != null ? stats.resolved : 0}" />
                <c:set var="totalVal" value="${stats.total != null ? stats.total : 0}" />
                <c:set var="pendingVal" value="${totalVal - resolvedVal}" />
                
                <c:set var="positivePercent" value="${totalVal > 0 ? (positiveVal * 100.0) / totalVal : 0}" />
                <c:set var="neutralPercent" value="${totalVal > 0 ? (neutralVal * 100.0) / totalVal : 0}" />
                <c:set var="negativePercent" value="${totalVal > 0 ? (negativeVal * 100.0) / totalVal : 0}" />
                <c:set var="resolvedPercent" value="${totalVal > 0 ? (resolvedVal * 100.0) / totalVal : 0}" />
                <c:set var="pendingPercent" value="${totalVal > 0 ? (pendingVal * 100.0) / totalVal : 0}" />
                
                <c:choose>
                    <c:when test="${totalVal > 0}">
                        <div class="stats-grid">
                            <div class="stat-card">
                                <div class="stat-label">Total Feedback</div>
                                <div class="stat-value">${totalVal}</div>
                                <div class="stat-percentage">100%</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-label">Positive</div>
                                <div class="stat-value">${positiveVal}</div>
                                <div class="stat-percentage">
                                    <fmt:formatNumber value="${positivePercent}" maxFractionDigits="1" />%
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-label">Neutral</div>
                                <div class="stat-value">${neutralVal}</div>
                                <div class="stat-percentage">
                                    <fmt:formatNumber value="${neutralPercent}" maxFractionDigits="1" />%
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-label">Negative</div>
                                <div class="stat-value">${negativeVal}</div>
                                <div class="stat-percentage">
                                    <fmt:formatNumber value="${negativePercent}" maxFractionDigits="1" />%
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-label">Resolved</div>
                                <div class="stat-value">${resolvedVal}</div>
                                <div class="stat-percentage">
                                    <fmt:formatNumber value="${resolvedPercent}" maxFractionDigits="1" />%
                                </div>
                            </div>
                        </div>

                        <div class="chart-row">
                            <div class="chart-container">
                                <h4>Sentiment Distribution</h4>
                                <div class="chart-wrapper">
                                    <canvas id="sentimentChart"></canvas>
                                </div>
                            </div>
                            <div class="chart-container">
                                <h4>Resolution Status</h4>
                                <div class="chart-wrapper">
                                    <canvas id="resolutionChart"></canvas>
                                </div>
                            </div>
                        </div>

                        <c:if test="${reportType == 'detailed' && not empty allFeedback}">
                            <div class="report-content">
                                <h3 style="color: #713C0B; margin: 0 0 20px 0; font-size: 22px;">
                                    <i class="fas fa-list"></i> Detailed Feedback Records (First 20)
                                </h3>
                                <table class="feedback-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>User</th>
                                            <th>Message Preview</th>
                                            <th>Category</th>
                                            <th>Sentiment</th>
                                            <th>Rating</th>
                                            <th>Status</th>
                                            <th>Date</th>
                                            <th>Replied</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="feedback" items="${allFeedback}" begin="0" end="19">
                                            <tr>
                                                <td>${feedback.id}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty feedback.userFullName}">
                                                            ${feedback.userFullName}
                                                        </c:when>
                                                        <c:when test="${not empty feedback.name}">
                                                            ${feedback.name}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Anonymous
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${fn:length(feedback.message) > 50}">
                                                            ${fn:substring(feedback.message, 0, 50)}...
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${feedback.message}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${feedback.category}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${feedback.sentiment == 'Positive'}">
                                                            <span class="sentiment-badge sentiment-positive">Positive</span>
                                                        </c:when>
                                                        <c:when test="${feedback.sentiment == 'Negative'}">
                                                            <span class="sentiment-badge sentiment-negative">Negative</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="sentiment-badge sentiment-neutral">Neutral</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${feedback.rating != null}">
                                                            <div style="display: flex; align-items: center; gap: 5px;">
                                                                <div style="color: #FFD700;">
                                                                    <c:forEach begin="1" end="5" var="star">
                                                                        <c:choose>
                                                                            <c:when test="${star <= feedback.rating}">
                                                                                <i class="fas fa-star"></i>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <i class="fas fa-star" style="color: #E2D5C1;"></i>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:forEach>
                                                                </div>
                                                                <span style="font-weight: 600; color: #713C0B;">(${feedback.rating}/5)</span>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: #888; font-style: italic;">No rating</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${feedback.resolved}">
                                                            <span style="color: #27AE60; font-weight: 600;">
                                                                <i class="fas fa-check-circle"></i> Resolved
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: #F39C12; font-weight: 600;">
                                                                <i class="fas fa-clock"></i> Pending
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${feedback.createdAt}" pattern="dd/MM/yyyy" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty feedback.replyDate}">
                                                            <fmt:formatDate value="${feedback.replyDate}" pattern="dd/MM/yyyy" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: #888;">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${fn:length(allFeedback) > 20}">
                                            <tr>
                                                <td colspan="9" style="text-align: center; background: #FFF3C8; font-style: italic; padding: 20px;">
                                                    Showing first 20 of ${fn:length(allFeedback)} feedback entries. 
                                                    Export to CSV for complete data.
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="no-data">
                            <i class="fas fa-chart-pie"></i>
                            <h3>No Feedback Data Available</h3>
                            <p>No feedback has been submitted yet. Check back later.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:when>
            
            <c:otherwise>
                <div class="no-data">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Invalid Report Type</h3>
                    <p>Please select a valid report type from the analytics page.</p>
                    <a href="${pageContext.request.contextPath}/feedback/analytics" class="btn" style="margin-top: 20px;">
                        <i class="fas fa-arrow-left"></i> Back to Analytics
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const sentimentChartEl = document.getElementById('sentimentChart');
            const resolutionChartEl = document.getElementById('resolutionChart');
            
            const positive = parseFloat('${positiveVal}') || 0;
            const neutral = parseFloat('${neutralVal}') || 0;
            const negative = parseFloat('${negativeVal}') || 0;
            const resolved = parseFloat('${resolvedVal}') || 0;
            const total = parseFloat('${totalVal}') || 0;
            const pending = total - resolved;
            
            if (sentimentChartEl && (positive > 0 || neutral > 0 || negative > 0)) {
                try {
                    const sentimentData = [positive, neutral, negative];
                    const sentimentLabels = ['Positive', 'Neutral', 'Negative'];
                    const sentimentColors = ['#2ECC71', '#F39C12', '#E74C3C'];
                    
                    new Chart(sentimentChartEl, {
                        type: 'pie',
                        data: {
                            labels: sentimentLabels,
                            datasets: [{
                                data: sentimentData,
                                backgroundColor: sentimentColors,
                                borderWidth: 3,
                                borderColor: '#FFFFFF'
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    position: 'bottom',
                                    labels: {
                                        padding: 20,
                                        usePointStyle: true,
                                        font: {
                                            size: 14,
                                            family: 'Fredoka, sans-serif'
                                        },
                                        color: '#713C0B'
                                    }
                                }
                            },
                            animation: {
                                animateScale: true,
                                animateRotate: true,
                                duration: 1000
                            }
                        }
                    });
                } catch (error) {
                    sentimentChartEl.parentElement.innerHTML = 
                        '<div style="text-align: center; padding: 50px; color: #A06A2F;">' +
                        '<i class="fas fa-chart-pie" style="font-size: 48px; opacity: 0.5;"></i><br>' +
                        'Unable to display sentiment chart</div>';
                }
            } else if (sentimentChartEl) {
                sentimentChartEl.parentElement.innerHTML = 
                    '<div style="text-align: center; padding: 50px; color: #A06A2F;">' +
                    '<i class="fas fa-chart-pie" style="font-size: 48px; opacity: 0.5;"></i><br>' +
                    'No sentiment data available for chart</div>';
            }
            
            if (resolutionChartEl && total > 0) {
                try {
                    const resolutionData = [resolved, pending];
                    const resolutionLabels = ['Resolved', 'Pending'];
                    const resolutionColors = ['#27AE60', '#F39C12'];
                    
                    new Chart(resolutionChartEl, {
                        type: 'doughnut',
                        data: {
                            labels: resolutionLabels,
                            datasets: [{
                                data: resolutionData,
                                backgroundColor: resolutionColors,
                                borderWidth: 3,
                                borderColor: '#FFFFFF'
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            cutout: '60%',
                            plugins: {
                                legend: {
                                    position: 'bottom',
                                    labels: {
                                        padding: 20,
                                        usePointStyle: true,
                                        font: {
                                            size: 14,
                                            family: 'Fredoka, sans-serif'
                                        },
                                        color: '#713C0B'
                                    }
                                }
                            },
                            animation: {
                                animateScale: true,
                                animateRotate: true,
                                duration: 1000
                            }
                        }
                    });
                } catch (error) {
                    resolutionChartEl.parentElement.innerHTML = 
                        '<div style="text-align: center; padding: 50px; color: #A06A2F;">' +
                        '<i class="fas fa-chart-pie" style="font-size: 48px; opacity: 0.5;"></i><br>' +
                        'Unable to display resolution chart</div>';
                }
            } else if (resolutionChartEl) {
                resolutionChartEl.parentElement.innerHTML = 
                    '<div style="text-align: center; padding: 50px; color: #A06A2F;">' +
                    '<i class="fas fa-chart-pie" style="font-size: 48px; opacity: 0.5;"></i><br>' +
                    'No resolution data available for chart</div>';
            }
        });
    </script>
</body>
</html>