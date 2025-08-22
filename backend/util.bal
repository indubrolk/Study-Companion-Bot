import ballerina/http;
import ballerina/log;
import ballerina/regex;

// Open Trivia DB API configuration
const string TRIVIA_API_URL = "https://opentdb.com/api.php";

// HTTP client for Open Trivia DB API
http:Client triviaClient = check new("https://opentdb.com");

// Category mapping for Open Trivia DB
map<int> categoryMap = {
    "general": 9,
    "books": 10,
    "film": 11,
    "music": 12,
    "television": 14,
    "science": 17,
    "mathematics": 19,
    "sports": 21,
    "geography": 22,
    "history": 23,
    "politics": 24,
    "animals": 27,
    "vehicles": 28,
    "programming": 18, // Computer Science
    "computers": 18,
    "technology": 18
};

// Generate quiz questions using Open Trivia DB
function generateQuizWithPerplexity(string topic, int questionCount) returns json|error {
    log:printInfo("Generating quiz from Open Trivia DB - Topic: " + topic + ", Count: " + questionCount.toString());

    // Get category ID from topic
    int categoryId = getCategoryId(topic);

    // Build API URL
    string apiUrl = string `/api.php?amount=${questionCount}&category=${categoryId}&type=multiple&encode=url3986`;

    // Make request to Open Trivia DB
    http:Response|error response = triviaClient->get(apiUrl);

    if (response is error) {
        log:printError("Open Trivia DB API request failed", response);
        return createFallbackQuiz(topic, questionCount);
    }

    http:Response apiResponse = <http:Response>response;

    if (apiResponse.statusCode != 200) {
        log:printError("Open Trivia DB API returned error status: " + apiResponse.statusCode.toString());
        return createFallbackQuiz(topic, questionCount);
    }

    json|error responsePayload = apiResponse.getJsonPayload();

    if (responsePayload is error) {
        log:printError("Failed to parse Open Trivia DB response", responsePayload);
        return createFallbackQuiz(topic, questionCount);
    }

    json apiData = <json>responsePayload;

    // Check if API returned successful response
    int responseCode = check apiData.response_code;
    if (responseCode != 0) {
        log:printError("Open Trivia DB returned error code: " + responseCode.toString());
        return createFallbackQuiz(topic, questionCount);
    }

    // Parse the questions
    json|error parsedQuestions = parseTrivaQuestions(apiData);

    if (parsedQuestions is error) {
        log:printError("Failed to parse trivia questions", parsedQuestions);
        return createFallbackQuiz(topic, questionCount);
    }

    return parsedQuestions;
}

// Get category ID for Open Trivia DB
function getCategoryId(string topic) returns int {
    string lowerTopic = topic.toLowerAscii();

    if (categoryMap.hasKey(lowerTopic)) {
        return categoryMap.get(lowerTopic);
    }

    // Default to General Knowledge if topic not found
    return 9;
}

// Parse Open Trivia DB response and convert to our format
function parseTrivaQuestions(json apiData) returns json|error {
    json results = check apiData.results;

    if (!(results is json[])) {
        return error("Invalid results format from Open Trivia DB");
    }

    json[] triviaQuestions = <json[]>results;
    json[] formattedQuestions = [];

    int questionId = 1;
    foreach json question in triviaQuestions {
        // Decode URL-encoded strings
        string decodedQuestion = decodeUrl(check question.question);
        string correctAnswer = decodeUrl(check question.correct_answer);
        json incorrectAnswers = check question.incorrect_answers;

        // Create options array with correct answer mixed in
        string[] options = [];

        if (incorrectAnswers is json[]) {
            json[] incorrectArray = <json[]>incorrectAnswers;

            // Add incorrect answers
            foreach json incorrect in incorrectArray {
                options.push(decodeUrl(<string>incorrect));
            }
        }

        // Add correct answer
        options.push(correctAnswer);

        // Shuffle options to randomize correct answer position
        string[] shuffledOptions = shuffleArray(options);

        // Find the new position of correct answer
        int correctIndex = 0;
        int i = 0;
        foreach string option in shuffledOptions {
            if (option == correctAnswer) {
                correctIndex = i;
                break;
            }
            i = i + 1;
        }

        // Create formatted question
        json formattedQuestion = {
            "id": questionId,
            "question": decodedQuestion,
            "options": shuffledOptions,
            "correctAnswer": correctIndex
        };

        formattedQuestions.push(formattedQuestion);
        questionId = questionId + 1;
    }

    return {"questions": formattedQuestions};
}

// Simple URL decoder for basic HTML entities and URL encoding
function decodeUrl(string encoded) returns string {
    string decoded = encoded;

    // Decode common HTML entities
    decoded = regex:replaceAll(decoded, "&quot;", "\"");
    decoded = regex:replaceAll(decoded, "&#039;", "'");
    decoded = regex:replaceAll(decoded, "&amp;", "&");
    decoded = regex:replaceAll(decoded, "&lt;", "<");
    decoded = regex:replaceAll(decoded, "&gt;", ">");

    // Decode URL encoding
    decoded = regex:replaceAll(decoded, "%20", " ");
    decoded = regex:replaceAll(decoded, "%21", "!");
    decoded = regex:replaceAll(decoded, "%22", "\"");
    decoded = regex:replaceAll(decoded, "%27", "'");
    decoded = regex:replaceAll(decoded, "%28", "(");
    decoded = regex:replaceAll(decoded, "%29", ")");
    decoded = regex:replaceAll(decoded, "%2C", ",");
    decoded = regex:replaceAll(decoded, "%3A", ":");
    decoded = regex:replaceAll(decoded, "%3B", ";");
    decoded = regex:replaceAll(decoded, "%3F", "?");

    return decoded;
}

// Simple array shuffling function
function shuffleArray(string[] array) returns string[] {
    string[] shuffled = array.clone();
    int length = shuffled.length();

    // Simple shuffle algorithm
    int i = 0;
    while (i < length) {
        // Use a simple pseudo-random approach based on string hash
        int j = (array[i].toString().length() * (i + 1)) % length;
        string temp = shuffled[i];
        shuffled[i] = shuffled[j];
        shuffled[j] = temp;
        i = i + 1;
    }

    return shuffled;
}

// Create fallback quiz if API generation fails
function createFallbackQuiz(string topic, int questionCount) returns json {
    json[] fallbackQuestions = [
        {
            "id": 1,
            "question": "What is the main purpose of version control systems?",
            "options": [
                "Track changes in code over time",
                "Compile source code",
                "Debug applications",
                "Design user interfaces"
            ],
            "correctAnswer": 0
        },
        {
            "id": 2,
            "question": "Which HTTP method is typically used to retrieve data?",
            "options": ["POST", "GET", "PUT", "DELETE"],
            "correctAnswer": 1
        },
        {
            "id": 3,
            "question": "What does API stand for?",
            "options": [
                "Application Programming Interface",
                "Advanced Program Integration",
                "Automated Process Instruction",
                "Application Process Interface"
            ],
            "correctAnswer": 0
        },
        {
            "id": 4,
            "question": "In programming, what is a variable?",
            "options": [
                "A fixed value that never changes",
                "A container for storing data values",
                "A type of loop structure",
                "A debugging tool"
            ],
            "correctAnswer": 1
        },
        {
            "id": 5,
            "question": "What is the World Wide Web?",
            "options": [
                "A type of spider web",
                "A global information system",
                "A programming language",
                "A computer virus"
            ],
            "correctAnswer": 1
        },
        {
            "id": 6,
            "question": "Which planet is known as the Red Planet?",
            "options": ["Venus", "Jupiter", "Mars", "Saturn"],
            "correctAnswer": 2
        },
        {
            "id": 7,
            "question": "What is the largest ocean on Earth?",
            "options": ["Atlantic", "Pacific", "Indian", "Arctic"],
            "correctAnswer": 1
        },
        {
            "id": 8,
            "question": "Who wrote 'Romeo and Juliet'?",
            "options": ["Charles Dickens", "William Shakespeare", "Mark Twain", "Jane Austen"],
            "correctAnswer": 1
        },
        {
            "id": 9,
            "question": "What is the chemical symbol for gold?",
            "options": ["Go", "Gd", "Au", "Ag"],
            "correctAnswer": 2
        },
        {
            "id": 10,
            "question": "Which year did World War II end?",
            "options": ["1944", "1945", "1946", "1947"],
            "correctAnswer": 1
        }
    ];

    // Take only the requested number of questions
    json[] selectedQuestions = [];
    int questionsToTake = questionCount > fallbackQuestions.length() ? fallbackQuestions.length() : questionCount;

    int i = 0;
    while (i < questionsToTake) {
        selectedQuestions.push(fallbackQuestions[i]);
        i = i + 1;
    }

    return {"questions": selectedQuestions};
}

// Simple text summarization (fallback without AI)
function summarizeTextWithPerplexity(string text) returns json|error {
    // Since we're not using AI anymore, provide a simple summarization
    string[] sentences = regex:split(text, "\\.");

    if (sentences.length() <= 3) {
        return {"summary": text};
    }

    // Take first 2-3 sentences as summary
    string summary = "";
    int sentenceCount = sentences.length() > 3 ? 3 : sentences.length();

    int i = 0;
    while (i < sentenceCount) {
        if (sentences[i].trim().length() > 0) {
            summary = summary + sentences[i].trim() + ". ";
        }
        i = i + 1;
    }

    return {"summary": summary.trim()};
}