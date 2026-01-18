package smilespace.filter;

import java.util.logging.Logger;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class SelfAssessmentAuthorizationFilter implements HandlerInterceptor {
    private static final Logger logger = Logger.getLogger(SelfAssessmentAuthorizationFilter.class.getName());
    
    private static final String[] PROTECTED_PATTERNS = {
        "/self-assessment/manage",
        "/self-assessment/delete",
        "/self-assessment/export/csv",
        "/self-assessment/details",
        "/self-assessment/history"
    };
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        logger.info(() -> "SelfAssessmentAuthorizationFilter checking access to: " + requestURI);
        
        if (!isProtectedRequest(requestURI, contextPath)) {
            return true;
        }
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            logger.warning("User not logged in, redirecting to login page");
            response.sendRedirect(contextPath + "/login?redirect=" + requestURI);
            return false;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        
        if (!isAuthorized(userRole)) {
            logger.warning(() -> "User with role " + userRole + " not authorized for: " + requestURI);
            response.sendRedirect(contextPath + "/dashboard?error=unauthorized");
            return false;
        }
        
        return true;
    }
    
    private boolean isProtectedRequest(String requestURI, String contextPath) {
        for (String pattern : PROTECTED_PATTERNS) {
            if (requestURI.startsWith(contextPath + pattern)) {
                return true;
            }
        }
        return false;
    }
    
    private boolean isAuthorized(String userRole) {
        return "professional".equals(userRole);
    }
}