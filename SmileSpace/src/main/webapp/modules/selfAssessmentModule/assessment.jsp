<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DASS-21 Assessment</title>
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

        .page-title {
            text-align: center;
            margin-top: 30px;
            margin-bottom: 20px;
        }

        .page-title h1 {
            color: #F0A548;
            font-size: 36px;
            font-weight: 700;
        }

        .progress-bar-container {
            margin: 10px auto;
            width: 80%;
        }

        .progress-bar {
            width: 100%;
            background-color: #E2D5C1;
            height: 8px;
            border-radius: 4px;
        }

        .progress-bar-filled {
            height: 100%;
            width: 0%;
            background-color: #55C57A;
            border-radius: 4px;
        }

        .question-container {
            background-color: #FFF;
            padding: 20px;
            margin-top: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .question-container h3 {
            font-size: 22px;
            color: #F0A548;
        }

        .question-container p {
            font-size: 18px;
            margin-bottom: 15px;
        }

        .answer-options {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .answer-options label {
            background-color: #FFEBC8;
            padding: 10px;
            border-radius: 8px;
            cursor: pointer;
        }

        .answer-options input[type="radio"] {
            display: inline-block;
            margin-right: 10px;
        }

        .btn {
            padding: 12px 30px;
            border-radius: 10px;
            border: none;
            background-color: #F0A548;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }

        .btn:disabled {
            background-color: #E8C6A2;
        }

        .footer {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <!-- Top Navigation -->
    <div class="top-nav">
        <div class="logo">SmileSpace</div>
        <div class="user-menu">
            <button class="user-btn" id="userBtn">
                <i class="fas fa-user"></i>
            </button>
            <div class="dropdown" id="dropdown">
                <div class="user-info">
                    <div class="user-name">John Doe</div>
                    <div class="user-role">Student</div>
                </div>
                <a href="#" class="menu-item">
                    <i class="fas fa-user-edit"></i> Manage Profile
                </a>
                <a href="#" class="menu-item logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </div>

    <!-- Page Title -->
    <div class="page-title">
        <h1>DASS-21 Assessment</h1>
        <p>Question <span id="questionNumber">1</span> of 21</p>
    </div>

    <!-- Progress Bar -->
    <div class="progress-bar-container">
        <div class="progress-bar">
            <div class="progress-bar-filled" id="progressBar"></div>
        </div>
    </div>

    <!-- Question Container -->
    <div class="question-container">
        <h3>Over the past week: I found it hard to wind down</h3>
        <div class="answer-options">
            <label>
                <input type="radio" name="answer" value="0">
                Did not apply to me at all
            </label>
            <label>
                <input type="radio" name="answer" value="1">
                Applied to me to some degree
            </label>
            <label>
                <input type="radio" name="answer" value="2">
                Applied to me a considerable degree
            </label>
            <label>
                <input type="radio" name="answer" value="3">
                Applied to me very much
            </label>
        </div>
    </div>

    <!-- Buttons -->
    <div class="action-buttons">
        <button class="btn" id="prevButton" onclick="prevQuestion()">Previous</button>
        <button class="btn" id="nextButton" onclick="nextQuestion()">Next Question</button>
    </div>

    <script>
        let currentQuestion = 1;
        const totalQuestions = 21;
        
        // Questions List
        const questions = [
            "Over the past week: I found it hard to wind down",
            "Over the past week: I was aware of dryness of my mouth",
            "Over the past week: I couldn’t seem to experience any positive feeling at all",
            "Over the past week: I experienced breathing difficulty (eg, excessively rapid breathing, breathlessness in the absence of physical exertion)",
            "Over the past week: I found it difficult to work up the initiative to do things",
            "Over the past week: I tended to over-react to situations",
            "Over the past week: I experienced trembling (eg, in the hands)",
            "Over the past week: I felt that I was using a lot of nervous energy",
            "Over the past week: I was worried about situations in which I might panic and make a fool of myself",
            "Over the past week: I felt that I had nothing to look forward to",
            "Over the past week: I found myself getting agitated",
            "Over the past week: I found it difficult to relax",
            "Over the past week: I felt down-hearted and blue",
            "Over the past week: I was intolerant of anything that kept me from getting on with what I was doing",
            "Over the past week: I felt I was close to panic",
            "Over the past week: I was unable to become enthusiastic about anything",
            "Over the past week: I felt I wasn’t worth much as a person",
            "Over the past week: I felt that I was rather touchy",
            "Over the past week: I was aware of the action of my heart in the absence of physical exertion (eg, sense of heart rate increase, heart missing a beat)",
            "Over the past week: I felt scared without any good reason",
            "Over the past week: I felt that life was meaningless"
        ];

        function updateQuestion() {
            document.getElementById('questionNumber').innerText = currentQuestion;
            document.querySelector('.question-container h3').innerText = questions[currentQuestion - 1];
            updateProgressBar();
            toggleButtons();
        }

        function updateProgressBar() {
            const progress = (currentQuestion - 1) / (totalQuestions - 1) * 100;
            document.getElementById('progressBar').style.width = progress + "%";
        }

        function toggleButtons() {
            if (currentQuestion === 1) {
                document.getElementById('prevButton').disabled = true;
            } else {
                document.getElementById('prevButton').disabled = false;
            }

            if (currentQuestion === totalQuestions) {
                document.getElementById('nextButton').innerText = 'View Result';
                document.getElementById('nextButton').onclick = function() {
                    window.location.href = "viewResult.jsp"; // Redirect to viewResult.jsp
                };
            } else {
                document.getElementById('nextButton').innerText = 'Next Question';
            }
        }

        function nextQuestion() {
            if (currentQuestion < totalQuestions) {
                currentQuestion++;
                updateQuestion();
            } else {
                // This part is handled by the new onclick event above
            }
        }

        function prevQuestion() {
            if (currentQuestion > 1) {
                currentQuestion--;
                updateQuestion();
            }
        }

        // Initialize
        updateQuestion();
    </script>
</body>
</html>
