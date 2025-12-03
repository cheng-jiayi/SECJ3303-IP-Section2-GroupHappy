<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    // Demo users
    if ("student1".equals(username) && "password123".equals(password)) {
        session.setAttribute("username", username);
        session.setAttribute("userRole", "student");
        session.setAttribute("userFullName", "Amy Tan");
        session.setAttribute("phone", "012-3456789");
        session.setAttribute("email", "student1@graduate.utm.my");
        response.sendRedirect("dashboards/studentDashboard.jsp");
    }
    else if ("faculty1".equals(username) && "password123".equals(password)) {
        session.setAttribute("username", username);
        session.setAttribute("userRole", "faculty");
        session.setAttribute("userFullName", "Dr. Smith");
        session.setAttribute("phone", "012-3456000");
        session.setAttribute("email", "faculty1@utm.my");
        response.sendRedirect("dashboards/facultyDashboard.jsp");
    }
    else if ("admin1".equals(username) && "password123".equals(password)) {
        session.setAttribute("username", username);
        session.setAttribute("userRole", "admin");
        session.setAttribute("userFullName", "Admin User");
        session.setAttribute("phone", "012-3456787");
        session.setAttribute("email", "admin1@utm.my");
        response.sendRedirect("dashboards/adminDashboard.jsp");
    }
    else if ("professional1".equals(username) && "password123".equals(password)) {
        session.setAttribute("username", username);
        session.setAttribute("userRole", "professional");
        session.setAttribute("userFullName", "Dr. Johnson");
        session.setAttribute("phone", "012-3456786");
        session.setAttribute("email", "professional1@utm.my");
        response.sendRedirect("dashboards/professionalDashboard.jsp");
    }
    else {
        // Invalid credentials
        request.setAttribute("error", "Invalid username or password");
        request.getRequestDispatcher("loginPage.jsp").forward(request, response);
    }
%>