package smilespace.controller;

import jakarta.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import smilespace.dao.UserDAO;
import smilespace.model.User;

@Controller
@RequestMapping("/profile")
public class ProfileController {

    @Autowired
    private UserDAO userDAO;

    //View Profile
    @GetMapping
    public String viewProfile(HttpSession session, Model model) {
        System.out.println("=== DEBUG ProfileController.viewProfile() ===");

        // Try to get user from session
        User sessionUser = (User) session.getAttribute("user");
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("userRole");

        System.out.println("Session user: " + (sessionUser != null ? sessionUser.getFullName() : "null"));
        System.out.println("Session userId: " + userId);
        System.out.println("Session role: " + role);

        User user = null;

        if (sessionUser != null) {
            // Always fetch fresh data from DB
            user = userDAO.getUserById(sessionUser.getUserId());
            // Update session with fresh user object
            session.setAttribute("user", user);
        } else if (userId != null) {
            user = userDAO.getUserById(userId);
            if (user != null) {
                // Save user object and role in session
                session.setAttribute("user", user);
                session.setAttribute("userRole", user.getUserRole());
                session.setAttribute("userId", user.getUserId());
            }
        }

        if (user == null) {
            System.out.println("=== ERROR: No user found, redirecting to login ===");
            return "redirect:/login";
        }

        System.out.println("Database user found: " + user.getFullName());
        System.out.println("Faculty from DB: " + user.getFaculty());
        System.out.println("Email from DB: " + user.getEmail());

        model.addAttribute("user", user);
        model.addAttribute("userRole", role != null ? role : user.getUserRole());

        System.out.println("DEBUG faculty: '" + user.getFaculty() + "'");
        System.out.println("DEBUG faculty class: " + (user.getFaculty() != null ? user.getFaculty().getClass().getName() : "null"));

        return "/userManagementModule/profile";
    }

    /* ================= UPDATE PROFILE ================= */
    @PostMapping("/update")
    public String updateProfile(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String phone,
            @RequestParam(required = false) String matricNumber,
            @RequestParam(required = false) String faculty,
            @RequestParam(required = false) Integer year,
            HttpSession session
    ) {
        User sessionUser = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("userRole");

        if (sessionUser == null) {
            return "redirect:/login";
        }

        // Get fresh user from database
        User user = userDAO.getUserById(sessionUser.getUserId());
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);

        // Only students can update these
        if ("student".equals(role)) {
            user.setMatricNumber(matricNumber);
            user.setFaculty(faculty);
            user.setYear(year);
        }

        userDAO.updateUser(user);

        // Update session values - ALSO update the user object
        session.setAttribute("userFullName", fullName);
        session.setAttribute("email", email);
        session.setAttribute("phone", phone);
        
        // Update the user object in session with new data
        sessionUser.setFullName(fullName);
        sessionUser.setEmail(email);
        sessionUser.setPhone(phone);
        if ("student".equals(role)) {
            sessionUser.setMatricNumber(matricNumber);
            sessionUser.setFaculty(faculty);
            sessionUser.setYear(year);
        }
        session.setAttribute("user", sessionUser);

        return "redirect:/profile";
    }

    /* ================= CHANGE PASSWORD ================= */
    @PostMapping("/change-password")
    public String changePassword(
            @RequestParam String newPassword,
            HttpSession session
    ) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        // Hash the password using BCrypt
        String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());

        // Update in DB
        userDAO.updatePassword(user.getUserId(), hashed);

        // Optionally, set a session attribute or flash message
        session.setAttribute("message", "Password updated successfully!");

        return "redirect:/profile";
    }
}
