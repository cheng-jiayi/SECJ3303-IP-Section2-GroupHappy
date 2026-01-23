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
    
    boolean quizExists = questions != null && !questions.isEmpty();
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Quiz - <%= moduleTitle %></title>
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
        
        .alert-warning {
            background: #FFF8E1;
            color: #FF8F00;
            border: 2px solid #FFECB3;
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
            background: #E3F2FD;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            border-left: 4px solid #2196F3;
        }
        
        .instruction-box h3 {
            color: #1565C0;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .quiz-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: #FFF9F0;
            padding: 20px;
            border-radius: 12px;
            border: 2px solid #F0D5B8;
            text-align: center;
        }
        
        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #F0A548;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 14px;
            color: #713C0B;
            opacity: 0.8;
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
        
        .correct-answer-badge {
            font-size: 14px;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: 600;
        }
        
        .correct-true {
            background: #C8E6C9;
            color: #2E7D32;
            border: 2px solid #2E7D32;
        }
        
        .correct-false {
            background: #FFEBEE;
            color: #C62828;
            border: 2px solid #C62828;
        }
        
        .question-text {
            color: #713C0B;
            font-size: 18px;
            line-height: 1.6;
            margin-bottom: 20px;
            padding: 15px;
            background: #FBF6EA;
            border-radius: 10px;
            border: 2px solid #F0D5B8;
        }
        
        .explanation-box {
            background: #E8F5E9;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #4CAF50;
            margin-top: 15px;
        }
        
        .explanation-label {
            font-weight: 600;
            color: #2E7D32;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .explanation-text {
            color: #388E3C;
            line-height: 1.6;
            font-size: 16px;
        }
        
        .button-group { 
            display: flex; 
            gap: 15px; 
            justify-content: center; 
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid #F0D5B8;
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
        
        .btn-back { 
            background: #F0D5B8; 
            color: #713C0B; 
            border: 2px solid #713C0B;
        }
        
        .btn-back:hover { 
            background: #713C0B; 
            color: #FBF6EA;
            transform: translateY(-2px);
            text-decoration: none;
        }
        
        .btn-edit {
            background: #F0A548;
            color: white;
        }
        
        .btn-edit:hover {
            background: #D18A2C;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(240, 165, 72, 0.25);
            text-decoration: none;
        }
        
        .btn-take-quiz {
            background: #4CAF50;
            color: white;
        }
        
        .btn-take-quiz:hover {
            background: #388E3C;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.25);
            text-decoration: none;
        }
        
        .empty-state {
            text-align: center;
            padding: 50px 30px;
            background: #FFF9F0;
            border-radius: 15px;
            border: 2px dashed #F0D5B8;
            margin: 30px 0;
        }
        
        .empty-state i {
            font-size: 60px;
            color: #F0D5B8;
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            color: #713C0B;
            margin-bottom: 15px;
        }
        
        .empty-state p {
            color: #C7A178;
            margin-bottom: 25px;
            font-size: 16px;
        }

        .top-right {
            position: absolute;
            right: 40px;
            top: 20px;
            font-size: 20px;
            font-weight: bold;
        }
        .home-link {
            text-decoration: none;
            color: inherit;
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
            
            .quiz-stats {
                grid-template-columns: 1fr;
            }
            
            .button-group {
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
    <div class="top-right">
        <a href="<%= request.getContextPath() %>/admin-module-dashboard" class="home-link">
            <div class="logo">
                <i class="fas fa-home"></i>
                SmileSpace
            </div>
        </a>
    </div>
    
    <div class="container">
        <div class="page-title">
            <h1>View Quiz for Module</h1>
            <p>Review the quiz questions and answers</p>
        </div>
        
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
                    <div class="spec-value"><%= quizExists ? totalQuestions : "0" %></div>
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
            <% if (!quizExists) { %>
            <div class="empty-state">
                <i class="fas fa-question-circle"></i>
                <h3>No Quiz Available</h3>
                <p>This module doesn't have a quiz yet. You can create one to help students test their understanding.</p>
                <div class="button-group">
                    <a href="${pageContext.request.contextPath}/create-quiz?moduleId=<%= moduleId %>" class="btn btn-edit">
                        <i class="fas fa-plus-circle"></i>
                        Create Quiz Now
                    </a>
                </div>
            </div>
            <% } else { %>
            
            <div class="instruction-box">
                <h3><i class="fas fa-info-circle"></i> Quiz Information</h3>
                <p>This is a True/False quiz with <%= totalQuestions %> questions. Each question shows the correct answer and explanation for better learning.</p>
            </div>
            
            <div class="quiz-stats">
                <div class="stat-card">
                    <div class="stat-value"><%= totalQuestions %></div>
                    <div class="stat-label">Total Questions</div>
                </div>
                <%
                    int trueCount = 0;
                    int falseCount = 0;
                    int withExplanation = 0;
                    
                    for (Question q : questions) {
                        if (q.isTrue()) trueCount++;
                        else falseCount++;
                        
                        if (q.getExplanation() != null && !q.getExplanation().trim().isEmpty()) {
                            withExplanation++;
                        }
                    }
                %>
                <div class="stat-card">
                    <div class="stat-value"><%= trueCount %></div>
                    <div class="stat-label">True Answers</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value"><%= falseCount %></div>
                    <div class="stat-label">False Answers</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value"><%= withExplanation %></div>
                    <div class="stat-label">With Explanations</div>
                </div>
            </div>
            
            <% 
            for (int i = 0; i < questions.size(); i++) { 
                Question q = questions.get(i);
                if (q.getText() == null || q.getText().trim().isEmpty()) {
                    continue; 
                }
            %>
            <div class="question-section">
                <h3 class="section-title">Question <%= i + 1 %></h3>
                
                <div class="question-card">
                    <div class="question-header">
                        <div class="question-number">Q<%= i + 1 %></div>
                        <div class="correct-answer-badge <%= q.isTrue() ? "correct-true" : "correct-false" %>">
                            <i class="fas fa-<%= q.isTrue() ? "check" : "times" %>"></i>
                            Correct Answer: <%= q.isTrue() ? "True" : "False" %>
                        </div>
                    </div>
                    
                    <div class="question-text">
                        <%= q.getText() %>
                    </div>
                    

                    <% if (q.getExplanation() != null && !q.getExplanation().trim().isEmpty()) { %>
                    <div class="explanation-box">
                        <div class="explanation-label">
                            <i class="fas fa-lightbulb"></i>
                            Explanation
                        </div>
                        <div class="explanation-text">
                            <%= q.getExplanation() %>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } %>
            
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/view-module?id=<%= moduleId %>" class="btn btn-back">
                    <i class="fas fa-arrow-left"></i>
                    Back to Module
                </a>
            </div>
            <% } %>
        </div>
    </div>
</body>
</html>