<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Counseling Session - SmileSpace</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Preahvihear&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #FFF8E8;
            font-family: 'Inter', sans-serif;
            color: #6B4F36;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        .container {
            width: 90%;
            max-width: 1200px;
            text-align: left;
            margin-top: 3%;
        }

        .top-right {
            position: absolute;
            right: 40px;
            top: 20px;
            font-family: 'Preahvihear', sans-serif;
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

        .home-link:hover {
            opacity: 0.7;
            text-decoration: none;
        }

        h1 {
            font-size: 40px;
            font-weight: 600;
            text-align: left;
            margin-bottom: 10px;
            padding-bottom: 0;
            color: #6B4F36;
            font-family: 'Preahvihear', sans-serif;
        }

        .subtitle {
            font-family: 'Preahvihear', sans-serif;
            font-size: 18px;
            margin-bottom: 20px;
            text-align: left;
            font-weight: 400;
            color: #CF8224;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .back-btn {
            font-family: 'Preahvihear', sans-serif;
            background: #8B7355;
            color: white;
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 25px;
            font-size: 15px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }

        .back-btn:hover {
            background: #6B4F36;
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
        }

        /* Main form layout */
        .form-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            align-items: start;
            margin-bottom: 60px;
        }

        .card {
            background: #FFF3C8;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0px 4px 15px rgba(107, 79, 54, 0.1);
            height: fit-content;
        }

        .card h2 {
            font-size: 22px;
            color: #6B4F36;
            margin-top: 0;
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 2px solid #E8D4B9;
        }

        .form-group {
            margin-bottom: 25px;
            width: 100%;
        }

        label {
            display: block;
            font-weight: 600;
            margin-bottom: 10px;
            color: #6B4F36;
            font-size: 14px;
        }

        label.required::after {
            content: " *";
            color: #E74C3C;
        }

        textarea, input {
            width: 100%;
            padding: 10px;
            border: 2px solid #E8D4B9;
            border-radius: 10px;
            font-family: 'Inter', sans-serif;
            font-size: 14px;
            background: white;
            color: #6B4F36;
            transition: all 0.3s;
            box-sizing: border-box;
            display: block;
            
        }
        
        select {
            width: 100%;
            padding: 10px;
            border: 2px solid #E8D4B9;
            border-radius: 10px;
            font-family: 'Inter', sans-serif;
            font-size: 14px;
            background: white;
            color: #6B4F36;
            transition: all 0.3s;
            box-sizing: border-box;
            display: block;
            /* Add custom dropdown arrow */
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%236B4F36' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 8px center; /* Changed from 12px to 8px to move left */
            background-size: 16px;
        }
        
        select:focus {
            outline: none;
            border-color: #D7923B;
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.2);
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23D7923B' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
        }

        textarea:focus, input:focus {
            outline: none;
            border-color: #D7923B;
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.2);
        }

        textarea {
            height: 120px;
            resize: vertical;
        }

        /* Multi-select dropdown styling - Selected moods inside input */
        .multiselect-dropdown {
            position: relative;
            width: 100%;
        }

        .multiselect-select {
            width: 100%;
            min-height: 46px;
            padding: 10px;
            border: 2px solid #E8D4B9;
            border-radius: 10px;
            background: white;
            cursor: pointer;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 6px;
            font-family: 'Inter', sans-serif;
            font-size: 14px;
            color: #6B4F36;
            transition: all 0.3s;
            box-sizing: border-box;
        }

        .multiselect-select:focus {
            outline: none;
            border-color: #D7923B;
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.2);
        }

        .multiselect-select .dropdown-arrow {
            font-size: 12px;
            transition: transform 0.3s;
            color: #6B4F36;
            margin-left: auto;
        }

        .multiselect-select.open .dropdown-arrow {
            transform: rotate(180deg);
        }

        .multiselect-options {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border: 2px solid #E8D4B9;
            border-top: none;
            border-radius: 0 0 10px 10px;
            max-height: 200px;
            overflow-y: auto;
            z-index: 1000;
            display: none;
            box-shadow: 0 4px 15px rgba(107, 79, 54, 0.1);
        }

        .multiselect-options.show {
            display: block;
        }

        .multiselect-option {
            padding: 10px 12px;
            cursor: pointer;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .multiselect-option:hover {
            background: #FFF8E8;
        }

        .multiselect-option input {
            width: auto;
            margin: 0;
        }

        .multiselect-option label {
            margin: 0;
            cursor: pointer;
            font-weight: normal;
            flex: 1;
        }

        .selected-moods {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            flex: 1;
        }

        .mood-tag {
            background: #D7923B;
            color: white;
            padding: 5px 12px;
            border-radius: 12px;
            font-size: 12px;
            display: flex;
            align-items: center;
            gap: 5px;
            white-space: nowrap;
        }

        .mood-tag .remove {
            cursor: pointer;
            font-size: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 14px;
            height: 14px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transition: all 0.2s;
        }

        .mood-tag .remove:hover {
            background: rgba(255, 255, 255, 0.5);
            transform: scale(1.1);
        }

        .placeholder-text {
            color: #A88C6D;
        }

        /* Calendar styling */
        .calendar-container {
            background: #fff6da;
            padding: 20px;
            border-radius: 12px;
            border: 2px solid #E8D4B9;
            margin-bottom: 20px;
        }

        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 5px;
        }

        .calendar-header h3 {
            margin: 0;
            color: #6B4F36;
            font-size: 14px;
            font-weight: 600;
        }

        .calendar-subtitle {
            font-size: 13px;
            color: #CF8224;
            margin-bottom: 15px;
            text-align: left;
        }

        .calendar-nav {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .calendar-nav button {
            background: #D7923B;
            color: white;
            border: none;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            cursor: pointer;
            font-size: 13px;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .calendar-nav button:hover {
            background: #C77D2F;
            transform: scale(1.1);
        }

        #currentMonth {
            font-size: 14px;
            font-weight: 600;
            color: #6B4F36;
            min-width: 150px;
            text-align: center;
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 5px;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .calendar-day {
            padding: 8px 5px;
            text-align: center;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
            font-weight: 500;
            min-height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .calendar-day:hover {
            background: #FFEBB5;
            transform: translateY(-2px);
        }

        .calendar-day.selected {
            background: #D7923B;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(215, 146, 59, 0.3);
        }

        .calendar-day.other-month {
            color: #A88C6D;
            cursor: not-allowed;
        }

        .calendar-day.other-month:hover {
            background: transparent;
            transform: none;
        }

        .calendar-day.disabled {
            color: #D3C1A7;
            cursor: not-allowed;
            background: #F5F5F5;
        }

        .calendar-day.disabled:hover {
            background: #F5F5F5;
            transform: none;
        }

        /* Time slots styling */
        .time-slots {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            margin-top: 15px;
        }

        .time-slot {
            padding: 10px;
            text-align: center;
            border: 2px solid #E8D4B9;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
            font-weight: 500;
            background: white;
        }

        .time-slot:hover {
            background: #FFEBB5;
            transform: translateY(-2px);
        }

        .time-slot.selected {
            background: #D7923B;
            color: white;
            border-color: #D7923B;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(215, 146, 59, 0.3);
        }

        .form-actions {
            display: flex;
            gap: 20px;
            justify-content: flex-end;
            margin-top: 35px;
            margin-bottom: 35px;
        }

        .submit-btn {
            background: #D7923B;
            color: white;
            padding: 15px 35px;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            font-weight: 600;
            font-size: 15px;
            font-family: 'Preahvihear', sans-serif;
            transition: all 0.3s;
        }

        .submit-btn:hover {
            background: #C77D2F;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(215, 146, 59, 0.4);
        }

        .cancel-btn {
            background: #8B7355;
            color: white;
            padding: 15px 35px;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
            font-size: 15px;
            font-family: 'Preahvihear', sans-serif;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .cancel-btn:hover {
            background: #6B4F36;
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
        }

        /* Responsive design */
        @media (max-width: 1024px) {
            .form-content {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .container {
                width: 95%;
            }
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .cancel-btn, .submit-btn {
                width: 100%;
                justify-content: center;
            }
            
            .calendar-grid {
                gap: 3px;
            }
            
            .calendar-day {
                padding: 8px 3px;
                font-size: 12px;
                min-height: 35px;
            }
            
            .time-slots {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .mood-tag {
                padding: 3px 8px;
                font-size: 11px;
            }
        }
    </style>
</head>
<body>

<div class="top-right">
    <a href="index.jsp" class="home-link">
        <i class="fas fa-home"></i>
        SmileSpace 
    </a>
</div>

<div class="container">
    <div class="header">
        <div>
            <h1>Book a Counseling Session</h1>
            <div class="subtitle">Schedule your counseling session and share what's on your mind.</div>
        </div>
        <a href="counseling?action=viewSessions" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Sessions
        </a>
    </div>

    <div class="form-content">
        <!-- Left Column: Session Type and Date/Time -->
        <div class="card">
            <h2>Session Details</h2>
            
            <div class="form-group">
                <label for="sessionType" class="required">Session Type</label>
                <select id="sessionType" name="sessionType" required>
                    <option value="">Select session type</option>
                    <option value="In-Person">In-Person</option>
                    <option value="Video Call">Video Call</option>
                    <option value="Phone Call">Phone Call</option>
                </select>
            </div>

            <div class="form-group">
                <label class="required">Date & Time</label>
                <div class="calendar-container">
                    <div class="calendar-header">
                        <h3>Select Date</h3>
                        <div class="calendar-nav">
                            <button type="button" id="prevMonth">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <span id="currentMonth"></span>
                            <button type="button" id="nextMonth">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                    <div class="calendar-subtitle">Minimum 3 days in advance</div>
                    <div class="calendar-grid" id="calendar">
                        <!-- Calendar will be populated by JavaScript -->
                    </div>
                    <div id="timeSlots" style="display: none;">
                        <h4 style="margin-bottom: 15px; color: #6B4F36; font-size: 16px;">Select Time</h4>
                        <div class="time-slots" id="timeSlotContainer">
                            <!-- Time slots will be populated by JavaScript -->
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column: Other Form Fields -->
        <div class="card">
            <h2>Session Information</h2>
            
            <div class="form-group">
                <label for="currentMood" class="required">Current Mood</label>
                <div class="multiselect-dropdown">
                    <div class="multiselect-select" id="moodSelector">
                        <div class="selected-moods" id="selectedMoods">
                            <span class="placeholder-text">Select your current mood(s)</span>
                        </div>
                        <i class="fas fa-chevron-down dropdown-arrow"></i>
                    </div>
                    <div class="multiselect-options" id="moodOptions">
                        <div class="multiselect-option">
                            <input type="checkbox" id="mood-happy" value="Happy">
                            <label for="mood-happy">Happy</label>
                        </div>
                        <div class="multiselect-option">
                            <input type="checkbox" id="mood-neutral" value="Neutral">
                            <label for="mood-neutral">Neutral</label>
                        </div>
                        <div class="multiselect-option">
                            <input type="checkbox" id="mood-stressed" value="Stressed">
                            <label for="mood-stressed">Stressed</label>
                        </div>
                        <div class="multiselect-option">
                            <input type="checkbox" id="mood-anxious" value="Anxious">
                            <label for="mood-anxious">Anxious</label>
                        </div>
                        <div class="multiselect-option">
                            <input type="checkbox" id="mood-sad" value="Sad">
                            <label for="mood-sad">Sad</label>
                        </div>
                        <div class="multiselect-option">
                            <input type="checkbox" id="mood-overwhelmed" value="Overwhelmed">
                            <label for="mood-overwhelmed">Overwhelmed</label>
                        </div>
                        <div class="multiselect-option">
                            <input type="checkbox" id="mood-confused" value="Confused">
                            <label for="mood-confused">Confused</label>
                        </div>
                        <div class="multiselect-option">
                            <input type="checkbox" id="mood-other" value="Other">
                            <label for="mood-other">Other</label>
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label for="reason" class="required">Reason for Session</label>
                <textarea id="reason" name="reason" placeholder="Please describe what you'd like to discuss..." required></textarea>
            </div>

            <div class="form-group">
                <label for="additionalNotes">Additional Notes (Optional)</label>
                <textarea id="additionalNotes" name="additionalNotes" placeholder="Any additional information that might be helpful..."></textarea>
            </div>

            <div class="form-group">
                <label for="followUpMethod" class="required">Preferred Follow-up Method</label>
                <select id="followUpMethod" name="followUpMethod" required>
                    <option value="">Select follow-up method</option>
                    <option value="Email">Email</option>
                    <option value="WhatsApp">WhatsApp</option>
                    <option value="Phone Call">Phone Call</option>
                    <option value="In-Person Meeting">In-Person Meeting</option>
                </select>
            </div>

            <form action="counseling" method="post" id="bookingForm">
                <input type="hidden" name="action" value="submitBooking">
                <input type="hidden" name="sessionDate" id="sessionDate">
                <input type="hidden" name="sessionTime" id="sessionTime">
                <input type="hidden" name="sessionType" id="sessionTypeHidden">
                <input type="hidden" name="currentMood" id="currentMoodHidden">
                <input type="hidden" name="reason" id="reasonHidden">
                <input type="hidden" name="additionalNotes" id="additionalNotesHidden">
                <input type="hidden" name="followUpMethod" id="followUpMethodHidden">
                
                <div class="form-actions">
                    <a href="counseling?action=viewSessions" class="cancel-btn">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                    <button type="submit" class="submit-btn">
                        <i class="fas fa-calendar-check"></i> Confirm Booking
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Mood multi-select functionality
    const moodSelector = document.getElementById('moodSelector');
    const moodOptions = document.getElementById('moodOptions');
    const selectedMoodsContainer = document.getElementById('selectedMoods');
    const moodCheckboxes = document.querySelectorAll('#moodOptions input[type="checkbox"]');
    const currentMoodHidden = document.getElementById('currentMoodHidden');
    
    let selectedMoods = [];

    // Toggle dropdown
    moodSelector.addEventListener('click', function(e) {
        // Don't toggle if clicking on a remove button
        if (!e.target.closest('.remove')) {
            moodOptions.classList.toggle('show');
            moodSelector.classList.toggle('open');
        }
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function(event) {
        if (!event.target.closest('.multiselect-dropdown')) {
            moodOptions.classList.remove('show');
            moodSelector.classList.remove('open');
        }
    });

    // Handle checkbox changes
    moodCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            const mood = this.value;
            
            if (this.checked) {
                if (!selectedMoods.includes(mood)) {
                    selectedMoods.push(mood);
                }
            } else {
                selectedMoods = selectedMoods.filter(m => m !== mood);
            }
            
            updateSelectedMoodsDisplay();
            updateHiddenField();
        });
    });

    // Update the display of selected moods as tags
    function updateSelectedMoodsDisplay() {
        selectedMoodsContainer.innerHTML = '';
        
        if (selectedMoods.length === 0) {
            selectedMoodsContainer.innerHTML = '<span class="placeholder-text">Select your current mood(s)</span>';
        } else {
            selectedMoods.forEach(mood => {
                const tag = document.createElement('div');
                tag.className = 'mood-tag';
                tag.innerHTML = `
                    ${mood}
                    <span class="remove" data-mood="${mood}">
                        <i class="fas fa-times"></i>
                    </span>
                `;
                selectedMoodsContainer.appendChild(tag);
            });
        }

        // Add event listeners to remove buttons
        document.querySelectorAll('.mood-tag .remove').forEach(button => {
            button.addEventListener('click', function(e) {
                e.stopPropagation(); // Prevent dropdown toggle
                const moodToRemove = this.getAttribute('data-mood');
                selectedMoods = selectedMoods.filter(m => m !== moodToRemove);
                
                // Uncheck the corresponding checkbox
                const checkbox = document.querySelector(`#moodOptions input[value="${moodToRemove}"]`);
                if (checkbox) {
                    checkbox.checked = false;
                }
                
                updateSelectedMoodsDisplay();
                updateHiddenField();
            });
        });
    }

    // Update the hidden field value
    function updateHiddenField() {
        currentMoodHidden.value = selectedMoods.join(', ');
    }

    // Calendar functionality
    let currentDate = new Date();
    let selectedDate = null;
    let selectedTime = null;

    function renderCalendar() {
        const calendar = document.getElementById('calendar');
        const currentMonth = document.getElementById('currentMonth');
        
        // Set month header
        currentMonth.textContent = currentDate.toLocaleString('default', { month: 'long', year: 'numeric' });
        
        // Clear calendar
        calendar.innerHTML = '';
        
        // Add day headers
        const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        days.forEach(day => {
            const dayHeader = document.createElement('div');
            dayHeader.textContent = day;
            dayHeader.style.fontWeight = '600';
            dayHeader.style.color = '#6B4F36';
            dayHeader.style.textAlign = 'center';
            dayHeader.style.fontSize = '12px';
            dayHeader.style.padding = '6px 2px';
            dayHeader.style.textTransform = 'uppercase';
            calendar.appendChild(dayHeader);
        });
        
        // Get first day of month
        const firstDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
        const startingDay = firstDay.getDay();
        
        // Get last day of month
        const lastDay = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
        const daysInMonth = lastDay.getDate();
        
        // Add empty cells for days before first day of month
        for (let i = 0; i < startingDay; i++) {
            const emptyDay = document.createElement('div');
            emptyDay.classList.add('calendar-day', 'other-month');
            emptyDay.style.textAlign = 'center';
            calendar.appendChild(emptyDay);
        }
        
        // Add days of month
        for (let day = 1; day <= daysInMonth; day++) {
            const dayElement = document.createElement('div');
            dayElement.classList.add('calendar-day');
            dayElement.textContent = day;
            dayElement.style.textAlign = 'center';
            
            const dateStr = `${currentDate.getFullYear()}-${(currentDate.getMonth() + 1).toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`;
            dayElement.dataset.date = dateStr;
            
            // Check if this date is selected
            if (selectedDate === dateStr) {
                dayElement.classList.add('selected');
            }
            
            // Calculate minimum allowed date (3 days from today)
            const today = new Date();
            const minDate = new Date();
            minDate.setDate(today.getDate() + 3); // 3 days from today
            minDate.setHours(0, 0, 0, 0);
            
            const cellDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), day);
            
            if (cellDate >= minDate) {
                dayElement.addEventListener('click', () => selectDate(dateStr, dayElement));
            } else {
                dayElement.classList.add('disabled');
                dayElement.style.color = '#D3C1A7';
                dayElement.style.cursor = 'not-allowed';
                dayElement.style.background = '#F5F5F5';
            }
            
            calendar.appendChild(dayElement);
        }
    }

    function selectDate(date, element) {
        // Remove previous selection
        document.querySelectorAll('.calendar-day.selected').forEach(el => {
            el.classList.remove('selected');
        });
        
        // Add new selection
        element.classList.add('selected');
        selectedDate = date;
        
        // Show time slots
        document.getElementById('timeSlots').style.display = 'block';
        renderTimeSlots();
    }

    function renderTimeSlots() {
        const timeSlotContainer = document.getElementById('timeSlotContainer');
        timeSlotContainer.innerHTML = '';
        
        const timeSlots = [
            '09:00', '10:00', '11:00', '14:00', 
            '15:00', '16:00', '17:00', '18:00'
        ];
        
        timeSlots.forEach(time => {
            const timeSlot = document.createElement('div');
            timeSlot.classList.add('time-slot');
            timeSlot.textContent = time;
            
            if (selectedTime === time) {
                timeSlot.classList.add('selected');
            }
            
            timeSlot.addEventListener('click', () => {
                document.querySelectorAll('.time-slot.selected').forEach(el => {
                    el.classList.remove('selected');
                });
                timeSlot.classList.add('selected');
                selectedTime = time;
                
                // Set hidden form fields
                document.getElementById('sessionDate').value = selectedDate;
                document.getElementById('sessionTime').value = selectedTime + ':00';
            });
            
            timeSlotContainer.appendChild(timeSlot);
        });
    }

    // Initialize calendar
    document.getElementById('prevMonth').addEventListener('click', () => {
        currentDate.setMonth(currentDate.getMonth() - 1);
        renderCalendar();
    });

    document.getElementById('nextMonth').addEventListener('click', () => {
        currentDate.setMonth(currentDate.getMonth() + 1);
        renderCalendar();
    });

    // Form validation and data transfer
    document.getElementById('bookingForm').addEventListener('submit', function(e) {
        if (!selectedDate || !selectedTime) {
            e.preventDefault();
            alert('Please select both date and time for your session.');
            return;
        }

        if (selectedMoods.length === 0) {
            e.preventDefault();
            alert('Please select at least one mood.');
            return;
        }

        // Check if session type is selected
        const sessionType = document.getElementById('sessionType').value;
        if (!sessionType) {
            e.preventDefault();
            alert('Please select a session type.');
            return;
        }

        // Check if reason is filled
        const reason = document.getElementById('reason').value;
        if (!reason.trim()) {
            e.preventDefault();
            alert('Please provide a reason for the session.');
            return;
        }

        // Check if follow-up method is selected
        const followUpMethod = document.getElementById('followUpMethod').value;
        if (!followUpMethod) {
            e.preventDefault();
            alert('Please select a follow-up method.');
            return;
        }

        // Transfer visible form data to hidden fields
        document.getElementById('sessionTypeHidden').value = sessionType;
        document.getElementById('reasonHidden').value = reason;
        document.getElementById('additionalNotesHidden').value = document.getElementById('additionalNotes').value;
        document.getElementById('followUpMethodHidden').value = followUpMethod;
    });

    // Initialize the page
    renderCalendar();
</script>
</body>
</html>