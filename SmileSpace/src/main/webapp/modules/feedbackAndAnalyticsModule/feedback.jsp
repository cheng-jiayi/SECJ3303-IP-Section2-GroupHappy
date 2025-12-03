<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("error");
    
    // Get user info from session
    String userFullName = (String) session.getAttribute("userFullName");
    String userRole = (String) session.getAttribute("userRole");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Share Your Feedback</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Fredoka', sans-serif; }

        body {
            background: #FBF6EA;
            color: #713C0B;
            padding-bottom: 40px;
        }

        /* Header */
        .top-nav {
    display: flex;
    justify-content: flex-end; /* align everything to the right */
    align-items: center;
    padding: 22px 40px;
    background: #FBF6EA;
    border-bottom: 2px solid #F0D5B8;
    gap: 20px; /* space between logo and profile button */
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
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            min-width: 200px;
            display: none;
            z-index: 100;
        }
        .dropdown.show { display: block; }
        .user-info { padding: 15px; background: #FFF3C8; border-bottom: 2px solid #E8D4B9; }
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
        .menu-item { padding: 12px 15px; display: flex; align-items: center; gap: 10px; text-decoration: none; color: #6B4F36; border-bottom: 1px solid #eee; }
        .menu-item:hover { background: #FFF8E8; }
        .menu-item.logout { color: #E74C3C; }

        /* Title */
        .title-wrapper { text-align: center; margin-top: 35px; margin-bottom: 30px; }
        .title-wrapper h1 { color: #F0A548; font-size: 40px; font-weight: 700; }
        .title-wrapper p { margin-top: 10px; font-size: 18px; color: #A06A2F; }

        /* Feedback card */
        .feedback-card {
            width: 60%;
            background: #FFFFFF;
            border-radius: 20px;
            border: 2px solid #F0D5B8;
            margin: 0 auto;
            padding: 30px;
        }

        label { font-weight: 600; display: block; margin: 14px 0 6px; }
        input, textarea {
            width: 100%;
            padding: 14px;
            border-radius: 12px;
            background: #F4F2FA;
            border: 2px solid #E2D5C1;
            font-size: 15px;
        }
        textarea { height: 150px; resize: none; }

        .submit-btn {
            width: 100%;
            margin-top: 22px;
            padding: 14px;
            border-radius: 12px;
            background: #BDF5C6;
            border: none;
            font-size: 17px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.25s;
        }
        .submit-btn:hover { background: #A0EFB4; transform: translateY(-2px); }

        .helper-box {
            width: 60%;
            background: #FFF9F0;
            border-radius: 16px;
            margin: 30px auto;
            padding: 22px;
            border: 2px solid #F0D5B8;
        }

        ul { margin-left: 20px; margin-top: 10px; }
        ul li { margin-bottom: 8px; }

        .error { color: red; margin-top: 5px; font-size: 14px; }

        /* Toast style */
        .toast {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background-color: #D4EDDA;
            color: #155724;
            border: 1px solid #C3E6CB;
            border-radius: 12px;
            padding: 18px 22px;
            min-width: 280px;
            font-weight: 600;
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
            z-index: 1000;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .toast strong { display: block; font-size: 16px; }
        .toast p { margin: 4px 0 0 0; font-weight: 400; font-size: 14px; }
        .toast .close-btn { background: transparent; border: none; font-size: 18px; font-weight: bold; cursor: pointer; color: #155724; }
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
                <div class="user-name"><%= userFullName %></div>
                <div class="user-role"><%= userRole != null ? userRole.substring(0,1).toUpperCase() + userRole.substring(1) : "Student" %></div>
            </div>
            <a href="../profiles/studentProfile.jsp" class="menu-item">
                <i class="fas fa-user-edit"></i> Manage Profile
            </a>
            <a href="../logout.jsp" class="menu-item logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>
</div>


    <!-- Title -->
    <div class="title-wrapper">
        <h1>Share Your Feedback</h1>
        <p>Your thoughts help us improve the platform for all students.</p>
    </div>

    <!-- Feedback Form -->
    <div class="feedback-card">

        <% if (successMessage != null) { %>
            <div class="toast" id="successToast">
                <div>
                    <strong>Your feedback has been submitted successfully!</strong>
                    <p>Your thoughts help us improve SmileSpace for all students.</p>
                </div>
                <button class="close-btn" onclick="closeToast()">×</button>
            </div>
        <% } %>

        <form id="feedbackForm" action="<%= request.getContextPath() %>/submit-feedback" method="POST">

            <label>Name (Optional)</label>
            <input type="text" name="name" placeholder="Your name">

            <label>Email (Optional)</label>
            <input type="email" name="email" placeholder="your.email@university.edu">

            <label>Your Feedback *</label>
            <textarea name="message" placeholder="Tell us your thoughts..."></textarea>

            <% if (errorMessage != null) { %>
                <div class="error"><%= errorMessage %></div>
            <% } %>

            <button type="submit" class="submit-btn">➣ Submit Feedback</button>
        </form>
    </div>

    <!-- Helper Suggestions -->
    <div class="helper-box">
        <strong>What kind of feedback is helpful?</strong>
        <ul>
            <li>Your experience using SmileSpace features</li>
            <li>Suggestions for new enhancements</li>
            <li>Bugs or technical issues you found</li>
            <li>How the platform could support students better</li>
            <li>Ideas to improve user experience</li>
        </ul>
    </div>

    <script>
        // User dropdown
        const userBtn = document.getElementById('userBtn');
        const dropdown = document.getElementById('dropdown');
        userBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            dropdown.classList.toggle('show');
        });
        document.addEventListener('click', function() {
            dropdown.classList.remove('show');
        });
        dropdown.addEventListener('click', function(e) { e.stopPropagation(); });

        // Toast close
        function closeToast() {
            const toast = document.getElementById('successToast');
            if (toast) toast.style.display = 'none';
        }

        // Auto-hide toast after 5 seconds
        setTimeout(() => { closeToast(); }, 5000);

        // Reset form
        const form = document.getElementById("feedbackForm");
        if (form) form.reset();
    </script>

</body>
</html>
