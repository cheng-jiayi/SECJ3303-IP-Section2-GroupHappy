<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create New Learning Module</title>
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
            min-height: 24px;
            font-size: 16px;
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
            display: none;
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
        
        .btn-continue {
            background: #4A90E2;
            color: white;
        }
        
        .btn-continue:hover {
            background: #357ABD;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(74, 144, 226, 0.25);
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

        .preview-section {
            margin-top: 15px;
        }
        .preview-label {
            font-weight: 600;
            color: #713C0B;
            margin-bottom: 8px;
            display: block;
        }

        .error-message {
            color: #FF4757;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }

        .loading-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }
        
        .loading-spinner {
            background: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
        }
        
        .loading-spinner i {
            font-size: 40px;
            color: #F0A548;
            margin-bottom: 15px;
        }
        
        .loading-spinner p {
            color: #713C0B;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner">
            <i class="fas fa-spinner fa-spin"></i>
            <p>Creating Module...</p>
        </div>
    </div>
    
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
            <h1>Create New Learning Module</h1>
            <p>Add a new learning module to help users grow and learn</p>
        </div>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="status-info" style="background: #FFE2E5; border-color: #FF4757;">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <% if (request.getAttribute("success") != null) { %>
            <div class="status-info" style="background: #D4EDDA; border-color: #28A745;">
                <i class="fas fa-check-circle"></i>
                <%= request.getAttribute("success") %>
            </div>
        <% } %>
        
        <div class="content">
            <a href="<%= request.getContextPath() %>/admin-module-dashboard" class="back-link">
                <i class="fas fa-arrow-left"></i>
                Back to Dashboard
            </a>
            
            <form action="<%= request.getContextPath() %>/create-module" method="POST" enctype="multipart/form-data" id="moduleForm">
                <div class="form-layout">
                    <div class="left-column">
                        <div class="form-group">
                            <label class="form-label required">Cover Page Image</label>
                            <div class="file-upload" id="coverUpload">
                                <div class="upload-icon">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                </div>
                                <div class="upload-text" id="coverUploadText">Upload Cover Image</div>
                                <div class="upload-subtext">Click to browse or drag & drop</div>
                                <input type="file" name="coverImage" id="coverImageInput" accept="image/*" style="display: none;">
                                <button type="button" class="browse-btn" onclick="document.getElementById('coverImageInput').click()">Browse Files</button>
                                <div class="file-types">PNG, JPG, JPEG, GIF, BMP (Max: 10MB)</div>
                            </div>
                            
                            <div class="file-info" id="coverFileInfo" style="display: none;"></div>
                            
                            <div class="preview-section" id="coverPreviewSection" style="display: none;">
                                <span class="preview-label">Cover Image Preview:</span>
                                <div class="image-preview-container">
                                    <img id="coverPreview" class="image-preview" src="" alt="Cover Preview">
                                </div>
                            </div>
                            <div class="error-message" id="coverImageError"></div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label required">Category</label>
                            <div class="checkbox-group" id="categoryGroup">
                                <label class="checkbox-item">
                                    <input type="radio" name="category" value="Stress" class="checkbox-input" required>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Stress</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="category" value="Sleep" class="checkbox-input">
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Sleep</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="category" value="Anxiety" class="checkbox-input">
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Anxiety</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="category" value="Self-Esteem" class="checkbox-input">
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Self-Esteem</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="category" value="Mindfulness" class="checkbox-input">
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Mindfulness</span>
                                </label>
                            </div>
                            <div class="help-text">Select one category for this module</div>
                            <div class="error-message" id="categoryError"></div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label required">Learning Level</label>
                            <div class="checkbox-group" id="levelGroup">
                                <label class="checkbox-item">
                                    <input type="radio" name="level" value="Beginner" class="checkbox-input" required>
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Beginner</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="level" value="Intermediate" class="checkbox-input">
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Intermediate</span>
                                </label>
                                <label class="checkbox-item">
                                    <input type="radio" name="level" value="Advanced" class="checkbox-input">
                                    <span class="checkbox-custom"></span>
                                    <span class="checkbox-label">Advanced</span>
                                </label>
                            </div>
                            <div class="help-text">Select one learning level for this module</div>
                            <div class="error-message" id="levelError"></div>
                        </div>
                    </div>
                    
                    <div class="right-column">
                        <div class="form-group">
                            <label for="title" class="form-label required">Title</label>
                            <input type="text" name="title" id="title" class="form-input" 
                                placeholder="Enter a descriptive title for the module..." required>
                            <div class="error-message" id="titleError"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="description" class="form-label required">Description</label>
                            <textarea name="description" id="description" class="form-textarea" 
                                    placeholder="Provide a detailed description of what this module covers..." required></textarea>
                            <div class="error-message" id="descriptionError"></div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="authorName" class="form-label required">Author Name</label>
                                <input type="text" name="authorName" id="authorName" class="form-input" 
                                    placeholder="Enter the author/lecturer name..." required>
                                <div class="error-message" id="authorNameError"></div>
                            </div>
                            
                            <div class="form-group">
                                <label for="estimatedDuration" class="form-label required">Estimated Duration</label>
                                <input type="text" name="estimatedDuration" id="estimatedDuration" class="form-input" 
                                    placeholder="e.g., 30 minutes, 2 hours, 1 week..." required>
                                <div class="error-message" id="estimatedDurationError"></div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="videoUrl" class="form-label">Video URL</label>
                            <input type="url" name="videoUrl" id="videoUrl" class="form-input" 
                                placeholder="https://www.youtube.com/watch?v=... or Vimeo link">
                            <div class="help-text">Optional: Link to instructional video</div>
                        </div>
                        
                        <div class="form-group">
                            <label for="contentOutline" class="form-label">Content Outline</label>
                            <textarea name="contentOutline" id="contentOutline" class="form-textarea" 
                                    placeholder="Enter learning points separated by double dollar signs ($$)"></textarea>
                            <div class="help-text">Separate each point with "$$" (e.g., "Introduction$$Lesson 1$$Lesson 2")</div>
                        </div>
                        
                        <div class="form-group">
                            <label for="learningGuide" class="form-label">Learning Guide</label>
                            <textarea name="learningGuide" id="learningGuide" class="form-textarea" 
                                    placeholder="Step-by-step guide separated by double dollar signs ($$)"></textarea>
                            <div class="help-text">Separate each step with "$$"</div>
                        </div>
                        
                        <div class="form-group">
                            <label for="learningTip" class="form-label">Learning Tip</label>
                            <input type="text" name="learningTip" id="learningTip" class="form-input" 
                                placeholder="Short helpful tip for learners">
                        </div>
                        
                        <div class="form-group">
                            <label for="keyPoints" class="form-label">Key Points</label>
                            <textarea name="keyPoints" id="keyPoints" class="form-textarea" 
                                    placeholder="Key takeaways separated by double dollar signs ($$)"></textarea>
                            <div class="help-text">Separate each key point with "$$"</div>
                        </div>
                        
                        <div class="form-group resource-upload">
                            <label class="form-label">Upload Resource File</label>
                            <div class="file-upload" id="resourceUpload">
                                <div class="upload-icon">
                                    <i class="fas fa-file-upload"></i>
                                </div>
                                <div class="upload-text" id="resourceUploadText">Upload Resource File</div>
                                <div class="upload-subtext">Lecture slides, articles, or videos</div>
                                <input type="file" name="resourceFile" id="resourceFileInput" style="display: none;">
                                <button type="button" class="browse-btn" onclick="document.getElementById('resourceFileInput').click()">Browse Files</button>
                                <div class="file-types">MP4, PDF, DOCX, PPT, PNG, JPG, JPEG (Max: 50MB)</div>
                            </div>
                            
                            <div class="file-info" id="resourceFileInfo" style="display: none;"></div>
                            
                            <div class="help-text">Optional: Upload supporting materials for this module</div>
                        </div>
                        
                        <div class="form-group">
                            <label for="notes" class="form-label">Additional Notes</label>
                            <textarea name="notes" id="notes" class="form-textarea" 
                                    placeholder="Any additional information or prerequisites for this module..."></textarea>
                        </div>
                    </div>
                </div> 
                
                <div class="button-group">
                    <button type="button" class="btn btn-secondary" id="cancelBtn">
                        <i class="fas fa-times"></i>
                        Cancel
                    </button>
                    <button type="button" class="btn btn-continue" id="continueToQuizBtn">
                        <i class="fas fa-arrow-right"></i>
                        Continue to Create Quiz
                    </button>
                    <button type="submit" class="btn btn-primary" id="submitBtn">
                        <i class="fas fa-check"></i>
                        Create & Submit
                    </button>
                </div>
                
                <input type="hidden" name="action" id="actionField" value="save">
                <input type="hidden" name="redirectTo" id="redirectTo" value="">
            </form>
        </div>
    </div>
    
    <script>
        function handleFileUpload(inputId, uploadTextId, fileInfoId, previewImgId, previewSectionId, isImage = false) {
            const fileInput = document.getElementById(inputId);
            const uploadText = document.getElementById(uploadTextId);
            const fileInfo = document.getElementById(fileInfoId);
            const previewImg = previewImgId ? document.getElementById(previewImgId) : null;
            const previewSection = previewSectionId ? document.getElementById(previewSectionId) : null;
            
            if (!fileInput) return;
            
            console.log('Setting up file upload for:', inputId);
            
            fileInput.addEventListener('change', function(e) {
                console.log('File input changed for:', inputId);
                
                if (this.files && this.files[0]) {
                    const file = this.files[0];
                    const fileName = file.name;
                    const fileSizeMB = (file.size / (1024 * 1024)).toFixed(2);
                    
                    console.log('Selected file:', fileName, 'Size:', fileSizeMB, 'MB');
                    
                    if (uploadText) {
                        uploadText.textContent = 'Selected: ' + fileName;
                    }
                    
                    if (fileInfo) {
                        if (isImage) {
                            fileInfo.innerHTML = 
                                '<div style="display: flex; align-items: center; gap: 10px;">' +
                                '    <i class="fas fa-image" style="color: #4A90E2; font-size: 24px;"></i>' +
                                '    <div>' +
                                '        <div style="font-weight: 600; color: #713C0B;">Selected Cover Image</div>' +
                                '        <div style="color: #8B7355; font-size: 14px;">' + fileName + ' (' + fileSizeMB + ' MB)</div>' +
                                '    </div>' +
                                '</div>';
                        } else {
                            const fileTypeIcon = getFileIcon(fileName);
                            fileInfo.innerHTML = 
                                '<div style="display: flex; align-items: center; gap: 10px;">' +
                                '    <i class="fas fa-' + fileTypeIcon + '" style="color: #4A90E2; font-size: 24px;"></i>' +
                                '    <div>' +
                                '        <div style="font-weight: 600; color: #713C0B;">Selected Resource File</div>' +
                                '        <div style="color: #8B7355; font-size: 14px;">' + fileName + ' (' + fileSizeMB + ' MB)</div>' +
                                '    </div>' +
                                '</div>';
                        }
                        fileInfo.style.display = 'block';
                    }
                    
                    if (isImage && previewImg && previewSection) {
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            previewImg.src = e.target.result;
                            previewImg.style.display = 'block';
                            previewSection.style.display = 'block';
                        };
                        reader.readAsDataURL(file);
                    }
                } else {
                    console.log('No file selected');
                    
                    if (uploadText) {
                        uploadText.textContent = inputId === 'coverImageInput' ? 'Upload Cover Image' : 'Upload Resource File';
                    }
                    
                    if (fileInfo) {
                        fileInfo.style.display = 'none';
                        fileInfo.innerHTML = '';
                    }
                    
                    if (previewImg && previewSection) {
                        previewImg.style.display = 'none';
                        previewSection.style.display = 'none';
                    }
                }
            });
            
            const uploadArea = fileInput.parentElement.querySelector('.file-upload');
            if (uploadArea) {
                uploadArea.addEventListener('click', function(e) {
                    if (e.target.tagName !== 'BUTTON') {
                        fileInput.click();
                    }
                });
            }
        }

        function getFileIcon(filename) {
            if (!filename) return 'file';
            const extension = filename.toLowerCase().split('.').pop();
            switch(extension) {
                case 'pdf': return 'file-pdf';
                case 'doc':
                case 'docx': return 'file-word';
                case 'ppt':
                case 'pptx': return 'file-powerpoint';
                case 'jpg':
                case 'jpeg':
                case 'png':
                case 'gif':
                case 'bmp': return 'file-image';
                case 'mp4':
                case 'avi':
                case 'mov':
                case 'wmv': return 'file-video';
                default: return 'file';
            }
        }

        function setupButtonHandlers() {
            const form = document.getElementById('moduleForm');
            const actionField = document.getElementById('actionField');
            const redirectTo = document.getElementById('redirectTo');
            const cancelBtn = document.getElementById('cancelBtn');
            const continueToQuizBtn = document.getElementById('continueToQuizBtn');
            const submitBtn = document.getElementById('submitBtn');
            const loadingOverlay = document.getElementById('loadingOverlay');
            
            cancelBtn.addEventListener('click', function(e) {
                e.preventDefault();
                
                if (hasFormData()) {
                    if (confirm('You have unsaved changes. Discard changes and return to dashboard?')) {
                        window.location.href = '<%= request.getContextPath() %>/admin-module-dashboard';
                    }
                } else {
                    window.location.href = '<%= request.getContextPath() %>/admin-module-dashboard';
                }
            });
            

            continueToQuizBtn.addEventListener('click', function(e) {
                e.preventDefault();
                console.log('Continue to Quiz button clicked');
                
                clearAllErrors();
                
                if (!validateBasicFields()) {
                    return;
                }
                
                loadingOverlay.style.display = 'flex';
                
                actionField.value = 'save';
                redirectTo.value = 'quiz';
                
                console.log('Submitting form with action=save, redirectTo=quiz');
                
                setTimeout(() => {
                    form.submit();
                }, 500);
            });
            
            form.addEventListener('submit', function(e) {
                console.log('Form submit event triggered');
                
                if (redirectTo.value === 'quiz') {
                    console.log('Redirecting to quiz, skipping strict validation');
                    return true;
                }
                
                e.preventDefault();
                
                clearAllErrors();
                
                if (!validateForSubmission()) {
                    return false;
                }
                
                loadingOverlay.style.display = 'flex';
                
                actionField.value = 'submit';
                redirectTo.value = 'dashboard';
                
                console.log('Submitting form with action=submit, redirectTo=dashboard');
                
                setTimeout(() => {
                    form.submit();
                }, 500);
            });
        }

        function validateBasicFields() {
            console.log('Validating basic fields for quiz...');
            let isValid = true;
            
            const title = document.getElementById('title');
            if (!title.value.trim()) {
                showError('titleError', 'Title is required');
                highlightField(title);
                isValid = false;
            }
            
            const description = document.getElementById('description');
            if (!description.value.trim()) {
                showError('descriptionError', 'Description is required');
                highlightField(description);
                isValid = false;
            }
            
            const authorName = document.getElementById('authorName');
            if (!authorName.value.trim()) {
                showError('authorNameError', 'Author name is required');
                highlightField(authorName);
                isValid = false;
            }
            
            const estimatedDuration = document.getElementById('estimatedDuration');
            if (!estimatedDuration.value.trim()) {
                showError('estimatedDurationError', 'Estimated duration is required');
                highlightField(estimatedDuration);
                isValid = false;
            }
            
            const categorySelected = document.querySelector('input[name="category"]:checked');
            if (!categorySelected) {
                showError('categoryError', 'Please select a category');
                document.getElementById('categoryGroup').style.border = '2px solid #FF4757';
                document.getElementById('categoryGroup').style.padding = '10px';
                document.getElementById('categoryGroup').style.borderRadius = '8px';
                isValid = false;
            }
            
            const levelSelected = document.querySelector('input[name="level"]:checked');
            if (!levelSelected) {
                showError('levelError', 'Please select a learning level');
                document.getElementById('levelGroup').style.border = '2px solid #FF4757';
                document.getElementById('levelGroup').style.padding = '10px';
                document.getElementById('levelGroup').style.borderRadius = '8px';
                isValid = false;
            }
            
            const coverImageInput = document.getElementById('coverImageInput');
            if (!coverImageInput.files || coverImageInput.files.length === 0) {
                showError('coverImageError', 'Cover image is required');
                document.getElementById('coverUpload').style.borderColor = '#FF4757';
                isValid = false;
            }
            
            if (!isValid) {
                console.log('Basic validation failed');
                alert('Please fill in all required fields marked with *');
            }
            
            return isValid;
        }

        function validateForSubmission() {
            console.log('Validating for submission...');

            if (!validateBasicFields()) {
                return false;
            }
            
            const coverImageInput = document.getElementById('coverImageInput');
            if (coverImageInput.files && coverImageInput.files[0]) {
                const file = coverImageInput.files[0];
                const validImageTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/bmp'];
                if (!validImageTypes.includes(file.type)) {
                    showError('coverImageError', 'Please upload a valid image (JPEG, PNG, GIF, BMP)');
                    document.getElementById('coverUpload').style.borderColor = '#FF4757';
                    return false;
                }

                if (file.size > 10 * 1024 * 1024) {
                    showError('coverImageError', 'Cover image must be less than 10MB');
                    document.getElementById('coverUpload').style.borderColor = '#FF4757';
                    return false;
                }
            }
            
            return true;
        }

        function showError(elementId, message) {
            const element = document.getElementById(elementId);
            if (element) {
                element.textContent = message;
                element.style.display = 'block';
            }
        }

        function clearAllErrors() {
            document.querySelectorAll('.error-message').forEach(el => {
                el.style.display = 'none';
                el.textContent = '';
            });

            document.querySelectorAll('.form-input, .form-textarea').forEach(field => {
                field.style.borderColor = '#F0D5B8';
                field.style.boxShadow = 'none';
            });

            document.querySelectorAll('.checkbox-group').forEach(group => {
                group.style.border = '';
                group.style.padding = '';
                group.style.borderRadius = '';
            });

            document.getElementById('coverUpload').style.borderColor = '#F0D5B8';
        }

        function highlightField(field) {
            field.style.borderColor = '#FF4757';
            field.style.boxShadow = '0 0 0 3px rgba(255, 71, 87, 0.2)';
        }

        function hasFormData() {
            const textFields = ['title', 'description', 'authorName', 'estimatedDuration', 
                               'videoUrl', 'contentOutline', 'learningGuide', 'learningTip', 
                               'keyPoints', 'notes'];
            
            for (let fieldId of textFields) {
                const field = document.getElementById(fieldId);
                if (field && field.value && field.value.trim() !== '') {
                    return true;
                }
            }
            
            if (document.querySelector('input[name="category"]:checked') ||
                document.querySelector('input[name="level"]:checked')) {
                return true;
            }
            
            if ((document.getElementById('coverImageInput').files && 
                 document.getElementById('coverImageInput').files.length > 0) || 
                (document.getElementById('resourceFileInput').files && 
                 document.getElementById('resourceFileInput').files.length > 0)) {
                return true;
            }
            
            return false;
        }
        
        function setupInputListeners() {
            document.querySelectorAll('.form-input, .form-textarea, .form-select').forEach(field => {
                field.addEventListener('input', function() {
                    this.style.borderColor = '#F0D5B8';
                    this.style.boxShadow = 'none';
                    const errorId = this.id + 'Error';
                    const errorElement = document.getElementById(errorId);
                    if (errorElement) {
                        errorElement.style.display = 'none';
                    }
                });
            });
            
            document.querySelectorAll('.checkbox-input').forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    const groupName = this.name;
                    const group = document.getElementById(groupName + 'Group');
                    if (group) {
                        group.style.border = '';
                        group.style.padding = '';
                        group.style.borderRadius = '';
                    }
                    const errorElement = document.getElementById(groupName + 'Error');
                    if (errorElement) {
                        errorElement.style.display = 'none';
                    }
                });
            });
            
            document.getElementById('coverImageInput').addEventListener('change', function() {
                document.getElementById('coverUpload').style.borderColor = '#F0D5B8';
                document.getElementById('coverImageError').style.display = 'none';
            });
        }

        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded, initializing create module page...');
            
            handleFileUpload('coverImageInput', 'coverUploadText', 'coverFileInfo', 'coverPreview', 'coverPreviewSection', true);
            handleFileUpload('resourceFileInput', 'resourceUploadText', 'resourceFileInfo', null, null, false);
            
            setupButtonHandlers();

            setupInputListeners();
            
            console.log('Create module page initialization complete');
        });
    </script>
</body>
</html>