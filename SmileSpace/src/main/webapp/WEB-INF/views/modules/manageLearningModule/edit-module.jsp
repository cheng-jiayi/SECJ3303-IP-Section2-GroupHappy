<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="smilespace.model.LearningModule" %>
<% 
    LearningModule module = (LearningModule) request.getAttribute("module");
    String category = module.getCategory();
    String level = module.getLevel();
    String status = module.getStatus();
    
    boolean quizExists = (Boolean) request.getAttribute("quizExists");
    
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    
    boolean isSubmitted = "Submitted".equalsIgnoreCase(status);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Learning Module</title>
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
            max-width: 1200px; 
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
        
        .content { 
            background: white; 
            border-radius: 20px; 
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            border: 2px solid #F0D5B8;
            margin-top: 10px;
        }
        
        .module-id-display {
            background: #F4DBAF;
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-weight: 600;
            color: #713C0B;
            border: 2px solid #713C0B;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .module-id-display i {
            color: #F0A548;
        }
        
        .module-status {
            margin-left: auto;
            padding: 5px 15px;
            border-radius: 15px;
            font-size: 14px;
            font-weight: 600;
        }
        
        .status-draft { 
            background: #FFF4C8; 
            color: #B88414; 
        }
        .status-submitted { 
            background: #CFFFE5; 
            color: #17926E; 
        }

        .back-link { 
            display: inline-flex; 
            align-items: center; 
            gap: 8px;
            margin-bottom: 25px; 
            color: #713C0B; 
            text-decoration: none; 
            font-weight: 500;
            padding: 8px 15px;
            border-radius: 8px;
            background: #F4DBAF;
            border: 2px solid #713C0B;
            transition: all 0.3s;
        }
        
        .back-link:hover { 
            background: #713C0B; 
            color: #FBF6EA;
            transform: translateX(-3px);
        }

        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-success {
            background: #E8F5E9;
            color: #2E7D32;
            border: 2px solid #C8E6C9;
        }
        
        .alert-error {
            background: #FFEBEE;
            color: #C62828;
            border: 2px solid #FFCDD2;
        }

        .form-layout {
            display: grid;
            grid-template-columns: 1fr 2fr; 
            gap: 30px;
        }

        @media (max-width: 900px) {
            .form-layout {
                grid-template-columns: 1fr;
            }
        }

        .left-column {
            background: #FFF9F0;
            padding: 25px;
            border-radius: 15px;
            border: 2px solid #F0D5B8;
            display: flex;
            flex-direction: column;
            gap: 25px;
        }

        .right-column {
            background: #FFF9F0;
            padding: 25px;
            border-radius: 15px;
            border: 2px solid #F0D5B8;
            display: flex;
            flex-direction: column;
            gap: 25px;
        }

        .form-group { 
            width: 100%;
        }
        
        .form-label { 
            display: block; 
            margin-bottom: 10px; 
            font-weight: 600; 
            color: #713C0B;
            font-size: 16px;
        }
        
        .required::after { 
            content: " *"; 
            color: #FF4757; 
        }
        
        .form-input, .form-textarea, .form-select { 
            width: 100%; 
            padding: 14px 18px; 
            border: 2px solid #F0D5B8; 
            border-radius: 12px; 
            font-size: 15px;
            background: #FBF6EA;
            color: #713C0B;
            transition: all 0.3s;
        }
        
        .form-input:focus, .form-textarea:focus, .form-select:focus { 
            outline: none; 
            border-color: #F0A548; 
            box-shadow: 0 0 0 3px rgba(240, 165, 72, 0.2); 
            background: white;
        }
        
        .form-input::placeholder, .form-textarea::placeholder {
            color: #C7A178;
        }
        
        .form-textarea { 
            min-height: 120px; 
            resize: vertical; 
        }

        .checkbox-group {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-top: 10px;
        }
        
        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 12px;
            cursor: pointer;
        }
        
        .checkbox-input {
            display: none;
        }
        
        .checkbox-custom {
            width: 22px;
            height: 22px;
            border: 2px solid #713C0B;
            border-radius: 6px;
            background: #FBF6EA;
            position: relative;
            transition: all 0.3s;
        }
        
        .checkbox-input:checked + .checkbox-custom {
            background: #F0A548;
            border-color: #F0A548;
        }
        
        .checkbox-input:checked + .checkbox-custom::after {
            content: "✓";
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-weight: bold;
            font-size: 14px;
        }

        .checkbox-input[type="radio"] + .checkbox-custom {
            border-radius: 50%;
        }

        .checkbox-input[type="radio"]:checked + .checkbox-custom::after {
            content: "";
            width: 10px;
            height: 10px;
            background: white;
            border-radius: 50%;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-weight: normal;
            font-size: 0;
        }
                
        .checkbox-label {
            font-weight: 500;
            color: #713C0B;
            user-select: none;
        }

        .file-upload { 
            border: 2px dashed #F0D5B8; 
            border-radius: 12px; 
            padding: 25px;
            text-align: center;
            background: #FBF6EA;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .file-upload:hover {
            border-color: #F0A548;
            background: #F9EEDB;
        }
        
        .upload-icon {
            font-size: 40px;
            color: #F0A548;
            margin-bottom: 15px;
        }
        
        .upload-text {
            color: #713C0B;
            margin-bottom: 8px;
            font-weight: 500;
            font-size: 16px;
            min-height: 24px;
        }
        
        .upload-subtext {
            color: #C7A178;
            font-size: 14px;
            margin-bottom: 15px;
        }
        
        .browse-btn { 
            background: #F0A548; 
            color: white; 
            border: none; 
            padding: 10px 25px; 
            border-radius: 8px; 
            cursor: pointer; 
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .browse-btn:hover { 
            background: #D18A2C;
            transform: translateY(-2px);
        }
        
        .file-info {
            margin-top: 10px;
            font-size: 14px;
            color: #713C0B;
            background: #F4DBAF;
            padding: 8px 12px;
            border-radius: 8px;
            display: block;
            min-height: 36px;
        }
        
        .current-file {
            margin-top: 10px;
            font-size: 14px;
            color: #713C0B;
            background: #F4DBAF;
            padding: 8px 12px;
            border-radius: 8px;
            min-height: 36px;
        }
        
        .file-types { 
            font-size: 13px; 
            color: #C7A178; 
            margin-top: 8px; 
            font-style: italic; 
        }

        .form-row { 
            display: grid; 
            grid-template-columns: 1fr 1fr; 
            gap: 20px; 
            width: 100%;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }

        .button-group { 
            display: flex; 
            gap: 15px; 
            justify-content: flex-end; 
            margin-top: 30px;
            padding-top: 25px;
            border-top: 2px solid #F0D5B8;
            grid-column: 1 / -1;
        }
        
        .btn { 
            padding: 14px 35px; 
            border: none; 
            border-radius: 12px; 
            font-weight: 600; 
            font-size: 16px; 
            cursor: pointer; 
            transition: all 0.3s; 
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        
        .btn-primary { 
            background: #F0A548; 
            color: white; 
        }
        
        .btn-primary:hover { 
            background: #D18A2C; 
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(240, 165, 72, 0.25);
        }
        
        .btn-secondary { 
            background: #F0D5B8; 
            color: #713C0B; 
            border: 2px solid #713C0B;
        }
        
        .btn-secondary:hover { 
            background: #713C0B; 
            color: #FBF6EA;
            transform: translateY(-2px);
        }
        
        .btn-draft { 
            background: #FFF4C8; 
            color: #B88414; 
            border: 2px solid #B88414;
        }
        
        .btn-draft:hover { 
            background: #B88414; 
            color: white;
            transform: translateY(-2px);
        }

        .help-text {
            font-size: 14px;
            color: #C7A178;
            margin-top: 5px;
        }

        .resource-upload {
            margin-top: 10px;
        }

        .image-preview-container {
            margin-top: 15px;
        }
        
        .image-preview {
            max-width: 100%;
            max-height: 200px;
            border-radius: 12px;
            display: none;
            margin-top: 10px;
            border: 2px solid #F0D5B8;
            object-fit: contain;
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

        .status-info {
            background: #FFF4C8;
            padding: 10px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 2px solid #F0A548;
            font-size: 14px;
            color: #713C0B;
        }
        
        .status-info i {
            color: #F0A548;
            margin-right: 8px;
        }
        
        .warning-info {
            background: #FFE8E8;
            padding: 10px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 2px solid #FF6B6B;
            font-size: 14px;
            color: #713C0B;
        }
        
        .warning-info i {
            color: #FF6B6B;
            margin-right: 8px;
        }

        .quiz-action-section {
            background: #FFF9F0;
            padding: 25px;
            border-radius: 15px;
            border: 2px solid #F0D5B8;
            margin-top: 30px;
        }
        
        .quiz-action-title {
            color: #713C0B;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .quiz-action-content {
            color: #8B7355;
            margin-bottom: 20px;
            line-height: 1.6;
        }
        
        .quiz-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .quiz-btn {
            padding: 12px 25px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            border: none;
        }
        
        .quiz-btn-continue {
            background: #F0A548;
            color: white;
        }
        
        .quiz-btn-continue:hover {
            background: #D18A2C;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(240, 165, 72, 0.25);
        }
        
        .quiz-btn-view {
            background: #4A90E2;
            color: white;
        }
        
        .quiz-btn-view:hover {
            background: #357ABD;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(74, 144, 226, 0.25);
        }
        
        .quiz-info-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            margin-left: 15px;
        }
        
        .quiz-exists {
            background: #CFFFE5;
            color: #17926E;
            border: 2px solid #17926E;
        }
        
        .quiz-missing {
            background: #FFE8E8;
            color: #C73737;
            border: 2px solid #C73737;
        }

        .resource-upload .current-file {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-top: 15px;
        }

        .resource-upload .btn-small {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 15px;
            background: #4A90E2;
            color: white;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            margin-top: 10px;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }

        .resource-upload .btn-small:hover {
            background: #357ABD;
        }

        .resource-upload .help-text {
            margin-top: 15px;
        }

        .file-icon {
            font-size: 18px;
            margin-right: 8px;
        }

        .file-pdf { color: #FF4757; }
        .file-word { color: #2B579A; }
        .file-powerpoint { color: #D24726; }
        .file-image { color: #4A90E2; }
        .file-video { color: #9B59B6; }
        .file-default { color: #713C0B; }
    </style>
</head>
<body>
    <div class="top-right">
        <a href="<%= request.getContextPath() %>/admin-module-dashboard" class="home-link">
            <div class="logo">
                <i class="fas fa-home"></i>
                SmileSpace
            </div>
        </a>
    </div>
    
    <div class="container">
        <div class="page-title">
            <h1>Edit Learning Module</h1>
            <p>Update the learning module information</p>
        </div>
        
        <div class="content">
            <% if (success != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= success %>
            </div>
            <% } %>
            
            <% if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <%= error %>
            </div>
            <% } %>
            
            <div class="module-id-display">
                <i class="fas fa-edit"></i>
                <span>Editing: <%= module.getId() %> - <%= module.getTitle() %></span>
                <span class="module-status <%= "Draft".equalsIgnoreCase(status) ? "status-draft" : "status-submitted" %>">
                    <%= isSubmitted ? "Submitted" : "Draft" %>
                </span>
            </div>

            <% if (isSubmitted) { %>
            <div class="warning-info">
                <i class="fas fa-exclamation-triangle"></i>
                <strong>Note:</strong> This module is already submitted. You can save changes as a draft, 
                but you need to submit it again to update the submission.
            </div>
            <% } else { %>
            <div class="status-info">
                <i class="fas fa-info-circle"></i>
                <strong>Note:</strong> This module is currently a draft. You can save as draft or submit it.
            </div>
            <% } %>
            
            <form action="edit-module" method="POST" enctype="multipart/form-data" id="moduleForm">
                <input type="hidden" name="id" value="<%= module.getId() %>">
                
                <div class="form-layout">
                    <div class="left-column">
                        <div class="form-group">
                            <label class="form-label required">Cover Page Image</label>
                            <div class="file-upload" id="coverUpload">
                                <div class="upload-icon">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                </div>
                                <div class="upload-text" id="coverUploadText">Upload New Cover Image</div>
                                <div class="upload-subtext">Click to browse or drag & drop</div>
                                <input type="file" name="coverImage" id="coverImageInput" accept="image/*" style="display: none;">
                                <button type="button" class="browse-btn" onclick="document.getElementById('coverImageInput').click()">Browse Files</button>
                                <div class="file-types">PNG, JPG, JPEG, GIF, BMP (Max: 10MB)</div>
                            </div>
                            <% if (module.getCoverImagePath() != null && !module.getCoverImagePath().isEmpty()) { 
                                String coverImageUrl = request.getContextPath() + "/uploads/" + module.getCoverImagePath();
                            %>
                                <div class="current-file" id="currentCoverFile">
                                    <i class="fas fa-image"></i> Current Cover Image:
                                    <div style="margin-top: 10px;">
                                        <img src="<%= coverImageUrl %>" 
                                            alt="Current Cover" 
                                            style="max-width: 200px; max-height: 150px; border-radius: 8px; border: 2px solid #F0D5B8;">
                                        <br>
                                        <small style="display: block; margin-top: 5px; color: #8B7355;">
                                            Path: <%= module.getCoverImagePath() %>
                                        </small>
                                    </div>
                                </div>
                            <% } else { %>
                                <div class="current-file" id="currentCoverFile">
                                    <i class="fas fa-image"></i> No cover image uploaded
                                </div>
                            <% } %>

                            <div class="file-info" id="coverFileInfo" style="display: none;"></div>

                            <div class="image-preview-container" id="newCoverPreviewContainer" style="display: none;">
                                <div class="current-file">
                                    <i class="fas fa-image"></i> New Cover Image Preview:
                                </div>
                                <img id="coverPreview" class="image-preview" src="" alt="New Cover Preview">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label required">Category</label>
                            <div class="checkbox-group">
                                <label class="checkbox-item">
                                    <input type="radio" name="category" value="Stress" class="checkbox-input" 
                                           <%= "Stress".equals(category) ? "checked" : "" %> required>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Stress</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="category" value="Sleep" class="checkbox-input"
                                           <%= "Sleep".equals(category) ? "checked" : "" %>>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Sleep</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="category" value="Anxiety" class="checkbox-input"
                                           <%= "Anxiety".equals(category) ? "checked" : "" %>>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Anxiety</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="category" value="Self-Esteem" class="checkbox-input"
                                           <%= "Self-Esteem".equals(category) ? "checked" : "" %>>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Self-Esteem</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="category" value="Mindfulness" class="checkbox-input"
                                           <%= "Mindfulness".equals(category) ? "checked" : "" %>>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Mindfulness</span>
                                </label>
                            </div>
                            <div class="help-text">Select one category for this module</div>
                        </div>

                        <div class="form-group">
                            <label class="form-label required">Learning Level</label>
                            <div class="checkbox-group">
                                <label class="checkbox-item">
                                    <input type="radio" name="level" value="Beginner" class="checkbox-input"
                                           <%= "Beginner".equals(level) ? "checked" : "" %> required>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Beginner</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="level" value="Intermediate" class="checkbox-input"
                                           <%= "Intermediate".equals(level) ? "checked" : "" %>>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Intermediate</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="level" value="Advanced" class="checkbox-input"
                                           <%= "Advanced".equals(level) ? "checked" : "" %>>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Advanced</span>
                                </label>
                            </div>
                            <div class="help-text">Select one learning level for this module</div>
                        </div>
                    </div>

                    <div class="right-column">
                        <div class="form-group">
                            <label for="title" class="form-label required">Title</label>
                            <input type="text" name="title" id="title" class="form-input" 
                                   value="<%= module.getTitle() %>" 
                                   placeholder="Enter a descriptive title for the module..." required>
                        </div>
                        
                        <div class="form-group">
                            <label for="description" class="form-label required">Description</label>
                            <textarea name="description" id="description" class="form-textarea" 
                                      placeholder="Provide a detailed description of what this module covers..." 
                                      required><%= module.getDescription() != null ? module.getDescription() : "" %></textarea>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="authorName" class="form-label required">Author Name</label>
                                <input type="text" name="authorName" id="authorName" class="form-input" 
                                       value="<%= module.getAuthorName() != null ? module.getAuthorName() : "" %>" 
                                       placeholder="Enter the author/lecturer name..." required>
                            </div>
                            
                            <div class="form-group">
                                <label for="estimatedDuration" class="form-label required">Estimated Duration</label>
                                <input type="text" name="estimatedDuration" id="estimatedDuration" class="form-input" 
                                       value="<%= module.getEstimatedDuration() != null ? module.getEstimatedDuration() : "" %>" 
                                       placeholder="e.g., 30 minutes, 2 hours, 1 week..." required>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="videoUrl" class="form-label">Video URL</label>
                            <input type="url" name="videoUrl" id="videoUrl" class="form-input" 
                                   value="<%= module.getVideoUrl() != null ? module.getVideoUrl() : "" %>"
                                   placeholder="https://www.youtube.com/watch?v=... or Vimeo link">
                            <div class="help-text">Optional: Link to instructional video</div>
                        </div>

                        <div class="form-group">
                            <label for="contentOutline" class="form-label">Content Outline</label>
                            <textarea name="contentOutline" id="contentOutline" class="form-textarea" 
                                      placeholder="Enter learning points separated by double dollar signs ($$)"><%= module.getContentOutline() != null ? module.getContentOutline() : "" %></textarea>
                            <div class="help-text">Separate each point with "$$" (e.g., "Introduction$$Lesson 1$$Lesson 2")</div>
                        </div>

                        <div class="form-group">
                            <label for="learningGuide" class="form-label">Learning Guide</label>
                            <textarea name="learningGuide" id="learningGuide" class="form-textarea" 
                                      placeholder="Step-by-step guide separated by double dollar signs ($$)"><%= module.getLearningGuide() != null ? module.getLearningGuide() : "" %></textarea>
                            <div class="help-text">Separate each step with "$$"</div>
                        </div>

                        <div class="form-group">
                            <label for="learningTip" class="form-label">Learning Tip</label>
                            <input type="text" name="learningTip" id="learningTip" class="form-input" 
                                   value="<%= module.getLearningTip() != null ? module.getLearningTip() : "" %>"
                                   placeholder="Short helpful tip for learners">
                        </div>

                        <div class="form-group">
                            <label for="keyPoints" class="form-label">Key Points</label>
                            <textarea name="keyPoints" id="keyPoints" class="form-textarea" 
                                      placeholder="Key takeaways separated by double dollar signs ($$)"><%= module.getKeyPoints() != null ? module.getKeyPoints() : "" %></textarea>
                            <div class="help-text">Separate each key point with "$$"</div>
                        </div>

                        <div class="form-group resource-upload">
                            <label class="form-label">Upload Resource File</label>
                            <div class="file-upload" id="resourceUpload">
                                <div class="upload-icon">
                                    <i class="fas fa-file-upload"></i>
                                </div>
                                <div class="upload-text" id="resourceUploadText">Upload New Resource File</div>
                                <div class="upload-subtext">Lecture slides, articles, or videos</div>
                                <input type="file" name="resourceFile" id="resourceFileInput" style="display: none;">
                                <button type="button" class="browse-btn" onclick="document.getElementById('resourceFileInput').click()">Browse Files</button>
                                <div class="file-types">MP4, PDF, DOCX, PPT, PNG, JPG, JPEG (Max: 50MB)</div>
                            </div>

                            <% if (module.getResourceFilePath() != null && !module.getResourceFilePath().isEmpty()) { 
                                String resourceUrl = request.getContextPath() + "/uploads/" + module.getResourceFilePath();
                                String resourceFileName = module.getResourceFilePath().substring(module.getResourceFilePath().lastIndexOf("/") + 1);
                                String fileIcon = "";
                                
                                if (resourceFileName.toLowerCase().endsWith(".pdf")) fileIcon = "file-pdf";
                                else if (resourceFileName.toLowerCase().endsWith(".doc") || resourceFileName.toLowerCase().endsWith(".docx")) fileIcon = "file-word";
                                else if (resourceFileName.toLowerCase().endsWith(".ppt") || resourceFileName.toLowerCase().endsWith(".pptx")) fileIcon = "file-powerpoint";
                                else if (resourceFileName.toLowerCase().endsWith(".jpg") || resourceFileName.toLowerCase().endsWith(".jpeg") || 
                                        resourceFileName.toLowerCase().endsWith(".png") || resourceFileName.toLowerCase().endsWith(".gif")) fileIcon = "file-image";
                                else if (resourceFileName.toLowerCase().endsWith(".mp4")) fileIcon = "file-video";
                                else fileIcon = "file";
                            %>
                                <div class="current-file" id="currentResourceFile">
                                    <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 10px;">
                                        <i class="fas fa-<%= fileIcon %>" style="color: #4A90E2; font-size: 24px;"></i>
                                        <div>
                                            <div style="font-weight: 600; color: #713C0B;">Current Resource File</div>
                                            <div style="color: #8B7355; font-size: 14px;"><%= resourceFileName %></div>
                                        </div>
                                    </div>
                                    <div style="margin-top: 10px;">
                                        <a href="<%= resourceUrl %>" 
                                        target="_blank" 
                                        style="display: inline-flex; align-items: center; gap: 8px; padding: 8px 15px; background: #F0A548; color: white; border-radius: 5px; text-decoration: none; font-weight: 500;">
                                            <i class="fas fa-download"></i>
                                            Download File
                                        </a>
                                    </div>
                                    <div style="margin-top: 8px; font-size: 12px; color: #8B7355;">
                                        Path: <%= module.getResourceFilePath() %>
                                    </div>
                                </div>
                            <% } else { %>
                                <div class="current-file" id="currentResourceFile">
                                    <i class="fas fa-file"></i> No resource file uploaded
                                </div>
                            <% } %>

                            <div class="file-info" id="resourceFileInfo" style="display: none; margin-top: 10px;"></div>
                            
                            <div class="help-text" style="margin-top: 10px;">Optional: Upload supporting materials for this module</div>
                        </div>

                        <div class="form-group">
                            <label for="notes" class="form-label">Additional Notes</label>
                            <textarea name="notes" id="notes" class="form-textarea" 
                                      placeholder="Any additional information or prerequisites for this module..."><%= module.getNotes() != null ? module.getNotes() : "" %></textarea>
                        </div>
                    </div>
                </div>

                <div class="button-group">
                    <button type="button" class="btn btn-secondary" id="cancelBtn">
                        <i class="fas fa-times"></i>
                        Cancel
                    </button>
                    <button type="button" class="btn btn-draft" id="saveDraftBtn">
                        <i class="fas fa-save"></i>
                        Save as Draft
                    </button>
                    <button type="button" class="btn btn-primary" id="submitBtn">
                        <i class="fas fa-check"></i>
                        Submit
                    </button>
                </div>

                <input type="hidden" name="action" id="actionField" value="save">
                <input type="hidden" name="redirect" id="redirectField" value="edit">
            </form>
            

            <div class="quiz-action-section">
                <div class="quiz-action-title">
                    <i class="fas fa-question-circle"></i>
                    Quiz Management
                    <span class="quiz-info-badge <%= quizExists ? "quiz-exists" : "quiz-missing" %>">
                        <i class="fas fa-<%= quizExists ? "check" : "times" %>"></i>
                        <%= quizExists ? "Quiz Exists" : "No Quiz" %>
                    </span>
                </div>
                
                <div class="quiz-action-content">
                    <% if (quizExists) { %>
                    <p>This module already has a quiz. You can continue to edit the quiz questions or view the current quiz.</p>
                    <% } else { %>
                    <p>This module doesn't have a quiz yet. After saving module changes, continue to create a 10-question True/False quiz.</p>
                    <% } %>
                </div>
                
                <div class="quiz-buttons">
                    <% if (quizExists) { %>
                    <a href="${pageContext.request.contextPath}/edit-quiz?moduleId=<%= module.getId() %>" class="quiz-btn quiz-btn-continue">
                        <i class="fas fa-edit"></i>
                        Continue to Edit Quiz
                    </a>
                    <% } else { %>
                    <a href="${pageContext.request.contextPath}/create-quiz?moduleId=<%= module.getId() %>" class="quiz-btn quiz-btn-continue">
                        <i class="fas fa-plus-circle"></i>
                        Create Quiz for This Module
                    </a>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    
    <script>

        function handleFileUpload(inputId, uploadTextId, fileInfoId, previewImgId, currentFileId, isImage = false) {
            const fileInput = document.getElementById(inputId);
            const uploadText = document.getElementById(uploadTextId);
            const fileInfo = document.getElementById(fileInfoId);
            const previewImg = previewImgId ? document.getElementById(previewImgId) : null;
            const currentFileDiv = currentFileId ? document.getElementById(currentFileId) : null;
            const newPreviewContainer = document.getElementById('newCoverPreviewContainer');
            
            if (!fileInput) {
                console.error('File input not found:', inputId);
                return;
            }
            
            fileInput.addEventListener('change', function(e) {
                console.log('File input changed');
                
                if (this.files && this.files[0]) {
                    const file = this.files[0];
                    const fileName = file.name;
                    const fileSize = (file.size / (1024 * 1024)).toFixed(2);
                    
                    console.log('Selected file:', fileName, 'Size:', fileSize, 'MB');
                    
                    if (uploadText) {
                        uploadText.textContent = 'Selected: ' + fileName;
                        console.log('Set upload text to:', uploadText.textContent);
                    }
                    
                    if (fileInfo) {
                        fileInfo.textContent = fileName + ' (' + fileSize + ' MB)';
                        fileInfo.style.display = 'block';
                        console.log('Set file info to:', fileInfo.textContent);
                    }

                    if (currentFileDiv) {
                        currentFileDiv.style.display = 'none';
                    }

                    if (isImage && previewImg && newPreviewContainer) {
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            previewImg.src = e.target.result;
                            previewImg.style.display = 'block';
                            newPreviewContainer.style.display = 'block'; 
                        };
                        reader.readAsDataURL(file);
                    }
                } else {
                    console.log('No file selected');
                    
                    if (uploadText) {
                        uploadText.textContent = inputId === 'coverImageInput' ? 'Upload New Cover Image' : 'Upload New Resource File';
                    }
                    
                    if (fileInfo) {
                        fileInfo.style.display = 'none';
                    }
                    
                    if (previewImg && newPreviewContainer) {
                        previewImg.style.display = 'none';
                        newPreviewContainer.style.display = 'none';
                    }

                    if (currentFileDiv) {
                        const content = currentFileDiv.textContent || currentFileDiv.innerText;
                        if (content && !content.includes('No cover image selected') && !content.includes('No cover image uploaded')) {
                            currentFileDiv.style.display = 'block';
                        }
                    }
                }
            });
        }
        
        function setupButtonHandlers() {
            const form = document.getElementById('moduleForm');
            const actionField = document.getElementById('actionField');
            const redirectField = document.getElementById('redirectField');
            const cancelBtn = document.getElementById('cancelBtn');
            const saveDraftBtn = document.getElementById('saveDraftBtn');
            const submitBtn = document.getElementById('submitBtn');
            
            if (cancelBtn) {
                cancelBtn.addEventListener('click', function() {
                    if (confirm('Are you sure you want to cancel? All unsaved quiz data will be lost.')) {
                        window.location.href = '${pageContext.request.contextPath}/admin-module-dashboard';
                    }
                });
            }
            
            saveDraftBtn.addEventListener('click', function(e) {
                e.preventDefault();

                actionField.value = 'save';
                redirectField.value = 'edit'; 
                
                if (!validateFormForDraft()) {
                    return;
                }

                form.submit();
            });
            
            submitBtn.addEventListener('click', function(e) {
                e.preventDefault();
                
                actionField.value = 'submit';
                redirectField.value = 'dashboard'; 
                
                if (!validateFormForSubmit()) {
                    return;
                }
                
                const moduleStatus = '<%= status %>';
                let confirmMessage;

                if (moduleStatus === 'submitted') {
                    confirmMessage = 'This module is already submitted. Submitting again will update the submission date. Continue?';
                } else {
                    confirmMessage = 'Are you sure you want to submit this module? Once submitted, it will be available for review.';
                }

                if (confirm(confirmMessage)) {
                    form.submit();
                }
            });
        }
        
        function validateFormForDraft() {
            document.querySelectorAll('.form-input, .form-textarea, .form-select').forEach(field => {
                field.style.borderColor = '#F0D5B8';
                field.style.boxShadow = 'none';
            });
            
            document.querySelectorAll('.checkbox-group').forEach(group => {
                group.style.color = '';
            });
            
            const coverUpload = document.getElementById('coverUpload');
            coverUpload.style.borderColor = '#F0D5B8';
            
            let isValid = true;
            let errorMessages = [];
            
            const categorySelected = document.querySelector('input[name="category"]:checked');
            if (!categorySelected) {
                isValid = false;
                const categoryGroup = document.querySelector('.form-group:nth-child(2) .checkbox-group');
                if (categoryGroup) {
                    categoryGroup.style.color = '#FF4757';
                }
                errorMessages.push('Please select a category');
            }
            
            const levelSelected = document.querySelector('input[name="level"]:checked');
            if (!levelSelected) {
                isValid = false;
                const levelGroup = document.querySelector('.form-group:nth-child(3) .checkbox-group');
                if (levelGroup) {
                    levelGroup.style.color = '#FF4757';
                }
                errorMessages.push('Please select a learning level');
            }
            
            const title = document.getElementById('title');
            if (title && !title.value.trim()) {
                isValid = false;
                title.style.borderColor = '#FF4757';
                title.style.boxShadow = '0 0 0 3px rgba(255, 71, 87, 0.2)';
                errorMessages.push('Title is required');
            }
            
            if (!isValid) {
                alert('Please fix the following errors:\n\n' + errorMessages.join('\n'));
                return false;
            }
            
            return true;
        }
        
        function validateFormForSubmit() {
            document.querySelectorAll('.form-input, .form-textarea, .form-select').forEach(field => {
                field.style.borderColor = '#F0D5B8';
                field.style.boxShadow = 'none';
            });
            
            document.querySelectorAll('.checkbox-group').forEach(group => {
                group.style.color = '';
            });
            
            const coverUpload = document.getElementById('coverUpload');
            coverUpload.style.borderColor = '#F0D5B8';
            
            let isValid = true;
            let errorMessages = [];
            
            const categorySelected = document.querySelector('input[name="category"]:checked');
            if (!categorySelected) {
                isValid = false;
                const categoryGroup = document.querySelector('.form-group:nth-child(2) .checkbox-group');
                if (categoryGroup) {
                    categoryGroup.style.color = '#FF4757';
                }
                errorMessages.push('Please select a category');
            }
            
            const levelSelected = document.querySelector('input[name="level"]:checked');
            if (!levelSelected) {
                isValid = false;
                const levelGroup = document.querySelector('.form-group:nth-child(3) .checkbox-group');
                if (levelGroup) {
                    levelGroup.style.color = '#FF4757';
                }
                errorMessages.push('Please select a learning level');
            }
            
            const requiredFields = ['title', 'description', 'authorName', 'estimatedDuration'];
            requiredFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                if (field && !field.value.trim()) {
                    isValid = false;
                    field.style.borderColor = '#FF4757';
                    field.style.boxShadow = '0 0 0 3px rgba(255, 71, 87, 0.2)';
                    
                    const fieldName = field.previousElementSibling?.textContent || 'This field';
                    if (!errorMessages.includes(`${fieldName} is required`)) {
                        errorMessages.push(`${fieldName} is required`);
                    }
                }
            });
            
            if (!isValid) {
                alert('Please fix the following errors:\n\n' + errorMessages.join('\n'));
                return false;
            }
            
            return true;
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded, initializing edit module page...');
            
            handleFileUpload('coverImageInput', 'coverUploadText', 'coverFileInfo', 'coverPreview', 'currentCoverFile', true);
handleFileUpload('resourceFileInput', 'resourceUploadText', 'resourceFileInfo', null, 'currentResourceFile', false);
            
            setupButtonHandlers();
            
            console.log('Edit module page initialization complete');
        });
        
        document.querySelectorAll('.form-input, .form-textarea, .form-select').forEach(field => {
            field.addEventListener('input', function() {
                this.style.borderColor = '#F0D5B8';
                this.style.boxShadow = 'none';
            });
        });
        
        document.querySelectorAll('.checkbox-input').forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                const groupName = this.name;
                const groupItems = document.querySelectorAll(`.checkbox-item input[name="${groupName}"]`);
                groupItems.forEach(item => {
                    item.parentElement.parentElement.style.color = '';
                });
            });
        });
    </script>
</body>
</html>