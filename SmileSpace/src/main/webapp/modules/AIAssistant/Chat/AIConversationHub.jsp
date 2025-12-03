<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Since you don't want login, we'll handle it differently
    // Instead of redirecting to login, we'll provide a default user
    String userRole = (String) session.getAttribute("userRole");
    String userFullName = (String) session.getAttribute("userFullName");
    
    // If user is not logged in, set default values
    if (userRole == null) {
        userRole = "student"; // Default role
    }
    
    if (userFullName == null) {
        userFullName = "Guest Student"; // Default name
    }
    
    // Save to session for consistency
    session.setAttribute("userRole", userRole);
    session.setAttribute("userFullName", userFullName);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Conversation Hub - SmileSpace</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: linear-gradient(135deg, #FFF8E8 0%, #FFEED8 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #6B4F36;
            min-height: 100vh;
        }
        .header {
            background-color: #FFF3C8;
            padding: 15px 40px;
            border-bottom: 2px solid #E8D9B5;
            display: flex;
            justify-content: flex-end;  /* Changed from space-between to flex-end */
            align-items: center;
        }

        .home-link {
            text-decoration: none;  /* Remove underline */
            color: #F0A548;  /* Change color to match logo */
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
            justify-content: flex-end;
            margin-left: auto;
        }

        .home-link:hover {
            opacity: 0.7;
            text-decoration: none;  /* Ensure no underline on hover */
        }
        
        .logo-section {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .logo {
            font-size: 28px;
            font-weight: bold;
            color: #D7923B;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .page-title {
            font-size: 24px;
            color: #6B4F36;
            font-weight: 600;
            position: relative;
            padding-left: 20px;
        }
        .page-title:before {
            content: "";
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 4px;
            height: 24px;
            background: #D7923B;
            border-radius: 2px;
        }
        .user-nav {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .nav-btn {
            background: #FFF3C8;
            color: #6B4F36;
            padding: 10px 25px;
            border-radius: 25px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s;
            border: 2px solid transparent;
        }
        .nav-btn:hover {
            background: #D7923B;
            color: white;
            transform: translateY(-2px);
        }
        .nav-btn.secondary {
            background: white;
            color: #D7923B;
            border: 2px solid #D7923B;
        }
        .nav-btn.secondary:hover {
            background: #FFF3C8;
            color: #6B4F36;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 30px 20px;
        }
        .chat-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            overflow: hidden;
            margin-bottom: 40px;
        }
        .chat-header {
            background: linear-gradient(135deg, #D7923B 0%, #CF8224 100%);
            color: white;
            padding: 25px 30px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .ai-avatar {
            width: 70px;
            height: 70px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            color: #D7923B;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .chat-title {
            flex: 1;
        }
        .chat-title h1 {
            font-size: 28px;
            margin-bottom: 5px;
        }
        .chat-title p {
            opacity: 0.9;
            font-size: 16px;
        }
        .chat-status {
            background: rgba(255,255,255,0.2);
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        .chat-messages {
            height: 500px;
            padding: 30px;
            overflow-y: auto;
            background: #FAF5ED;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .message {
            max-width: 75%;
            padding: 18px;
            border-radius: 18px;
            line-height: 1.6;
            position: relative;
            animation: fadeIn 0.3s ease-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .message.ai {
            background: white;
            align-self: flex-start;
            border-bottom-left-radius: 5px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            border-left: 4px solid #D7923B;
        }
        .message.user {
            background: linear-gradient(135deg, #D7923B 0%, #CF8224 100%);
            color: white;
            align-self: flex-end;
            border-bottom-right-radius: 5px;
            box-shadow: 0 3px 10px rgba(215, 146, 59, 0.2);
        }
        .message-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            font-weight: 600;
        }
        .message-header.ai {
            color: #D7923B;
        }
        .message-header.user {
            color: white;
        }
        .message-icon {
            font-size: 14px;
        }
        .message-content {
            line-height: 1.7;
        }
        .exercise-steps {
            background: #F0F8FF;
            border-left: 4px solid #4A90E2;
            padding: 15px;
            margin: 15px 0;
            border-radius: 0 8px 8px 0;
        }
        .step-list {
            list-style: none;
            padding-left: 0;
        }
        .step-list li {
            padding: 8px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .step-number {
            width: 28px;
            height: 28px;
            background: #4A90E2;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 14px;
        }
        .response-options {
            display: flex;
            gap: 15px;
            margin-top: 15px;
            flex-wrap: wrap;
        }
        .response-btn {
            padding: 10px 20px;
            background: white;
            border: 2px solid #E8D4B9;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
            color: #6B4F36;
        }
        .response-btn:hover {
            background: #D7923B;
            color: white;
            border-color: #D7923B;
            transform: translateY(-2px);
        }
        .chat-input-area {
            padding: 25px 30px;
            background: white;
            border-top: 1px solid #E8D4B9;
            display: flex;
            gap: 15px;
        }
        .chat-input-wrapper {
            flex: 1;
            position: relative;
        }
        .chat-input {
            width: 100%;
            padding: 16px 20px;
            padding-right: 50px;
            border: 2px solid #E8D4B9;
            border-radius: 25px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s;
        }
        .chat-input:focus {
            border-color: #D7923B;
        }
        .chat-input-btn {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: #D7923B;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: none;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.3s;
        }
        .chat-input-btn:hover {
            background: #CF8224;
            transform: translateY(-50%) scale(1.05);
        }
        .quick-actions {
            display: flex;
            gap: 15px;
            padding: 0 30px 25px;
            background: white;
        }
        .quick-action-btn {
            padding: 12px 25px;
            background: #FFF3C8;
            border: 2px solid #FFE9A9;
            border-radius: 25px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            color: #6B4F36;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }
        .quick-action-btn:hover {
            background: #D7923B;
            color: white;
            border-color: #D7923B;
        }
        .chat-history {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }
        .history-title {
            color: #D7923B;
            font-size: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .history-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .history-item {
            background: #FAF5ED;
            padding: 20px;
            border-radius: 12px;
            border: 2px solid #E8D4B9;
            cursor: pointer;
            transition: all 0.3s;
        }
        .history-item:hover {
            transform: translateY(-5px);
            border-color: #D7923B;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .history-date {
            color: #8B7355;
            font-size: 13px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .history-preview {
            color: #6B4F36;
            line-height: 1.5;
            font-size: 15px;
        }
        .mood-tracker {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        .mood-title {
            color: #D7923B;
            font-size: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .mood-options {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 30px;
        }
        .mood-option {
            width: 80px;
            height: 80px;
            background: #FFF3C8;
            border-radius: 50%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
            border: 3px solid transparent;
        }
        .mood-option:hover {
            transform: scale(1.1);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .mood-option.active {
            border-color: #D7923B;
            background: #FFE9A9;
        }
        .mood-icon {
            font-size: 28px;
            margin-bottom: 8px;
        }
        .mood-label {
            font-size: 12px;
            font-weight: 600;
        }
        .end-chat-btn {
            display: block;
            width: 200px;
            margin: 40px auto;
            padding: 15px 30px;
            background: #FFF3C8;
            color: #6B4F36;
            border: 2px solid #D7923B;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all 0.3s;
        }
        .end-chat-btn:hover {
            background: #D7923B;
            color: white;
            transform: translateY(-2px);
        }
        .typing-indicator {
            display: none;
            align-items: center;
            gap: 8px;
            padding: 15px;
            background: white;
            border-radius: 18px;
            border-bottom-left-radius: 5px;
            align-self: flex-start;
            max-width: 120px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }
        .typing-dot {
            width: 8px;
            height: 8px;
            background: #D7923B;
            border-radius: 50%;
            animation: typingBounce 1.5s infinite;
        }
        .typing-dot:nth-child(2) { animation-delay: 0.2s; }
        .typing-dot:nth-child(3) { animation-delay: 0.4s; }
        
        @keyframes typingBounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }
        
        @media (max-width: 768px) {
            .header {
                padding: 15px 20px;
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            .logo-section {
                width: 100%;
                justify-content: center;
            }
            .user-nav {
                width: 100%;
                justify-content: center;
            }
            .container {
                padding: 15px;
            }
            .chat-header {
                padding: 20px;
                flex-direction: column;
                text-align: center;
                gap: 15px;
            }
            .chat-status {
                align-self: center;
            }
            .chat-messages {
                height: 400px;
                padding: 20px;
            }
            .message {
                max-width: 90%;
            }
            .quick-actions {
                padding: 20px;
                flex-direction: column;
            }
            .mood-options {
                flex-wrap: wrap;
            }
            .history-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <a href="<%= request.getContextPath() %>/modules/userManagementModule/dashboards/studentDashboard.jsp" class="home-link">
            <div class="logo">
                <i class="fas fa-home"></i>
                SmileSpace
            </div>
        </a>
    </div>
    <div class="page-title">AI Conversation Hub</div>
        <div class="user-nav">
            <a href="javascript:void(0)" onclick="goToDashboard()" class="nav-btn secondary">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="javascript:void(0)" onclick="goToLearningHub()" class="nav-btn">
                <i class="fas fa-graduation-cap"></i> Learning Hub
            </a>
        </div>
    </div>

    <!-- Main Container -->
    <div class="container">
        <!-- Chat History Section -->
        <div class="chat-history">
            <div class="history-title">
                <i class="fas fa-history"></i> Recent Conversations
            </div>
            <div class="history-grid">
                <div class="history-item" onclick="loadConversation('stress_relief')">
                    <div class="history-date">
                        <i class="far fa-calendar"></i> Today, 2:30 PM
                    </div>
                    <div class="history-preview">Stress relief breathing exercise - 5 cycles completed</div>
                </div>
                <div class="history-item" onclick="loadConversation('anxiety_talk')">
                    <div class="history-date">
                        <i class="far fa-calendar"></i> Yesterday, 4:15 PM
                    </div>
                    <div class="history-preview">Anxiety management discussion - Coping strategies</div>
                </div>
                <div class="history-item" onclick="loadConversation('sleep_tips')">
                    <div class="history-date">
                        <i class="far fa-calendar"></i> Dec 2, 9:30 PM
                    </div>
                    <div class="history-preview">Sleep improvement techniques - Bedtime routine</div>
                </div>
            </div>
        </div>

        <!-- Current Chat -->
        <div class="chat-container">
            <!-- Chat Header -->
            <div class="chat-header">
                <div class="ai-avatar">
                    <i class="fas fa-robot"></i>
                </div>
                <div class="chat-title">
                    <h1>Chat with Assistant</h1>
                    <p>Hi <%= userFullName %>, I'm here to support your mental wellbeing</p>
                </div>
                <div class="chat-status">
                    <i class="fas fa-circle" style="color:#4CAF50; font-size:10px;"></i> Available 24/7
                </div>
            </div>

            <!-- Chat Messages -->
            <div class="chat-messages" id="chatMessages">
                <!-- Initial messages -->
                <div class="message ai">
                    <div class="message-header ai">
                        <i class="fas fa-robot message-icon"></i>
                        AI Assistant
                    </div>
                    <div class="message-content">
                        Hello <%= userFullName %>! How are you feeling today?
                    </div>
                    <div class="response-options">
                        <button class="response-btn" onclick="sendQuickResponse('overwhelmed')">Overwhelmed😔</button>
                        <button class="response-btn" onclick="sendQuickResponse('stressed')">Stressed😞</button>
                        <button class="response-btn" onclick="sendQuickResponse('neutral')">Neutral😐</button>
                        <button class="response-btn" onclick="sendQuickResponse('happy')">Happy😊</button>
                    </div>
                </div>

                <div id="typingIndicator" class="typing-indicator">
                    <div class="typing-dot"></div>
                    <div class="typing-dot"></div>
                    <div class="typing-dot"></div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <button class="quick-action-btn" onclick="startExercise('breathing')">
                    <i class="fas fa-wind"></i> Breathing Exercise<br>
                    <small style="font-size: 11px; opacity: 0.8;">Calm anxiety with guided breathing</small>
                </button>
                <button class="quick-action-btn" onclick="startExercise('mindfulness')">
                    <i class="fas fa-brain"></i> Mindfulness Practice<br>
                    <small style="font-size: 11px; opacity: 0.8;">Stay present, reduce stress</small>
                </button>
                <button class="quick-action-btn" onclick="startExercise('gratitude')">
                    <i class="fas fa-heart"></i> Gratitude Journal<br>
                    <small style="font-size: 11px; opacity: 0.8;">Boost positivity and mood</small>
                </button>
                <button class="quick-action-btn" onclick="showCopingStrategies()">
                    <i class="fas fa-life-ring"></i> Coping Strategies<br>
                    <small style="font-size: 11px; opacity: 0.8;">Practical tools for tough moments</small>
                </button>
            </div>

            <!-- Chat Input -->
            <div class="chat-input-area">
                <div class="chat-input-wrapper">
                    <input type="text" 
                        class="chat-input" 
                        id="messageInput"
                        placeholder="Type your message here..."
                        onkeypress="handleKeyPress(event)">
                    <button class="chat-input-btn" onclick="sendMessage()">
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- End Chat Button -->
        <button class="end-chat-btn" onclick="endChat()">
            <i class="fas fa-sign-out-alt"></i> End Chat
        </button>
    </div>

    <script>
    // Conversation data
    const exercises = {
        breathing: {
            title: "2-Minute Breathing Exercise",
            steps: [
                "Sit comfortably and close your eyes",
                "Breathe in slowly for 4 seconds",
                "Hold your breath for 2 seconds",
                "Breathe out slowly for 6 seconds",
                "Repeat for 5 cycles"
            ],
            followUp: "How do you feel now? Would you like to continue with another exercise?"
        },
        mindfulness: {
            title: "Mindfulness Practice",
            steps: [
                "Find a quiet place to sit",
                "Focus on your breathing",
                "Notice thoughts without judgment",
                "Return focus to breath",
                "Practice for 5 minutes"
            ],
            followUp: "Great job practicing mindfulness! How was your experience?"
        },
        gratitude: {
            title: "Gratitude Journal Practice",
            steps: [
                "Think of 3 things you're grateful for",
                "Write them down in detail",
                "Reflect on why they matter",
                "Notice how you feel",
                "Make this a daily habit"
            ],
            followUp: "Did writing help shift your perspective? Would you like to share one thing you're grateful for?"
        }
    };

    const copingStrategies = [
        "Practice deep breathing - Inhale 4s, hold 4s, exhale 6s",
        "Take a short walk - Even 5 minutes can help clear your mind",
        "Write down your thoughts - Journaling can provide clarity",
        "Talk to someone - Sharing helps reduce the burden",
        "Listen to calming music - Nature sounds or instrumental",
        "Practice progressive muscle relaxation - Tense and relax each muscle group"
    ];

    // Predefined responses for different emotions
    const emotionResponses = {
        overwhelmed: {
            title: "Feeling Overwhelmed",
            message: "I understand feeling overwhelmed. When everything feels like too much, it's important to take small steps.",
            tips: [
                "Break tasks into smaller, manageable parts",
                "Focus on just one thing at a time",
                "Take a 5-minute break to breathe",
                "Write down everything that's on your mind",
                "Ask for help if you need it"
            ],
            followUp: "Would you like to try a quick breathing exercise to help calm your mind?"
        },
        stressed: {
            title: "Feeling Stressed",
            message: "Stress is your body's response to pressure. Let's work on calming your nervous system.",
            tips: [
                "Practice the 4-7-8 breathing technique",
                "Take a short walk outside",
                "Do some gentle stretching",
                "Listen to calming music",
                "Drink some herbal tea"
            ],
            followUp: "I can guide you through a stress-relief exercise. Would that help?"
        },
        neutral: {
            title: "Feeling Neutral",
            message: "Neutral is a good baseline! It means you're not experiencing extreme emotions right now.",
            tips: [
                "This is a great time for self-reflection",
                "Consider starting a mindfulness practice",
                "Plan something enjoyable for later",
                "Check in with your physical needs",
                "Set small, achievable goals for today"
            ],
            followUp: "Would you like to explore ways to enhance your mood or build positive habits?"
        },
        happy: {
            title: "Feeling Happy",
            message: "That's wonderful to hear! It's great to celebrate positive emotions.",
            tips: [
                "Savor this moment - really notice how you feel",
                "Share your happiness with someone",
                "Do something creative to express your joy",
                "Practice gratitude for this good feeling",
                "Use this energy to tackle something you've been putting off"
            ],
            followUp: "Would you like to learn how to maintain this positive state?"
        }
    };

    let currentMood = null;
    let conversationHistory = [];

    // Navigation functions
    function goToDashboard() {
        alert("Dashboard feature would be implemented here.");
    }

    function goToLearningHub() {
        alert("Learning Hub feature would be implemented here.");
    }

    // Add message to chat
    function addMessage(sender, content, isResponseOptions = false, options = null) {
        const chatMessages = document.getElementById('chatMessages');
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${sender}`;
        
        const headerDiv = document.createElement('div');
        headerDiv.className = `message-header ${sender}`;
        headerDiv.innerHTML = sender === 'ai' 
            ? '<i class="fas fa-robot message-icon"></i> AI Assistant'
            : '<i class="fas fa-user message-icon"></i> You';
        
        const contentDiv = document.createElement('div');
        contentDiv.className = 'message-content';
        contentDiv.innerHTML = content;
        
        messageDiv.appendChild(headerDiv);
        messageDiv.appendChild(contentDiv);
        
        if (isResponseOptions && options) {
            const optionsDiv = document.createElement('div');
            optionsDiv.className = 'response-options';
            optionsDiv.innerHTML = options;
            messageDiv.appendChild(optionsDiv);
        }
        
        chatMessages.appendChild(messageDiv);
        
        // Add to history
        conversationHistory.push({
            sender: sender,
            content: content,
            timestamp: new Date().toISOString()
        });
        
        // Scroll to bottom
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    // Show typing indicator
    function showTyping() {
        const typingIndicator = document.getElementById('typingIndicator');
        typingIndicator.style.display = 'flex';
        const chatMessages = document.getElementById('chatMessages');
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    // Hide typing indicator
    function hideTyping() {
        const typingIndicator = document.getElementById('typingIndicator');
        typingIndicator.style.display = 'none';
    }

    // Send user message
    function sendMessage() {
        const input = document.getElementById('messageInput');
        const message = input.value.trim();
        
        if (message === '') return;
        
        // Add user message
        addMessage('user', message);
        input.value = '';
        
        // Show typing indicator
        showTyping();
        
        // AI response after delay
        setTimeout(() => {
            hideTyping();
            generateAIResponse(message);
        }, 1000);
    }

    // Handle emotion buttons - SIMPLE VERSION
    function sendQuickResponse(emotion) {
        // Add user message
        let userMsg = '';
        switch(emotion) {
            case 'overwhelmed': userMsg = "I feel overwhelmed with everything."; break;
            case 'stressed': userMsg = "I'm feeling stressed right now."; break;
            case 'neutral': userMsg = "I feel neutral - not great, not bad."; break;
            case 'happy': userMsg = "I feel happy and content!"; break;
            default: userMsg = "I want to talk about my feelings.";
        }
        
        addMessage('user', userMsg);
        
        // Show quick tip immediately
        showEmotionQuickTips(emotion);
        
        // Show typing
        showTyping();
        
        // AI response
        setTimeout(() => {
            hideTyping();
            handleEmotionResponse(emotion);
        }, 800);
    }

    // Handle specific emotion responses
    function handleEmotionResponse(emotion) {
        const emotionData = emotionResponses[emotion];
        if (!emotionData) {
            addMessage('ai', "Thank you for sharing. How can I support you?");
            return;
        }
        
        // Create tips HTML
        let tipsHTML = '<ul style="margin: 10px 0 0 20px; padding: 0;">';
        emotionData.tips.forEach(tip => {
            tipsHTML += `<li style="margin-bottom: 8px; color: #6B4F36;">${tip}</li>`;
        });
        tipsHTML += '</ul>';
        
        const response = `
            <strong>${emotionData.title}</strong><br>
            ${emotionData.message}<br><br>
            <strong>Quick Tips:</strong>
            ${tipsHTML}
        `;
        
        addMessage('ai', response);
        
        // Add follow-up options
        setTimeout(() => {
            const optionsHTML = `
                <button class="response-btn" onclick="startExercise('breathing')">
                    <i class="fas fa-play-circle"></i> Try Exercise
                </button>
                <button class="response-btn" onclick="showMoreTips('${emotion}')">
                    <i class="fas fa-lightbulb"></i> More Tips
                </button>
                <button class="response-btn" onclick="talkAboutFeeling('${emotion}')">
                    <i class="fas fa-comment"></i> Talk About It
                </button>
            `;
            addMessage('ai', emotionData.followUp, true, optionsHTML);
        }, 500);
    }

    // Show more tips
    function showMoreTips(emotion) {
        const additionalTips = {
            overwhelmed: [
                "Use the '5-4-3-2-1' grounding technique",
                "Set a timer for 25 minutes of focused work",
                "Create a 'stop doing' list",
                "Practice saying 'no' to protect your energy",
                "Visualize putting each worry in a box"
            ],
            stressed: [
                "Try progressive muscle relaxation",
                "Apply cold water to your wrists",
                "Chew gum - it can reduce cortisol levels",
                "Practice yoga or gentle stretching",
                "Use aromatherapy with lavender"
            ],
            neutral: [
                "Try a new activity to stimulate your mind",
                "Connect with nature",
                "Practice self-compassion meditation",
                "Learn something new",
                "Do a random act of kindness"
            ],
            happy: [
                "Document this moment in a journal",
                "Create a 'happy playlist'",
                "Share what made you happy",
                "Do something physical",
                "Set an intention to carry this feeling forward"
            ]
        };
        
        const tips = additionalTips[emotion] || [];
        
        let tipsHTML = '<ul style="margin: 10px 0 0 20px; padding: 0;">';
        tips.forEach(tip => {
            tipsHTML += `<li style="margin-bottom: 8px; color: #6B4F36;">${tip}</li>`;
        });
        tipsHTML += '</ul>';
        
        const response = `
            <strong>Additional Tips for ${emotionResponses[emotion].title}:</strong>
            ${tipsHTML}
        `;
        
        addMessage('ai', response);
        
        setTimeout(() => {
            const optionsHTML = `
                <button class="response-btn" onclick="sendQuickResponse('${emotion}')">
                    <i class="fas fa-redo"></i> Main Options
                </button>
                <button class="response-btn" onclick="showCopingStrategies()">
                    <i class="fas fa-life-ring"></i> More Strategies
                </button>
                <button class="response-btn" onclick="sendMessageDirect('I want to try one of these tips')">
                    <i class="fas fa-check"></i> Try a Tip
                </button>
            `;
            addMessage('ai', "Would you like to try one of these tips now?", true, optionsHTML);
        }, 500);
    }

    // Talk about the feeling
    function talkAboutFeeling(emotion) {
        const prompts = {
            overwhelmed: [
                "What feels like the biggest source of overwhelm right now?",
                "Is there one small thing you could let go of?",
                "How would you support a friend feeling this way?"
            ],
            stressed: [
                "Where do you feel the stress in your body?",
                "What's one thing causing stress that you can address today?",
                "How have you managed stress in the past?"
            ],
            neutral: [
                "What would help you move from neutral to feeling good?",
                "Is there anything you've been putting off?",
                "What are you looking forward to?"
            ],
            happy: [
                "What specifically is contributing to your happiness?",
                "How can you extend this positive feeling?",
                "Is there someone you'd like to share this with?"
            ]
        };
        
        const promptsList = prompts[emotion] || ["How does this feeling affect your day?"];
        const randomPrompt = promptsList[Math.floor(Math.random() * promptsList.length)];
        
        addMessage('ai', `Let's explore this feeling together.<br><br><strong>Reflection Question:</strong> ${randomPrompt}`);
    }

    // Send direct message
    function sendMessageDirect(text) {
        addMessage('user', text);
        
        showTyping();
        setTimeout(() => {
            hideTyping();
            generateAIResponse(text);
        }, 800);
    }

    // Start an exercise - IMPROVED VERSION
    function startExercise(type) {
        const exercise = exercises[type];
        if (!exercise) return;
        
        // Better introduction messages for each exercise
        const exerciseIntros = {
            breathing: "Breathing exercises can calm your nervous system in minutes. When stressed, focusing on your breath helps ground you in the present moment.",
            mindfulness: "Mindfulness helps you observe thoughts without judgment. Regular practice reduces stress and increases emotional resilience.",
            gratitude: "Gratitude journaling shifts focus from problems to positives. Studies show it can increase happiness by 25% over time."
        };
        
        // Create steps HTML
        let stepsHTML = '<ol class="step-list">';
        exercise.steps.forEach((step, index) => {
            stepsHTML += `<li><span class="step-number">${index + 1}</span>${step}</li>`;
        });
        stepsHTML += '</ol>';
        
        const intro = exerciseIntros[type] || "This exercise can help improve your mental wellbeing.";
        
        const response = `
            <strong>${exercise.title}</strong><br>
            ${intro}<br><br>
            <strong>Steps to follow:</strong>
            <div class="exercise-steps">
                ${stepsHTML}
            </div>
        `;
        
        addMessage('ai', response);
        
        // Add helpful tips specific to each exercise
        const exerciseTips = {
            breathing: "💡 <strong>Tip:</strong> Place one hand on your chest and one on your belly. Feel your belly rise as you breathe in.",
            mindfulness: "💡 <strong>Tip:</strong> If your mind wanders, gently bring it back to your breath. This is normal and part of the practice.",
            gratitude: "💡 <strong>Tip:</strong> Be specific! Instead of 'I'm grateful for family,' try 'I'm grateful for how my sister made me laugh today.'"
        };
        
        setTimeout(() => {
            addMessage('ai', exerciseTips[type] || "Take your time and be gentle with yourself.");
        }, 300);
        
        // Add start button
        setTimeout(() => {
            const optionsHTML = `
                <button class="response-btn" onclick="startExerciseTimer('${type}')">
                    <i class="fas fa-play"></i> Start Now
                </button>
                <button class="response-btn" onclick="sendMessageDirect('I need more preparation time')">
                    <i class="fas fa-clock"></i> Not Ready Yet
                </button>
                <button class="response-btn" onclick="showCopingStrategies()">
                    <i class="fas fa-exchange-alt"></i> Different Exercise
                </button>
            `;
            addMessage('ai', "Ready to begin? Take a moment to get comfortable.", true, optionsHTML);
        }, 800);
    }

    // Start exercise timer
    function startExerciseTimer(type) {
        const exercise = exercises[type];
        if (!exercise) return;
        
        let timeLeft = 120;
        
        addMessage('ai', `Starting ${exercise.title} now. I'll guide you through it.`);
        
        // Create timer display
        const timerDiv = document.createElement('div');
        timerDiv.className = 'exercise-steps';
        timerDiv.innerHTML = `
            <strong>Exercise Timer:</strong><br>
            <div style="font-size: 24px; font-weight: bold; color: #D7923B; margin: 10px 0;" id="exerciseTimer">2:00</div>
            <div id="stepGuide">${exercise.steps[0]}</div>
        `;
        
        const aiMessage = document.createElement('div');
        aiMessage.className = 'message ai';
        aiMessage.innerHTML = `
            <div class="message-header ai">
                <i class="fas fa-robot message-icon"></i> AI Assistant
            </div>
            <div class="message-content"></div>
        `;
        
        aiMessage.querySelector('.message-content').appendChild(timerDiv);
        
        const chatMessages = document.getElementById('chatMessages');
        chatMessages.appendChild(aiMessage);
        
        // Timer logic
        const timerInterval = setInterval(() => {
            timeLeft--;
            
            if (timeLeft <= 0) {
                clearInterval(timerInterval);
                if (document.getElementById('exerciseTimer')) {
                    document.getElementById('exerciseTimer').textContent = "Complete!";
                }
                if (document.getElementById('stepGuide')) {
                    document.getElementById('stepGuide').textContent = "Great job!";
                }
                
                setTimeout(() => {
                    const optionsHTML = `
                        <button class="response-btn" onclick="sendMessageDirect('I feel better after the exercise')">
                            <i class="fas fa-smile"></i> Feeling Better
                        </button>
                        <button class="response-btn" onclick="sendMessageDirect('I want to try another exercise')">
                            <i class="fas fa-redo"></i> Try Another
                        </button>
                        <button class="response-btn" onclick="sendMessageDirect('Can we talk about how I feel now?')">
                            <i class="fas fa-comment"></i> Talk About It
                        </button>
                    `;
                    addMessage('ai', exercise.followUp, true, optionsHTML);
                }, 1000);
                return;
            }
            
            // Update timer display
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            if (document.getElementById('exerciseTimer')) {
                document.getElementById('exerciseTimer').textContent = 
                    `${minutes}:${seconds < 10 ? '0' : ''}${seconds}`;
            }
            
            // Update step guidance (for breathing exercise)
            if (type === 'breathing' && document.getElementById('stepGuide')) {
                const cycleTime = 12;
                const cyclePosition = (120 - timeLeft) % cycleTime;
                
                if (cyclePosition < 4) {
                    document.getElementById('stepGuide').textContent = "Breathe IN...";
                } else if (cyclePosition < 6) {
                    document.getElementById('stepGuide').textContent = "HOLD...";
                } else {
                    document.getElementById('stepGuide').textContent = "Breathe OUT...";
                }
            }
            
        }, 1000);
    }

    // Show coping strategies - IMPROVED VERSION
    function showCopingStrategies() {
        // Create strategies HTML
        let strategiesHTML = '<ol class="step-list">';
        copingStrategies.forEach((strategy, index) => {
            strategiesHTML += `<li><span class="step-number">${index + 1}</span>${strategy}</li>`;
        });
        strategiesHTML += '</ol>';
        
        const response = `
            <strong>Coping Strategies for Tough Moments</strong><br>
            When emotions feel overwhelming, these evidence-based strategies can help:<br><br>
            <div class="exercise-steps">
                ${strategiesHTML}
            </div>
        `;
        
        addMessage('ai', response);
        
        // Add helpful tip
        setTimeout(() => {
            addMessage('ai', "💡 <strong>Pro Tip:</strong> Try 2-3 different strategies to see what works best for you. Everyone responds differently!");
        }, 300);
        
        // Add follow-up
        setTimeout(() => {
            const optionsHTML = `
                <button class="response-btn" onclick="sendMessageDirect('I want to try the breathing strategy')">
                    <i class="fas fa-wind"></i> Breathing
                </button>
                <button class="response-btn" onclick="sendMessageDirect('I want to try walking or exercise')">
                    <i class="fas fa-walking"></i> Movement
                </button>
                <button class="response-btn" onclick="sendMessageDirect('I want to try journaling')">
                    <i class="fas fa-book"></i> Journaling
                </button>
                <button class="response-btn" onclick="startExercise('breathing')">
                    <i class="fas fa-play-circle"></i> Guided Exercise
                </button>
            `;
            addMessage('ai', `Which strategy resonates with you most right now?`, true, optionsHTML);
        }, 800);
    }

    // Generate AI response for free text input
    function generateAIResponse(userMessage) {
        const lowerMessage = userMessage.toLowerCase();
        let response = "";
        
        if (lowerMessage.includes('thank')) {
            response = "You're welcome! I'm here whenever you need support.";
        } else if (lowerMessage.includes('help')) {
            response = "I can help you with emotional support, breathing exercises, mindfulness practices, or coping strategies.";
        } else if (lowerMessage.includes('exercise') || lowerMessage.includes('practice')) {
            response = "I can guide you through breathing exercises, mindfulness practices, or gratitude journaling.";
        } else if (lowerMessage.includes('sad') || lowerMessage.includes('depressed')) {
            response = "I'm sorry to hear you're feeling this way. Would you like to talk about it or try a calming exercise?";
        } else if (lowerMessage.includes('sleep') || lowerMessage.includes('tired')) {
            response = "Sleep issues are common with stress. Would you like some relaxation techniques for better sleep?";
        } else if (lowerMessage.includes('anxious') || lowerMessage.includes('worry')) {
            response = "Anxiety can feel overwhelming. Would you like to try a grounding technique or breathing exercise?";
        } else if (lowerMessage.includes('better') || lowerMessage.includes('improve')) {
            response = "I'm glad to hear you're feeling better! How can I help you maintain this positive state?";
        } else {
            const responses = [
                "Thank you for sharing. How does that make you feel?",
                "I understand. Would you like to explore ways to manage that feeling?",
                "That's important to acknowledge. Would a calming activity help?",
                "I hear you. Is there anything specific you'd like to try to feel better?"
            ];
            response = responses[Math.floor(Math.random() * responses.length)];
        }
        
        addMessage('ai', response);
    }

    // Add helpful descriptions for quick actions
function explainQuickAction(action) {
    const explanations = {
        breathing: "Guided breathing to reduce stress and anxiety",
        mindfulness: "Present-moment awareness practice",
        gratitude: "Positive reflection exercise",
        coping: "Practical strategies for difficult moments"
    };
    
    return explanations[action] || "Helpful mental wellbeing exercise";
}

    // Handle Enter key
    function handleKeyPress(event) {
        if (event.key === 'Enter') {
            sendMessage();
            event.preventDefault();
        }
    }

    // End chat
    function endChat() {
        if (confirm("Are you sure you want to end this chat? Your conversation will be saved.")) {
            localStorage.setItem('lastConversation', JSON.stringify({
                history: conversationHistory,
                mood: currentMood,
                timestamp: new Date().toISOString()
            }));
            
            alert("Chat ended. You can reload the page to start a new conversation.");
            
            // Clear chat
            const chatMessages = document.getElementById('chatMessages');
            chatMessages.innerHTML = '';
            
            // Add initial message again
            addMessage('ai', "Hello! How are you feeling today?", true, `
                <button class="response-btn" onclick="sendQuickResponse('overwhelmed')">Overwhelmed😔</button>
                <button class="response-btn" onclick="sendQuickResponse('stressed')">Stressed😞</button>
                <button class="response-btn" onclick="sendQuickResponse('neutral')">Neutral😐</button>
                <button class="response-btn" onclick="sendQuickResponse('happy')">Happy😊</button>
            `);
            
            conversationHistory = [];
        }
    }

    // Show quick tips after emotion selection
    function showEmotionQuickTips(emotion) {
        const quickTips = {
            overwhelmed: "Take 3 deep breaths. Inhale for 4 counts, hold for 2, exhale for 6. This helps calm your nervous system immediately.",
            stressed: "Try the 5-4-3-2-1 grounding technique: Name 5 things you see, 4 things you feel, 3 things you hear, 2 things you smell, and 1 thing you taste.",
            neutral: "This is a great moment for self-awareness. Take 1 minute to notice your breath without trying to change it.",
            happy: "Savor this moment! Take a mental snapshot - what colors, sounds, and feelings make this moment special?"
        };
        
        const tip = quickTips[emotion] || "Take a moment to breathe deeply and notice how you feel.";
        
        // Show quick tip immediately after emotion selection
        setTimeout(() => {
            addMessage('ai', `<strong>Quick Tip:</strong> ${tip}`);
        }, 300);
    }

    // Load conversation from history
    function loadConversation(conversationId) {
        if (confirm("Load this conversation? Your current chat will be cleared.")) {
            const chatMessages = document.getElementById('chatMessages');
            chatMessages.innerHTML = '';
            
            let sampleMessages = [];
            
            switch(conversationId) {
                case 'stress_relief':
                    sampleMessages = [
                        { sender: 'ai', content: "Hello! How are you feeling today?" },
                        { sender: 'user', content: "A bit stressed about my work." },
                        { sender: 'ai', content: "I understand. Would you like to try a breathing exercise?" }
                    ];
                    break;
                case 'anxiety_talk':
                    sampleMessages = [
                        { sender: 'ai', content: "Welcome back! How have you been feeling?" },
                        { sender: 'user', content: "Some anxiety, but managing." },
                        { sender: 'ai', content: "Let's explore some coping strategies together." }
                    ];
                    break;
                case 'sleep_tips':
                    sampleMessages = [
                        { sender: 'ai', content: "Good to see you again! How has your sleep been?" },
                        { sender: 'user', content: "Better, thank you." },
                        { sender: 'ai', content: "Great! Would you like to refine your bedtime routine?" }
                    ];
                    break;
            }
            
            sampleMessages.forEach(msg => {
                addMessage(msg.sender, msg.content);
            });
        }
    }

    // Initialize
    window.addEventListener('load', function() {
        const input = document.getElementById('messageInput');
        if (input) {
            input.focus();
        }
    });
</script>
</body>
</html>