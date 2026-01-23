<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="smilespace.model.LearningModule" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String userFullName = (String) session.getAttribute("userFullName");
    if (userFullName == null) {
        userFullName = "Guest Student";
    }
    
    String contextPath = request.getContextPath();
    if (contextPath == null || contextPath.isEmpty()) {
        contextPath = "";
    }
    
    LearningModule learningModule = (LearningModule) request.getAttribute("module");
    String moduleId = "stress";
    String moduleTitle = "Stress Management";
    String moduleCategory = "Stress Management";
    
    if (learningModule != null) {
        moduleId = learningModule.getId();
        moduleTitle = learningModule.getTitle();
        moduleCategory = learningModule.getCategory();
    }
    
    Integer currentTopicObj = (Integer) request.getAttribute("currentTopic");
    int currentTopic = (currentTopicObj != null) ? currentTopicObj : 1;
    
    Boolean isCompleteObj = (Boolean) request.getAttribute("isComplete");
    boolean isComplete = (isCompleteObj != null) ? isCompleteObj : false;
    
    String topicTitle = (String) request.getAttribute("topicTitle");
    String aiMessage = (String) request.getAttribute("aiMessage");
    String mainContent = (String) request.getAttribute("mainContent");
    String exampleContent = (String) request.getAttribute("exampleContent");
    
    if (topicTitle == null) {
        String[] topicTitles = {
            "Understanding " + moduleCategory,
            "Coping Strategies for " + moduleCategory,
            "Maintaining Long-Term " + moduleCategory
        };
        topicTitle = topicTitles[currentTopic-1];
    }
    
    if (aiMessage == null) {
        String[] aiMessages = {
            "Let's talk about " + moduleCategory.toLowerCase() + " today. Understanding this topic is the first step toward improvement.",
            "Now that you understand the basics, let's explore practical ways to manage " + moduleCategory.toLowerCase() + " effectively.",
            "Great! Let's discuss maintaining a healthy approach to " + moduleCategory.toLowerCase() + " over the long term."
        };
        aiMessage = aiMessages[currentTopic-1];
    }
    
    if (mainContent == null) {
        if (learningModule != null && learningModule.getContentOutline() != null) {
            String[] outlines = learningModule.getContentOutlineArray();
            if (outlines.length >= currentTopic) {
                mainContent = outlines[currentTopic-1];
            } else if (outlines.length > 0) {
                mainContent = outlines[0];
            } else {
                mainContent = "Content coming soon for " + moduleCategory.toLowerCase() + ".";
            }
        } else {
            String[] mainContents = {
                "Understanding " + moduleCategory.toLowerCase() + " is crucial for mental wellness. This module will help you identify key aspects and develop awareness.",
                "Practical strategies can significantly improve your ability to manage " + moduleCategory.toLowerCase() + ". Practice makes progress.",
                "Building lasting habits and resilience is key for sustainable " + moduleCategory.toLowerCase() + " management."
            };
            mainContent = mainContents[currentTopic-1];
        }
    }
    
    if (exampleContent == null) {
        if (learningModule != null && learningModule.getLearningGuide() != null) {
            String[] guides = learningModule.getLearningGuideArray();
            if (guides.length >= currentTopic) {
                exampleContent = guides[currentTopic-1];
            } else if (guides.length > 0) {
                exampleContent = guides[0];
            } else {
                exampleContent = "Examples and practical applications will be provided.";
            }
        } else {
            String[] exampleContents = {
                "For example, many people experience " + moduleCategory.toLowerCase() + " without recognizing the early signs. Awareness is the first step to management.",
                "Try implementing one strategy this week and observe its effects on your daily experience of " + moduleCategory.toLowerCase() + ".",
                "Creating a personalized wellness plan can help maintain progress in managing " + moduleCategory.toLowerCase() + " over time."
            };
            exampleContent = exampleContents[currentTopic-1];
        }
    }
    
    String learningTip = null;
    if (learningModule != null && learningModule.getLearningTip() != null) {
        learningTip = learningModule.getLearningTip();
    }
    
    String[] topicTips = new String[3];
    if (learningTip != null && !learningTip.isEmpty()) {
        topicTips[0] = learningTip;
        topicTips[1] = learningTip;
        topicTips[2] = learningTip;
    } else {
        topicTips[0] = "Practice the 5-5-5 breathing technique: Breathe in for 5 seconds, hold for 5 seconds, breathe out for 5 seconds.";
        topicTips[1] = "Use the 'two-minute rule': If a task takes less than two minutes, do it immediately.";
        topicTips[2] = "Set aside 15 minutes daily for 'me time' - no screens, just relaxation.";
    }
    
    int widthPercent = 0;
    if (!isComplete) {
        widthPercent = (currentTopic * 100) / 3;
    } else {
        widthPercent = 100;
    }
    
    java.util.List<smilespace.model.LearningModule> suggestedModules = 
        (java.util.List<smilespace.model.LearningModule>) request.getAttribute("suggestedModules");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= moduleTitle %> - Learning Mode - SmileSpace</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: #FFF8E8;
            font-family: Arial, sans-serif;
            color: #6B4F36;
            min-height: 100vh;
        }
        .header {
            background: #FFF3C8;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(107, 79, 54, 0.1);
        }
        .logo h1 {
            color: #D7923B;
            font-size: 32px;
        }
        .nav-buttons {
            display: flex;
            gap: 15px;
        }
        .nav-btn {
            background: #D7923B;
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            transition: background 0.3s;
            border: none;
            cursor: pointer;
        }
        .nav-btn:hover {
            background: #CF8224;
        }
        .nav-btn.secondary {
            background: white;
            color: #D7923B;
            border: 2px solid #D7923B;
        }
        .nav-btn.secondary:hover {
            background: #FFF3C8;
        }
        .learn-container {
            padding: 40px;
            max-width: 1200px;
            margin: 0 auto;
            min-height: calc(100vh - 100px);
        }
        .learning-header {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .learning-header h2 {
            color: #D7923B;
            font-size: 28px;
            margin-bottom: 5px;
        }
        .progress-bar {
            width: 100%;
            height: 8px;
            background: #E8D4B9;
            border-radius: 4px;
            margin: 15px 0;
            overflow: hidden;
        }
        .progress-fill {
            height: 100%;
            background: #D7923B;
            border-radius: 4px;
            transition: width 0.5s;
        }
        .topic-indicator {
            display: flex;
            justify-content: space-between;
            color: #8B7355;
            font-size: 14px;
        }
        .topic-nav-dots {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin: 20px 0;
        }
        .topic-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #E8D4B9;
            cursor: pointer;
        }
        .topic-dot.active {
            background: #D7923B;
        }
        
        .chat-section {
            display: flex;
            flex-direction: column;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .chat-header {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .chat-avatar {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #D7923B, #CF8224);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 28px;
        }
        
        .chat-info h3 {
            color: #D7923B;
            font-size: 20px;
            margin-bottom: 5px;
        }
        
        .chat-info p {
            color: #8B7355;
            font-size: 14px;
        }
        
        .ai-message-box {
            background: linear-gradient(135deg, #FFF3C8, #FFE9A9);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            border-left: 5px solid #D7923B;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .ai-message-box .ai-avatar {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .ai-avatar-icon {
            width: 50px;
            height: 50px;
            background: #D7923B;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
        }
        
        .ai-name {
            font-weight: bold;
            color: #D7923B;
            font-size: 18px;
        }
        
        .ai-message {
            color: #6B4F36;
            font-size: 16px;
            line-height: 1.6;
        }
        
        .content-section {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .content-box {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .content-box h3 {
            color: #D7923B;
            font-size: 20px;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #FFF3C8;
        }
        
        .content-text {
            color: #6B4F36;
            line-height: 1.8;
            font-size: 16px;
        }
        
        .tip-box {
            background: #E8F4FD;
            border-left: 4px solid #4A90E2;
            padding: 15px;
            margin: 20px 0;
            border-radius: 0 10px 10px 0;
        }
        
        .tip-title {
            color: #4A90E2;
            font-weight: bold;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .example-box {
            background: #F0F8F0;
            border: 2px dashed #4CAF50;
            padding: 20px;
            margin: 20px 0;
            border-radius: 10px;
        }
        
        .example-title {
            color: #4CAF50;
            font-weight: bold;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .chat-input-area {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .input-wrapper {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }
        
        .chat-input {
            flex: 1;
            padding: 12px 20px;
            border: 2px solid #E8D4B9;
            border-radius: 25px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s;
        }
        
        .chat-input:focus {
            border-color: #D7923B;
        }
        
        .send-button {
            padding: 12px 25px;
            background: #D7923B;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .send-button:hover {
            background: #CF8224;
            transform: translateY(-2px);
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .action-btn {
            padding: 12px 20px;
            background: white;
            color: #D7923B;
            border: 2px solid #D7923B;
            border-radius: 25px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .action-btn:hover {
            background: #D7923B;
            color: white;
        }
        
        .action-btn.next {
            background: #4CAF50;
            color: white;
            border-color: #4CAF50;
        }
        
        .action-btn.next:hover {
            background: #45a049;
            border-color: #45a049;
        }
        
        .chat-messages-container {
            max-height: 300px;
            overflow-y: auto;
            margin-bottom: 20px;
            padding: 15px;
            background: #f9f9f9;
            border-radius: 10px;
            border: 1px solid #E8D4B9;
        }
        
        .message {
            margin-bottom: 15px;
            padding: 12px 15px;
            border-radius: 10px;
            max-width: 80%;
        }
        
        .message.ai {
            background: white;
            border-left: 4px solid #D7923B;
            margin-right: auto;
        }
        
        .message.user {
            background: #D7923B;
            color: white;
            margin-left: auto;
        }
        
        .message-header {
            font-weight: bold;
            margin-bottom: 8px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .message-header.ai {
            color: #D7923B;
        }
        
        .message-header.user {
            color: white;
        }
        
        .message-content {
            line-height: 1.6;
        }
        
        .message-icon {
            font-size: 14px;
        }
        
        .tip-message {
            background: #E8F4FD;
            border-left: 4px solid #4A90E2;
            padding: 12px 15px;
            margin: 8px 0;
            border-radius: 0 8px 8px 0;
        }
        
        .example-message {
            background: #F0F8F0;
            border: 1px solid #4CAF50;
            padding: 12px 15px;
            margin: 8px 0;
            border-radius: 8px;
        }
        
        .message-empty-state {
            text-align: center;
            color: #8B7355;
            font-style: italic;
            padding: 30px;
            font-size: 14px;
        }
        
        .navigation-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #E8D4B9;
        }
        
        .module-complete {
            text-align: center;
            padding: 50px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-top: 30px;
        }
        
        .module-complete h2 {
            color: #4CAF50;
            font-size: 32px;
            margin-bottom: 20px;
        }
        
        .module-complete p {
            color: #6B4F36;
            font-size: 18px;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .completion-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 30px;
        }
        
        .resources-section {
            background: #FFF3C8;
            border-radius: 15px;
            padding: 25px;
            margin-top: 30px;
            text-align: left;
        }
        
        .resources-section h3 {
            color: #D7923B;
            font-size: 20px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .resource-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .resource-item {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .resource-item h4 {
            color: #CF8224;
            margin-bottom: 10px;
        }
        
        .resource-item p {
            color: #8B7355;
            font-size: 14px;
            line-height: 1.5;
        }
        
        .suggested-modules-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-top: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .suggested-modules-section h3 {
            color: #D7923B;
            font-size: 20px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .suggested-modules-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .suggested-module-card {
            background: white;
            border: 2px solid #E8D4B9;
            border-radius: 12px;
            padding: 20px;
            transition: all 0.3s;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        
        .suggested-module-card:hover {
            transform: translateY(-5px);
            border-color: #D7923B;
            box-shadow: 0 10px 25px rgba(215, 146, 59, 0.2);
            text-decoration: none;
            color: inherit;
        }
        
        .suggested-module-header {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .suggested-module-icon {
            width: 50px;
            height: 50px;
            background: #FFF3C8;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #D7923B;
            font-size: 20px;
            flex-shrink: 0;
        }
        
        .suggested-module-info h4 {
            color: #D7923B;
            font-size: 16px;
            margin-bottom: 5px;
            line-height: 1.3;
        }
        
        .suggested-module-tags {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 8px;
        }
        
        .module-tag {
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 10px;
            font-weight: 500;
        }
        
        .tag-category {
            background: #FFF3C8;
            color: #8B7355;
        }
        
        .tag-level {
            background: #E8F4FD;
            color: #2C6FB7;
        }
        
        .suggested-module-description {
            color: #8B7355;
            font-size: 14px;
            line-height: 1.5;
            margin-top: 10px;
        }
        
        .suggested-module-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #E8D4B9;
            font-size: 12px;
            color: #8B7355;
        }
        
        .start-module-btn {
            background: #D7923B;
            color: white;
            border: none;
            border-radius: 20px;
            padding: 8px 15px;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .start-module-btn:hover {
            background: #CF8224;
        }
        
        @media (max-width: 768px) {
            .learn-container {
                padding: 20px;
            }
            
            .header {
                padding: 15px 20px;
                flex-direction: column;
                gap: 15px;
            }
            
            .nav-buttons {
                width: 100%;
                justify-content: center;
            }
            
            .action-buttons {
                justify-content: center;
            }
            
            .action-btn {
                flex: 1;
                min-width: 120px;
                justify-content: center;
            }
            
            .navigation-buttons {
                flex-direction: column;
                gap: 15px;
            }
            
            .resource-list {
                grid-template-columns: 1fr;
            }
            
            .suggested-modules-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">
            <h1>SmileSpace</h1>
        </div>
        <div class="nav-buttons">
            <a href="<%= contextPath %>/dashboard" class="nav-btn">
                <i class="fas fa-arrow-left"></i> Dashboard
            </a>
        </div>
    </div>

    <div class="learn-container">
        <% if (!isComplete) { %>
            <div class="learning-header">
                <h2>Learning Mode: <%= moduleTitle %></h2>
                <div class="topic-indicator">
                    <span>Topic <%= currentTopic %> of 3 : <%= topicTitle %></span>
                    <span><%= moduleCategory %> Module</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: %<%= widthPercent %>%"></div>
                </div>
                <div class="topic-nav-dots">
                    <% for (int i = 1; i <= 3; i++) { %>
                        <div class="topic-dot <%= (i == currentTopic) ? "active" : "" %>" 
                            onclick="location.href='<%= contextPath %>/ai/learn/<%= moduleId %>/interactive?topic=<%= i %>'"></div>
                    <% } %>
                </div>
            </div>


            <div class="chat-section">
                <div class="ai-message-box">
                    <div class="ai-avatar">
                        <div class="ai-avatar-icon">
                            <i class="fas fa-robot"></i>
                        </div>
                        <div class="ai-name">AI Assistant</div>
                    </div>
                    <div class="ai-message">
                        Hi <%= userFullName %>! <%= aiMessage %> What would you like to know about <%= topicTitle.toLowerCase() %>?
                        <br><br>
                        <strong>Try asking:</strong>
                        <ul style="margin-top: 10px; padding-left: 20px;">
                            <li>"What is <%= topicTitle.toLowerCase() %>?"</li>
                            <li>"Can you give me an example?"</li>
                            <li>"What's a quick tip?"</li>
                        </ul>
                    </div>
                </div>

                <div class="content-section">
                    <div class="content-box">
                        <h3>Key Concepts</h3>
                        <div class="content-text">
                            <%= mainContent %>
                        </div>
                        
                        <div class="tip-box">
                            <div class="tip-title">
                                <i class="fas fa-lightbulb"></i> Quick Tip
                            </div>
                            <div class="content-text">
                                <%= topicTips[currentTopic-1] %>
                            </div>
                        </div>
                        
                        <div class="example-box">
                            <div class="example-title">
                                <i class="fas fa-eye"></i> Example
                            </div>
                            <div class="content-text">
                                <%= exampleContent %>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="chat-messages-container" id="chatMessages">
                    <div class="message-empty-state" id="emptyState">
                        <i class="fas fa-comment-alt" style="font-size: 24px; margin-bottom: 10px; color: #D7923B;"></i><br>
                        No messages yet. Type a question or use the buttons below to start the conversation!
                    </div>
                </div>

                <div class="chat-input-area">
                    <div class="input-wrapper">
                        <input type="text" 
                               class="chat-input" 
                               id="messageInput"
                               placeholder="Ask about <%= topicTitle.toLowerCase() %>..."
                               onkeypress="handleKeyPress(event)">
                        <button class="send-button" onclick="sendMessage()">
                            <i class="fas fa-paper-plane"></i> Send
                        </button>
                    </div>
                    
                    <div class="action-buttons">
                        <button class="action-btn" onclick="explainMore()">
                            <i class="fas fa-info-circle"></i> Explain More
                        </button>
                        <button class="action-btn" onclick="showExample()">
                            <i class="fas fa-chart-bar"></i> Show Example
                        </button>
                        <button class="action-btn" onclick="showTip()">
                            <i class="fas fa-lightbulb"></i> Show Tip
                        </button>
                        <% if (currentTopic < 3) { %>
                            <button class="action-btn next" onclick="nextTopic()">
                                Next Topic <i class="fas fa-arrow-right"></i>
                            </button>
                        <% } else { %>
                            <button class="action-btn next" onclick="completeModule()">
                                Complete Module <i class="fas fa-check"></i>
                            </button>
                        <% } %>
                    </div>
                </div>
            </div>

        <% } else { %>
            <div class="module-complete">
                <h2><i class="fas fa-trophy"></i> Great job!</h2>
                <p>You've just mastered the basics of the <%= moduleTitle %> — you're one step closer to better mental wellness!</p>
                
                <div class="resources-section">
                    <h3><i class="fas fa-book-open"></i> Additional Resources</h3>
                    <p>Continue your learning journey with these additional resources:</p>
                    
                    <div class="resource-list">
                        <% if (learningModule != null && learningModule.getKeyPoints() != null) {
                            String[] keyPoints = learningModule.getKeyPointsArray();
                            for (int i = 0; i < Math.min(keyPoints.length, 3); i++) { %>
                                <div class="resource-item">
                                    <h4>Key Insight <%= i+1 %></h4>
                                    <p><%= keyPoints[i] %></p>
                                </div>
                            <% }
                        } else { %>
                            <div class="resource-item">
                                <h4>Managing <%= moduleCategory %> in Daily Life</h4>
                                <p>Learn how to identify sources of everyday challenges, and build healthy habits to manage them effectively.</p>
                            </div>
                            <div class="resource-item">
                                <h4>Building Resilience</h4>
                                <p>Understand how to develop long-term resilience for better mental wellness.</p>
                            </div>
                            <div class="resource-item">
                                <h4>Advanced Techniques</h4>
                                <p>Step-by-step guide to practicing advanced techniques for sustained improvement.</p>
                            </div>
                        <% } %>
                    </div>
                </div>

                <div class="suggested-modules-section">
                    <h3><i class="fas fa-book-reader"></i> Continue Your Learning Journey</h3>
                    <p style="color: #8B7355; margin-bottom: 20px;">
                        Explore more modules in <strong><%= moduleCategory %></strong> to deepen your understanding:
                    </p>
                    
                    <div style="text-align: center; margin-top: 25px;">
                        <a href="<%= contextPath %>/ai/learn?category=<%= java.net.URLEncoder.encode(moduleCategory, "UTF-8") %>" 
                           class="nav-btn secondary" style="display: inline-flex;">
                            <i class="fas fa-list"></i> View All <%= moduleCategory %> Modules
                        </a>
                    </div>
                </div>

                <div class="completion-buttons">
                    <a href="<%= contextPath %>/dashboard" class="nav-btn">
                        <i class="fas fa-home"></i> Return to Dashboard
                    </a>
                    <a href="<%= contextPath %>/ai/learn" class="nav-btn secondary">
                        <i class="fas fa-book"></i> Explore All Topics
                    </a>
                </div>
            </div>
        <% } %>
    </div>

    <script>
        const currentTopicNumber = <%= currentTopic %>;
        const moduleCategory = "<%= moduleCategory.toLowerCase() %>";
        const topicTitleLower = "<%= topicTitle.toLowerCase() %>";
        
        const topicExplainations = [
            "This topic covers the foundational knowledge needed to understand " + moduleCategory + " and its impact on mental wellness. Understanding these concepts is the first step toward effective management.",
            "This section covers practical techniques and approaches for managing " + moduleCategory + ". Different strategies work for different people - it's about finding what works for you.",
            "This final section focuses on creating sustainable systems for ongoing management of " + moduleCategory + ". Building lasting habits and resilience is crucial for long-term success."
        ];
        
        const topicExamples = [
            "For example, many people experience " + moduleCategory + " without recognizing the early signs. Real-world examples will help you identify patterns in your own experience.",
            "Case studies show how others have successfully implemented these strategies. Try adapting these examples to your own situation.",
            "Success stories demonstrate how consistent practice leads to lasting improvement. These examples can inspire your own journey."
        ];
        
        const topicTips = [
            "<%= topicTips[0] %>",
            "<%= topicTips[1] %>",
            "<%= topicTips[2] %>"
        ];
        
        let hasMessages = false;

        function updateEmptyState() {
            const emptyState = document.getElementById('emptyState');
            if (hasMessages && emptyState) {
                emptyState.style.display = 'none';
            }
        }

        function addMessage(sender, content, isTip = false, isExample = false) {
            const chatMessages = document.getElementById('chatMessages');
            const messageDiv = document.createElement('div');
            messageDiv.className = 'message ' + sender;
            
            const headerDiv = document.createElement('div');
            headerDiv.className = 'message-header ' + sender;
            
            const iconSpan = document.createElement('span');
            iconSpan.className = 'message-icon';
            iconSpan.innerHTML = sender === 'ai' ? '<i class="fas fa-robot"></i>' : '<i class="fas fa-user"></i>';
            
            const senderSpan = document.createElement('span');
            senderSpan.textContent = sender === 'ai' ? 'AI Assistant' : 'You';
            
            headerDiv.appendChild(iconSpan);
            headerDiv.appendChild(senderSpan);
            
            const contentDiv = document.createElement('div');
            contentDiv.className = 'message-content';
            
            if (isTip) {
                const tipDiv = document.createElement('div');
                tipDiv.className = 'tip-message';
                tipDiv.innerHTML = content;
                contentDiv.appendChild(tipDiv);
            } else if (isExample) {
                const exampleDiv = document.createElement('div');
                exampleDiv.className = 'example-message';
                exampleDiv.innerHTML = content;
                contentDiv.appendChild(exampleDiv);
            } else {
                contentDiv.textContent = content;
            }
            
            messageDiv.appendChild(headerDiv);
            messageDiv.appendChild(contentDiv);
            chatMessages.appendChild(messageDiv);
            
            hasMessages = true;
            updateEmptyState();
            
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }

        function sendMessage() {
            const input = document.getElementById('messageInput');
            const message = input.value.trim();
            
            if (message === '') return;
            
            addMessage('user', message);
            input.value = '';
            
            setTimeout(() => {
                const lowerMessage = message.toLowerCase();
                let response = '';
                
                if (currentTopicNumber === 1) {
                    if (lowerMessage.includes('what is') || lowerMessage.includes('what\'s')) {
                        response = "This is a comprehensive introduction to " + moduleCategory + " and its effects on mental health. It covers basic concepts and why understanding this topic matters.";
                    } else if (lowerMessage.includes('symptoms')) {
                        response = "Common indicators include both physical and emotional changes that affect daily functioning. Recognizing these early can help with timely management.";
                    } else if (lowerMessage.includes('causes')) {
                        response = "Various factors can contribute, including biological, psychological, and environmental elements. Understanding causes helps in developing effective strategies.";
                    } else if (lowerMessage.includes('effects')) {
                        response = "Understanding the potential impacts helps in recognizing the importance of proper management for long-term wellness.";
                    }
                } else if (currentTopicNumber === 2) {
                    if (lowerMessage.includes('strategies')) {
                        response = "There are multiple evidence-based strategies for managing " + moduleCategory + ". We'll explore several approaches to find what resonates with you.";
                    } else if (lowerMessage.includes('techniques')) {
                        response = "Different techniques work for different people. We'll help you identify which approaches might be most effective for your specific situation.";
                    } else if (lowerMessage.includes('practice')) {
                        response = "Consistent practice is key to making these strategies effective. Even 5-10 minutes daily can make a significant difference over time.";
                    } else if (lowerMessage.includes('implementation')) {
                        response = "Start by choosing one technique to implement this week. Track your progress and adjust as needed.";
                    }
                } else if (currentTopicNumber === 3) {
                    if (lowerMessage.includes('long term') || lowerMessage.includes('long-term')) {
                        response = "Sustainable management requires ongoing attention and adaptation. We'll explore how to create systems that support long-term wellness.";
                    } else if (lowerMessage.includes('habits')) {
                        response = "Building positive habits creates a foundation for lasting change. We'll help you establish routines that support your goals.";
                    } else if (lowerMessage.includes('maintenance')) {
                        response = "Regular check-ins and adjustments help maintain progress. We'll provide tools for ongoing self-assessment and adjustment.";
                    } else if (lowerMessage.includes('growth')) {
                        response = "View challenges as opportunities for growth. This mindset shift can transform how you approach " + moduleCategory + " management.";
                    }
                }
                
                if (response === '') {
                    if (lowerMessage.includes('tip')) {
                        response = topicTips[currentTopicNumber - 1];
                    } else if (lowerMessage.includes('example') || lowerMessage.includes('instance')) {
                        response = topicExamples[currentTopicNumber - 1];
                    } else if (lowerMessage.includes('explain') || lowerMessage.includes('what') || lowerMessage.includes('how')) {
                        response = topicExplainations[currentTopicNumber - 1];
                    } else {
                        const genericResponses = [
                            "I'd be happy to help with that! Would you like me to explain more, give an example, or share a tip about " + topicTitleLower + "?",
                            "That's an interesting question about " + topicTitleLower + ". Could you be more specific about what you'd like to know?",
                            "Great question! For " + topicTitleLower + ", you might find it helpful if I explain the concept, show an example, or give you a practical tip."
                        ];
                        response = genericResponses[Math.floor(Math.random() * genericResponses.length)];
                    }
                }
                
                addMessage('ai', response);
            }, 800);
        }

        function handleKeyPress(event) {
            if (event.key === 'Enter') {
                sendMessage();
                event.preventDefault();
            }
        }

        function explainMore() {
            const response = topicExplainations[currentTopicNumber - 1];
            addMessage('ai', response);
        }

        function showExample() {
            const response = topicExamples[currentTopicNumber - 1];
            addMessage('ai', response, false, true);
        }

        function showTip() {
            const response = topicTips[currentTopicNumber - 1];
            addMessage('ai', response, true, false);
        }

        function nextTopic() {
            if (currentTopicNumber < 3) {
                window.location.href = '<%= contextPath %>/ai/learn/<%= moduleId %>/interactive?topic=' + (currentTopicNumber + 1);
            }
        }

        function completeModule() {
            window.location.href = '<%= contextPath %>/ai/learn/<%= moduleId %>/interactive?complete=true';
        }

        window.addEventListener('load', function() {
            const input = document.getElementById('messageInput');
            if (input) {
                input.focus();
            }
        });
    </script>
</body>
</html>