<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String feedbackId = request.getAttribute("feedbackId") != null ? 
        request.getAttribute("feedbackId").toString() : "";
    String errorMessage = (String) request.getAttribute("error");
    
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reply to Admin - SmileSpace</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
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
            padding-bottom: 40px;
            min-height: 100vh;
        }

        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 22px 40px;
            background: #FBF6EA;
            border-bottom: 2px solid #F0D5B8;
        }

        .logo {
            font-size: 28px;
            font-weight: 700;
            color: #F0A548;
            text-decoration: none;
        }

        .logo:hover {
            color: #D7923B;
        }

        .page-header {
            text-align: center;
            margin-top: 35px;
            margin-bottom: 30px;
        }

        .page-header h1 { 
            color: #F0A548; 
            font-size: 36px; 
            font-weight: 700; 
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }
        
        .page-header p { 
            margin-top: 10px; 
            font-size: 18px; 
            color: #A06A2F; 
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .warning-box {
            background: #FFF3C8;
            border: 2px solid #F0D5B8;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
            border-left: 6px solid #F39C12;
        }

        .warning-box h3 {
            color: #D35400;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .reply-form {
            background: #FFFFFF;
            border-radius: 20px;
            border: 2px solid #F0D5B8;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        label { 
            font-weight: 600; 
            display: block; 
            margin: 14px 0 6px; 
            color: #713C0B;
        }
        
        textarea {
            width: 100%;
            padding: 14px;
            border-radius: 12px;
            background: #F4F2FA;
            border: 2px solid #E2D5C1;
            font-size: 15px;
            height: 200px;
            resize: vertical;
            min-height: 120px;
        }
        
        textarea:focus {
            outline: none;
            border-color: #D7923B;
            background: #FFFFFF;
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.1);
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }

        .btn {
            padding: 14px 30px;
            border-radius: 12px;
            border: none;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-submit {
            background: #BDF5C6;
            color: #2C6B2F;
        }
        
        .btn-submit:hover {
            background: #A0EFB4;
            transform: translateY(-2px);
        }

        .btn-cancel {
            background: #FFCE8A;
            color: #D35400;
        }
        
        .btn-cancel:hover {
            background: #F39C12;
            color: white;
            transform: translateY(-2px);
        }

        .error {
            color: #E74C3C;
            margin: 10px 0;
            font-size: 14px;
            padding: 10px;
            background: #FDEDED;
            border-radius: 8px;
            border-left: 4px solid #E74C3C;
            margin-bottom: 20px;
        }

        .char-counter {
            text-align: right;
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
       
        .char-counter.warning {
            color: #E74C3C;
        }
       
        .char-counter.success {
            color: #27AE60;
        }

        @media (max-width: 768px) {
            .container {
                width: 95%;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>

    <div class="top-nav">
        <a href="<%= request.getContextPath() %>/dashboard" class="logo">SmileSpace</a>
        <a href="<%= request.getContextPath() %>/feedback/my-feedback" class="btn-cancel">
            <i class="fas fa-arrow-left"></i> Back to My Feedback
        </a>
    </div>

    <div class="page-header">
        <h1><i class="fas fa-reply"></i> Reply to Administrator</h1>
        <p>Send a follow-up response to the administrator's reply</p>
    </div>

    <div class="container">
        <% if (errorMessage != null) { %>
            <div class="error">
                <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
            </div>
        <% } %>

        <div class="warning-box">
            <h3><i class="fas fa-exclamation-triangle"></i> Important Notice</h3>
            <p>Sending a reply will mark this feedback as <strong>unresolved</strong> in the administrator's dashboard. 
            Only reply if you have additional concerns or need further clarification.</p>
        </div>

        <form class="reply-form" method="POST" action="${pageContext.request.contextPath}/feedback/my-feedback/reply" 
              onsubmit="return confirmReply()">
            <input type="hidden" name="feedbackId" value="<%= feedbackId %>">
            
            <label for="replyMessage">Your Response *</label>
            <textarea id="replyMessage" name="replyMessage" 
                      placeholder="Type your follow-up response here..." 
                      required></textarea>
            <div class="char-counter" id="charCounter">0 characters (minimum 10)</div>
            
            <div class="form-actions">
                <button type="submit" class="btn btn-submit" id="submitBtn">
                    <i class="fas fa-paper-plane"></i> Send Reply
                </button>
                <a href="<%= request.getContextPath() %>/feedback/my-feedback" class="btn btn-cancel">
                    <i class="fas fa-times"></i> Cancel
                </a>
            </div>
        </form>
    </div>

    <script>
        const textarea = document.getElementById('replyMessage');
        const charCounter = document.getElementById('charCounter');
        const submitBtn = document.getElementById('submitBtn');
        
        function updateCharCounter() {
            const length = textarea.value.length;
            charCounter.textContent = `${length} characters (minimum 10)`;
            
            if (length < 10) {
                charCounter.className = 'char-counter warning';
                submitBtn.disabled = true;
            } else {
                charCounter.className = 'char-counter success';
                submitBtn.disabled = false;
            }
        }
        
        textarea.addEventListener('input', updateCharCounter);
        updateCharCounter(); 
        
        function confirmReply() {
            const message = textarea.value.trim();
            if (message.length < 10) {
                alert('Please provide a more detailed response (at least 10 characters)');
                textarea.focus();
                return false;
            }
            
            return confirm('Are you sure you want to send this reply? This will mark the feedback as unresolved.');
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            textarea.focus();
        });
    </script>

</body>
</html>