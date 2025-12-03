<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if already logged in
    if (session.getAttribute("username") != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - SmileSpace</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: #FFF8E8;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            width: 100%;
            max-width: 400px;
        }
        .logo {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo h1 {
            color: #D7923B;
            font-size: 42px;
            margin-bottom: 10px;
        }
        .card {
            background: #FFF3C8;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(107, 79, 54, 0.15);
        }
        .card h2 {
            color: #6B4F36;
            text-align: center;
            margin-bottom: 30px;
            font-size: 28px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            color: #6B4F36;
            font-weight: bold;
            margin-bottom: 8px;
        }
        input {
            width: 100%;
            padding: 12px;
            border: 2px solid #E8D4B9;
            border-radius: 10px;
            font-size: 16px;
        }
        input:focus {
            outline: none;
            border-color: #D7923B;
        }
        .btn {
            width: 100%;
            padding: 14px;
            background: #D7923B;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 10px;
        }
        .btn:hover {
            background: #C77D2F;
        }
        .link {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid #E8D4B9;
        }
        .link a {
            display: block;
            background: #8B7355;
            color: white;
            padding: 12px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
        }
        .link a:hover {
            background: #6B4F36;
        }
        .message {
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
        }
        .error {
            background: #FFE8E6;
            color: #E74C3C;
        }
        .success {
            background: #E8F6F3;
            color: #27AE60;
        }
        .demo-info {
            background: #E8F4F8;
            padding: 15px;
            border-radius: 10px;
            margin-top: 20px;
            font-size: 14px;
            color: #2C7873;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">
            <h1>SmileSpace</h1>
            <p>Your mental wellness companion</p>
        </div>
        
        <div class="card">
            <h2>Welcome Back!</h2>
            
            <% if (error != null) { %>
                <div class="message error"><%= error %></div>
            <% } %>
            
            <% if (success != null) { %>
                <div class="message success"><%= success %></div>
            <% } %>
            
            <form action="loginAction.jsp" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" placeholder="Enter username" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Enter password" required>
                </div>
                
                <button type="submit" class="btn">Sign In</button>
            </form>
            
            <div class="link">
                <p>Don't have an account?</p>
                <a href="registrationPage.jsp">Create New Account</a>
            </div>
            
            <div class="demo-info">
                <strong>Demo Accounts:</strong><br>
                Student: student1 / password123<br>
                Faculty: faculty1 / password123<br>
                Admin: admin1 / password123<br>
                Professional: professional1 / password123
            </div>
        </div>
    </div>
</body>
</html>