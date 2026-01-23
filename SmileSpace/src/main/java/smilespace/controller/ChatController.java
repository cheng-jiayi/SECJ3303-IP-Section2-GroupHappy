package smilespace.controller;

import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.*;

@Controller
@RequestMapping("/chat")
public class ChatController {

    private static final String HUGGINGFACE_API_KEY = "";

    private static final String HUGGINGFACE_ROUTER_URL = "https://router.huggingface.co/v1/chat/completions";

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper mapper = new ObjectMapper();

    @PostMapping("/send")
    @ResponseBody
    public Map<String, Object> send(@RequestBody Map<String, String> payload) {
        String userMessage = payload.get("message");
        Map<String, Object> responseMap = new HashMap<>();

        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(HUGGINGFACE_API_KEY);

            Map<String, Object> body = new HashMap<>();
            body.put("model", "meta-llama/Llama-3.1-8B-Instruct"); 

            List<Map<String, String>> messages = new ArrayList<>();
            messages.add(Map.of("role", "system", "content", "You are a helpful assistant."));
            messages.add(Map.of("role", "user", "content", userMessage));
            body.put("messages", messages);

            body.put("max_tokens", 1000);

            HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);

            ResponseEntity<String> response = restTemplate.postForEntity(
                    HUGGINGFACE_ROUTER_URL,
                    request,
                    String.class
            );

            String replyText = "No response";
            Map<String, Object> jsonResponse = mapper.readValue(response.getBody(), Map.class);
            List<Map<String, Object>> choices = (List<Map<String, Object>>) jsonResponse.get("choices");
            if (choices != null && !choices.isEmpty()) {
                Map<String, Object> message = (Map<String, Object>) choices.get(0).get("message");
                if (message != null && message.containsKey("content")) {
                    replyText = (String) message.get("content");
                }
            }

            responseMap.put("status", "success");
            responseMap.put("message", replyText);

        } catch (Exception e) {
            responseMap.put("status", "error");
            responseMap.put("message", e.getMessage());
            e.printStackTrace();
        }

        return responseMap;
    }
}
