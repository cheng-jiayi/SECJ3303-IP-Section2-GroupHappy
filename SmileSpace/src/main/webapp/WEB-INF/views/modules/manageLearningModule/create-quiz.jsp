<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="smilespace.model.Question" %>
<%@ page import="smilespace.model.LearningModule" %>
<%
    LearningModule module = (LearningModule) request.getAttribute("module");
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    String moduleId = module != null ? module.getId() : "";
    String moduleTitle = module != null ? module.getTitle() : "";
    String duration = (String) request.getAttribute("duration");
    String type = (String) request.getAttribute("type");
    int totalQuestions = (Integer) request.getAttribute("totalQuestions");
    
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Create Quiz - <%= moduleTitle %></title>
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
        
        .container { 
            max-width: 1200px; 
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .page-title {
            text-align: left;
            margin: 20px 0 30px 0;
        }
        
        .page-title h1 {
            font-size: 32px;
            font-weight: 700;
            color: #F0A548;
            margin-bottom: 8px;
        }
        
        .page-title p {
            font-size: 16px;
            color: #713C0B;
            opacity: 0.9;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-success {
            background: #E8F5E9;
            color: #2E7D32;
            border: 2px solid #C8E6C9;
        }
        
        .alert-error {
            background: #FFEBEE;
            color: #C62828;
            border: 2px solid #FFCDD2;
        }
        
        .module-info {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 25px;
            border: 2px solid #F0D5B8;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .module-details h3 {
            color: #713C0B;
            margin-bottom: 5px;
            font-size: 20px;
        }
        
        .module-meta {
            display: flex;
            gap: 20px;
            color: #C7A178;
            font-size: 14px;
        }
        
        .quiz-specs {
            background: #FFF9F0;
            padding: 15px;
            border-radius: 10px;
            display: flex;
            gap: 20px;
        }
        
        .spec-item {
            text-align: center;
        }
        
        .spec-value {
            font-weight: 600;
            color: #F0A548;
            font-size: 18px;
        }
        
        .spec-label {
            font-size: 12px;
            color: #713C0B;
            opacity: 0.8;
        }
        
        .content { 
            background: white; 
            border-radius: 20px; 
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            border: 2px solid #F0D5B8;
            margin-top: 10px;
        }
        
        .instruction-box {
            background: #FFF4C8;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            border-left: 4px solid #F0A548;
        }
        
        .instruction-box h3 {
            color: #713C0B;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .instruction-box ul {
            list-style: none;
            padding-left: 10px;
        }
        
        .instruction-box li {
            margin: 8px 0;
            color: #713C0B;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        
        .instruction-box li:before {
            content: "•";
            color: #F0A548;
            font-weight: bold;
        }
        
        .progress-bar {
            margin-bottom: 30px;
        }
        
        .progress-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
        }
        
        .progress-label {
            font-weight: 600;
            color: #713C0B;
        }
        
        .progress-count {
            color: #F0A548;
            font-weight: 600;
        }
        
        .progress-track {
            height: 10px;
            background: #F0D5B8;
            border-radius: 5px;
            overflow: hidden;
        }
        
        .progress-fill {
            height: 100%;
            background: #F0A548;
            border-radius: 5px;
            transition: width 0.3s;
        }
        
        .question-section {
            margin-bottom: 40px;
        }
        
        .section-title {
            color: #713C0B;
            font-size: 22px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #F0D5B8;
        }
        
        .question-card {
            background: #FFF9F0;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            border: 2px solid #F0D5B8;
            transition: all 0.3s;
        }
        
        .question-card:hover {
            border-color: #F0A548;
            box-shadow: 0 4px 12px rgba(240, 165, 72, 0.1);
        }
        
        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .question-number {
            font-size: 18px;
            font-weight: 600;
            color: #F0A548;
            background: #FFF4C8;
            padding: 8px 15px;
            border-radius: 8px;
        }
        
        .required-badge {
            font-size: 12px;
            color: #FF4757;
            background: #FFEBEE;
            padding: 4px 10px;
            border-radius: 4px;
        }
        
        .question-label {
            font-weight: 600;
            color: #713C0B;
            margin-bottom: 10px;
            display: block;
        }
        
        .question-textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid #F0D5B8;
            border-radius: 12px;
            font-size: 15px;
            background: #FBF6EA;
            color: #713C0B;
            resize: vertical;
            min-height: 80px;
        }
        
        .question-textarea:focus {
            outline: none;
            border-color: #F0A548;
            box-shadow: 0 0 0 3px rgba(240, 165, 72, 0.2);
        }
        
        .answer-options {
            margin: 20px 0;
        }
        
        .options-label {
            font-weight: 600;
            color: #713C0B;
            margin-bottom: 15px;
            display: block;
        }
        
        .answer-select {
            width: 200px;
            padding: 12px 15px;
            border: 2px solid #F0D5B8;
            border-radius: 12px;
            font-size: 15px;
            background: white;
            color: #713C0B;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .answer-select:focus {
            outline: none;
            border-color: #F0A548;
            box-shadow: 0 0 0 3px rgba(240, 165, 72, 0.2);
        }
        
        .answer-select option {
            padding: 10px;
            background: white;
            color: #713C0B;
        }
        
        .explanation-group {
            margin-top: 20px;
        }
        
        .explanation-textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid #F0D5B8;
            border-radius: 12px;
            font-size: 15px;
            background: #FBF6EA;
            color: #713C0B;
            resize: vertical;
            min-height: 60px;
        }
        
        .explanation-textarea:focus {
            outline: none;
            border-color: #F0A548;
            box-shadow: 0 0 0 3px rgba(240, 165, 72, 0.2);
        }
        
        .help-text {
            font-size: 14px;
            color: #C7A178;
            margin-top: 5px;
        }
        
        .button-group { 
            display: flex; 
            gap: 15px; 
            justify-content: space-between; 
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid #F0D5B8;
        }
        
        .left-buttons {
            display: flex;
            gap: 15px;
        }
        
        .right-buttons {
            display: flex;
            gap: 15px;
        }
        
        .btn { 
            padding: 14px 35px; 
            border: none; 
            border-radius: 12px; 
            font-weight: 600; 
            font-size: 16px; 
            cursor: pointer; 
            transition: all 0.3s; 
            display: inline-flex;
            align-items: center;
            gap: 10px;
            min-width: 150px;
            justify-content: center;
            text-decoration: none;
        }
        
        .btn-cancel { 
            background: #F0D5B8; 
            color: #713C0B; 
            border: 2px solid #713C0B;
        }
        
        .btn-cancel:hover { 
            background: #713C0B; 
            color: #FBF6EA;
            transform: translateY(-2px);
        }
        
        .btn-preview {
            background: #4A90E2;
            color: white;
        }
        
        .btn-preview:hover {
            background: #357ABD;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(74, 144, 226, 0.25);
        }
        
        .btn-draft { 
            background: #FFF4C8; 
            color: #B88414; 
            border: 2px solid #B88414;
        }
        
        .btn-draft:hover { 
            background: #B88414; 
            color: white;
            transform: translateY(-2px);
        }
        
        .btn-submit { 
            background: #F0A548; 
            color: white; 
        }
        
        .btn-submit:hover { 
            background: #D18A2C; 
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(240, 165, 72, 0.25);
        }
                
        @media (max-width: 768px) {
            .module-info {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
            
            .quiz-specs {
                width: 100%;
                justify-content: space-around;
            }
            
            .button-group {
                flex-direction: column;
                gap: 15px;
            }
            
            .left-buttons, .right-buttons {
                flex-direction: column;
                width: 100%;
            }
            
            .btn {
                width: 100%;
            }
            
            .answer-select {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="top-right">
        <a href="<%= request.getContextPath() %>/dashboard" class="home-link">
            <div class="logo">
                <i class="fas fa-home"></i>
                SmileSpace
            </div>
        </a>
    </div>
    
    <div class="container">
        <div class="page-title">
            <h1>Create Quiz</h1>
            <p>Add 10 True/False questions to test learners' understanding</p>
        </div>
        
        <% if (success != null) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <%= success %>
        </div>
        <% } %>

        <% if (error != null) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <%= error %>
        </div>
        <% } %>
        
        <div class="module-info">
            <div class="module-details">
                <h3><%= moduleTitle %></h3>
                <div class="module-meta">
                    <span><strong>ID:</strong> <%= moduleId %></span>
                    <span><strong>Category:</strong> <%= module != null ? module.getCategory() : "" %></span>
                    <span><strong>Level:</strong> <%= module != null ? module.getLevel() : "" %></span>
                </div>
            </div>
            <div class="quiz-specs">
                <div class="spec-item">
                    <div class="spec-value"><%= totalQuestions %></div>
                    <div class="spec-label">Questions</div>
                </div>
                <div class="spec-item">
                    <div class="spec-value"><%= duration %></div>
                    <div class="spec-label">Duration</div>
                </div>
                <div class="spec-item">
                    <div class="spec-value"><%= type %></div>
                    <div class="spec-label">Type</div>
                </div>
            </div>
        </div>
        
        <div class="content">
            <div class="instruction-box">
                <h3><i class="fas fa-info-circle"></i> Quiz Creation Instructions</h3>
                <ul>
                    <li><strong>Duration:</strong> 10-15 minutes</li>
                    <li><strong>Type:</strong> True/False Quiz</li>
                    <li><strong>Questions:</strong> Exactly 10 questions required</li>
                    <li><strong>Content:</strong> Questions should test understanding of key concepts from the module</li>
                    <li><strong>Marking:</strong> Set correct answer (True or False) for each question</li>
                    <li><strong>Explanation:</strong> Provide clear explanations for better learning</li>
                </ul>
            </div>
            
            <div class="progress-bar">
                <div class="progress-info">
                    <span class="progress-label">Quiz Completion</span>
                    <span class="progress-count" id="filledCount">0/10</span>
                </div>
                <div class="progress-track">
                    <div class="progress-fill" id="progressFill" style="width: 0%"></div>
                </div>
            </div>
            
            <form action="<%= request.getContextPath() %>/create-quiz" method="POST" id="quizForm">
                <input type="hidden" name="moduleId" value="<%= moduleId %>">
                
                <% 
                for (int i = 1; i <= 10; i++) { 
                    Question q = null;
                    boolean isTrue = true; 
                    String questionText = "";
                    String explanation = "";
                    
                    if (questions != null && questions.size() >= i) {
                        q = questions.get(i-1);
                        if (q != null) {
                            isTrue = q.isTrue();
                            questionText = q.getText() != null ? q.getText() : "";
                            explanation = q.getExplanation() != null ? q.getExplanation() : "";
                        }
                    }
                %>
                <div class="question-section">
                    <h3 class="section-title">Question <%= i %></h3>
                    
                    <div class="question-card" id="question-card-<%= i %>">
                        <div class="question-header">
                            <div class="question-number">Q<%= i %></div>
                            <div class="required-badge">Required</div>
                        </div>
                        
                        <div class="form-group">
                            <label class="question-label required">Question Statement</label>
                            <textarea name="question_<%= i %>" class="question-textarea question-input" 
                                      placeholder="Enter a clear True/False statement based on module content..."
                                      data-question="<%= i %>"><%= questionText %></textarea>
                            <div class="help-text">Write a statement that can be answered as True or False</div>
                        </div>
                        
                        <div class="answer-options">
                            <label class="options-label required">Correct Answer</label>
                            <select name="correct_answer_<%= i %>" class="answer-select" data-question="<%= i %>">
                                <option value="true" <%= isTrue ? "selected" : "" %>>True</option>
                                <option value="false" <%= !isTrue ? "selected" : "" %>>False</option>
                            </select>
                        </div>
                        
                        <div class="explanation-group">
                            <label class="question-label">Explanation (Optional but recommended)</label>
                            <textarea name="explanation_<%= i %>" class="explanation-textarea" 
                                      placeholder="Explain why this answer is correct..."><%= explanation %></textarea>
                            <div class="help-text">Help learners understand why this answer is correct</div>
                        </div>
                    </div>
                </div>
                <% } %>
                
                <div class="button-group">
                    <div class="left-buttons">
                        <a href="<%= request.getContextPath() %>/admin-module-dashboard"
                            class="btn btn-cancel">
                                <i class="fas fa-times"></i>
                                Cancel
                            </a>
                    </div>
                    <div class="right-buttons">
                        <button type="submit" class="btn btn-draft" name="action" value="save">
                            <i class="fas fa-save"></i>
                            Save as Draft
                        </button>
                        <button type="submit" class="btn btn-submit" name="action" value="submit">
                            <i class="fas fa-check"></i>
                            Submit & Publish
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        console.log('=== Quiz Creator Initialized ===');
        
        const form = document.getElementById('quizForm');
        const progressFill = document.getElementById('progressFill');
        const filledCount = document.getElementById('filledCount');
        const questionInputs = document.querySelectorAll('.question-input');
        

        updateProgress();

        questionInputs.forEach(input => {
            input.addEventListener('input', updateProgress);
        });

        const submitBtn = document.querySelector('button[name="action"][value="submit"]');
        if (submitBtn) {
            submitBtn.addEventListener('click', function(e) {
                let emptyQuestions = [];
                for (let i = 1; i <= 10; i++) {
                    const questionText = document.querySelector(`textarea[name="question_${i}"]`).value.trim();
                    if (!questionText) {
                        emptyQuestions.push(i);
                    }
                }
                
                if (emptyQuestions.length > 0) {
                    e.preventDefault();
                    alert('Please fill all 10 questions before submitting. Empty questions: ' + emptyQuestions.join(', '));
                    return;
                }
                
                if (!confirm('Are you sure you want to submit this quiz?\n\nModule status will be set to "Submitted".')) {
                    e.preventDefault();
                }
            });
        }

        const draftBtn = document.querySelector('button[name="action"][value="save"]');
        if (draftBtn) {
            draftBtn.addEventListener('click', function(e) {
                let filledQuestions = 0;
                for (let i = 1; i <= 10; i++) {
                    const questionText = document.querySelector(`textarea[name="question_${i}"]`).value.trim();
                    if (questionText) {
                        filledQuestions++;
                    }
                }
                
                if (filledQuestions === 0) {
                    e.preventDefault();
                    alert('Please fill at least one question before saving as draft.');
                    return;
                }
                
                if (!confirm('Save quiz as draft? Module status will be set to "Draft".')) {
                    e.preventDefault();
                }
            });
        }
        
        function updateProgress() {
            let filled = 0;
            for (let i = 1; i <= 10; i++) {
                const questionText = document.querySelector(`textarea[name="question_${i}"]`).value.trim();
                if (questionText) {
                    filled++;
                }
            }
            
            const percentage = (filled / 10) * 100;
            if (progressFill) {
                progressFill.style.width = percentage + '%';
            }
            if (filledCount) {
                filledCount.textContent = filled + '/10';
            }
            
            for (let i = 1; i <= 10; i++) {
                const card = document.getElementById(`question-card-${i}`);
                const questionText = document.querySelector(`textarea[name="question_${i}"]`).value.trim();
                
                if (card) {
                    if (questionText) {
                        card.style.borderColor = '#4CAF50';
                        card.style.backgroundColor = '#F1F8E9';
                    } else {
                        card.style.borderColor = '#F0D5B8';
                        card.style.backgroundColor = '#FFF9F0';
                    }
                }
            }
        }
        
        const textareas = document.querySelectorAll('.question-textarea, .explanation-textarea');
        textareas.forEach(textarea => {
            textarea.addEventListener('input', function() {
                this.style.height = 'auto';
                this.style.height = (this.scrollHeight) + 'px';
            });
            
            textarea.style.height = 'auto';
            textarea.style.height = (textarea.scrollHeight) + 'px';
        });
        
        console.log('=== Initialization Complete ===');
    });
    </script>
</body>
</html>