<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("error");
   
    String prevName = (String) request.getAttribute("name");
    String prevEmail = (String) request.getAttribute("email");
    String prevMessage = (String) request.getAttribute("message");
    String prevCategory = (String) request.getAttribute("category");
    Integer prevRating = (Integer) request.getAttribute("rating");
   
    String userFullName = (String) session.getAttribute("userFullName");
    String userRole = (String) session.getAttribute("userRole");
   
    Object userIdObj = session.getAttribute("userId");
    Integer userId = null;
   
    if (userIdObj != null) {
        if (userIdObj instanceof Integer) {
            userId = (Integer) userIdObj;
        } else if (userIdObj instanceof String) {
            try {
                userId = Integer.parseInt((String) userIdObj);
            } catch (NumberFormatException e) {
                userId = null;
            }
        }
    }
   
    if (prevName == null && userFullName != null) prevName = userFullName;
    if (prevCategory == null) prevCategory = "General";
    if (prevRating == null) prevRating = 0;
    if (prevMessage == null) prevMessage = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Share Your Feedback - SmileSpace</title>
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

        .nav-container {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .nav-links {
            display: flex;
            gap: 10px;
        }
        
        .nav-link {
            color: #713C0B;
            text-decoration: none;
            font-weight: 600;
            padding: 10px 20px;
            border-radius: 10px;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-link:hover {
            background: #F0D5B8;
            text-decoration: none;
        }

        .nav-link.active {
            background: #D7923B;
            color: white;
        }

        .my-feedback-link {
            background: #FFEBC8;
            color: #713C0B;
            padding: 10px 20px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }
       
        .my-feedback-link:hover {
            background: #F0D5B8;
            transform: translateY(-2px);
            text-decoration: none;
            color: #713C0B;
        }
       
        .notification-badge {
            background: #E74C3C;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 12px;
            font-weight: bold;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-left: 5px;
            animation: pulse 2s infinite;
        }
       
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
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
            transition: all 0.3s ease;
        }
       
        .user-btn:hover {
            background: #C77D2F;
            transform: scale(1.05);
        }
       
        .dropdown {
            position: absolute;
            top: 60px;
            right: 0;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            min-width: 220px;
            display: none;
            z-index: 1000;
            overflow: hidden;
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
            font-size: 16px;
        }
       
        .user-role {
            background: #D7923B;
            color: white;
            padding: 4px 12px;
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
            transition: background 0.2s;
        }
       
        .menu-item:hover {
            background: #FFF8E8;
            text-decoration: none;
        }
       
        .menu-item.logout {
            color: #E74C3C;
        }

        .title-wrapper {
            text-align: center;
            margin-top: 35px;
            margin-bottom: 30px;
        }
       
        .title-wrapper h1 {
            color: #F0A548;
            font-size: 40px;
            font-weight: 700;
            margin-bottom: 10px;
        }
       
        .title-wrapper p {
            margin-top: 10px;
            font-size: 18px;
            color: #A06A2F;
        }

        .feedback-card {
            width: 60%;
            background: #FFFFFF;
            border-radius: 20px;
            border: 2px solid #F0D5B8;
            margin: 0 auto;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        label {
            font-weight: 600;
            display: block;
            margin: 14px 0 6px;
            color: #713C0B;
        }
       
        input, textarea, select {
            width: 100%;
            padding: 14px;
            border-radius: 12px;
            background: #F4F2FA;
            border: 2px solid #E2D5C1;
            font-size: 15px;
            transition: all 0.3s ease;
        }
       
        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #D7923B;
            background: #FFFFFF;
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.1);
        }
       
        textarea {
            height: 150px;
            resize: vertical;
            min-height: 120px;
        }

        .rating-container {
            margin: 20px 0;
        }
       
        .rating-title {
            font-weight: 600;
            margin-bottom: 10px;
            color: #713C0B;
            display: block;
        }
       
        .rating-required {
            color: #E74C3C;
            font-size: 12px;
            margin-left: 5px;
        }
       
        .star-rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
            gap: 5px;
        }
       
        .star-rating input {
            display: none;
        }
       
        .star-rating label {
            font-size: 40px;
            color: #E2D5C1;
            cursor: pointer;
            transition: color 0.2s;
            margin: 0;
            padding: 0;
        }
       
        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label {
            color: #FFD700;
        }

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
            color: #2C6B2F;
        }
       
        .submit-btn:hover {
            background: #A0EFB4;
            transform: translateY(-2px);
        }
       
        .submit-btn:disabled {
            background: #E2D5C1;
            color: #A06A2F;
            cursor: not-allowed;
            transform: none;
        }

        .helper-box {
            width: 60%;
            background: #FFF9F0;
            border-radius: 16px;
            margin: 30px auto;
            padding: 22px;
            border: 2px solid #F0D5B8;
        }

        ul {
            margin-left: 20px;
            margin-top: 10px;
        }
       
        ul li {
            margin-bottom: 8px;
        }

        .error {
            color: #E74C3C;
            margin: 10px 0;
            font-size: 14px;
            padding: 10px;
            background: #FDEDED;
            border-radius: 8px;
            border-left: 4px solid #E74C3C;
            display: flex;
            align-items: center;
            gap: 10px;
        }
       
        .field-error {
            font-size: 13px;
            color: #E74C3C;
            margin-top: 5px;
            display: none;
        }

        .toast {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background-color: #D4EDDA;
            color: #155724;
            border: 1px solid #C3E6CB;
            border-radius: 12px;
            padding: 18px 22px;
            min-width: 300px;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            z-index: 1000;
            display: flex;
            justify-content: space-between;
            align-items: center;
            animation: slideIn 0.3s ease-out;
        }
       
        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
       
        .toast strong {
            display: block;
            font-size: 16px;
        }
       
        .toast p {
            margin: 4px 0 0 0;
            font-weight: 400;
            font-size: 14px;
        }
       
        .toast .close-btn {
            background: transparent;
            border: none;
            font-size: 20px;
            font-weight: bold;
            cursor: pointer;
            color: #155724;
            padding: 0 0 0 15px;
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

        @media (max-width: 992px) {
            .feedback-card, .helper-box {
                width: 80%;
            }
        }

        @media (max-width: 768px) {
            .top-nav {
                padding: 15px 20px;
                flex-direction: column;
                gap: 15px;
            }
           
            .nav-container {
                order: 3;
                width: 100%;
                justify-content: center;
                margin-top: 10px;
            }
           
            .nav-links {
                flex-direction: column;
                width: 100%;
                align-items: center;
            }
           
            .nav-link, .my-feedback-link {
                width: 100%;
                text-align: center;
                justify-content: center;
            }
           
            .feedback-card, .helper-box {
                width: 90%;
                padding: 20px;
            }
           
            .title-wrapper h1 {
                font-size: 32px;
            }
           
            .title-wrapper p {
                font-size: 16px;
            }
           
            .star-rating label {
                font-size: 32px;
            }
        }
    </style>
</head>
<body>

    <div class="top-nav">
        <a href="${pageContext.request.contextPath}/dashboard" class="logo">SmileSpace</a>
        
        <div class="nav-container">
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/feedback" class="nav-link active">
                    <i class="fas fa-comment"></i> Give Feedback
                </a>
                
                <c:if test="${not empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/feedback/my-feedback" 
                       class="nav-link" 
                       id="myFeedbackLink">
                        <i class="fas fa-history"></i> My Feedback
                    </a>
                </c:if>
            </div>
            
            <div class="user-menu">
                <button class="user-btn" id="userBtn">
                    <i class="fas fa-user"></i>
                </button>
                <div class="dropdown" id="dropdown">
                    <div class="user-info">
                        <div class="user-name">${sessionScope.userFullName}</div>
                        <div class="user-role">${sessionScope.userRole}</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/dashboard" class="menu-item">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/profile" class="menu-item">
                        <i class="fas fa-user-edit"></i> My Profile
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="menu-item logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="title-wrapper">
        <h1>Share Your Feedback</h1>
        <p>Your thoughts help us improve the platform for all students.</p>
    </div>

    <div class="feedback-card">
        <% if (successMessage != null) { %>
            <div class="toast" id="successToast">
                <div>
                    <strong>Success!</strong>
                    <p><%= successMessage %></p>
                </div>
                <button class="close-btn" onclick="closeToast()">×</button>
            </div>
        <% } %>

        <% if (errorMessage != null) { %>
            <div class="error" id="errorMessage">
                <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
            </div>
        <% } %>

        <form id="feedbackForm" action="${pageContext.request.contextPath}/feedback/submit" method="POST">
            <label>Name (Optional)</label>
            <input type="text" name="name" id="name" placeholder="Your name" value="<%= prevName != null ? prevName : "" %>">
           
            <label>Email (Optional)</label>
            <%
                String userEmail = (String) session.getAttribute("userEmail");
                String emailValue = prevEmail != null ? prevEmail : (userEmail != null ? userEmail : "");
            %>
            <input type="email" name="email" id="email" placeholder="your.email@university.edu" value="<%= emailValue %>">
           
            <div class="rating-container">
                <span class="rating-title">
                    Rate Your Experience <span class="rating-required">*</span>
                </span>
                <div class="star-rating" id="starRating">
                    <input type="radio" id="star5" name="rating" value="5" <%= prevRating == 5 ? "checked" : "" %> required>
                    <label for="star5" title="5 stars">★</label>
                   
                    <input type="radio" id="star4" name="rating" value="4" <%= prevRating == 4 ? "checked" : "" %>>
                    <label for="star4" title="4 stars">★</label>
                   
                    <input type="radio" id="star3" name="rating" value="3" <%= prevRating == 3 ? "checked" : "" %>>
                    <label for="star3" title="3 stars">★</label>
                   
                    <input type="radio" id="star2" name="rating" value="2" <%= prevRating == 2 ? "checked" : "" %>>
                    <label for="star2" title="2 stars">★</label>
                   
                    <input type="radio" id="star1" name="rating" value="1" <%= prevRating == 1 ? "checked" : "" %>>
                    <label for="star1" title="1 star">★</label>
                </div>
                <div id="ratingError" class="field-error">
                    <i class="fas fa-exclamation-circle"></i> Please select a rating
                </div>
            </div>
           
            <label>Category</label>
            <select name="category" id="category">
                <option value="General" <%= "General".equals(prevCategory) ? "selected" : "" %>>General Feedback</option>
                <option value="User Experience" <%= "User Experience".equals(prevCategory) ? "selected" : "" %>>User Experience</option>
                <option value="Features" <%= "Features".equals(prevCategory) ? "selected" : "" %>>Features</option>
                <option value="Technical Issues" <%= "Technical Issues".equals(prevCategory) ? "selected" : "" %>>Technical Issues</option>
                <option value="Suggestions" <%= "Suggestions".equals(prevCategory) ? "selected" : "" %>>Suggestions</option>
                <option value="Other" <%= "Other".equals(prevCategory) ? "selected" : "" %>>Other</option>
            </select>
           
            <label>Your Feedback <span style="color:#E74C3C; font-size:12px;">*</span></label>
            <textarea name="message" id="message" placeholder="Tell us your thoughts, suggestions, or issues..." required><%= prevMessage %></textarea>
            <div class="char-counter" id="charCounter">0 characters (minimum 10)</div>
            <div id="messageError" class="field-error">
                <i class="fas fa-exclamation-circle"></i> Message must be at least 10 characters
            </div>

            <button type="submit" class="submit-btn" id="submitBtn">
                <i class="fas fa-paper-plane"></i> Submit Feedback
            </button>
        </form>
    </div>

    <div class="helper-box">
        <strong>What kind of feedback is helpful?</strong>
        <ul>
            <li>Your experience using SmileSpace features</li>
            <li>Suggestions for new enhancements</li>
            <li>Bugs or technical issues you found</li>
            <li>How the platform could support students better</li>
            <li>Ideas to improve user experience</li>
        </ul>
        <p style="margin-top: 15px; color: #713C0B; font-size: 14px;">
            <i class="fas fa-star" style="color: #FFD700;"></i>
            <strong>Rating Guide:</strong>
            1-2 stars = Negative, 3 stars = Neutral, 4-5 stars = Positive
        </p>
        
        <c:if test="${not empty sessionScope.userId}">
            <div style="margin-top: 20px; padding-top: 15px; border-top: 1px solid #F0D5B8;">
                <p style="color: #713C0B; font-weight: 600;">
                    <i class="fas fa-info-circle" style="color: #D7923B;"></i>
                    Want to see your previous feedback?
                </p>
                <a href="${pageContext.request.contextPath}/feedback/my-feedback" 
                   style="display: inline-flex; align-items: center; gap: 8px; margin-top: 10px; color: #D7923B; font-weight: 600;">
                    <i class="fas fa-history"></i> View My Feedback History
                </a>
            </div>
        </c:if>
    </div>

    <script>
        const userBtn = document.getElementById('userBtn');
        const dropdown = document.getElementById('dropdown');
        const form = document.getElementById('feedbackForm');
        const messageTextarea = document.getElementById('message');
        const charCounter = document.getElementById('charCounter');
        const messageError = document.getElementById('messageError');
        const ratingInputs = document.querySelectorAll('input[name="rating"]');
        const ratingError = document.getElementById('ratingError');
        const submitBtn = document.getElementById('submitBtn');
        const categorySelect = document.getElementById('category');

        userBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            dropdown.classList.toggle('show');
        });
       
        document.addEventListener('click', function() {
            dropdown.classList.remove('show');
        });
       
        dropdown.addEventListener('click', function(e) {
            e.stopPropagation();
        });

        function closeToast() {
            const toast = document.getElementById('successToast');
            if (toast) {
                toast.style.animation = 'slideIn 0.3s ease-out reverse';
                setTimeout(() => {
                    toast.style.display = 'none';
                }, 300);
            }
        }

        setTimeout(() => {
            closeToast();
        }, 5000);

        function updateCharCounter() {
            const length = messageTextarea.value.length;
            charCounter.textContent = `${length} characters (minimum 10)`;
           
            if (length < 10) {
                charCounter.className = 'char-counter warning';
                messageError.style.display = 'block';
            } else {
                charCounter.className = 'char-counter success';
                messageError.style.display = 'none';
            }
           
            updateSubmitButton();
        }

        function validateRating() {
            const selectedRating = document.querySelector('input[name="rating"]:checked');
            if (!selectedRating) {
                ratingError.style.display = 'block';
                return false;
            } else {
                ratingError.style.display = 'none';
                return true;
            }
        }

        function updateSubmitButton() {
            const messageLength = messageTextarea.value.length;
            const hasRating = document.querySelector('input[name="rating"]:checked') !== null;
           
            if (messageLength >= 10 && hasRating) {
                submitBtn.disabled = false;
            } else {
                submitBtn.disabled = true;
            }
        }

        form.addEventListener('submit', function(e) {
            const messageLength = messageTextarea.value.length;
            const hasRating = validateRating();
           
            if (messageLength < 10) {
                e.preventDefault();
                messageTextarea.focus();
                alert('Please provide more detailed feedback (at least 10 characters)');
                return;
            }
           
            if (!hasRating) {
                e.preventDefault();
                alert('Please select a rating for your experience');
                return;
            }
        });

        const stars = document.querySelectorAll('.star-rating label');
       
        stars.forEach(star => {
            star.addEventListener('mouseover', function() {
                const value = this.getAttribute('for').replace('star', '');
                highlightStars(value);
            });
           
            star.addEventListener('mouseout', function() {
                const checkedInput = document.querySelector('.star-rating input:checked');
                if (checkedInput) {
                    highlightStars(checkedInput.value);
                } else {
                    resetStars();
                }
            });
        });

        ratingInputs.forEach(input => {
            input.addEventListener('change', function() {
                highlightStars(this.value);
                updateSubmitButton();
            });
        });

        function highlightStars(value) {
            stars.forEach(star => {
                const starValue = star.getAttribute('for').replace('star', '');
                if (starValue <= value) {
                    star.style.color = '#FFD700';
                } else {
                    star.style.color = '#E2D5C1';
                }
            });
        }
       
        function resetStars() {
            stars.forEach(star => {
                star.style.color = '#E2D5C1';
            });
        }

        document.addEventListener('DOMContentLoaded', function() {
            updateCharCounter();
            updateSubmitButton();
           
            if (messageTextarea.value.length < 10) {
                messageTextarea.focus();
            }
           
            const checkedInput = document.querySelector('.star-rating input:checked');
            if (checkedInput) {
                highlightStars(checkedInput.value);
            }
           
            messageTextarea.addEventListener('input', updateCharCounter);
            categorySelect.addEventListener('change', function() {});
        });

        ratingInputs.forEach(input => {
            input.addEventListener('click', function() {
                ratingError.style.display = 'none';
            });
        });

        submitBtn.addEventListener('click', function(e) {
            if (!validateRating()) {
                ratingError.style.display = 'block';
            }
        });
    </script>

    <c:if test="${not empty sessionScope.userId}">
        <script>
            function fetchUnseenReplyCount() {
                fetch('${pageContext.request.contextPath}/feedback/unseen-count')
                    .then(response => response.json())
                    .then(data => {
                        if (data.count > 0) {
                            const myFeedbackLink = document.getElementById('myFeedbackLink');
                            if (myFeedbackLink) {
                                let badge = myFeedbackLink.querySelector('.notification-badge');
                                if (!badge) {
                                    badge = document.createElement('span');
                                    badge.className = 'notification-badge';
                                    myFeedbackLink.appendChild(badge);
                                }
                                badge.textContent = data.count;
                            }
                        }
                    })
                    .catch(error => console.error('Error fetching unseen count:', error));
            }
        </script>
    </c:if>

</body>
</html>