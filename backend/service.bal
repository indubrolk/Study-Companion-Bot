import ballerina/http;
import ballerina/log;

// Listener initialization
listener http:Listener studyListener = new (port);

// CORS and Service configuration
@http:ServiceConfig {
    cors: {
        allowOrigins: allowedOrigins,
        allowCredentials: false,
        allowHeaders: ["CORELATION_ID", "Content-Type", "Authorization"],
        allowMethods: ["GET", "POST", "OPTIONS"]
    }
}
service /study on studyListener {

    // Health check endpoint
    resource function get health() returns HealthResponse {
        return {
            status: "healthy",
            'service: "study-companion-bot",
            timestamp: getCurrentTimestamp()
        };
    }

    // Generate quiz via GET query parameters
    resource function get quiz(string? topic, int? count) returns QuizResponse|http:BadRequest|http:InternalServerError {
        string quizTopic = topic ?: "programming";
        int questionCount = count ?: 5;

        if questionCount < 1 || questionCount > 20 {
            return <http:BadRequest>{
                body: {'error: "Invalid question count", message: "Question count must be between 1 and 20"}
            };
        }

        QuizResponse|error quizResult = generateQuiz(quizTopic, questionCount);
        if quizResult is error {
            log:printError("Failed to generate quiz", quizResult);
            return <http:InternalServerError>{
                body: {'error: "Quiz generation failed", message: "Unable to generate quiz questions at this time"}
            };
        }

        return quizResult;
    }

    // Generate quiz via POST JSON payload
    resource function post quiz(@http:Payload QuizRequest payload) returns QuizResponse|http:BadRequest|http:InternalServerError {
        string topic = payload.topic;
        int count = payload.count;

        if count < 1 || count > 20 {
            return <http:BadRequest>{
                body: {'error: "Invalid question count", message: "Question count must be between 1 and 20"}
            };
        }

        QuizResponse|error quizResult = generateQuiz(topic, count);
        if quizResult is error {
            log:printError("Failed to generate quiz", quizResult);
            return <http:InternalServerError>{
                body: {'error: "Quiz generation failed", message: "Unable to generate quiz questions at this time"}
            };
        }

        return quizResult;
    }

    // Text summarization endpoint (supports both JSON { text: "..." } and raw text)
    resource function post summarize(http:Request req) returns SummaryResponse|http:BadRequest {
        string|http:BadRequest textOrError = extractInputText(req);
        if textOrError is http:BadRequest {
            return textOrError;
        }

        return summarizeText(textOrError);
    }

    // Text analysis endpoint
    resource function post analyze(http:Request req) returns TextAnalysisResponse|http:BadRequest {
        string|http:BadRequest textOrError = extractInputText(req);
        if textOrError is http:BadRequest {
            return textOrError;
        }

        return analyzeText(textOrError);
    }

    // Keyword extraction endpoint
    resource function post keywords(http:Request req) returns KeywordsResponse|http:BadRequest {
        string|http:BadRequest textOrError = extractInputText(req);
        if textOrError is http:BadRequest {
            return textOrError;
        }

        return extractKeywords(textOrError);
    }

    // Bullet points conversion endpoint (kebab-case)
    resource function post 'bullet\-points(http:Request req) returns BulletPointsResponse|http:BadRequest {
        string|http:BadRequest textOrError = extractInputText(req);
        if textOrError is http:BadRequest {
            return textOrError;
        }

        return convertToBulletPoints(textOrError);
    }

    // Bullet points conversion endpoint (camelCase alias)
    resource function post bulletPoints(http:Request req) returns BulletPointsResponse|http:BadRequest {
        string|http:BadRequest textOrError = extractInputText(req);
        if textOrError is http:BadRequest {
            return textOrError;
        }

        return convertToBulletPoints(textOrError);
    }
}

// Helper to extract text from either JSON { "text": "..." } or plain text payload
function extractInputText(http:Request req) returns string|http:BadRequest {
    string contentType = req.getContentType();
    if contentType.includes("application/json") {
        json|error jsonPayload = req.getJsonPayload();
        if jsonPayload is error {
            return <http:BadRequest>{
                body: {'error: "Invalid request payload", message: "Expected JSON with a text field"}
            };
        }
        if jsonPayload is map<json> && jsonPayload.hasKey("text") {
            json textVal = jsonPayload.get("text");
            if textVal is string {
                string trimmed = textVal.trim();
                if trimmed.length() == 0 {
                    return <http:BadRequest>{
                        body: {'error: "Text cannot be empty", message: "Please provide non-empty text"}
                    };
                }
                return trimmed;
            }
        }
        return <http:BadRequest>{
            body: {'error: "Invalid payload format", message: "JSON payload must contain a 'text' string field"}
        };
    }

    string|error textPayload = req.getTextPayload();
    if textPayload is error {
        return <http:BadRequest>{
            body: {'error: "Invalid text payload", message: textPayload.message()}
        };
    }

    string text = textPayload.trim();
    if text.length() == 0 {
        return <http:BadRequest>{
            body: {'error: "Empty text provided", message: "Text cannot be empty"}
        };
    }

    return text;
}
