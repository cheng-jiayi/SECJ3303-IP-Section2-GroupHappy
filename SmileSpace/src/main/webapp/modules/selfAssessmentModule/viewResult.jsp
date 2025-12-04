<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Assessment Results</title>
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

        .user-menu {
            position: relative;
        }

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

        .dropdown.show {
            display: block;
        }

        .user-info {
            padding: 15px;
            background: #FFF3C8;
            border-bottom: 2px solid #E8D4B9;
        }

        .user-name {
            font-weight: bold;
        }

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

        .menu-item:hover {
            background: #FFF8E8;
        }

        .menu-item.logout {
            color: #E74C3C;
        }

        /* Result Section */
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

        .page-title p {
            font-size: 16px;
            color: #A06A2F;
        }

        .results-section {
            display: flex;
            justify-content: space-around;
            margin-top: 40px;
        }

        .result-card {
            background: #FFF;
            padding: 20px;
            border-radius: 18px;
            width: 25%;
            text-align: center;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            font-size: 18px;
            margin: 0 10px;
            transition: background-color 0.3s ease;
        }

        .result-card:hover {
            background-color: #FFEB99;
        }

        .result-card h3 {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
        }

        .result-card .score {
            font-size: 32px;
            font-weight: 700;
            color: #713C0B;
        }

        .result-card .level {
            font-size: 18px;
            color: #A06A2F;
        }

        .personalized-recommendations {
            margin-top: 40px;
            text-align: center;
            display: flex;
            flex-direction: column;
            gap: 20px;
            align-items: center;
        }

        .recommendation {
            background: #FFF;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 18px;
            width: 60%;
            text-align: left;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            font-size: 18px;
            color: #713C0B;
        }

        .recommendation h3 {
            font-size: 22px;
            font-weight: 700;
            color: #F0A548;
        }

        .recommendation p {
            font-size: 16px;
            color: #A06A2F;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 40px;
        }

        .btn {
            background: #F0A548;
            color: white;
            padding: 12px 30px;
            border-radius: 10px;
            font-size: 16px;
            cursor: pointer;
        }

        .btn:disabled {
            background-color: #E8C6A2;
        }

        /* Modal Styles */
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
            text-align: center;
        }

        .modal-content h2 {
            margin-bottom: 15px;
        }

        .modal-content button {
            background-color: #BDF5C6;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
        }

        .modal-content button:hover {
            background-color: #A0EFB4;
        }

        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            position: absolute;
            top: 10px;
            right: 10px;
            cursor: pointer;
        }

        .close:hover {
            color: black;
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

    <div class="page-title">
        <h1>Your Assessment Results</h1>
        <p>Completed on 11/8/2025 at 1:10:02 AM</p>
    </div>

    <div class="results-section">
        <div class="result-card">
            <h3>Depression</h3>
            <div class="score">36</div>
            <div class="level">Extremely severe</div>
        </div>
        <div class="result-card">
            <h3>Anxiety</h3>
            <div class="score">26</div>
            <div class="level">Extremely severe</div>
        </div>
        <div class="result-card">
            <h3>Stress</h3>
            <div class="score">26</div>
            <div class="level">Severe</div>
        </div>
    </div>

    <div class="personalized-recommendations">
        <div class="recommendation">
            <h3>Consider Professional Support</h3>
            <p>Your results suggest you may benefit from speaking with a mental health professional. University counseling services are a great place to start.</p>
        </div>
        <div class="recommendation">
            <h3>Stress Management Techniques</h3>
            <p>Try mindfulness meditation, deep breathing exercises, or progressive muscle relaxation to help manage stress levels.</p>
        </div>
        <div class="recommendation">
            <h3>Mood Enhancement Activities</h3>
            <p>Engage in activities you enjoy, maintain social connections, and establish a regular sleep schedule to support your mood.</p>
        </div>
    </div>

    <div class="action-buttons">
        <button class="btn">Explore Modules</button>
        <button class="btn" onclick="window.location.href='assessment.jsp'">Take Assessment Again</button>
        <button class="btn" onclick="showModal()">Download Results</button>
    </div>

    <!-- Modal for result message -->
    <div id="resultModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2>Your result is ready to go</h2>
            <p>A PDF copy of your assessment has been created. You can download it now or email it to yourself for safekeeping.</p>
            <button onclick="downloadPdf()">Download pdf</button>
            <button onclick="emailMe()">Email me</button>
            <button onclick="closeModal()">Cancel</button>
        </div>
    </div>

    <script>
        function showModal() {
            document.getElementById('resultModal').style.display = "block";
        }

        function closeModal() {
            document.getElementById('resultModal').style.display = "none";
        }

        function downloadPdf() {
            alert("Downloading PDF...");
            // Implement download PDF functionality here
        }

        function emailMe() {
            alert("Emailing results...");
            // Implement email functionality here
        }
    </script>
</body>
</html>
