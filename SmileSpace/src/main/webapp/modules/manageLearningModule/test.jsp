<%@ page contentType="text/html" %>
<html>
<body>
    <h1>Test Page</h1>
    <p>Testing if model class can be accessed...</p>
    <%
        try {
            Class.forName("smilespace.model.LearningModule");
            out.println("<p style='color:green'>✅ LearningModule class found!</p>");
        } catch (ClassNotFoundException e) {
            out.println("<p style='color:red'>❌ LearningModule class NOT found: " + e.getMessage() + "</p>");
        }
    %>
</body>
</html>