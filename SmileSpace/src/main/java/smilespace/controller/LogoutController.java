package smilespace.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Cookie;
import java.io.IOException;
import java.util.logging.Logger;

@Controller
@RequestMapping("/logout")
public class LogoutController {
    
    private static final Logger logger = Logger.getLogger(LogoutController.class.getName());
    
    @GetMapping
    public String performLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        return logout(request, response);
    }
    
    @PostMapping
    public String performLogoutPost(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        return logout(request, response);
    }
    
    private String logout(HttpServletRequest request, HttpServletResponse response) {
        setNoCacheHeaders(response);
        
        String username = getUsernameFromSession(request);
        
        clearAuthCookies(response);
        
        invalidateSession(request);
        
        logger.info("User logged out: " + (username != null ? username : "Unknown"));
        
        return "redirect:/login?logout=success&message=You have been successfully logged out.";
    }
    
    private String getUsernameFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object user = session.getAttribute("user");
            if (user != null) {
                try {
                    java.lang.reflect.Method getUsername = user.getClass()
                            .getMethod("getUsername");
                    return (String) getUsername.invoke(user);
                } catch (Exception e) {
                    return (String) session.getAttribute("username");
                }
            }
        }
        return null;
    }
    
    private void setNoCacheHeaders(HttpServletResponse response) {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        response.setDateHeader("Expires", -1);
    }
    
    private void clearAuthCookies(HttpServletResponse response) {
        Cookie rememberCookie = new Cookie("rememberToken", "");
        rememberCookie.setMaxAge(0);
        rememberCookie.setPath("/");
        response.addCookie(rememberCookie);
        
        Cookie sessionCookie = new Cookie("JSESSIONID", "");
        sessionCookie.setMaxAge(0);
        sessionCookie.setPath("/");
        response.addCookie(sessionCookie);
    }
    
    private void invalidateSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            try {
                java.util.Enumeration<String> attributeNames = session.getAttributeNames();
                while (attributeNames.hasMoreElements()) {
                    session.removeAttribute(attributeNames.nextElement());
                }
                
                session.invalidate();
                logger.fine("Session invalidated successfully");
                
            } catch (IllegalStateException e) {
                logger.warning("Session was already invalidated: " + e.getMessage());
            } catch (Exception e) {
                logger.severe("Error invalidating session: " + e.getMessage());
            }
        }
    }
}
