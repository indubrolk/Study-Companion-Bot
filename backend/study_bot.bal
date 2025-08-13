import ballerina/http;
import ballerina/lang.'string;
import ballerina/log;
import ballerina/regex;

// Configuration for the service
configurable int PORT = 9090;
configurable string HOST = "localhost";

// CORS configuration
@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:3000", "http://localhost:5173"],
        allowCredentials: false,
        allowHeaders: ["COEP", "COOP", "CORP", "CSRF", "Origin", "X-Requested-With", "Content-Type", "Accept", "Authorization", "Cache-Control"],
        allowMethods: ["GET", "POST", "PUT", "DELETE", "PATCH", "HEAD", "OPTIONS"]
    }
}
service /study on new http:Listener(PORT) {

    // Health check endpoint
    resource function get health() returns json {
        return {
            status: "healthy",
service: "Smart Study Backend",
            timestamp: time:utcNow()
        };
    }

    // Text summarization endpoint
    resource function post summarize(http:Caller caller, http:Request req) returns error? {
        do {
            // Get the text from request body
            string textToSummarize = check req.getTextPayload();

            if textToSummarize.trim() == "" {
                http:Response response = new;
                response.statusCode = 400;
                response.setJsonPayload({
                    error: "Empty text provided",
                    message: "Please provide text to summarize"
                });
                check caller->respond(response);
                return;
            }

            // Generate summary using extractive summarization
            string summary = generateSummary(textToSummarize);

            json responseJson = {
                summary: summary,
                originalLength: textToSummarize.length(),
                summaryLength: summary.length(),
                compressionRatio: (summary.length() * 100) / textToSummarize.length()
            };

            check caller->respond(responseJson);

        } on fail var e {
            log:printError("Error in summarization", 'error = e);
            http:Response errorResponse = new;
            errorResponse.statusCode = 500;
            errorResponse.setJsonPayload({
                error: "Internal server error",
                message: "Failed to process summarization request"
            });
            check caller->respond(errorResponse);
        }
    }

    // Chatbot interaction endpoint
    resource function post chat(http:Caller caller, http:Request req) returns error? {
        do {
            json requestBody = check req.getJsonPayload();
            string userMessage = check requestBody.message;
            string? context = requestBody.context is string ? <string>requestBody.context : ();

            if userMessage.trim() == "" {
                http:Response response = new;
                response.statusCode = 400;
                response.setJsonPayload({
                    error: "Empty message",
                    message: "Please provide a message"
                });
                check caller->respond(response);
                return;
            }

            // Generate bot response
            string botResponse = generateBotResponse(userMessage, context);

            json responseJson = {
                response: botResponse,
                timestamp: time:utcNow(),
                messageType: determineChatType(userMessage)
            };

            check caller->respond(responseJson);

        } on fail var e {
            log:printError("Error in chat processing", 'error = e);
            http:Response errorResponse = new;
            errorResponse.statusCode = 500;
            errorResponse.setJsonPayload({
                error: "Internal server error",
                message: "Failed to process chat request"
            });
            check caller->respond(errorResponse);
        }
    }

    // Study session tracking endpoint
    resource function post session(http:Caller caller, http:Request req) returns error? {
        do {
            json requestBody = check req.getJsonPayload();
            string sessionType = check requestBody.sessionType; // "start", "pause", "complete"
            int duration = check requestBody.duration; // in seconds
            string? mode = requestBody.mode is string ? <string>requestBody.mode : "focus";

            json sessionData = {
                sessionType: sessionType,
                duration: duration,
                mode: mode,
                timestamp: time:utcNow(),
                status: "recorded"
            };

            // Here you could save to a database
            log:printInfo(string `Study session ${sessionType}: ${duration} seconds in ${mode} mode`);

            check caller->respond(sessionData);

        } on fail var e {
            log:printError("Error in session tracking", 'error = e);
            http:Response errorResponse = new;
            errorResponse.statusCode = 500;
            errorResponse.setJsonPayload({
                error: "Internal server error",
                message: "Failed to track study session"
            });
            check caller->respond(errorResponse);
        }
    }

    // Get study resources (past papers, notes)
    resource function get resources/[string resourceType]() returns json|http:NotFound {
        match resourceType {
            "pastpapers" => {
                return {
                    resources: [
                        {
                            id: "1",
                            title: "Mathematics Past Paper 2023",
                            subject: "Mathematics",
                            year: 2023,
type: "final_exam",
                            url: "/resources/math_2023_final.pdf"
                        },
                        {
                            id: "2",
                            title: "Physics Past Paper 2023",
                            subject: "Physics",
                            year: 2023,
type: "midterm",
                            url: "/resources/physics_2023_midterm.pdf"
                        },
                        {
                            id: "3",
                            title: "Computer Science Past Paper 2023",
                            subject: "Computer Science",
                            year: 2023,
type: "final_exam",
                            url: "/resources/cs_2023_final.pdf"
                        }
                    ]
                };
            }
            "notes" => {
                return {
                    resources: [
                        {
                            id: "1",
                            title: "Calculus Fundamentals",
                            subject: "Mathematics",
                            topic: "Derivatives and Integrals",
                            summary: "Comprehensive notes on differential and integral calculus"
                        },
                        {
                            id: "2",
                            title: "Quantum Mechanics Basics",
                            subject: "Physics",
                            topic: "Quantum Theory",
                            summary: "Introduction to quantum mechanics principles"
                        },
                        {
                            id: "3",
                            title: "Data Structures and Algorithms",
                            subject: "Computer Science",
                            topic: "Programming",
                            summary: "Essential data structures and algorithmic concepts"
                        }
                    ]
                };
            }
            _ => {
                return http:NOT_FOUND;
            }
        }
    }
}

// Function to generate summary using extractive summarization
function generateSummary(string text) returns string {
    // Split text into sentences
    string[] sentences = regex:split(text, "[.!?]+");

    // Remove empty sentences and trim
    string[] cleanSentences = [];
    foreach string sentence in sentences {
        string trimmed = sentence.trim();
        if trimmed != "" {
            cleanSentences.push(trimmed);
        }
    }

    if cleanSentences.length() == 0 {
        return "No content to summarize.";
    }

    // Simple extractive summarization: take first sentence, middle sentence, and last sentence
    string[] selectedSentences = [];

    if cleanSentences.length() == 1 {
        return cleanSentences[0] + ".";
    } else if cleanSentences.length() == 2 {
        return string:join        (". " , ...cleanSentences ) + ".";
    } else if cleanSentences.length() <= 5 {
        // For short texts, take first and last sentences
        selectedSentences.push(cleanSentences[0]);
        selectedSentences.push(cleanSentences[cleanSentences.length() - 1]);
    } else {
        // For longer texts, take first, middle, and last sentences
        selectedSentences.push(cleanSentences[0]);
        selectedSentences.push(cleanSentences[cleanSentences.length() / 2]);
        selectedSentences.push(cleanSentences[cleanSentences.length() - 1]);
    }

    return string:join    (". " , ...selectedSentences ) + ".";
}

// Function to generate chatbot responses
function generateBotResponse(string userMessage, string? context) returns string {
    string lowerMessage = userMessage.toLowerAscii();

    // Study-related responses
    if lowerMessage.includes("help") || lowerMessage.includes("assist") {
        return "I'm here to help with your studies! I can help you find past papers, notes, explain concepts, or assist with time management. What would you like to work on?";
    }

    if lowerMessage.includes("past paper") || lowerMessage.includes("exam") || lowerMessage.includes("test") {
        return "I can help you find past papers for your subjects. What subject are you studying? I have papers for Mathematics, Physics, Computer Science, and more.";
    }

    if lowerMessage.includes("note") || lowerMessage.includes("study material") {
        return "I have study notes available for various subjects. Would you like notes for a specific topic or subject? I can provide summaries and key concepts.";
    }

    if lowerMessage.includes("pomodoro") || lowerMessage.includes("timer") || lowerMessage.includes("focus") {
        return "Great question about time management! The Pomodoro Technique uses 25-minute focus sessions followed by 5-minute breaks. This helps maintain concentration and prevents burnout. Would you like tips on staying focused during study sessions?";
    }

    if lowerMessage.includes("summarize") || lowerMessage.includes("summary") {
        return "I can help you summarize long texts to make them easier to study. Just paste your text and I'll create a concise summary highlighting the key points. This is great for reviewing lecture notes or textbook chapters.";
    }

    // Subject-specific responses
    if lowerMessage.includes("math") || lowerMessage.includes("calculus") || lowerMessage.includes("algebra") {
        return "Mathematics can be challenging! I can help explain concepts step by step. Are you working on a specific topic like calculus, algebra, geometry, or statistics? Let me know what you're struggling with.";
    }

    if lowerMessage.includes("physics") || lowerMessage.includes("quantum") || lowerMessage.includes("mechanics") {
        return "Physics concepts can be complex but fascinating! Whether it's classical mechanics, thermodynamics, electromagnetism, or quantum physics, I can help break down the concepts. What topic interests you?";
    }

    if lowerMessage.includes("computer science") || lowerMessage.includes("programming") || lowerMessage.includes("algorithm") {
        return "Computer science covers so many exciting areas! From algorithms and data structures to software engineering and AI. What specific area would you like to explore or need help with?";
    }

    // Motivational responses
    if lowerMessage.includes("difficult") || lowerMessage.includes("hard") || lowerMessage.includes("struggle") {
        return "I understand studying can be challenging sometimes. Remember that every expert was once a beginner! Break complex topics into smaller parts, use active learning techniques, and don't hesitate to ask questions. You've got this! 💪";
    }

    if lowerMessage.includes("motivation") || lowerMessage.includes("tired") || lowerMessage.includes("give up") {
        return "It's normal to feel tired or unmotivated sometimes. Try taking a short break, doing some light exercise, or switching to a different subject. Remember your goals and why you started. Small consistent efforts lead to big results! 🌟";
    }

    // Default responses
    string[] defaultResponses = [
        "That's an interesting question! I can help with study materials, past papers, concept explanations, or study techniques. What would you like to focus on?",
        "I'm here to support your learning journey! Whether you need help with specific subjects, study planning, or finding resources, just let me know.",
        "Great to hear from you! I specialize in helping students with their studies. Try asking me about past papers, study notes, or explaining difficult concepts.",
        "I'm ready to help with your studies! You can ask me to find resources, explain topics, or give study tips. What subject are you working on?"
    ];

    // Use hash of message to pick a consistent response
    int responseIndex = (userMessage.length() + lowerMessage.length()) % defaultResponses.length();
    return defaultResponses[responseIndex];
}

// Function to determine chat message type for analytics
function determineChatType(string message) returns string {
    string lowerMessage = message.toLowerAscii();

    if lowerMessage.includes("past paper") || lowerMessage.includes("exam") {
        return "resource_request";
    } else if lowerMessage.includes("note") || lowerMessage.includes("study material") {
        return "notes_request";
    } else if lowerMessage.includes("explain") || lowerMessage.includes("what is") || lowerMessage.includes("how to") {
        return "explanation_request";
    } else if lowerMessage.includes("help") || lowerMessage.includes("assist") {
        return "help_request";
    } else {
        return "general_chat";
    }
}
