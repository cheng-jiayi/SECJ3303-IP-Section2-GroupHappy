<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Assessment History - SmileSpace</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            background-color: #FFF8E8;
            color: #6B4F36;
            font-family: 'Fredoka', sans-serif;
            padding-bottom: 40px;
        }
        
        .header {
            background-color: #FFF3C8;
            padding: 15px 40px;
            border-bottom: 2px solid #E8D9B5;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .home-link {
            text-decoration: none;
            color: #6B4F36;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: opacity 0.2s;
        }
        
        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn {
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-secondary {
            background: #E6C68D;
            color: #6B4F36;
        }
        
        .btn-secondary:hover {
            background: #D4B57F;
            transform: translateY(-2px);
            box-shadow: 0px 4px 8px rgba(0,0,0,0.1);
        }
        
        .container {
            width: 90%;
            max-width: 1200px;
            margin: 40px auto;
        }
        
        .comparison-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            border: 2px solid #F0D5B8;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }
        
        .comparison-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .comparison-item {
            text-align: center;
            padding: 15px;
            background: #FFF9F0;
            border-radius: 10px;
        }
        
        .improvement { color: #27AE60; }
        .deterioration { color: #E74C3C; }
        .stable { color: #7F8C8D; }
        
        .timeline-container {
            margin-top: 40px;
        }
        
        .timeline-item {
            background: white;
            padding: 20px;
            margin-bottom: 15px;
            border-left: 5px solid #F0A548;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .timeline-item:hover {
            transform: translateX(10px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .export-btn {
            background: #27AE60;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            margin-left: 10px;
        }
        
        .export-btn:hover {
            background: #219653;
        }
        
        .severity-normal { background: #2ECC71; color: white; }
        .severity-mild { background: #F39C12; color: white; }
        .severity-moderate { background: #E67E22; color: white; }
        .severity-severe { background: #E74C3C; color: white; }
        .severity-extremely-severe { background: #8B0000; color: white; }
        
        .print-btn {
            background: #6B4F36;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            margin-left: 10px;
        }
        
        .print-btn:hover {
            background: #5A422E;
        }
        
        .btn-primary {
            background: #CF8224;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary:hover {
            background: #B3711E;
            color: white;
            transform: translateY(-2px);
        }
        
        .badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 600;
        }
        
        @media (max-width: 768px) {
            .header {
                padding: 15px 20px;
            }
            
            .container {
                width: 95%;
                margin: 20px auto;
            }
            
            .comparison-grid {
                grid-template-columns: 1fr;
            }
            
            .d-flex {
                flex-direction: column;
                gap: 10px;
            }
            
            .export-btn, .print-btn {
                margin-left: 0;
                margin-top: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <a href="${pageContext.request.contextPath}/dashboard" class="home-link">
            <div class="logo">
                <i class="fas fa-home"></i>
                SmileSpace
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/self-assessment" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back to Self Assessment
        </a>
    </div>
    
    <div class="container">
        <h1 class="mb-4">My Assessment History</h1>
        
        <div class="mb-4 d-flex">
            <a href="${pageContext.request.contextPath}/self-assessment" class="btn btn-primary">
                <i class="fas fa-plus-circle"></i> Take New Assessment
            </a>
            <button onclick="exportHistory()" class="export-btn">
                <i class="fas fa-file-export"></i> Export History
            </button>
            <button onclick="printHistory()" class="print-btn">
                <i class="fas fa-print"></i> Print History
            </button>
        </div>
        
        <c:choose>
            <c:when test="${not empty assessments and assessments.size() > 0}">
                <div id="assessmentData" style="display: none;">
                    <c:forEach var="assessment" items="${assessments}" varStatus="status">
                        <div class="assessment-entry" 
                             data-id="${assessment.assessmentId}"
                             data-date="<fmt:formatDate value="${assessment.assessmentDate}" pattern="yyyy-MM-dd" />"
                             data-depression="${assessment.depressionScore}"
                             data-anxiety="${assessment.anxietyScore}"
                             data-stress="${assessment.stressScore}"
                             data-depression-severity="${assessment.depressionSeverity}"
                             data-anxiety-severity="${assessment.anxietySeverity}"
                             data-stress-severity="${assessment.stressSeverity}"
                             data-overall="${assessment.overallSeverity}">
                        </div>
                    </c:forEach>
                </div>
                
                <c:if test="${assessments.size() > 1}">
                    <div class="comparison-card">
                        <h3><i class="fas fa-chart-line"></i> Progress Comparison</h3>
                        <p>Comparing your latest assessment with previous ones</p>
                        
                        <div class="comparison-grid">
                            <div class="comparison-item">
                                <h5>Total Assessments</h5>
                                <h2>${assessments.size()}</h2>
                            </div>
                            
                            <c:set var="latest" value="${assessments.get(0)}" />
                            <c:set var="previous" value="${assessments.get(1)}" />
                            
                            <div class="comparison-item">
                                <h5>Latest Overall</h5>
                                <h3>${latest.overallSeverity}</h3>
                                <c:choose>
                                    <c:when test="${latest.overallSeverity != previous.overallSeverity}">
                                        <small class="${latest.overallSeverity == 'Normal' ? 'improvement' : 'deterioration'}">
                                            <i class="fas fa-arrow-${latest.overallSeverity == 'Normal' ? 'down' : 'up'}"></i>
                                            Changed from ${previous.overallSeverity}
                                        </small>
                                    </c:when>
                                    <c:otherwise>
                                        <small class="stable">
                                            <i class="fas fa-minus"></i>
                                            No change
                                        </small>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <div class="comparison-item">
                                <h5>Time Span</h5>
                                <h4 id="timeSpan">Calculating...</h4>
                            </div>
                        </div>
                        
                        <div style="height: 300px; margin-top: 30px;">
                            <canvas id="trendChart"></canvas>
                        </div>
                    </div>
                </c:if>
                
                <div class="timeline-container">
                    <h3 class="mb-4">All Assessments</h3>
                    <c:forEach var="assessment" items="${assessments}" varStatus="status">
                        <div class="timeline-item" onclick="window.location.href='${pageContext.request.contextPath}/self-assessment/result/${assessment.assessmentId}'">
                            <div class="row">
                                <div class="col-md-3">
                                    <strong>Assessment #${assessment.assessmentId}</strong>
                                    <div class="text-muted">
                                        <fmt:formatDate value="${assessment.assessmentDate}" pattern="dd MMM yyyy, hh:mm a" />
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="row">
                                        <div class="col-4 text-center">
                                            <div>${assessment.depressionScore}</div>
                                            <small class="severity-${assessment.depressionSeverity == 'Normal' ? 'normal' : 
                                                assessment.depressionSeverity == 'Mild' ? 'mild' : 
                                                assessment.depressionSeverity == 'Moderate' ? 'moderate' : 
                                                assessment.depressionSeverity == 'Severe' ? 'severe' : 'extremely-severe'}">
                                                ${assessment.depressionSeverity}
                                            </small>
                                            <div><small>Depression</small></div>
                                        </div>
                                        <div class="col-4 text-center">
                                            <div>${assessment.anxietyScore}</div>
                                            <small class="severity-${assessment.anxietySeverity == 'Normal' ? 'normal' : 
                                                assessment.anxietySeverity == 'Mild' ? 'mild' : 
                                                assessment.anxietySeverity == 'Moderate' ? 'moderate' : 
                                                assessment.anxietySeverity == 'Severe' ? 'severe' : 'extremely-severe'}">
                                                ${assessment.anxietySeverity}
                                            </small>
                                            <div><small>Anxiety</small></div>
                                        </div>
                                        <div class="col-4 text-center">
                                            <div>${assessment.stressScore}</div>
                                            <small class="severity-${assessment.stressSeverity == 'Normal' ? 'normal' : 
                                                assessment.stressSeverity == 'Mild' ? 'mild' : 
                                                assessment.stressSeverity == 'Moderate' ? 'moderate' : 
                                                assessment.stressSeverity == 'Severe' ? 'severe' : 'extremely-severe'}">
                                                ${assessment.stressSeverity}
                                            </small>
                                            <div><small>Stress</small></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3 text-end">
                                    <span class="badge severity-${assessment.overallSeverity == 'Normal' ? 'normal' : 
                                        assessment.overallSeverity == 'Mild' ? 'mild' : 
                                        assessment.overallSeverity == 'Moderate' ? 'moderate' : 
                                        assessment.overallSeverity == 'Severe' ? 'severe' : 'extremely-severe'}">
                                        ${assessment.overallSeverity}
                                    </span>
                                    <c:if test="${status.index > 0}">
                                        <c:set var="prev" value="${assessments.get(status.index-1)}" />
                                        <c:set var="totalChange" value="${assessment.depressionScore + assessment.anxietyScore + assessment.stressScore - (prev.depressionScore + prev.anxietyScore + prev.stressScore)}" />
                                        <small class="${totalChange < 0 ? 'improvement' : totalChange > 0 ? 'deterioration' : 'stable'}">
                                            <i class="fas fa-arrow-${totalChange < 0 ? 'down' : totalChange > 0 ? 'up' : 'minus'}"></i>
                                            <c:choose>
                                                <c:when test="${totalChange == 0}">No change</c:when>
                                                <c:otherwise>${Math.abs(totalChange)} pts ${totalChange < 0 ? 'improvement' : 'increase'}</c:otherwise>
                                            </c:choose>
                                        </small>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <i class="fas fa-clipboard-list fa-4x text-muted mb-4"></i>
                    <h3>No Assessments Yet</h3>
                    <p class="text-muted mb-4">Take your first DASS-21 assessment to track your mental well-being.</p>
                    <a href="${pageContext.request.contextPath}/self-assessment" class="btn btn-primary btn-lg">
                        <i class="fas fa-play-circle"></i> Start Your First Assessment
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        function loadAssessmentData() {
            const assessmentEntries = document.querySelectorAll('.assessment-entry');
            const assessments = [];
            
            assessmentEntries.forEach(entry => {
                assessments.push({
                    id: entry.dataset.id,
                    date: new Date(entry.dataset.date),
                    depression: parseInt(entry.dataset.depression),
                    anxiety: parseInt(entry.dataset.anxiety),
                    stress: parseInt(entry.dataset.stress),
                    depressionSeverity: entry.dataset.depressionSeverity,
                    anxietySeverity: entry.dataset.anxietySeverity,
                    stressSeverity: entry.dataset.stressSeverity,
                    overall: entry.dataset.overall
                });
            });
            
            return assessments;
        }
        
        function calculateTimeSpan() {
            const assessments = loadAssessmentData();
            
            if (assessments.length > 1) {
                const firstDate = assessments[assessments.length - 1].date;
                const lastDate = assessments[0].date;
                const timeDiff = Math.abs(lastDate.getTime() - firstDate.getTime());
                const dayDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
                document.getElementById('timeSpan').textContent = dayDiff + ' days';
            } else {
                document.getElementById('timeSpan').textContent = 'First assessment';
            }
        }
        
        function initializeTrendChart() {
            const assessments = loadAssessmentData();
            
            if (assessments.length > 1) {
                const dates = [];
                const depressionScores = [];
                const anxietyScores = [];
                const stressScores = [];
                
                assessments.sort((a, b) => a.date - b.date);
                
                assessments.forEach(assessment => {
                    const formattedDate = assessment.date.toLocaleDateString('en-US', { 
                        month: 'short', 
                        day: '2-digit' 
                    });
                    
                    dates.push(formattedDate);
                    depressionScores.push(assessment.depression);
                    anxietyScores.push(assessment.anxiety);
                    stressScores.push(assessment.stress);
                });
                
                const ctx = document.getElementById('trendChart').getContext('2d');
                if (ctx) {
                    new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: dates,
                            datasets: [
                                {
                                    label: 'Depression',
                                    data: depressionScores,
                                    borderColor: '#E74C3C',
                                    backgroundColor: 'rgba(231, 76, 60, 0.1)',
                                    borderWidth: 2,
                                    tension: 0.3,
                                    fill: true
                                },
                                {
                                    label: 'Anxiety',
                                    data: anxietyScores,
                                    borderColor: '#F39C12',
                                    backgroundColor: 'rgba(243, 156, 18, 0.1)',
                                    borderWidth: 2,
                                    tension: 0.3,
                                    fill: true
                                },
                                {
                                    label: 'Stress',
                                    data: stressScores,
                                    borderColor: '#3498DB',
                                    backgroundColor: 'rgba(52, 152, 219, 0.1)',
                                    borderWidth: 2,
                                    tension: 0.3,
                                    fill: true
                                }
                            ]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    position: 'bottom',
                                    labels: {
                                        padding: 20,
                                        font: {
                                            size: 12
                                        }
                                    }
                                },
                                tooltip: {
                                    mode: 'index',
                                    intersect: false
                                }
                            },
                            scales: {
                                x: {
                                    grid: {
                                        display: false
                                    },
                                    ticks: {
                                        font: {
                                            size: 11
                                        }
                                    }
                                },
                                y: {
                                    beginAtZero: true,
                                    grid: {
                                        borderDash: [5, 5]
                                    },
                                    ticks: {
                                        font: {
                                            size: 11
                                        }
                                    },
                                    title: {
                                        display: true,
                                        text: 'Score',
                                        font: {
                                            size: 12,
                                            weight: 'bold'
                                        }
                                    }
                                }
                            },
                            interaction: {
                                intersect: false,
                                mode: 'nearest'
                            },
                            elements: {
                                point: {
                                    radius: 4,
                                    hoverRadius: 6
                                }
                            }
                        }
                    });
                }
            }
        }
        
        function exportHistory() {
            window.location.href = '${pageContext.request.contextPath}/self-assessment/export/history-csv';
        }

        function showExportSuccess() {
            const alertDiv = document.createElement('div');
            alertDiv.className = 'alert alert-success alert-dismissible fade show position-fixed';
            alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 1050; min-width: 300px;';
            alertDiv.innerHTML = `
                <i class="fas fa-check-circle me-2"></i>
                <strong>Export Successful!</strong> Your assessment history has been downloaded.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            document.body.appendChild(alertDiv);
            
            setTimeout(() => {
                if (alertDiv.parentNode) {
                    alertDiv.parentNode.removeChild(alertDiv);
                }
            }, 5000);
        }
        
        function printHistory() {
            window.print();
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            calculateTimeSpan();
            
            <c:if test="${assessments.size() > 1}">
                initializeTrendChart();
            </c:if>
            
            const printStyles = `
                @media print {
                    .btn, .export-btn, .print-btn, .header {
                        display: none !important;
                    }
                    body {
                        background: white !important;
                        color: black !important;
                    }
                    .container {
                        max-width: 100% !important;
                        padding: 20px !important;
                        margin: 0 !important;
                    }
                    .timeline-item {
                        break-inside: avoid;
                        border: 1px solid #ddd !important;
                        box-shadow: none !important;
                    }
                    .comparison-card {
                        break-inside: avoid;
                        border: 1px solid #ddd !important;
                        box-shadow: none !important;
                    }
                    h1, h2, h3, h4, h5, h6 {
                        color: black !important;
                    }
                }
            `;
            
            const styleSheet = document.createElement("style");
            styleSheet.type = "text/css";
            styleSheet.innerText = printStyles;
            document.head.appendChild(styleSheet);
        });
    </script>
</body>
</html>