

package smilespace.controller.CompleteQuiz;

import smilespace.model.Question;
import smilespace.model.QuizResult;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;


@WebServlet(name = "QuizController", value = "/quiz")

public class QuizController extends HttpServlet {
    
    private List<Question> getStressQuestions() {
        List<Question> questions = new ArrayList<>();
        questions.add(new Question(1, "Regular exercise can help reduce stress levels.", true, "Stress"));
        questions.add(new Question(2, "Stress only affects your mental health, not your physical health.", false, "Stress"));
        questions.add(new Question(3, "Deep breathing exercises can help calm your mind during stressful moments.", true, "Stress"));
        questions.add(new Question(4, "A balanced diet has no effect on stress management.", false, "Stress"));
        questions.add(new Question(5, "Setting realistic goals can reduce stress caused by overwhelming tasks.", true, "Stress"));
        questions.add(new Question(6, "Ignoring stress and not talking about it is an effective coping strategy.", false, "Stress"));
        questions.add(new Question(7, "Mindfulness and meditation can improve your ability to handle stress.", true, "Stress"));
        questions.add(new Question(8, "Sleep quality has no impact on stress levels.", false, "Stress"));
        questions.add(new Question(9, "Talking to friends or family can help relieve stress.", true, "Stress"));
        questions.add(new Question(10, "Time management is a key technique to reduce daily stress.", true, "Stress"));
        return questions;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("start".equals(action)) {
            // Show quiz instruction page
            request.setAttribute("duration", "10 minutes");
            request.setAttribute("type", "True or False Questions (10 items)");
            request.setAttribute("moduleName", "Managing Stress in Daily Life");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/modules/completeQuiz/quiz-instruction.jsp");
            dispatcher.forward(request, response);
        } else if ("take".equals(action)) {
            // Show quiz questions
            List<Question> questions = getStressQuestions();
            request.setAttribute("questions", questions);
            request.setAttribute("moduleName", "Managing Stress in Daily Life");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/modules/completeQuiz/quiz.jsp");
            dispatcher.forward(request, response);
        } else if ("result".equals(action)) {
            // Show quiz result
            HttpSession session = request.getSession();
            QuizResult result = (QuizResult) session.getAttribute("quizResult");
            if (result != null) {
                request.setAttribute("quizResult", result);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/modules/completeQuiz/quiz-result.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendRedirect("quiz?action=take");
            }
        } else {
            // Default to start
            response.sendRedirect("quiz?action=start");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Process quiz submission
        List<Question> questions = getStressQuestions();
        Map<Integer, Boolean> userAnswers = new HashMap<>();
        int score = 0;
        
        for (Question question : questions) {
            String answerParam = request.getParameter("q" + question.getId());
            if (answerParam != null) {
                boolean userAnswer = "true".equals(answerParam);
                userAnswers.put(question.getId(), userAnswer);
                
                if (userAnswer == question.isTrue()) {
                    score++;
                }
            }
        }
        
        // Create quiz result
        QuizResult result = new QuizResult(score, questions.size(), questions, userAnswers, 
                                         "Managing Stress in Daily Life");
        
        // Store in session
        HttpSession session = request.getSession();
        session.setAttribute("quizResult", result);
        
        // Redirect to result page
        response.sendRedirect("quiz?action=result");
    }
}