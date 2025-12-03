<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<% 
    // Only initialize if not already done
    if (application.getAttribute("forumPosts") == null) {
        // Create simulated posts database
        List<Map<String, String>> posts = new ArrayList<>();
        
        // Sample post 1
        Map<String, String> post1 = new HashMap<>();
        post1.put("id", "1");
        post1.put("title", "Feeling overwhelmed with studies");
        post1.put("content", "I'm having trouble balancing all my assignments and exams. Any advice on time management?");
        post1.put("author", "Amy Tan");
        post1.put("authorRole", "Student");
        post1.put("isAnonymous", "false");
        post1.put("createdAt", "2024-03-10 14:30:00");
        post1.put("replyCount", "3");
        posts.add(post1);
        
        // Sample post 2
        Map<String, String> post2 = new HashMap<>();
        post2.put("id", "2");
        post2.put("title", "Tips for managing stress");
        post2.put("content", "Sharing some techniques that helped me cope with academic pressure:\n\n1. Pomodoro technique\n2. Regular exercise\n3. Mindfulness meditation\n4. Proper sleep schedule");
        post2.put("author", "Dr. Smith");
        post2.put("authorRole", "Faculty");
        post2.put("isAnonymous", "false");
        post2.put("createdAt", "2024-03-09 10:15:00");
        post2.put("replyCount", "5");
        posts.add(post2);
        
        // Sample post 3
        Map<String, String> post3 = new HashMap<>();
        post3.put("id", "3");
        post3.put("title", "Need someone to talk to");
        post3.put("content", "Going through a tough time and could use some support. Feeling isolated lately.");
        post3.put("author", "Anonymous");
        post3.put("authorRole", "");
        post3.put("isAnonymous", "true");
        post3.put("createdAt", "2024-03-08 16:45:00");
        post3.put("replyCount", "2");
        posts.add(post3);
        
        // Sample post 4
        Map<String, String> post4 = new HashMap<>();
        post4.put("id", "4");
        post4.put("title", "Dealing with anxiety before presentations");
        post4.put("content", "Anyone else gets really anxious before presentations? How do you cope?");
        post4.put("author", "John Doe");
        post4.put("authorRole", "Student");
        post4.put("isAnonymous", "false");
        post4.put("createdAt", "2024-03-07 09:20:00");
        post4.put("replyCount", "4");
        posts.add(post4);
        
        application.setAttribute("forumPosts", posts);
        
        // Replies database
        Map<String, List<Map<String, String>>> replies = new HashMap<>();
        
        // Replies for post 1
        List<Map<String, String>> replies1 = new ArrayList<>();
        
        Map<String, String> reply1 = new HashMap<>();
        reply1.put("id", "1");
        reply1.put("postId", "1");
        reply1.put("content", "Try breaking tasks into smaller chunks and use a planner! I found the Pomodoro technique really helpful.");
        reply1.put("author", "Senior Student");
        reply1.put("authorRole", "Student");
        reply1.put("isAnonymous", "false");
        reply1.put("createdAt", "2024-03-10 15:45:00");
        replies1.add(reply1);
        
        Map<String, String> reply2 = new HashMap<>();
        reply2.put("id", "2");
        reply2.put("postId", "1");
        reply2.put("content", "Remember to take breaks and practice self-care. You can't pour from an empty cup.");
        reply2.put("author", "Wellness Advisor");
        reply2.put("authorRole", "Professional");
        reply2.put("isAnonymous", "false");
        reply2.put("createdAt", "2024-03-10 16:20:00");
        replies1.add(reply2);
        
        Map<String, String> reply3 = new HashMap<>();
        reply3.put("id", "3");
        reply3.put("postId", "1");
        reply3.put("content", "Talk to your professors if you're struggling. Most are understanding and can offer extensions.");
        reply3.put("author", "Former Student");
        reply3.put("authorRole", "Alumni");
        reply3.put("isAnonymous", "false");
        reply3.put("createdAt", "2024-03-10 17:30:00");
        replies1.add(reply3);
        
        replies.put("1", replies1);
        
        // Replies for post 2
        List<Map<String, String>> replies2 = new ArrayList<>();
        
        Map<String, String> reply4 = new HashMap<>();
        reply4.put("id", "1");
        reply4.put("postId", "2");
        reply4.put("content", "Great tips! I'd add deep breathing exercises - they help me during stressful moments.");
        reply4.put("author", "Anonymous");
        reply4.put("authorRole", "");
        reply4.put("isAnonymous", "true");
        reply4.put("createdAt", "2024-03-09 11:30:00");
        replies2.add(reply4);
        
        replies.put("2", replies2);
        
        // Replies for post 3
        List<Map<String, String>> replies3 = new ArrayList<>();
        
        Map<String, String> reply5 = new HashMap<>();
        reply5.put("id", "1");
        reply5.put("postId", "3");
        reply5.put("content", "I'm here for you. Sometimes just knowing someone is listening helps.");
        reply5.put("author", "Caring Friend");
        reply5.put("authorRole", "Student");
        reply5.put("isAnonymous", "false");
        reply5.put("createdAt", "2024-03-08 18:20:00");
        replies3.add(reply5);
        
        replies.put("3", replies3);
        
        // Replies for post 4
        List<Map<String, String>> replies4 = new ArrayList<>();
        
        Map<String, String> reply6 = new HashMap<>();
        reply6.put("id", "1");
        reply6.put("postId", "4");
        reply6.put("content", "Practice in front of friends or record yourself. It gets easier with practice!");
        reply6.put("author", "Public Speaking Coach");
        reply6.put("authorRole", "Faculty");
        reply6.put("isAnonymous", "false");
        reply6.put("createdAt", "2024-03-07 10:45:00");
        replies4.add(reply6);
        
        replies.put("4", replies4);
        
        application.setAttribute("forumReplies", replies);
    }
%>