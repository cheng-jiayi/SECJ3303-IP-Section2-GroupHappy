<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assessment Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: #FBF6EA;
            color: #713C0B;
            font-family: 'Fredoka', sans-serif;
            margin: 0;
            padding: 0;
        }

        /* Top Navigation */
        .top-nav {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding: 22px 40px;
            background: #FBF6EA;
            border-bottom: 2px solid #F0D5B8;
            gap: 20px;
        }

        .logo {
            font-size: 28px;
            font-weight: 700;
            color: #F0A548;
        }

        .user-menu {
            position: relative;
        }

        .user-btn {
            background: #D7923B;
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: none;
            cursor: pointer;
            font-size: 20px;
        }

        /* Export Button */
        .export-btn {
            background: #F0A548;
            color: white;
            padding: 10px 30px;
            border-radius: 10px;
            font-size: 16px;
            cursor: pointer;
            border: none;
        }

        .export-btn:hover {
            background: #F29F3D;
        }

        /* Page Title */
        .page-title {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            text-align: left;
            margin-top: 30px;
            margin-bottom: 20px;
            padding-left: 5%;
            padding-right: 5%;
        }

        .page-title h1 {
            color: #F0A548;
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .page-title p {
            font-size: 16px;
            color: #A06A2F;
        }

        /* Results and Filter Section */
        .results-section {
            display: flex;
            justify-content: space-between;
            margin-top: 40px;
            margin-left: 5%;
            margin-right: 5%;
        }

        .results-section .card {
            background: #FFF;
            padding: 20px;
            border-radius: 18px;
            width: 30%;
            text-align: center;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .results-section .card h3 {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
        }

        .results-section .card .score {
            font-size: 32px;
            font-weight: 700;
            color: #713C0B;
        }

        /* Filter Section */
        .filter-section {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            margin-left: 5%;
            margin-right: 5%;
        }

        .filter-section input, .filter-section select {
            padding: 10px;
            font-size: 14px;
            border-radius: 10px;
            border: 2px solid #E2D5C1;
            width: 45%;
        }

        /* Assessment Table */
        .assessment-table {
            width: 90%;
            margin-top: 40px;
            margin-left: 5%;
            margin-right: 5%;
            border-collapse: collapse;
        }

        .assessment-table th, .assessment-table td {
            padding: 10px;
            text-align: center;
            border: 1px solid #E2D5C1;
        }

        .assessment-table th {
            background-color: #F0A548;
            color: white;
        }

        /* Modal for Viewing Details */
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            width: 50%;
            margin: 15% auto;
            text-align: center;
            position: relative;
        }

        .modal-content h2 {
            margin-bottom: 15px;
        }

        .modal-content button {
            background-color: #BDF5C6;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
        }

        .modal-content button:hover {
            background-color: #A0EFB4;
        }

        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            position: absolute;
            top: 10px;
            right: 10px;
            cursor: pointer;
        }

        .close:hover {
            color: black;
        }

        /* Export Success Message */
        .export-success {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .export-success-content {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            width: 50%;
            margin: 15% auto;
            text-align: center;
            position: relative;
        }

        .export-success-content h2 {
            margin-bottom: 15px;
        }

        .export-success-content button {
            background-color: #BDF5C6;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
        }

        .export-success-content button:hover {
            background-color: #A0EFB4;
        }

        .close-export {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            position: absolute;
            top: 10px;
            right: 10px;
            cursor: pointer;
        }

        .close-export:hover {
            color: black;
        }

    </style>
</head>
<body>

    <div class="top-nav">
        <div class="logo">SmileSpace</div>
        <div class="user-menu">
            <button class="user-btn" id="userBtn">
                <i class="fas fa-user"></i>
            </button>
        </div>
    </div>

<!-- Page Title -->
<div class="page-title" style="display: flex; justify-content: space-between; align-items: center; padding-left: 5%; padding-right: 5%; width: 100%;">
    <!-- Title and Export button container -->
    <!-- Page Title -->
<div style="display: flex; align-items: center; justify-content: flex-start; width: 100%;"> <h1 style="color: #F0A548; font-size: 36px; font-weight: 700; margin-bottom: 5px; margin-right: 10px; text-align: left;"> Assessment Management </h1> </div> <!-- Export Button beside title, aligned to the right --> <div class="export-btn" onclick="showExportModal()" style="background: #F0A548; color: white; padding: 10px 30px; border-radius: 10px; font-size: 16px; cursor: pointer; border: none; margin-left: auto;"> Export to CSV 📤 ..............</div>
</div>


<!-- Description below Title -->
<div style="padding-left: 5%; padding-right: 5%; margin-top: -10px;">
    <p style="font-size: 16px; color: #A06A2F;">View and analyze student DASS-21 assessments</p>
</div>



    <!-- Results Section -->
    <div class="results-section">
        <div class="card">
            <h3>Average Depression Score</h3>
            <div class="score">16.4</div>
            <div>Across all assessments</div>
        </div>
        <div class="card">
            <h3>Average Anxiety Score</h3>
            <div class="score">18.8</div>
            <div>Across all assessments</div>
        </div>
        <div class="card">
            <h3>Average Stress Score</h3>
            <div class="score">20.2</div>
            <div>Across all assessments</div>
        </div>
    </div>

    <!-- Filters Section -->
    <div class="filter-section">
        <input type="text" placeholder="Search by student’s name">
        <select>
            <option>All Severities</option>
            <option>Normal</option>
            <option>Mild</option>
            <option>Moderate</option>
            <option>Severe</option>
            <option>Extremely Severe</option>
        </select>
    </div>

    <!-- Assessment Table -->
    <table class="assessment-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Student Name</th>
                <th>Date</th>
                <th>Depression</th>
                <th>Anxiety</th>
                <th>Stress</th>
                <th>Overall Severity</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>A002</td>
                <td>Michael Chen</td>
                <td>05/12/2025</td>
                <td>14</td>
                <td>12</td>
                <td>18</td>
                <td>Moderate</td>
                <td>
                    <button onclick="showModal()">👁️</button>
                    <button>🗑️</button>
                </td>
            </tr>
            <tr>
                <td>A003</td>
                <td>Emma Davis</td>
                <td>05/11/2025</td>
                <td>20</td>
                <td>16</td>
                <td>22</td>
                <td>Severe</td>
                <td>
                    <button onclick="showModal()">👁️</button>
                    <button>🗑️</button>
                </td>
            </tr>
            <tr>
                <td>A004</td>
                <td>Olivia Brown</td>
                <td>05/05/2025</td>
                <td>25</td>
                <td>20</td>
                <td>30</td>
                <td>Extremely Severe</td>
                <td>
                    <button onclick="showModal()">👁️</button>
                    <button>🗑️</button>
                </td>
            </tr>
            <tr>
                <td>A005</td>
                <td>David Lee</td>
                <td>04/10/2025</td>
                <td>18</td>
                <td>14</td>
                <td>20</td>
                <td>Mild</td>
                <td>
                    <button onclick="showModal()">👁️</button>
                    <button>🗑️</button>
                </td>
            </tr>
        </tbody>

    </table>

    <!-- Modal for Detailed View -->
    <div id="detailsModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2>Assessment Details</h2>
            <p>Depression: 12</p>
            <p>Anxiety: 14</p>
            <p>Stress: 16</p>
            <p>Overall Severity: Mild</p>
        </div>
    </div>

    <!-- Export Success Popup -->
    <div id="exportModal" class="export-success">
        <div class="export-success-content">
            <span class="close-export" onclick="closeExportModal()">&times;</span>
            <h2>✅ Export Successful!</h2>
            <p>The student self-assessment list has been successfully exported to a CSV file. Your download is ready.</p>
            <button onclick="downloadCSV()">Download CSV</button>
        </div>
    </div>

    <script>
        function showModal() {
            document.getElementById('detailsModal').style.display = "block";
        }

        function closeModal() {
            document.getElementById('detailsModal').style.display = "none";
        }

        function closeExportModal() {
            document.getElementById('exportModal').style.display = "none";
        }

        function downloadCSV() {
            alert("CSV file is being downloaded...");
            // Implement download functionality here
        }

        function showExportModal() {
            document.getElementById('exportModal').style.display = "block";
        }
    </script>

</body>
</html>
