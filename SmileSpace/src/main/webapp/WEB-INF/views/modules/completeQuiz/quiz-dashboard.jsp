<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="smilespace.model.LearningModule" %>
<%
    List<LearningModule> stressModules = (List<LearningModule>) request.getAttribute("stressModules");
    String pageTitle = (String) request.getAttribute("pageTitle");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    
    if (pageTitle == null) pageTitle = "All Learning Modules";
    if (selectedCategory == null) selectedCategory = "all";
    
    String categoryDescription = "";
    switch(selectedCategory) {
        case "Stress":
            categoryDescription = "Feeling overwhelmed? These modules will teach you how to stay calm, balanced, and confident even under pressure. Select a module to begin your learning journey.";
            break;
        case "Sleep":
            categoryDescription = "Struggling with sleep? These modules will help you understand sleep patterns and develop better sleep habits for improved rest and energy.";
            break;
        case "Anxiety":
            categoryDescription = "Dealing with anxiety? These modules provide techniques to manage anxious thoughts and build resilience in challenging situations.";
            break;
        case "Self-Esteem":
            categoryDescription = "Looking to build confidence? These modules focus on developing self-worth, positive self-talk, and embracing your unique qualities.";
            break;
        case "Mindfulness":
            categoryDescription = "Want to live more mindfully? These modules teach present-moment awareness and meditation techniques for greater peace and clarity.";
            break;
        default:
            categoryDescription = "Explore various mental wellness topics. Select a module to begin your learning journey toward better mental health.";
    }

    
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= pageTitle %> - SmileSpace</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: #FFF8E8;
            color: #6B4F36;
            min-height: 100vh;
        }
        
        .top-right {
            position: absolute;
            right: 40px;
            top: 20px;
            font-size: 20px;
            font-weight: bold;
        }

        .home-link {
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none; 
            color: #6B4F36; 
            transition: opacity 0.2s;
        }

        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .home-link:hover {
            opacity: 0.7;
            text-decoration: none;
        }
        
        .category-nav {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-left: 20px;
        }
        
        .category-btn {
            padding: 8px 20px;
            border-radius: 20px;
            background-color: white;
            border: 2px solid #E8D9B5;
            color: #6B4F36;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .category-btn:hover {
            background-color: #FFF3C8;
            border-color: #CF8224;
            transform: translateY(-2px);
        }
        
        .category-btn.active {
            background-color: #CF8224;
            color: white;
            border-color: #CF8224;
        }
        

        .main-container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .page-header {
            margin-bottom: 40px;
        }
        
        .page-title {
            font-size: 32px;
            color: #6B4F36;
            margin-bottom: 10px;
            font-weight: 700;
            letter-spacing: -0.5px;
        }
        
        .page-subtitle {
            font-size: 18px;
            color: #CF8224;
            margin-bottom: 15px;
            font-weight: 500;
        }
        
        .welcome-message {
            color: #8D735B;
            font-size: 16px;
            line-height: 1.6;
            max-width: 800px;
            padding: 20px;
            background-color: #FFFDF6;
            border-radius: 12px;
            border-left: 4px solid #CF8224;
            margin-top: 20px;
        }
        
        .controls-section {
            background-color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 40px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: 1px solid #E8D9B5;
        }
        
        .controls-wrapper {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }
        
        .search-container {
            flex: 1;
            max-width: 500px;
            position: relative;
        }
        
        .search-input {
            width: 100%;
            padding: 14px 20px 14px 50px;
            border: 2px solid #E8D9B5;
            border-radius: 25px;
            background-color: #FFFDF6;
            font-size: 15px;
            color: #6B4F36;
            transition: all 0.3s ease;
        }
        
        .search-input:focus {
            outline: none;
            border-color: #CF8224;
            box-shadow: 0 0 0 3px rgba(207, 130, 36, 0.1);
        }
        
        .search-icon {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #CF8224;
            font-size: 18px;
        }
        
        .filter-container {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .filter-label {
            color: #6B4F36;
            font-weight: 600;
            font-size: 15px;
        }
        
        .filter-dropdown {
            padding: 12px 25px;
            border: 2px solid #E8D9B5;
            border-radius: 25px;
            background-color: #FFFDF6;
            color: #6B4F36;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 180px;
        }
        
        .filter-dropdown:focus {
            outline: none;
            border-color: #CF8224;
            box-shadow: 0 0 0 3px rgba(207, 130, 36, 0.1);
        }
        
        .modules-section {
            margin-bottom: 50px;
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }
        
        .section-title {
            font-size: 24px;
            color: #6B4F36;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .modules-count {
            background-color: #FFF3C8;
            color: #CF8224;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        
        .modules-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 30px;
        }
        

        .module-card {
            background-color: white;
            border-radius: 18px;
            padding: 30px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.06);
            border: 1px solid #E8D9B5;
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        
        .module-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.1);
            border-color: #CF8224;
        }
        
        .module-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
        }
        
        .module-id {
            background-color: #FFF3C8;
            color: #CF8224;
            padding: 5px 15px;
            border-radius: 15px;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.5px;
        }
        
        .module-level {
            padding: 7px 18px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .module-level.beginner {
            background-color: #E8F5E9;
            color: #2E7D32;
        }
        
        .module-level.intermediate {
            background-color: #E3F2FD;
            color: #1565C0;
        }
        
        .module-level.advanced {
            background-color: #FFF3E0;
            color: #EF6C00;
        }
        
        .module-category {
            position: absolute;
            top: 15px;
            left: -30px;
            background-color: #CF8224;
            color: white;
            padding: 5px 35px;
            transform: rotate(-45deg);
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.5px;
        }
        
        .module-content {
            flex: 1;
            margin-bottom: 25px;
        }
        
        .module-title {
            font-size: 22px;
            color: #6B4F36;
            margin-bottom: 15px;
            font-weight: 700;
            line-height: 1.3;
        }
        
        .module-desc {
            color: #8D735B;
            font-size: 15px;
            line-height: 1.6;
            margin-bottom: 20px;
        }
        
        .module-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 20px;
            border-top: 1px solid #F0E9DD;
            margin-top: auto;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #8D735B;
            font-size: 13px;
        }
        
        .module-footer {
            margin-top: 20px;
        }
        
        .btn-start {
            display: block;
            width: 100%;
            background: linear-gradient(135deg, #CF8224 0%, #E8A95E 100%);
            color: white;
            text-align: center;
            padding: 14px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 700;
            font-size: 15px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .btn-start:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(207, 130, 36, 0.3);
        }
        
        .no-modules-message {
            text-align: center;
            padding: 60px 40px;
            color: #8D735B;
            font-size: 17px;
            grid-column: 1 / -1;
            background-color: white;
            border-radius: 15px;
            border: 1px solid #E8D9B5;
        }
        
        .no-modules-icon {
            font-size: 48px;
            color: #E8D9B5;
            margin-bottom: 20px;
        }
        
        @media (max-width: 768px) {
            .main-container {
                padding: 0 15px;
            }
            
            .header {
                padding: 15px 20px;
                flex-direction: column;
                gap: 15px;
            }
            
            .category-nav {
                margin-left: 0;
                justify-content: center;
            }
            
            .controls-wrapper {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-container {
                max-width: 100%;
            }
            
            .filter-container {
                width: 100%;
                justify-content: space-between;
            }
            
            .filter-dropdown {
                flex: 1;
                min-width: 0;
            }
            
            .modules-grid {
                grid-template-columns: 1fr;
            }
            
            .module-card {
                padding: 25px;
            }
            
            .page-title {
                font-size: 28px;
            }
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .module-card {
            animation: fadeIn 0.5s ease forwards;
        }
        

        .text-center { text-align: center; }
        .text-right { text-align: right; }
        .mb-20 { margin-bottom: 20px; }
        .mb-30 { margin-bottom: 30px; }
        .mt-20 { margin-top: 20px; }
        .mt-30 { margin-top: 30px; }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <div class="top-right">
        <a href="<%= request.getContextPath() %>/student-learning-modules" class="home-link">
        <div class="logo">
            <i class="fas fa-home"></i>
            SmileSpace
        </div>
    </a>
    </div>
    
    <main class="main-container">
        <section class="page-header">
            <h1 class="page-title"><%= pageTitle %></h1>
            <p class="page-subtitle">Filtered by: <%= "all".equals(selectedCategory) ? "All Categories" : selectedCategory %></p>
            <div class="welcome-message">
                <%= categoryDescription %>
            </div>
        </section>
        
        <section class="controls-section">
            <div class="controls-wrapper">
                <div class="search-container">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" class="search-input" placeholder="Search modules by title or description...">
                </div>
                
                <div class="filter-container">
                    <span class="filter-label">Filter by level:</span>
                    <select class="filter-dropdown" id="levelFilter">
                        <option value="all">All Levels</option>
                        <option value="beginner">Beginner</option>
                        <option value="intermediate">Intermediate</option>
                        <option value="advanced">Advanced</option>
                    </select>
                </div>
            </div>
        </section>
        
        <section class="modules-section">
            <div class="section-header">
                <h2 class="section-title">
                    <i class="fas fa-graduation-cap"></i>
                    <%= "all".equals(selectedCategory) ? "All Modules" : selectedCategory + " Modules" %>
                </h2>
                <span class="modules-count">
                    <%= stressModules != null ? stressModules.size() : 0 %> Module<%= stressModules != null && stressModules.size() != 1 ? "s" : "" %>
                </span>
            </div>
            
            <div class="modules-grid">
                <% if (stressModules != null && !stressModules.isEmpty()) { 
                    for (LearningModule module : stressModules) { 
                        String levelClass = "";
                        String level = module.getLevel().toLowerCase();
                        switch(level) {
                            case "beginner": levelClass = "beginner"; break;
                            case "intermediate": levelClass = "intermediate"; break;
                            case "advanced": 
                            case "advance": levelClass = "advanced"; break;
                            default: levelClass = "beginner";
                        }
                %>
                    <article class="module-card">
                        <div class="module-category"><%= module.getCategory() %></div>
                        <div class="module-header">
                            <span class="module-id"><%= module.getId() %></span>
                            <span class="module-level <%= levelClass %>"><%= module.getLevel() %></span>
                        </div>
                        
                        <div class="module-content">
                            <h3 class="module-title"><%= module.getTitle() %></h3>
                            <p class="module-desc"><%= module.getDescription() %></p>
                        </div>
                        
                        <div class="module-meta">
                            <div class="meta-item">
                                <i class="far fa-eye"></i>
                                <span><%= module.getViews() %> views</span>
                            </div>
                            <div class="meta-item">
                                <i class="far fa-calendar-alt"></i>
                                <span><%= module.getLastUpdated() %></span>
                            </div>
                        </div>
                        
                        <div class="module-footer">
                            <a href="<%= request.getContextPath() %>/student-module?id=<%= module.getId() %>&category=<%= java.net.URLEncoder.encode(selectedCategory, "UTF-8") %>" class="btn-start">
                                <i class="fas fa-play-circle"></i>
                                Begin Journey
                            </a>
                        </div>
                    </article>
                <%   }
                   } else { %>
                    <div class="no-modules-message">
                        <div class="no-modules-icon">
                            <i class="fas fa-book-open"></i>
                        </div>
                        <h3>No Modules Available</h3>
                        <p>
                            <%= "all".equals(selectedCategory) 
                                ? "There are currently no submitted learning modules available." 
                                : "There are no submitted modules in the " + selectedCategory + " category." %>
                        </p>
                        <% if (!"all".equals(selectedCategory)) { %>
                            <p style="margin-top: 10px;">
                                <a href="<%= request.getContextPath() %>/quiz-dashboard?category=all" 
                                   style="color: #CF8224; text-decoration: underline;">
                                    View all modules
                                </a>
                            </p>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </section>
    </main>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const modules = document.querySelectorAll('.module-card');
            const searchInput = document.querySelector('.search-input');
            const levelFilter = document.getElementById('levelFilter');
            
            searchInput.addEventListener('input', function(e) {
                const searchTerm = e.target.value.trim().toLowerCase();
                
                modules.forEach(module => {
                    if (module.style.display === 'none') return;
                    
                    const title = module.querySelector('.module-title').textContent.toLowerCase();
                    const desc = module.querySelector('.module-desc').textContent.toLowerCase();
                    
                    if (searchTerm === '' || title.includes(searchTerm) || desc.includes(searchTerm)) {
                        module.style.display = 'flex';
                        module.style.animation = 'fadeIn 0.5s ease forwards';
                    } else {
                        module.style.display = 'none';
                    }
                });
            });
            
            levelFilter.addEventListener('change', function(e) {
                const selectedLevel = e.target.value.toLowerCase();
                
                modules.forEach(module => {
                    const levelElement = module.querySelector('.module-level');
                    if (levelElement) {
                        const levelText = levelElement.textContent.toLowerCase();
                        
                        if (selectedLevel === 'all' || levelText.includes(selectedLevel)) {
                            module.style.display = 'flex';
                            module.style.animation = 'fadeIn 0.5s ease forwards';
                        } else {
                            module.style.display = 'none';
                        }
                    }
                });
                
                searchInput.dispatchEvent(new Event('input'));
            });
            
            const categoryButtons = document.querySelectorAll('.category-btn');
            categoryButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    categoryButtons.forEach(btn => btn.classList.remove('active'));
                    this.classList.add('active');
                });
            });
            
            modules.forEach(module => {
                module.addEventListener('click', function(e) {
                    if (!e.target.closest('.btn-start')) {
                        const link = this.querySelector('.btn-start');
                        if (link) {
                            link.style.transform = 'scale(0.98)';
                            setTimeout(() => {
                                link.style.transform = '';
                            }, 150);
                        }
                    }
                });
            });
            
            levelFilter.addEventListener('focus', function() {
                this.parentElement.style.transform = 'translateY(-2px)';
            });
            
            levelFilter.addEventListener('blur', function() {
                this.parentElement.style.transform = '';
            });
            
            const urlParams = new URLSearchParams(window.location.search);
            const levelParam = urlParams.get('level');
            if (levelParam && ['beginner', 'intermediate', 'advanced'].includes(levelParam.toLowerCase())) {
                levelFilter.value = levelParam.toLowerCase();
                levelFilter.dispatchEvent(new Event('change'));
            }
        });
    </script>
</body>
</html>