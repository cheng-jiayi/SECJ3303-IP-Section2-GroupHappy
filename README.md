# SmileSpace Project

## To Run Code:

1. **Prerequisites:**
   * **JDK:** 21.0.9 or later
   * **Apache Maven:** 3.9.11 or later
   * **Apache Tomcat:** 11.0.13 or later

2. **Download code:** Clone or download the repository to your local machine.

3. **Build database in this order:**
   1. [user.sql](https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/resources/database/user.sql)
   2. [forum.sql](https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/resources/database/forum.sql)
   3. [report.sql](https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/resources/database/report.sql)
   4. [learning_modules.sql](https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/resources/database/learning_modules.sql)
   5. [mood_counseling.sql](https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/resources/database/mood_counseling.sql)
   6. [feedback.sql](https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/resources/database/feedback.sql)
   7. [self_assessment.sql](https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/resources/database/SelfAssessment.sql)

4. **Configure DataSource:** Ensure `AppConfig.java` DataSource username and password are correct for your local MySQL instance.

5. **Navigate to the project root directory:** Open your terminal/command prompt in the `SmileSpace` root folder.

6. **Build the WAR file in SmileSpace folder:** Run the following Maven command:
   ```bash
   mvn clean package
7. **Deploy the WAR file:** Copy the generated .war file from the target folder to the Tomcat webapps directory.

8. **Start Tomcat:** Launch your Apache Tomcat server.

9. **Access Application:** Open your browser and go to: http://localhost:8585/SmileSpace/login
    [Default port is 8585 (adjust if your Tomcat uses a different port)]

<br>

<h2>Member Contributions</h2>
<table border="1">
  <tr>
    <th>Member</th>
    <th>Module</th>
    <th>Model (DAO, Database)</th>
    <th>View (JSP, CSS, Bootstrap)</th>
    <th>Controller (CRUD)</th>
    <th>Personalization and Authorization (Session, Filter)</th>
    <th>Reporting (Transaction, History)</th>
  </tr>
  <tr>
    <td>Cheng Jia Yi</td>
    <td>
      <ul>
        <li>User Management Module</li>
        <li><b>Peer Support Forum Module</b></li>
      </ul>
    </td>
    <td>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/model/Post.java">Post.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/model/Reply.java">Reply.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/model/Report.java">Report.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/dao/PostDAO.java">PostDAO.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/dao/PostDAOImpl.java">PostDAOImpl.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/dao/ReplyDAO.java">ReplyDAO.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/dao/ReplyDAOImpl.java">ReplyDAOImpl.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/dao/ReportDAO.java">ReportDAO.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/dao/ReportDAOImpl.java">ReportDAOImpl.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/resources/database/forum.sql">forum.sql</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/resources/database/report.sql">report.sql</a></li>
      </ul>
    </td>
    <td>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/peerSupportForumModule/forum.jsp">forum.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/peerSupportForumModule/myReports.jsp">myReports.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/peerSupportForumModule/adminReports.jsp">adminReports.jsp</a></li>
      </ul>
    </td>
    <td>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/ForumController.java">ForumController.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/ReportController.java">ReportController.java</a></li>
      </ul>
    </td>
    <td>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/18b60356812e1e024683cae99d7da4e696f77ac7/SmileSpace/src/main/webapp/WEB-INF/views/modules/peerSupportForumModule/forum.jsp#L4C1-L12C3">forum.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/18b60356812e1e024683cae99d7da4e696f77ac7/SmileSpace/src/main/webapp/WEB-INF/views/modules/peerSupportForumModule/myReports.jsp#L4-L11">myReports.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/18b60356812e1e024683cae99d7da4e696f77ac7/SmileSpace/src/main/webapp/WEB-INF/views/modules/peerSupportForumModule/adminReports.jsp#L3-L10">adminReports.jsp</a></li>
      </ul>
    </td>
    <td>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/model/Report.java">Report.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/ReportController.java">ReportController.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/dao/ReportDAO.java">ReportDAO.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/dao/ReportDAOImpl.java">ReportDAOImpl.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/service/ReportService.java">ReportService.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/service/ReplyServiceImpl.java">ReportServiceImpl.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/resources/database/report.sql">report.sql</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/peerSupportForumModule/myReports.jsp">myReports.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/peerSupportForumModule/adminReports.jsp">adminReports.jsp</a></li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>Ong Ya Sian</td>
    <td>
      <ul>
        <li><b>Learning Resources Module</b></li>
        <li>AI Mental Health Assistant Module</li>
      </ul>
    </td>
    <td>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/model/LearningModule.java">LearningModule.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/model/Question.java">Qustion.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/model/QuizResult.java">QuizResult.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/dao/LearningModuleDAO.java">LearningModuleDAO.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/dao/QuizDAO.java">QuizDAO.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/resources/database/learning_modules.sql">learning_modules.sql</a></li>
      </ul>
    </td>
    <td>
      <a>Mental Health Professional View</a>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/manageLearningModule/dashboard.jsp">dashboard.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/manageLearningModule/create-module.jsp">create-module.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/manageLearningModule/edit-module.jsp">edit-module.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/manageLearningModule/view-module.jsp">view-module.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/manageLearningModule/delete-module.jsp">delete-module.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/manageLearningModule/create-quiz.jsp">create-quiz.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/manageLearningModule/edit-quiz.jsp">edit-quiz.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/manageLearningModule/view-quiz.jsp">view-quiz.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/manageLearningModule/draft-confirmation.jsp">draft-confirmation.jsp</a></li>
      </ul>
      <a>Student View / Faculty Member View</a>
        <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/completeQuiz/student-module.jsp">student-module.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/completeQuiz/module-content.jsp">module-content.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/completeQuiz/quiz-intro.jsp">quiz-intro.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/completeQuiz/quiz-dashboard.jsp">quiz-dashboard.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/completeQuiz/quiz.jsp">quiz.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/completeQuiz/quiz-instruction.jsp">quiz-instruction.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/completeQuiz/quiz-result.jsp">quiz-result.jsp</a></li>
      </ul>
    </td>
    <td>
      <a>Mental Health Professional View</a>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/ManageLearningModule/ModuleDashboardController.java">ModuleDashboardController.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/ManageLearningModule/CreateModuleController.java">CreateModuleController.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/ManageLearningModule/EditModuleController.java">EditModuleController.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/ManageLearningModule/ViewModuleController.java">ViewModuleController.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/ManageLearningModule/DeleteModuleController.java">DeleteModuleController.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/ManageLearningModule/CreateQuizController.java">CreateQuizController.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/ManageLearningModule/EditQuizController.java">EditQuizController.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/ManageLearningModule/ViewQuizController.java">ViewQuizController.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/ManageLearningModule/DraftConfirmationController.java">DraftConfirmationController.java</a></li>
      </ul>
      <br>
      <a>Student View / Faculty Member View</a>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/completeQuiz/StudentLearningModuleController.java">StudentLearningModuleController.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/completeQuiz/StudentModuleController.java">StudentModuleController.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/completeQuiz/QuizDashboardController.java">QuizDashboardController.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/completeQuiz/QuizController.java">QuizController.java</a></li>
      </ul>
    </td>
    <td>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/filter/ModuleAuthorizationFilter.java">ModuleAuthorizationFilter.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/completeQuiz/QuizController.java">QuizController.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/ManageLearningModule/ModuleDashboardController.java">ModuleDashboardController.java</a></li>
      </ul>
    </td>
    <td>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/model/LearningModule.java">LearningModule.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/ManageLearningModule/ModuleDashboardController.java">ModuleDashboardController.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/dao/LearningModuleDAO.java">LearningModuleDAO.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/service/LearningModuleService.java">LearningModuleService.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/manageLearningModule/dashboard.jsp">dashboard.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/resources/database/learning_modules.sql">learning_modules.sql</a></li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>Wong Jia Xuan</td>
    <td>
      <ul>
        <li>Mood and Wellness Module</li>
        <li><b>Virtual Counseling Module</b></li>
      </ul>
    </td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>Yap En Thong</td>
    <td>
      <ul>
        <li>Self Assessment Module</li>
        <li><b>Feedback and Analytics Module</b></li>
      </ul>
    </td>
    <td>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/model/Feedback.java">Fedback.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/dao/FeedbackDAO.java">FeedbackDAO.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/resources/database/feedback.sql">feedback.sql</a></li>
      </ul>    
      </td>
    <td>
      <ul>
<a>Administrator View</a>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/feedbackAndAnalyticsModule/feedbackAnalytics.jsp">feedbackAndAnalytics.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/feedbackAndAnalyticsModule/feedbackHistory.jsp">feedbackHistory.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/feedbackAndAnalyticsModule/feedbackReply.jsp">feedbackReply.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/feedbackAndAnalyticsModule/feedbackHistory.jsp">feedbackHistory.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/feedbackAndAnalyticsModule/feedbackReport.jsp">feedbackreport.jsp</a></li>
      </ul>
      <br>
      <a>Student View / Faculty Member View / Mental Heath Professional View</a>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/feedbackAndAnalyticsModule/feedback.jsp">feedback.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/feedbackAndAnalyticsModule/my-feedback.jsp">my-feedback.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/feedbackAndAnalyticsModule/userReply.jsp">userReply.jsp</a></li>
      </ul>
      </ul>  
    </td>
    <td>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/controller/feedbackAndAnalytics/FeedbackController.java">FeedbackController.java</a></li>
      </ul> 
    </td>
    <td>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/filter/FeedbackAuthorizationFilter.java">FeedbackAuthorizationFilter.java</a></li>
      </ul> 
    </td>
    <td>
      <ul>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/service/FeedbackAnalyticsService.java">FeedbackAnalyticsService.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/java/smilespace/service/FeedbackService.java">FeedbackService.java</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/feedbackAndAnalyticsModule/feedbackHistory.jsp">feedbackHistory.jsp</a></li>      
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/feedbackAndAnalyticsModule/my-feedback.jsp">my-feedback.jsp</a></li>
        <li><a href="https://github.com/azizah-utm/project-code-submission-group-happy/blob/main/SmileSpace/src/main/webapp/WEB-INF/views/modules/feedbackAndAnalyticsModule/feedbackReport.jsp">feedbackreport.jsp</a></li>
      </ul> 
    </td>
  </tr>
</table>
