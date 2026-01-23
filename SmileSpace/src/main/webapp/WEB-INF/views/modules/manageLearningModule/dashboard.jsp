<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="smilespace.model.LearningModule" %>
<%
    List<LearningModule> modules = (List<LearningModule>) request.getAttribute("modules");
    String searchTerm = (String) request.getAttribute("searchTerm");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String selectedLevel = (String) request.getAttribute("selectedLevel");
    String selectedStatus = (String) request.getAttribute("selectedStatus");
    String userRole = (String) request.getAttribute("userRole");
    Map<String, Object> statistics = (Map<String, Object>) request.getAttribute("statistics");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Learning Module Dashboard - Faculty</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600&display=swap" rel="stylesheet">
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
            min-height: 100vh;
        }
        
        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 30px;
            background: #FBF6EA;
            border-bottom: 2px solid #F0D5B8;
        }
        
        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
            display: flex;
            align-items: center;
            gap: 8px;
            justify-content: flex-end; 
            margin-left: auto;    
        }
        
        .logo i {
            color: #F0A548;
            font-size: 22px;
        }
        
        .container { 
            max-width: 1300px; 
            margin: 20px auto;
            padding: 0 15px;
        }
        
        .page-title {
            text-align: left;
            margin: 20px 0 30px 0;
        }
        
        .page-title h1 {
            font-size: 36px;
            font-weight: 700;
            color: #F0A548;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }
        
        .page-title p {
            font-size: 16px;
            color: #713C0B;
            opacity: 0.9;
        }
        
        .role-badge {
            display: inline-block;
            background: #F0A548;
            color: white;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 14px;
            font-weight: 600;
            margin-left: 10px;
        }
        
        .content { 
            background: white; 
            border-radius: 20px; 
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            border: 2px solid #F0D5B8;
        }
        
        .header-row {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }
        
        .search-container {
            flex: 1;
            min-width: 100px;
            position: relative;
        }
        
        .search-input { 
            width: 100%; 
            padding: 12px 20px 12px 45px; 
            border: 2px solid #713C0B; 
            border-radius: 12px; 
            font-size: 15px;
            background: #F4DBAF;
            color: #713C0B;
            transition: all 0.3s;
        }
        
        .search-input::placeholder {
            color: #713C0B;
            opacity: 0.7;
        }
        
        .search-input:focus {
            outline: none;
            border-color: #F0A548;
            box-shadow: 0 0 0 3px rgba(240, 165, 72, 0.2);
            background: #F9EEDB;
        }
        
        .search-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #713C0B;
            font-size: 16px;
        }
        
        .filter-container {
            min-width: 100px;

        }
        
        .filter-select { 
            width: 100%; 
            padding: 12px 20px; 
            border: 2px solid #713C0B; 
            border-radius: 12px; 
            font-size: 15px;
            background: #F4DBAF;
            color: #713C0B;
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%23713C0B' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 12px;
            padding-right: 40px;
        }
        
        .filter-select:focus {
            outline: none;
            border-color: #F0A548;
            box-shadow: 0 0 0 3px rgba(240, 165, 72, 0.2);
            background-color: #F9EEDB;
        }
        
        .add-btn { 
            background: transparent; 
            color: #713C0B; 
            border: 2px solid #713C0B; 
            padding: 12px 24px; 
            border-radius: 12px; 
            cursor: pointer; 
            text-decoration: none; 
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s;
            white-space: nowrap;
            background: #F4DBAF;
        }
        
        .add-btn:hover { 
            background: #713C0B; 
            color: #FBF6EA;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(113, 60, 11, 0.2);
        }
        
        .add-btn:hover i {
            color: #FBF6EA;
        }
        
        .add-btn i {
            color: #713C0B;
            transition: color 0.3s;
        }
        
        .filters { 
            background: #FFF9F0; 
            padding: 20px; 
            border-radius: 15px; 
            margin-bottom: 25px; 
            border: 2px solid #F0D5B8;
        }
        
        .filter-row { 
            display: grid; 
            grid-template-columns: 1fr 1fr 1fr; 
            gap: 15px; 
            margin-bottom: 15px; 
        }
        
        @media (max-width: 768px) {
            .filter-row {
                grid-template-columns: 1fr;
            }
        }
        
        .filter-group { 
            flex: 1; 
        }
        
        .filter-label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: 600; 
            color: #713C0B;
            font-size: 15px;
        }
        
        .filter-btn {
            background: #F0A548; 
            color: white; 
            border: none; 
            padding: 12px 25px; 
            border-radius: 12px; 
            cursor: pointer; 
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s;
        }
        
        .filter-btn:hover { 
            background: #f7bc70;
            transform: translateY(-2px);
        }
        
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 15px;
            background: #F4DBAF;
            border-radius: 12px;
            overflow: hidden;
        }
        
        th { 
            background: #F4DBAF; 
            color: #713C0B; 
            padding: 16px 12px; 
            text-align: left; 
            font-weight: 600;
            font-size: 15px;
            border-bottom: 3px solid #713C0B;
        }
        
        td { 
            padding: 14px 12px; 
            border-bottom: 2px solid #E8C7A0; 
            color: #713C0B;
            background: #F9EEDB;
        }
        
        tr:hover { 
            background: #F9EEDB; 
        }
        
        tr:last-child td {
            border-bottom: none;
        }
        
        .badge { 
            display: inline-block; 
            padding: 6px 12px; 
            border-radius: 15px; 
            font-size: 13px; 
            font-weight: 600; 
        }
        
        .stress { background: #FFE0E0; color: #C73737; }
        .sleep { background: #D7F7F7; color: #2A8989; }
        .anxiety { background: #FFF4C8; color: #B88414; }
        .self-esteem { background: #D1EBFF; color: #106C9E; }
        .mindfulness { background: #CFFFE5; color: #17926E; }
        
        .level-beginner { background: #CFFFE5; color: #136E52; }
        .level-intermediate { background: #FFF0BE; color: #85620C; }
        .level-advance { background: #FFD8E1; color: #A12B52; }
        
        .status-draft { 
            background: #FFF4C8; 
            color: #B88414; 
        }
        .status-submitted { 
            background: #CFFFE5; 
            color: #17926E; 
        }
        
        .actions { 
            display: flex; 
            gap: 8px; 
            flex-wrap: wrap;
        }
        
        .action-btn { 
            background: #F0A548; 
            color: white; 
            border: none; 
            padding: 6px 12px; 
            border-radius: 8px; 
            cursor: pointer; 
            text-decoration: none; 
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-weight: 500;
            font-size: 13px;
            transition: all 0.3s;
        }
        
        .action-btn:hover { 
            background: #D18A2C; 
            transform: translateY(-1px);
        }
        
        .action-btn.view { background: #A7C7E7; }
        .action-btn.view:hover { background: #3a8de0; }
        
        .action-btn.edit { background: #F6D89C; }
        .action-btn.edit:hover { background: #D18A2C; }
        
        .action-btn.delete { background: #FFC0BB; }
        .action-btn.delete:hover { background: #fc4e42; }
        
        .action-btn.submit { 
            background: #06D6A0; 
            color: white; 
        }
        .action-btn.submit:hover { 
            background: #04B486; 
        }
        
        .pagination { 
            display: flex; 
            gap: 8px; 
            justify-content: center; 
            margin-top: 25px; 
            padding-top: 20px;
            border-top: 2px solid #F0D5B8;
        }
        
        .page-btn { 
            padding: 8px 15px; 
            border: 2px solid #F0D5B8; 
            background: white; 
            color: #713C0B;
            border-radius: 10px; 
            cursor: pointer; 
            font-weight: 600;
            transition: all 0.3s;
            min-width: 40px;
        }
        
        .page-btn:hover { 
            border-color: #F0A548;
            background: #FFF9F0;
        }
        
        .page-btn.active { 
            background: #F0A548; 
            color: white; 
            border-color: #F0A548;
        }
        
        .empty-state { 
            text-align: center; 
            padding: 50px 20px; 
            color: #C7A178;
            background: #FFF9F0;
            border-radius: 15px;
            border: 2px dashed #F0D5B8;
            margin: 20px 0;
        }
        
        .empty-state i {
            font-size: 40px;
            margin-bottom: 15px;
            color: #F0D5B8;
        }
        
        .empty-state h3 {
            color: #713C0B;
            margin-bottom: 8px;
        }

        .statistics-panel {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 25px;
            border: 2px solid #F0D5B8;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }

        .statistics-panel h3 {
            color: #713C0B;
            margin-bottom: 20px;
            font-size: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .stat-card {
            background: #FFF9F0;
            border-radius: 10px;
            padding: 15px;
            display: flex;
            align-items: center;
            gap: 15px;
            border: 1px solid #F0D5B8;
            transition: all 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
        }

        .stat-info {
            flex: 1;
        }

        .stat-value {
            font-size: 24px;
            font-weight: 700;
            color: #713C0B;
            line-height: 1;
        }

        .stat-label {
            font-size: 13px;
            color: #C7A178;
            margin-top: 5px;
        }

        .top-right {
            position: absolute;
            right: 40px;
            top: 20px;
            font-size: 20px;
            font-weight: bold;
        }
        
        .home-link {
            text-decoration: none;
            color: inherit;
        }
 
        @media (max-width: 1024px) {
            .header-row {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-container,
            .filter-container {
                min-width: 100%;
            }
            
            .add-btn {
                align-self: flex-start;
            }
            
            .filter-row {
                grid-template-columns: 1fr;
            }
            
            table {
                display: block;
                overflow-x: auto;
            }
            
            .actions {
                flex-wrap: wrap;
            }
        }
        
        @media (max-width: 768px) {
            .top-nav {
                padding: 15px;
                flex-direction: column;
                gap: 12px;
                text-align: center;
            }
            
            .page-title h1 {
                font-size: 28px;
            }
            
            .content {
                padding: 20px;
            }
            
            .action-btn span {
                display: none;
            }
            
            .action-btn {
                padding: 8px 10px;
            }
            
            .stats-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 480px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="top-right">
        <a href="<%= request.getContextPath() %>/dashboard" class="home-link">
            <div class="logo">
                <i class="fas fa-home"></i>
                SmileSpace
            </div>
        </a>
    </div>
    
    <div class="container">
        <div class="page-title">
            <h1>Learning Module Dashboard <span class="role-badge">Faculty</span></h1>
            <p>Manage your learning modules - Create, edit, and submit modules for review</p>
        </div>
        
        <div class="content">
            <form action="admin-module-dashboard" method="GET" id="mainFilterForm">
                <div class="header-row">
                    <div class="search-container">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" name="search" class="search-input" 
                               placeholder="Search by title..." 
                               value="<%= searchTerm != null ? searchTerm : "" %>"
                               id="searchInput">
                    </div>           
                    
                    <a href="create-module" class="add-btn">
                        <i class="fas fa-plus"></i>
                        <span>Add New Module</span>
                    </a>
                </div>
                
                <% 
                    if (statistics != null) {
                %>
                <div class="statistics-panel">
                    <h3><i class="fas fa-chart-bar"></i> Module Statistics</h3>
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-icon" style="background: #4ECDC4;">
                                <i class="fas fa-book"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-value"><%= statistics.get("totalModules") %></div>
                                <div class="stat-label">Total Modules</div>
                            </div>
                        </div>
                        
                        <div class="stat-card">
                            <div class="stat-icon" style="background: #FF6B6B;">
                                <i class="fas fa-eye"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-value"><%= statistics.get("totalViews") %></div>
                                <div class="stat-label">Total Views</div>
                            </div>
                        </div>
                        
                        <% 
                            Map<String, Integer> categoryStats = (Map<String, Integer>) statistics.get("categoryStats");
                            if (categoryStats != null && !categoryStats.isEmpty()) {
                                int maxCategoryCount = 0;
                                String maxCategory = "";
                                for (Map.Entry<String, Integer> entry : categoryStats.entrySet()) {
                                    if (entry.getValue() > maxCategoryCount) {
                                        maxCategoryCount = entry.getValue();
                                        maxCategory = entry.getKey();
                                    }
                                }
                        %>
                        <div class="stat-card">
                            <div class="stat-icon" style="background: #FFD166;">
                                <i class="fas fa-tag"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-value"><%= maxCategory %></div>
                                <div class="stat-label">Most Popular Category</div>
                            </div>
                        </div>
                        <% } %>
                        
                        <div class="stat-card">
                            <div class="stat-icon" style="background: #06D6A0;">
                                <i class="fas fa-history"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-value">
                                    <% 
                                        List<LearningModule> recentModules = (List<LearningModule>) statistics.get("recentModules");
                                        if (recentModules != null) {
                                            out.print(recentModules.size());
                                        } else {
                                            out.print("0");
                                        }
                                    %>
                                </div>
                                <div class="stat-label">Recent Modules</div>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
                
                <div class="filters">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label class="filter-label">Category:</label>
                            <select name="category" class="filter-select" id="categorySelect">
                                <option value="all">All Categories</option>
                                <option value="Stress" <%= "Stress".equals(selectedCategory) ? "selected" : "" %>>Stress</option>
                                <option value="Sleep" <%= "Sleep".equals(selectedCategory) ? "selected" : "" %>>Sleep</option>
                                <option value="Anxiety" <%= "Anxiety".equals(selectedCategory) ? "selected" : "" %>>Anxiety</option>
                                <option value="Self-Esteem" <%= "Self-Esteem".equals(selectedCategory) ? "selected" : "" %>>Self-Esteem</option>
                                <option value="Mindfulness" <%= "Mindfulness".equals(selectedCategory) ? "selected" : "" %>>Mindfulness</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label class="filter-label">Learning Level:</label>
                            <select name="level" class="filter-select" id="levelSelect">
                                <option value="all">All Levels</option>
                                <option value="Beginner" <%= "Beginner".equals(selectedLevel) ? "selected" : "" %>>Beginner</option>
                                <option value="Intermediate" <%= "Intermediate".equals(selectedLevel) ? "selected" : "" %>>Intermediate</option>
                                <option value="Advance" <%= "Advance".equals(selectedLevel) ? "selected" : "" %>>Advanced</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label class="filter-label">Status:</label>
                            <select name="status" class="filter-select" id="statusSelect">
                                <option value="all">All Status</option>
                                <option value="Draft" <%= "Draft".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Draft</option>
                                <option value="Submitted" <%= "Submitted".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Submitted</option>
                            </select>
                        </div>
                    </div>
                    
                    <div style="text-align: center;">
                        <button type="submit" class="filter-btn">
                            <i class="fas fa-filter"></i>
                            Apply Filters
                        </button>
                        <button type="button" class="filter-btn" style="background: #F0D5B8; color: #713C0B; margin-left: 10px;" onclick="resetFilters()">
                            <i class="fas fa-times"></i>
                            Clear
                        </button>
                    </div>
                </div>
            </form>
            
            <% 
                if (modules == null || modules.isEmpty()) {
            %>
                <div class="empty-state">
                    <i class="fas fa-book-open"></i>
                    <h3>No modules found</h3>
                    <p>Try adjusting your search or filters, or add a new module.</p>
                </div>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Learning Level</th>
                            <th>Status</th>
                            <th>Views</th>
                            <th>Last Updated</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (LearningModule module : modules) { 
                            String displayLevel = module.getLevel();
                            if ("Advance".equals(displayLevel)) {
                                displayLevel = "Advanced";
                            }
                            
                            String moduleStatus = module.getStatus();
                        %>
                            <tr>
                                <td><strong><%= module.getId() %></strong></td>
                                <td><strong><%= module.getTitle() %></strong></td>
                                <td>
                                    <span class="badge <%= module.getCategory().toLowerCase().replace(" ", "-") %>">
                                        <%= module.getCategory() %>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge level-<%= module.getLevel().toLowerCase() %>">
                                        <%= displayLevel %>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge <%= "Draft".equalsIgnoreCase(moduleStatus) ? "status-draft" : "status-submitted" %>">
                                        <%= moduleStatus %>
                                    </span>
                                </td>
                                <td><%= module.getViews() %></td>
                                <td><%= module.getLastUpdated() %></td>
                                <td>
                                    <div class="actions">
                                        <a href="view-module?id=<%= module.getId() %>" class="action-btn view">
                                            <i class="fas fa-eye"></i>
                                            <span>View</span>
                                        </a>
                                        <% if ("Draft".equalsIgnoreCase(moduleStatus)) { %>
                                        <a href="edit-module?id=<%= module.getId() %>" class="action-btn edit">
                                            <i class="fas fa-edit"></i>
                                            <span>Edit</span>
                                        </a>
                                        <% } %>
                                        <a href="delete-module?id=<%= module.getId() %>" class="action-btn delete">
                                            <i class="fas fa-trash"></i>
                                            <span>Delete</span>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
                
                <div class="pagination">
                    <button class="page-btn active">1</button>
                    <button class="page-btn">2</button>
                    <button class="page-btn">3</button>
                    <button class="page-btn">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
            <% } %>
        </div>
    </div>
    
    <script>
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                document.getElementById('mainFilterForm').submit();
            }
        });
        
        function resetFilters() {
            window.location.href = 'admin-module-dashboard';
        }
        
        document.querySelectorAll('.page-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                document.querySelectorAll('.page-btn').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
            });
        });
        
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const success = urlParams.get('success');
            const error = urlParams.get('error');
            
            if (success) {
                alert('Success: ' + success);
            }
            if (error) {
                alert('Error: ' + error);
            }
        });
    </script>
</body>
</html>