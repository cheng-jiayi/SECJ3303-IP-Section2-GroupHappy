package smilespace.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import smilespace.filter.FeedbackAuthorizationFilter;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = {
    "smilespace.controller",
    "smilespace.controller.feedbackAndAnalytics",  
    "smilespace.service",                        
    "smilespace.dao",                             
    "smilespace.filter"                           
})
public class WebConfig implements WebMvcConfigurer {
    
    @Bean
    public FeedbackAuthorizationFilter feedbackAuthorizationFilter() {
        return new FeedbackAuthorizationFilter();
    }

    
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(feedbackAuthorizationFilter())
                .addPathPatterns("/feedback/analytics/**")
                .addPathPatterns("/feedback/reply/**")
                .addPathPatterns("/feedback/resolve/**")
                .addPathPatterns("/feedback/report/**")
                .excludePathPatterns("/feedback") 
                .excludePathPatterns("/feedback/submit")  
                .excludePathPatterns("/feedback/my-feedback/**");  
    
    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/modules/");
        resolver.setSuffix(".jsp");
        registry.viewResolver(resolver);
    }
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String uploadPath = System.getProperty("user.dir") + "/uploads/";
        System.out.println("DEBUG: Upload path configured: " + uploadPath);
        
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadPath);
        
        registry.addResourceHandler("/css/**")
                .addResourceLocations("/css/");
        
        registry.addResourceHandler("/js/**")
                .addResourceLocations("/js/");
        
        registry.addResourceHandler("/images/**")
                .addResourceLocations("/images/");

        registry.addResourceHandler("/modules/**")
                .addResourceLocations("/WEB-INF/views/modules/");
        
        registry.addResourceHandler("/static/**")
                .addResourceLocations("/static/");
        
        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/");

        registry.addResourceHandler("/fontawesome/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/font-awesome/6.0.0/");
        
        registry.addResourceHandler("/fonts/**")
                .addResourceLocations("classpath:/static/fonts/");
    }
}
