<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String[] questions = (String[]) request.getAttribute("questions");
    String[] questionTypes = (String[]) request.getAttribute("questionTypes");
    Integer totalQuestions = (Integer) request.getAttribute("totalQuestions");
    
    if (questions == null || totalQuestions == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DASS-21 Assessment - SmileSpace</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
        
        .container {
            width: 90%;
            max-width: 1000px;
            margin: 40px auto;
        }
        
        .assessment-header {
            margin-bottom: 30px;
        }
        
        .assessment-title {
            font-size: 36px;
            font-weight: 600;
            margin-bottom: 5px;
            color: #6B4F36;
        }
        
        .assessment-subtitle {
            font-size: 20px;
            color: #CF8224;
            font-weight: 400;
            margin-bottom: 25px;
        }
        
        .warning-box {
            background-color: #FFE5E5;
            border: 2px solid #FFB3B3;
            border-radius: 12px;
            padding: 15px 20px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .warning-text {
            color: #C53030;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            font-size: 16px;
        }
        
        .question-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0px 4px 8px rgba(0,0,0,0.1);
        }
        
        .question-table th {
            background-color: #FFE8B4;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            font-size: 18px;
            color: #6B4F36;
            border-bottom: 2px solid #E6C68D;
        }
        
        .question-table td {
            padding: 20px 15px;
            border-bottom: 1px solid #E6C68D;
            background-color: #FFF8E1;
        }
        
        .question-number {
            color: #CF8224;
            font-weight: bold;
            font-size: 20px;
            width: 50px;
            text-align: center;
        }
        
        .question-text {
            color: #6B4F36;
            font-size: 18px;
            line-height: 1.5;
        }
        
        .question-type {
            display: none;
        }
        
        .answer-options {
            display: flex;
            gap: 10px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .option-label {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            padding: 10px 15px;
            border-radius: 8px;
            transition: all 0.3s ease;
            border: 2px solid #E6C68D;
            background: white;
            min-width: 80px;
            justify-content: center;
            font-weight: 500;
        }
        
        .option-label:hover {
            background: #FFF3C8;
            border-color: #CF8224;
        }
        
        .option-label.selected {
            background: #CF8224;
            color: white;
            border-color: #CF8224;
        }
        
        .option-radio {
            display: none;
        }
        
        .option-text {
            font-size: 14px;
        }
        
        .action-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            gap: 20px;
        }
        
        .btn {
            padding: 14px 32px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            display: inline-block;
            min-width: 150px;
            text-align: center;
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
        
        .btn-primary {
            background: #CF8224;
            color: white;
        }
        
        .btn-primary:hover {
            background: #B3711E;
            transform: translateY(-2px);
            box-shadow: 0px 4px 8px rgba(0,0,0,0.15);
        }
        
        .btn-primary:disabled {
            background: #E6C68D;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        .error-message {
            background: #FDEDED;
            border: 2px solid #F5B7B1;
            color: #721c24;
            padding: 15px;
            border-radius: 10px;
            margin: 20px auto;
            display: none;
            text-align: center;
        }
        
        .error-message.show {
            display: block;
        }
        
        @media (max-width: 768px) {
            .container {
                width: 95%;
                margin: 20px auto;
            }
            
            .question-table {
                display: block;
                overflow-x: auto;
            }
            
            .answer-options {
                flex-direction: column;
                gap: 10px;
                align-items: center;
            }
            
            .option-label {
                width: 100%;
            }
            
            .action-buttons {
                flex-direction: column;
                gap: 15px;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <a href="<%= request.getContextPath() %>/dashboard" class="home-link">
            <div class="logo">
                <i class="fas fa-home"></i>
                SmileSpace
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/self-assessment/my-history" class="btn-secondary" 
           style="padding: 10px 20px; text-decoration: none; display: flex; align-items: center; gap: 8px;">
            <i class="fas fa-history"></i> My History
        </a>
    </div>
    
    <div class="container">
        <form id="assessmentForm" action="${pageContext.request.contextPath}/self-assessment/submit" method="post" onsubmit="return validateForm()">
            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </c:if>
            
            <input type="hidden" id="totalQuestionsHidden" value="<%= totalQuestions %>">
            
            <div class="assessment-header">
                <h1 class="assessment-title">DASS-21 Assessment</h1>
                <p class="assessment-subtitle">Please read each statement and select the option that applies to you over the past week</p>
            </div>
            
            <c:if test="${not empty success}">
                <div class="error-message show" style="background: #D4EDDA; border-color: #C3E6CB; color: #155724;">
                    <i class="fas fa-check-circle"></i> ${success}
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="error-message show">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>
            
            <div id="errorMessage" class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                <span id="errorText"></span>
            </div>
            
            <div class="warning-box">
                <div class="warning-text">
                    <span>⚠️</span>
                    All answers will be saved. Once submitted, you cannot change your answers.
                </div>
            </div>
            
            <table class="question-table">
                <thead>
                    <tr>
                        <th style="width: 50px;">#</th>
                        <th>Question</th>
                        <th style="width: 300px;">Answer (Select one)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="question" items="${questions}" varStatus="status">
                        <tr>
                            <td class="question-number">${status.index + 1}</td>
                            <td>
                                <div class="question-text">${question}</div>
                                <div class="question-type">
                                    <c:choose>
                                        <c:when test="${questionTypes[status.index] == 'depression'}">
                                            <i class="fas fa-circle" style="color: #F39C12;"></i> Depression
                                        </c:when>
                                        <c:when test="${questionTypes[status.index] == 'anxiety'}">
                                            <i class="fas fa-circle" style="color: #E74C3C;"></i> Anxiety
                                        </c:when>
                                        <c:when test="${questionTypes[status.index] == 'stress'}">
                                            <i class="fas fa-circle" style="color: #3498DB;"></i> Stress
                                        </c:when>
                                    </c:choose>
                                </div>
                            </td>
                            <td>
                                <div class="answer-options">
                                    <label class="option-label" data-question="${status.index}" data-answer="0">
                                        <input type="radio" name="answer${status.index}" value="0" class="option-radio" required>
                                        <span class="option-text">0 - Never</span>
                                    </label>
                                    <label class="option-label" data-question="${status.index}" data-answer="1">
                                        <input type="radio" name="answer${status.index}" value="1" class="option-radio" required>
                                        <span class="option-text">1 - Sometimes</span>
                                    </label>
                                    <label class="option-label" data-question="${status.index}" data-answer="2">
                                        <input type="radio" name="answer${status.index}" value="2" class="option-radio" required>
                                        <span class="option-text">2 - Often</span>
                                    </label>
                                    <label class="option-label" data-question="${status.index}" data-answer="3">
                                        <input type="radio" name="answer${status.index}" value="3" class="option-radio" required>
                                        <span class="option-text">3 - Almost Always</span>
                                    </label>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                    <i class="fas fa-times"></i> Cancel
                </a>
                <button type="submit" class="btn btn-primary" id="submitBtn" disabled>
                    <i class="fas fa-check-circle"></i> Submit Assessment
                </button>
            </div>
        </form>
    </div>
    
    <script>
    const totalQuestions = parseInt(document.getElementById('totalQuestionsHidden').value) || 21;
    let answeredCount = 0;
    
    document.addEventListener('DOMContentLoaded', function() {
        const optionLabels = document.querySelectorAll('.option-label');
        
        optionLabels.forEach(label => {
            label.addEventListener('click', function(e) {
                const questionIndex = parseInt(this.getAttribute('data-question'));
                const questionRow = this.closest('tr');
                const allOptions = questionRow.querySelectorAll('.option-label');
                
                allOptions.forEach(option => {
                    option.classList.remove('selected');
                });
                
                this.classList.add('selected');
                
                const radio = this.querySelector('input[type="radio"]');
                radio.checked = true;
                
                updateProgress();
            });
            
            const radio = label.querySelector('input[type="radio"]');
            if (radio) {
                radio.addEventListener('change', function() {
                    const parentLabel = this.closest('.option-label');
                    const questionRow = parentLabel.closest('tr');
                    const allOptions = questionRow.querySelectorAll('.option-label');
                    
                    allOptions.forEach(option => {
                        option.classList.remove('selected');
                    });
                    
                    parentLabel.classList.add('selected');
                    updateProgress();
                });
            }
        });
        
        updateProgress();
    });
    
    function updateProgress() {
        answeredCount = 0;
        
        const allRadios = document.querySelectorAll('.option-radio:checked');
        answeredCount = allRadios.length;
        
        const submitBtn = document.getElementById('submitBtn');
        
        if (submitBtn) {
            if (answeredCount === totalQuestions) {
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<i class="fas fa-check-circle"></i> All Questions Answered - Submit Now';
                submitBtn.style.backgroundColor = '#27AE60';
            } else {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-check-circle"></i> Submit Assessment';
                submitBtn.style.backgroundColor = '#CF8224';
            }
        }
    }
    
    function validateForm() {
        const answeredRadios = document.querySelectorAll('.option-radio:checked');
        
        if (answeredRadios.length < totalQuestions) {
            const unanswered = totalQuestions - answeredRadios.length;
            
            const errorMessage = document.getElementById('errorMessage');
            const errorText = document.getElementById('errorText');
            
            errorText.textContent = `Please answer all questions. You have ${unanswered} unanswered question(s).`;
            errorMessage.classList.add('show');
            
            errorMessage.scrollIntoView({ behavior: 'smooth', block: 'center' });
            
            highlightUnansweredQuestions();
            
            return false;
        }
        
        const submitBtn = document.getElementById('submitBtn');
        if (submitBtn) {
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Submitting...';
        }
        
        return true;
    }
    
    function highlightUnansweredQuestions() {
        document.querySelectorAll('.question-table tr').forEach(row => {
            row.style.backgroundColor = '';
            row.style.borderLeft = '';
        });
        
        for (let i = 0; i < totalQuestions; i++) {
            const radio = document.querySelector(`input[name="answer${i}"]:checked`);
            if (!radio) {
                const questionRow = document.querySelectorAll('.question-table tr')[i + 1];
                if (questionRow) {
                    questionRow.style.backgroundColor = '#FFE5E5';
                    questionRow.style.borderLeft = '4px solid #E74C3C';
                    
                    if (i === 0) {
                        questionRow.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                }
            }
        }
    }
    
    function saveProgressToLocalStorage() {
        if (typeof(Storage) !== "undefined") {
            const answers = {};
            for (let i = 0; i < totalQuestions; i++) {
                const radio = document.querySelector(`input[name="answer${i}"]:checked`);
                if (radio) {
                    answers[i] = radio.value;
                }
            }
            
            const progressData = {
                answers: answers,
                answeredCount: answeredCount,
                timestamp: new Date().getTime()
            };
            
            localStorage.setItem('dassAssessment_progress', JSON.stringify(progressData));
        }
    }
    
    function loadProgressFromLocalStorage() {
        if (typeof(Storage) !== "undefined") {
            const savedProgress = localStorage.getItem('dassAssessment_progress');
            if (savedProgress) {
                try {
                    const progressData = JSON.parse(savedProgress);
                    const answers = progressData.answers;
                    
                    for (const questionIndex in answers) {
                        const radio = document.querySelector(`input[name="answer${questionIndex}"][value="${answers[questionIndex]}"]`);
                        if (radio) {
                            radio.checked = true;
                            const label = radio.closest('.option-label');
                            if (label) {
                                const questionRow = label.closest('tr');
                                const allOptions = questionRow.querySelectorAll('.option-label');
                                allOptions.forEach(option => {
                                    option.classList.remove('selected');
                                });
                                label.classList.add('selected');
                            }
                        }
                    }
                    
                    updateProgress();
                } catch (e) {
                    console.error("Error loading progress from localStorage:", e);
                }
            }
        }
    }
    
    setInterval(saveProgressToLocalStorage, 5000);
    
    window.addEventListener('load', function() {
        setTimeout(loadProgressFromLocalStorage, 500);
    });
    
    window.addEventListener('beforeunload', function() {
        const submitBtn = document.getElementById('submitBtn');
        if (submitBtn && !submitBtn.disabled && answeredCount !== totalQuestions) {
            saveProgressToLocalStorage();
        } else if (answeredCount === totalQuestions) {
            localStorage.removeItem('dassAssessment_progress');
        }
    });
</script>
</body>
</html>