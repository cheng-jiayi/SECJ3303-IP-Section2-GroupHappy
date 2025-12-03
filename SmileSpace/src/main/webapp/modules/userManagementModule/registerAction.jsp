<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Get form data
    String username = request.getParameter("username");
    String phone = request.getParameter("phone");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String confirm = request.getParameter("confirm");
    
    // Validation
    StringBuilder error = new StringBuilder();
    
    if (username == null || !username.matches("^[a-zA-Z0-9]{3,20}$")) {
        error.append("Username must be 3-20 alphanumeric characters. ");
    }
    
    if (phone == null || !phone.matches("^[0-9]{10,15}$")) {
        error.append("Phone must be 10-15 digits. ");
    }
    
    if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
        error.append("Invalid email format. ");
    }
    
    if (password == null || password.length() < 8) {
        error.append("Password must be at least 8 characters. ");
    }
    
    if (!password.equals(confirm)) {
        error.append("Passwords do not match. ");
    }
    
    // If errors, show them
    if (error.length() > 0) {
        request.setAttribute("error", error.toString());
        request.getRequestDispatcher("registrationPage.jsp").forward(request, response);
        return;
    }
    
    // SUCCESS - For demo, just redirect to login with success message
    request.setAttribute("success", "Registration successful! Please login.");
    request.getRequestDispatcher("loginPage.jsp").forward(request, response);
%>