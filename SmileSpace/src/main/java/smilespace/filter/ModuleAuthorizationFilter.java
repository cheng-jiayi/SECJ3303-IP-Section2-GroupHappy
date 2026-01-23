package smilespace.filter;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.logging.Logger;

@Component
public class ModuleAuthorizationFilter implements HandlerInterceptor {
    private static final Logger logger = Logger.getLogger(ModuleAuthorizationFilter.class.getName());
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        logger.info("ModuleAuthorizationInterceptor checking access to: " + requestURI);
        
        if (!(requestURI.contains("/create-module") || 
              requestURI.contains("/edit-module") || 
              requestURI.contains("/delete-module"))) {
            return true;
        }
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            logger.warning("User not logged in, redirecting to login page");
            String loginPage = contextPath + "/modules/userManagementModule/loginPage.jsp";
            response.sendRedirect(loginPage);
            return false;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        Object userIdObj = session.getAttribute("userId");
        int userId = 0;
        
        if (userIdObj instanceof Integer) {
            userId = (Integer) userIdObj;
        } else if (userIdObj instanceof String) {
            try {
                userId = Integer.parseInt((String) userIdObj);
            } catch (NumberFormatException e) {
                logger.warning("Invalid user ID format: " + userIdObj);
            }
        }
        
        logger.info("User ID: " + userId + ", Role: " + userRole);
        
        if (!isAuthorized(userRole)) {
            logger.warning("User " + userId + " with role " + userRole + " not authorized for: " + requestURI);
            response.sendRedirect(contextPath + "/dashboard?error=unauthorized");
            return false;
        }

        request.setAttribute("loggedInUserId", userId);
        request.setAttribute("loggedInUserRole", userRole);
        
        return true;
    }
    
    private boolean isAuthorized(String userRole) {
        return "admin".equals(userRole) || 
               "faculty".equals(userRole) || 
               "professional".equals(userRole);
    }
}