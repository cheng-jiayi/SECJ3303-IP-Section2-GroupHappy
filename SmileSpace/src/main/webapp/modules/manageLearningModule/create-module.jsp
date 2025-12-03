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
        
        /* Top Navigation */
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
        
        /* Page Title */
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
        
        /* Content */
        .content { 
            background: white; 
            border-radius: 20px; 
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            border: 2px solid #F0D5B8;
            margin-top: 10px;
        }
        
        /* Back Link */
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
        
        /* Form Layout */
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
        
        /* Left Column - Cover, Category, Learning Level */
        .left-column {
            background: #FFF9F0;
            padding: 25px;
            border-radius: 15px;
            border: 2px solid #F0D5B8;
            display: flex;
            flex-direction: column;
            gap: 25px;
        }
        
        /* Right Column - Other Form Fields */
        .right-column {
            background: #FFF9F0;
            padding: 25px;
            border-radius: 15px;
            border: 2px solid #F0D5B8;
            display: flex;
            flex-direction: column;
            gap: 25px;
        }
        
        /* Form Groups */
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
        
        /* Checkbox Group */
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
        
        /* File Upload */
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
        }
        
        .file-types { 
            font-size: 13px; 
            color: #C7A178; 
            margin-top: 8px; 
            font-style: italic; 
        }
        
        /* Form Row for two columns */
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
        
        /* Button Group */
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
        
        /* Help Text */
        .help-text {
            font-size: 14px;
            color: #C7A178;
            margin-top: 5px;
        }
        
        /* Resource File Upload in Right Column */
        .resource-upload {
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <!-- Top Navigation -->
    <div class="top-nav">
        <div class="logo">
            <i class="fas fa-home"></i>
            SmileSpace
        </div>
    </div>
    
    <div class="container">
        <!-- Page Title -->
        <div class="page-title">
            <h1>Create New Learning Module</h1>
            <p>Add a new learning module to help users grow and learn</p>
        </div>
        
        <div class="content">
            <a href="dashboard" class="back-link">
                <i class="fas fa-arrow-left"></i>
                <span>Back to Dashboard</span>
            </a>
            
            <form action="create-module" method="POST" enctype="multipart/form-data" id="moduleForm">
                <div class="form-layout">
                    <!-- Left Column: Cover, Category, Learning Level -->
                    <div class="left-column">
                        <!-- Cover Page Image Upload -->
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
                                <div class="file-types">PNG, JPG, JPEG, GIF, BMP (Max: 5MB)</div>
                            </div>
                            <div class="file-info" id="coverFileInfo"></div>
                        </div>
                        
                        <!-- Category -->
                        <div class="form-group">
                            <label class="form-label required">Category</label>
                            <div class="checkbox-group">
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
                        </div>
                        
                        <!-- Learning Level -->
                        <div class="form-group">
                            <label class="form-label required">Learning Level</label>
                            <div class="checkbox-group">
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
                        </div>
                    </div>
                    
                    <!-- Right Column: Other Form Fields -->
                    <div class="right-column">
                        <!-- Title -->
                        <div class="form-group">
                            <label for="title" class="form-label required">Title</label>
                            <input type="text" name="title" id="title" class="form-input" 
                                   placeholder="Enter a descriptive title for the module..." required>
                        </div>
                        
                        <!-- Description -->
                        <div class="form-group">
                            <label for="description" class="form-label required">Description</label>
                            <textarea name="description" id="description" class="form-textarea" 
                                      placeholder="Provide a detailed description of what this module covers..." required></textarea>
                        </div>
                        
                        <!-- Author Name and Estimated Duration -->
                        <div class="form-row">
                            <div class="form-group">
                                <label for="authorName" class="form-label required">Author Name</label>
                                <input type="text" name="authorName" id="authorName" class="form-input" 
                                       placeholder="Enter the author/lecturer name..." required>
                            </div>
                            
                            <div class="form-group">
                                <label for="estimatedDuration" class="form-label required">Estimated Duration</label>
                                <input type="text" name="estimatedDuration" id="estimatedDuration" class="form-input" 
                                       placeholder="e.g., 30 minutes, 2 hours, 1 week..." required>
                            </div>
                        </div>
                        
                        <!-- Resource File Upload -->
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
                            <div class="file-info" id="resourceFileInfo"></div>
                            <div class="help-text">Optional: Upload supporting materials for this module</div>
                        </div>
                        
                        <!-- Additional Notes (Optional) -->
                        <div class="form-group">
                            <label for="notes" class="form-label">Additional Notes</label>
                            <textarea name="notes" id="notes" class="form-textarea" 
                                      placeholder="Any additional information or prerequisites for this module..."></textarea>
                        </div>
                    </div>
                </div>
                
                <!-- Submit Buttons -->
                <div class="button-group">
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='dashboard'">
                        <i class="fas fa-times"></i>
                        Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-check"></i>
                        Create Module
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // File Upload Functions
        function setupFileUpload(uploadAreaId, fileInputId, uploadTextId, fileInfoId, isImage = false) {
            const uploadArea = document.getElementById(uploadAreaId);
            const fileInput = document.getElementById(fileInputId);
            const uploadText = document.getElementById(uploadTextId);
            const fileInfo = document.getElementById(fileInfoId);
            
            if (!uploadArea || !fileInput) return;
            
            // Click to upload
            uploadArea.addEventListener('click', function(e) {
                if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'BUTTON') {
                    fileInput.click();
                }
            });
            
            // File input change
            fileInput.addEventListener('change', function(e) {
                if (this.files && this.files[0]) {
                    const file = this.files[0];
                    const fileName = file.name;
                    const fileSize = (file.size / (1024 * 1024)).toFixed(2); // Convert to MB
                    
                    // Update upload text
                    uploadText.textContent = `Selected: ${fileName}`;
                    
                    // Show file info
                    fileInfo.textContent = `${fileName} (${fileSize} MB)`;
                    fileInfo.style.display = 'block';
                    
                    // Validate file if needed
                    if (isImage) {
                        const validImageTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/bmp'];
                        if (!validImageTypes.includes(file.type)) {
                            fileInfo.innerHTML = `<span style="color: #FF4757;">Invalid image format. Please upload PNG, JPG, GIF, or BMP.</span>`;
                            fileInfo.style.display = 'block';
                        }
                    }
                } else {
                    uploadText.textContent = isImage ? 'Upload Cover Image' : 'Upload Resource File';
                    fileInfo.style.display = 'none';
                }
            });
            
            // Drag and drop
            ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
                uploadArea.addEventListener(eventName, preventDefaults, false);
            });
            
            function preventDefaults(e) {
                e.preventDefault();
                e.stopPropagation();
            }
            
            ['dragenter', 'dragover'].forEach(eventName => {
                uploadArea.addEventListener(eventName, highlight, false);
            });
            
            ['dragleave', 'drop'].forEach(eventName => {
                uploadArea.addEventListener(eventName, unhighlight, false);
            });
            
            function highlight() {
                uploadArea.style.borderColor = '#F0A548';
                uploadArea.style.background = '#F9EEDB';
            }
            
            function unhighlight() {
                uploadArea.style.borderColor = '#F0D5B8';
                uploadArea.style.background = '#FBF6EA';
            }
            
            uploadArea.addEventListener('drop', function(e) {
                const dt = e.dataTransfer;
                const files = dt.files;
                
                if (files.length > 0) {
                    fileInput.files = files;
                    
                    // Trigger change event
                    const event = new Event('change');
                    fileInput.dispatchEvent(event);
                }
                
                unhighlight();
            });
        }
        
        // Setup file uploads
        document.addEventListener('DOMContentLoaded', function() {
            // Cover image upload
            setupFileUpload('coverUpload', 'coverImageInput', 'coverUploadText', 'coverFileInfo', true);
            
            // Resource file upload
            setupFileUpload('resourceUpload', 'resourceFileInput', 'resourceUploadText', 'resourceFileInfo', false);
        });
        
        // Form Validation
        document.getElementById('moduleForm').addEventListener('submit', function(e) {
            // Clear previous error styles
            document.querySelectorAll('.form-input, .form-textarea, .form-select').forEach(field => {
                field.style.borderColor = '#F0D5B8';
                field.style.boxShadow = 'none';
            });
            
            document.querySelectorAll('.checkbox-group').forEach(group => {
                group.style.color = '';
            });
            
            const coverUpload = document.getElementById('coverUpload');
            const resourceUpload = document.getElementById('resourceUpload');
            coverUpload.style.borderColor = '#F0D5B8';
            resourceUpload.style.borderColor = '#F0D5B8';
            
            let isValid = true;
            let errorMessages = [];
            
            // Check category
            const categorySelected = document.querySelector('input[name="category"]:checked');
            if (!categorySelected) {
                isValid = false;
                const categoryGroup = document.querySelector('.form-group:nth-child(2) .checkbox-group');
                if (categoryGroup) {
                    categoryGroup.style.color = '#FF4757';
                }
                errorMessages.push('Please select a category');
            }
            
            // Check learning level
            const levelSelected = document.querySelector('input[name="level"]:checked');
            if (!levelSelected) {
                isValid = false;
                const levelGroup = document.querySelector('.form-group:nth-child(3) .checkbox-group');
                if (levelGroup) {
                    levelGroup.style.color = '#FF4757';
                }
                errorMessages.push('Please select a learning level');
            }
            
            // Check required text fields
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
            
            // Check cover image
            const coverImageInput = document.getElementById('coverImageInput');
            if (!coverImageInput.files || coverImageInput.files.length === 0) {
                isValid = false;
                coverUpload.style.borderColor = '#FF4757';
                errorMessages.push('Please upload a cover image');
            } else {
                // Optional: validate image type
                const file = coverImageInput.files[0];
                const validImageTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/bmp'];
                if (!validImageTypes.includes(file.type)) {
                    isValid = false;
                    coverUpload.style.borderColor = '#FF4757';
                    errorMessages.push('Please upload a valid image file (JPEG, PNG, GIF, BMP)');
                }
            }
            
            if (!isValid) {
                e.preventDefault();
                alert('Please fix the following errors:\n\n' + errorMessages.join('\n'));
                return false;
            }
            
            return true;
        });
        
        // Clear validation styles on input
        document.querySelectorAll('.form-input, .form-textarea, .form-select').forEach(field => {
            field.addEventListener('input', function() {
                this.style.borderColor = '#F0D5B8';
                this.style.boxShadow = 'none';
            });
        });
        
        // Clear validation styles on radio change
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

edit-module.jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="smilespace.model.LearningModule" %>
<%
    LearningModule module = (LearningModule) request.getAttribute("module");
    String category = module.getCategory();
%>
<!DOCTYPE html>
<html>
<head>
    <title>UC005 - Edit Module</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Preahvihear&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Preahvihear', sans-serif; }
        body { background: #FBF6EA; color: #713C0B; }
        
        .container { max-width: 800px; margin: 40px auto; background: white; border-radius: 15px; box-shadow: 0 8px 25px rgba(107, 79, 54, 0.1); overflow: hidden; }
        .header { background: #F0A548; color: #CF8224; padding: 30px; text-align: center; }
        .header h1 { font-size: 28px; font-weight: 600; color: #713C0B; margin-bottom: 10px; }
        .header p { font-size: 16px; color: #CF8224; }
        
        .content { padding: 35px; }
        
        .module-id { background: #F4DBAF; padding: 12px 18px; border-radius: 10px; margin-bottom: 25px; font-weight: 500; color: #713C0B; }
        .module-id span { color: #CF8224; font-weight: 600; }
        
        .back-link { 
            display: inline-flex; align-items: center; gap: 8px; margin-bottom: 25px; 
            color: #713C0B; text-decoration: none; font-weight: 500; font-size: 15px;
            padding: 8px 16px; border-radius: 20px; background: #F4DBAF; transition: all 0.3s;
        }
        .back-link:hover { background: #F0A548; text-decoration: none; color: white; }
        
        .form-group { margin-bottom: 25px; }
        .form-label { display: block; margin-bottom: 10px; font-weight: 600; color: #713C0B; font-size: 15px; }
        .form-input, .form-textarea, .form-select, .checkbox-group { 
            width: 100%; padding: 14px 18px; border: 2px solid #F0A548; 
            border-radius: 10px; font-size: 15px; transition: all 0.3s; 
            background: #FFFBF0;
        }
        .form-input:focus, .form-textarea:focus, .form-select:focus { 
            outline: none; border-color: #CF8224; box-shadow: 0 0 0 3px rgba(207, 130, 36, 0.2); 
        }
        .form-textarea { min-height: 130px; resize: vertical; }
        
        .checkbox-group {
            border: 2px solid #F0A548;
            padding: 15px;
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
            background: #FFFBF0;
        }
        
        .checkbox-option {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
        }
        
        .checkbox-option input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: #F0A548;
            cursor: pointer;
        }
        
        .checkbox-option label {
            color: #713C0B;
            cursor: pointer;
            font-weight: 500;
        }
        
        .file-upload { display: flex; align-items: center; gap: 10px; }
        .file-input { flex: 1; }
        .browse-btn { 
            background: #F0A548; color: white; border: none; padding: 12px 25px; 
            border-radius: 8px; cursor: pointer; font-weight: 600; transition: all 0.3s;
        }
        .browse-btn:hover { background: #CF8224; transform: translateY(-2px); }
        
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; }
        
        .file-types { font-size: 13px; color: #CF8224; margin-top: 8px; font-style: italic; }
        
        .button-group { display: flex; gap: 15px; justify-content: flex-end; margin-top: 40px; }
        .btn { 
            padding: 14px 35px; border: none; border-radius: 10px; 
            font-weight: 600; font-size: 16px; cursor: pointer; transition: all 0.3s; 
        }
        .btn-primary { background: #F0A548; color: white; }
        .btn-primary:hover { background: #CF8224; transform: translateY(-3px); box-shadow: 0 5px 15px rgba(240, 165, 72, 0.3); }
        .btn-secondary { background: #713C0B; color: white; }
        .btn-secondary:hover { background: #5A2F09; transform: translateY(-3px); }
        
        .form-hint {
            font-size: 13px;
            color: #CF8224;
            margin-top: 5px;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>UC005 - Edit Module</h1>
            <p>Would you like to edit learning modules?</p>
        </div>
        
        <div class="content">
            <a href="dashboard" class="back-link">← Back to Dashboard</a>
            
            <div class="module-id">Editing: <span><%= module.getId() %> - <%= module.getTitle() %></span></div>
            
            <form action="edit-module" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="id" value="<%= module.getId() %>">
                
                <div class="form-group">
                    <label class="form-label">Cover Page</label>
                    <div class="file-upload">
                        <input type="text" name="coverImage" class="form-input file-input" 
                               value="<%= module.getCoverImage() != null ? module.getCoverImage() : "" %>" 
                               placeholder="Upload cover image..." readonly>
                        <input type="file" id="coverImageFile" name="coverImageFile" accept=".png,.jpg,.jpeg,.gif,.bmp" style="display: none;">
                        <button type="button" class="browse-btn" onclick="document.getElementById('coverImageFile').click()">Browse</button>
                    </div>
                    <div class="file-types">Supported file types: PNG, JPG, JPEG, GIF, BMP</div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Title *</label>
                    <input type="text" name="title" class="form-input" 
                           value="<%= module.getTitle() %>" required>
                    <div class="form-hint">Keep it clear and descriptive</div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Description *</label>
                    <textarea name="description" class="form-textarea" required><%= module.getDescription() != null ? module.getDescription() : "" %></textarea>
                    <div class="form-hint">Describe what users will learn from this module</div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Category *</label>
                        <div class="checkbox-group">
                            <div class="checkbox-option">
                                <input type="checkbox" name="category" value="Stress" id="catStress" <%= "Stress".equals(category) ? "checked" : "" %>>
                                <label for="catStress">Stress</label>
                            </div>
                            <div class="checkbox-option">
                                <input type="checkbox" name="category" value="Anxiety" id="catAnxiety" <%= "Anxiety".equals(category) ? "checked" : "" %>>
                                <label for="catAnxiety">Anxiety</label>
                            </div>
                            <div class="checkbox-option">
                                <input type="checkbox" name="category" value="Sleep" id="catSleep" <%= "Sleep".equals(category) ? "checked" : "" %>>
                                <label for="catSleep">Sleep</label>
                            </div>
                            <div class="checkbox-option">
                                <input type="checkbox" name="category" value="Self-Esteem" id="catSelfEsteem" <%= "Self-Esteem".equals(category) ? "checked" : "" %>>
                                <label for="catSelfEsteem">Self-Esteem</label>
                            </div>
                            <div class="checkbox-option">
                                <input type="checkbox" name="category" value="Mindfulness" id="catMindfulness" <%= "Mindfulness".equals(category) ? "checked" : "" %>>
                                <label for="catMindfulness">Mindfulness</label>
                            </div>
                        </div>
                        <div class="form-hint">Select one or more categories</div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Learning Level *</label>
                        <select name="level" class="form-select" required>
                            <option value="Beginner" <%= "Beginner".equals(module.getLevel()) ? "selected" : "" %>>Beginner</option>
                            <option value="Intermediate" <%= "Intermediate".equals(module.getLevel()) ? "selected" : "" %>>Intermediate</option>
                            <option value="Advance" <%= "Advance".equals(module.getLevel()) ? "selected" : "" %>>Advanced</option>
                        </select>
                        <div class="form-hint">Choose the difficulty level</div>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Author Name *</label>
                        <input type="text" name="authorName" class="form-input" 
                               value="<%= module.getAuthorName() != null ? module.getAuthorName() : "" %>" required>
                        <div class="form-hint">Full name of the module creator</div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Estimated Duration *</label>
                        <input type="text" name="estimatedDuration" class="form-input" 
                               value="<%= module.getEstimatedDuration() != null ? module.getEstimatedDuration() : "" %>" required>
                        <div class="form-hint">e.g., "2 hours", "30 minutes"</div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Upload Resource File</label>
                    <div class="file-upload">
                        <input type="text" name="resourceFile" class="form-input file-input" 
                               value="<%= module.getResourceFile() != null ? module.getResourceFile() : "" %>" 
                               placeholder="Upload lecture slides, articles or recorded video..." readonly>
                        <input type="file" id="resourceFile" name="resourceFile" accept=".mp4,.pdf,.docx,.ppt,.pptx,.png,.jpg,.jpeg" style="display: none;">
                        <button type="button" class="browse-btn" onclick="document.getElementById('resourceFile').click()">Browse</button>
                    </div>
                    <div class="file-types">Supported file types: MP4, PDF, DOCX, PPT, PNG, JPG, JPEG</div>
                </div>
                
                <div class="button-group">
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='dashboard'">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Module</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        document.querySelector('form').addEventListener('submit', function(e) {
            const categories = this.querySelectorAll('input[name="category"]:checked');
            if (categories.length === 0) {
                e.preventDefault();
                alert('Please select at least one category');
                document.querySelector('.checkbox-group').style.borderColor = '#E74C3C';
                return false;
            }
            return true;
        });
        
        // Update file input display
        document.getElementById('coverImageFile').addEventListener('change', function(e) {
            const displayInput = this.previousElementSibling;
            if(this.files.length > 0) {
                displayInput.value = this.files[0].name;
            }
        });
        
        document.getElementById('resourceFile').addEventListener('change', function(e) {
            const displayInput = this.previousElementSibling;
            if(this.files.length > 0) {
                displayInput.value = this.files[0].name;
            }
        });
    </script>
</body>
</html>