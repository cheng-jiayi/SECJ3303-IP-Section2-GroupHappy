<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="smilespace.model.LearningModule" %>  <!-- CORRECT IMPORT -->
<%
    List<LearningModule> modules = (List<LearningModule>) request.getAttribute("modules");
    String searchTerm = (String) request.getAttribute("searchTerm");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String selectedLevel = (String) request.getAttribute("selectedLevel");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Learning Module Dashboard</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f5f5f5; color: #333; }
        
        .container { max-width: 1200px; margin: 20px auto; background: white; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 10px 10px 0 0; }
        .header h1 { font-size: 24px; display: flex; align-items: center; gap: 10px; }
        
        .content { padding: 20px; }
        
        .add-btn { 
            background: #28a745; color: white; border: none; padding: 10px 20px; 
            border-radius: 5px; cursor: pointer; text-decoration: none; display: inline-block; 
            margin-bottom: 15px; font-weight: bold;
        }
        .add-btn:hover { background: #218838; }
        
        .filters { background: #f8f9fa; padding: 15px; border-radius: 5px; margin-bottom: 15px; }
        .search-box { margin-bottom: 10px; }
        .search-input { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        
        .filter-row { display: flex; gap: 15px; margin-bottom: 10px; }
        .filter-group { flex: 1; }
        .filter-label { display: block; margin-bottom: 5px; font-weight: bold; }
        .filter-select { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        
        .submit-btn { background: #007bff; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { background: #6c757d; color: white; padding: 10px; text-align: left; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
        tr:hover { background: #f8f9fa; }
        
        .badge { display: inline-block; padding: 3px 8px; border-radius: 10px; font-size: 12px; font-weight: bold; }
        .stress { background: #ffcccc; color: #cc0000; }
        .sleep { background: #ccffcc; color: #006600; }
        .anxiety { background: #ffffcc; color: #999900; }
        .self-esteem { background: #ccccff; color: #0000cc; }
        .mindfulness { background: #ffccff; color: #cc00cc; }
        
        .level-beginner { background: #d4edda; color: #155724; }
        .level-intermediate { background: #fff3cd; color: #856404; }
        .level-advance { background: #f8d7da; color: #721c24; }
        
        .actions { display: flex; gap: 5px; }
        .action-btn { 
            background: none; border: 1px solid #ddd; padding: 5px 10px; 
            border-radius: 3px; cursor: pointer; text-decoration: none; color: #333;
        }
        .action-btn:hover { background: #f0f0f0; }
        
        .pagination { display: flex; gap: 5px; justify-content: center; margin-top: 15px; }
        .page-btn { padding: 5px 10px; border: 1px solid #ddd; background: white; cursor: pointer; }
        .page-btn.active { background: #007bff; color: white; }
        
        .empty-state { text-align: center; padding: 30px; color: #6c757d; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📚 Learning Module Dashboard</h1>
            <p>UC005 - Manage Learning Resources (Admin)</p>
        </div>
        
        <div class="content">
            <a href="create-module" class="add-btn">+ Add New Module</a>
            
            <div class="filters">
                <form action="dashboard" method="GET">
                    <div class="search-box">
                        <input type="text" name="search" class="search-input" 
                               placeholder="Search by title..." 
                               value="<%= searchTerm != null ? searchTerm : "" %>">
                    </div>
                    
                    <div class="filter-row">
                        <div class="filter-group">
                            <label class="filter-label">Category:</label>
                            <select name="category" class="filter-select">
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
                            <select name="level" class="filter-select">
                                <option value="all">All Levels</option>
                                <option value="Beginner" <%= "Beginner".equals(selectedLevel) ? "selected" : "" %>>Beginner</option>
                                <option value="Intermediate" <%= "Intermediate".equals(selectedLevel) ? "selected" : "" %>>Intermediate</option>
                                <option value="Advance" <%= "Advance".equals(selectedLevel) ? "selected" : "" %>>Advanced</option>
                            </select>
                        </div>
                    </div>
                    
                    <button type="submit" class="submit-btn">Apply Filters</button>
                </form>
            </div>
            
            <% 
                if (modules == null || modules.isEmpty()) {
            %>
                <div class="empty-state">
                    <p>No modules found. Try adjusting your search or filters.</p>
                </div>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Learning Level</th>
                            <th>Views</th>
                            <th>Last Updated</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (LearningModule module : modules) { %>
                            <tr>
                                <td><%= module.getId() %></td>
                                <td><strong><%= module.getTitle() %></strong></td>
                                <td>
                                    <span class="badge <%= module.getCategory().toLowerCase().replace(" ", "-") %>">
                                        <%= module.getCategory() %>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge level-<%= module.getLevel().toLowerCase() %>">
                                        <%= module.getLevel() %>
                                    </span>
                                </td>
                                <td><%= module.getViews() %></td>
                                <td><%= module.getLastUpdated() %></td>
                                <td>
                                    <div class="actions">
                                        <a href="view-module?id=<%= module.getId() %>" class="action-btn">View</a>
                                        <a href="edit-module?id=<%= module.getId() %>" class="action-btn">Edit</a>
                                        <a href="delete-module?id=<%= module.getId() %>" class="action-btn">Delete</a>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
            
            <div class="pagination">
                <button class="page-btn active">1</button>
                <button class="page-btn">2</button>
                <button class="page-btn">3</button>
            </div>
        </div>
    </div>
</body>
</html>