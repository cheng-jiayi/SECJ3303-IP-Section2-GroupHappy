<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Feedback Analytics</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: #FBF6EA;
            color: #713C0B;
            font-family: 'Fredoka', sans-serif;
            padding-bottom: 40px;
        }

        .top-nav {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding: 22px 40px;
            background: #FBF6EA;
            border-bottom: 2px solid #F0D5B8;
            gap: 20px;
        }

        .logo {
            font-size: 28px;
            font-weight: 700;
            color: #F0A548;
        }

        .user-menu { position: relative; }
        .user-btn {
            background: #D7923B;
            color: white;
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
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
            min-width: 200px;
            display: none;
            z-index: 100;
        }

        .dropdown.show { display: block; }

        .user-info {
            padding: 15px;
            background: #FFF3C8;
            border-bottom: 2px solid #E8D4B9;
        }

        .user-name { font-weight: bold; }
        .user-role {
            background: #D7923B;
            color: white;
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
            color: #6B4F36;
            border-bottom: 1px solid #eee;
        }

        .menu-item:hover { background: #FFF8E8; }

        .menu-item.logout { color: #E74C3C; }

        /* Page Title */
        .page-title {
            text-align: center;
            margin-top: 30px;
            margin-bottom: 20px;
        }

        .page-title h1 { color: #F0A548; font-size: 36px; font-weight: 700; }
        .page-title p { font-size: 16px; color: #A06A2F; }

        /* Filter Section */
        .filter-section {
            width: 85%;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .filter-section input, .filter-section select {
            padding: 10px;
            font-size: 14px;
            border-radius: 10px;
            border: 2px solid #E2D5C1;
            width: 30%;
        }

/* Stats Section */
        .stats-section {
            display: flex;
            justify-content: space-between;
            width: 80%;
            margin: 0 auto;
            padding-top: 30px;
            margin-bottom: 30px;
        }

        .stats-card {
            background: #FFF;
            padding: 20px;
            border-radius: 20px;
            width: 30%;
            text-align: left;
            font-size: 16px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            position: relative;
            margin-right: 20px;
        }

        .stats-card h3 { font-size: 18px; font-weight: 600; margin: 0; padding: 0; }
        .stats-card p { font-size: 26px; font-weight: 700; color: #713C0B; margin: 10px 0; }
        .stats-card .emoji { font-size: 32px; position: absolute; top: 5px; right: 5px; }
        .stats-card .total { font-size: 12px; color: #E8B949; margin-top: auto; }


        .feedback-list { width: 85%; margin: 0 auto; } /* Feedback Card */ 
        .feedback-card { 
            background: white; 
            border-radius: 18px; 
            border: 2px solid #F0D5B8; 
            padding: 18px; 
            margin-bottom: 18px; 
            display: flex; 
            flex-direction: column; /* Ensure vertical alignment */
            gap: 10px;
        } 

        .feedback-header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 12px; 
        } 

        .feedback-header div { display: flex; align-items: center; } 
        .feedback-header div:first-child { margin-right: 10px; } 
        .category-tag { background: #FFEBC8; padding: 5px 12px; font-weight: 600; border-radius: 15px; margin-left: 10px; }

        .sentiment-label {
            font-weight: 600;
            padding: 5px 10px;
            border-radius: 15px;
        }

        .sentiment-positive { background-color: #2ECC71; color: white; }
        .sentiment-neutral { background-color: #F39C12; color: white; }
        .sentiment-negative { background-color: #E74C3C; color: white; }

        .resolved-label {
            background-color: #BDF5C6;
            color: #2ECC71;
            padding: 5px 10px;
            border-radius: 15px;
            font-weight: 600;
        }

        .action-row { margin-top: 15px; display: flex; gap: 10px; }

        .btn-reply, .btn-resolve {
            padding: 8px 14px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            font-weight: 600;
        }

        .btn-reply { background: #BDF5C6; }
        .btn-resolve { background: #FFCE8A; }
        
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            width: 50%;
            margin: 15% auto;
        }

        .modal-content h2 { margin-bottom: 15px; }
        .modal-content textarea {
            width: 100%;
            height: 100px;
            padding: 10px;
            font-size: 14px;
            border-radius: 8px;
            border: 1px solid #E2D5C1;
        }

        .modal-content button {
            padding: 10px 20px;
            background-color: #BDF5C6;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
        }

        .modal-content button:hover {
            background-color: #A0EFB4;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
</head>
<body>

    <div class="top-nav">
        <div class="logo">SmileSpace</div>
        <div class="user-menu">
            <button class="user-btn" id="userBtn">
                <i class="fas fa-user"></i>
            </button>
        </div>
    </div>

    <div class="page-title">
        <h1>Feedback Analytics</h1>
        <p>Review and respond to student feedback</p>
    </div>

    <!-- Stats Section -->
    <div class="stats-section">
        <div class="stats-card">
            <h3>Positive Feedback</h3>
            <div class="emoji">👍</div>
            <p>2</p>
            <div class="total">40.0% of total</div>
        </div>
        <div class="stats-card">
            <h3>Neutral Feedback</h3>
            <div class="emoji">➖</div>
            <p>2</p>
            <div class="total">40.0% of total</div>
        </div>
        <div class="stats-card">
            <h3>Negative Feedback</h3>
            <div class="emoji">👎</div>
            <p>1</p>
            <div class="total">20.0% of total</div>
        </div>
    </div>

    <!-- Filters Section -->
    <div class="filter-section">
        <input type="text" placeholder="Search Feedback" />
        <select>
            <option>All Sentiments</option>
            <option>Positive</option>
            <option>Neutral</option>
            <option>Negative</option>
        </select>
        <select>
            <option>All Status</option>
            <option>New</option>
            <option>Resolved</option>
        </select>
    </div>

    <!-- Feedback List -->
    <div class="feedback-list">
        <div class="feedback-card" id="feedback-1">
            <div class="feedback-header">
                <div>
                    <strong>Sarah Johnson</strong><br>
                    <span class="category-tag">Assessment Experience</span>
                </div>
                <div>
                    <span class="sentiment-label sentiment-positive">Positive</span>
                    <span class="resolved-label" id="resolved-1" style="display:none;">Resolved</span>
                </div>
            </div>
            <p>The platform is really helpful! I appreciate the detailed assessment results and the resources provided. It helped me understand my mental health better.</p>
            <div class="action-row">
                <button class="btn-reply" onclick="openReplyModal('Sarah Johnson', 'The platform is really helpful! I appreciate the detailed assessment results and the resources provided. It helped me understand my mental health better.')">Reply</button>
                <button class="btn-resolve" id="btn-resolve-1" onclick="markAsResolved(1)">Mark as Resolved</button>
            </div>
        </div>

        <div class="feedback-card" id="feedback-2">
            <div class="feedback-header">
                <div>
                    <strong>Michael Chen</strong><br>
                    <span class="category-tag">User Experience</span>
                </div>
                <div>
                    <span class="sentiment-label sentiment-neutral">Neutral</span>
                </div>
            </div>
            <p>The platform works well but can be a little slow at times.</p>
            <div class="action-row">
                <button class="btn-reply" onclick="openReplyModal('Michael Chen', 'The platform works well but can be a little slow at times.')">Reply</button>
                <button class="btn-resolve" id="btn-resolve-2" onclick="markAsResolved(2)">Mark as Resolved</button>
            </div>
        </div>
    </div>

    <!-- Modal for Reply -->
    <div id="replyModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeReplyModal()">&times;</span>
            <h2>Reply to Feedback</h2>
            <p id="feedbackName"></p>
            <p id="feedbackMessage"></p>
            <textarea id="replyMessage" placeholder="Type your response here..."></textarea>
            <button onclick="sendReply()">Send Response</button>
        </div>
    </div>

    <script>
        function markAsResolved(feedbackId) {
            // Hide the "Mark as Resolved" button
            document.getElementById("btn-resolve-" + feedbackId).style.display = "none";
            // Show the "Resolved" label
            document.getElementById("resolved-" + feedbackId).style.display = "inline-block";
        }

        function openReplyModal(name, message) {
            document.getElementById('feedbackName').innerText = "Send a response to " + name;
            document.getElementById('feedbackMessage').innerText = message;
            document.getElementById('replyModal').style.display = "block";
        }


        function closeReplyModal() {
            document.getElementById('replyModal').style.display = "none";
        }


        function sendReply() {
            let replyMessage = document.getElementById('replyMessage').value;
            if (replyMessage.trim() === "") {
                alert("Please enter a response.");
            } else {
                alert("Response Sent: " + replyMessage);
                closeReplyModal();
            }
        }

    </script>

</body>
</html>
