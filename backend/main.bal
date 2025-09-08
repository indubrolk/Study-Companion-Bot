import ballerina/http;
import ballerina/log;

// CORS configuration
@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:5173", "http://localhost:3000"],
        allowCredentials: false,
        allowHeaders: ["CORELATION_ID", "Content-Type", "Authorization"],
        allowMethods: ["GET", "POST", "OPTIONS"]
    }
}
service /study on new http:Listener(9090) {

    // Health check endpoint
    resource function get health() returns json {
        return {"status": "healthy", "service": "study-companion-bot"};
    }

    // Generate quiz endpoint
    resource function get quiz(string? topic, int? count) returns json|error {
        log:printInfo("Quiz generation requested");

        // Default values
        string quizTopic = topic ?: "programming";
        int questionCount = count ?: 5;

        // Validate question count
        if (questionCount < 1 || questionCount > 20) {
            return error("Question count must be between 1 and 20");
        }

        // Generate quiz using Open Trivia DB
        json|error quizResult = generateQuizWithPerplexity(quizTopic, questionCount);

        if (quizResult is error) {
            log:printError("Failed to generate quiz", quizResult);
            return error("Failed to generate quiz questions");
        }

        return quizResult;
    }

    // Generate quiz with specific parameters
    resource function post quiz(http:Caller caller, http:Request req) returns error? {
        json|error payload = req.getJsonPayload();

        if (payload is error) {
            json errorResponse = {
                "error": "Invalid request payload",
                "message": "Expected JSON with topic and count fields"
            };
            check caller->respond(errorResponse);
            return;
        }

        json requestData = <json>payload;
        string topic = requestData.topic is string ? <string>requestData.topic : "programming";
        int count = requestData.count is int ? <int>requestData.count : 5;

        // Validate inputs
        if (count < 1 || count > 20) {
            json errorResponse = {
                "error": "Invalid question count",
                "message": "Question count must be between 1 and 20"
            };
            check caller->respond(errorResponse);
            return;
        }

        // Generate quiz using Open Trivia DB
        json|error quizResult = generateQuizWithPerplexity(topic, count);

        if (quizResult is error) {
            log:printError("Failed to generate quiz", quizResult);
            json errorResponse = {
                "error": "Quiz generation failed",
                "message": "Unable to generate quiz questions at this time"
            };
            check caller->respond(errorResponse);
            return;
        }

        check caller->respond(quizResult);
    }

    // Text summarization endpoint (bonus feature)
    resource function post summarize(http:Caller caller, http:Request req) returns error? {
        string|error textPayload = req.getTextPayload();

        if (textPayload is error) {
            json errorResponse = {"error": "Invalid text payload"};
            check caller->respond(errorResponse);
            return;
        }

        string text = <string>textPayload;

        if (text.length() == 0) {
            json errorResponse = {"error": "Empty text provided"};
            check caller->respond(errorResponse);
            return;
        }

        // Simple text summarization (no AI needed)
        json|error summaryResult = summarizeTextWithPerplexity(text);

        if (summaryResult is error) {
            log:printError("Failed to summarize text", summaryResult);
            json errorResponse = {"error": "Text summarization failed"};
            check caller->respond(errorResponse);
            return;
        }

        check caller->respond(summaryResult);
    }
}