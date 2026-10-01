import ballerina/http;
import ballerina/log;

// HTTP client for Open Trivia DB API
final http:Client triviaClient = check new (triviaBaseUrl);

// Category mapping for Open Trivia DB
final map<int> categoryMap = {
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

// Generate quiz questions using Open Trivia DB with fallback support
function generateQuiz(string topic, int questionCount) returns QuizResponse|error {
    log:printInfo(string `Generating quiz - Topic: ${topic}, Count: ${questionCount}`);

    int categoryId = getCategoryId(topic);
    string apiUrl = string `/api.php?amount=${questionCount}&category=${categoryId}&type=multiple&encode=url3986`;

    http:Response|error response = triviaClient->get(apiUrl);
    if response is error {
        log:printError("Open Trivia DB API request failed, falling back to local questions", response);
        return createFallbackQuiz(topic, questionCount);
    }

    if response.statusCode != 200 {
        log:printError(string `Open Trivia DB returned status ${response.statusCode}, falling back to local questions`);
        return createFallbackQuiz(topic, questionCount);
    }

    json|error responsePayload = response.getJsonPayload();
    if responsePayload is error {
        log:printError("Failed to parse Open Trivia DB response payload", responsePayload);
        return createFallbackQuiz(topic, questionCount);
    }

    var responseCode = responsePayload.response_code;
    if responseCode is error || responseCode != 0 {
        log:printError("Open Trivia DB returned non-zero response code, using fallback");
        return createFallbackQuiz(topic, questionCount);
    }

    QuizResponse|error parsedQuestions = parseTriviaQuestions(responsePayload);
    if parsedQuestions is error {
        log:printError("Failed to parse trivia questions, using fallback", parsedQuestions);
        return createFallbackQuiz(topic, questionCount);
    }

    return parsedQuestions;
}

// Get category ID for Open Trivia DB
function getCategoryId(string topic) returns int {
    string lowerTopic = topic.toLowerAscii();
    if categoryMap.hasKey(lowerTopic) {
        return categoryMap.get(lowerTopic);
    }
    // Default to General Knowledge (9)
    return 9;
}

// Parse Open Trivia DB response and convert to QuizResponse
function parseTriviaQuestions(json apiData) returns QuizResponse|error {
    json results = check apiData.results;
    if !(results is json[]) {
        return error("Invalid results format from Open Trivia DB");
    }

    json[] triviaQuestions = <json[]>results;
    QuizQuestion[] formattedQuestions = [];

    int questionId = 1;
    foreach json question in triviaQuestions {
        string decodedQuestion = decodeUrl(check question.question);
        string correctAnswer = decodeUrl(check question.correct_answer);
        json incorrectAnswers = check question.incorrect_answers;

        string[] options = [];
        if incorrectAnswers is json[] {
            foreach json incorrect in incorrectAnswers {
                options.push(decodeUrl(<string>incorrect));
            }
        }
        options.push(correctAnswer);

        string[] shuffledOptions = shuffleArray(options);

        int correctIndex = 0;
        int i = 0;
        foreach string option in shuffledOptions {
            if option == correctAnswer {
                correctIndex = i;
                break;
            }
            i = i + 1;
        }

        QuizQuestion formattedQuestion = {
            id: questionId,
            question: decodedQuestion,
            options: shuffledOptions,
            correctAnswer: correctIndex
        };

        formattedQuestions.push(formattedQuestion);
        questionId = questionId + 1;
    }

    return {questions: formattedQuestions};
}

// Create fallback quiz if API generation fails
function createFallbackQuiz(string topic, int questionCount) returns QuizResponse {
    QuizQuestion[] fallbackQuestions = [
        {
            id: 1,
            question: "What is the main purpose of version control systems?",
            options: [
                "Track changes in code over time",
                "Compile source code",
                "Debug applications",
                "Design user interfaces"
            ],
            correctAnswer: 0
        },
        {
            id: 2,
            question: "Which HTTP method is typically used to retrieve data?",
            options: ["POST", "GET", "PUT", "DELETE"],
            correctAnswer: 1
        },
        {
            id: 3,
            question: "What does API stand for?",
            options: [
                "Application Programming Interface",
                "Advanced Program Integration",
                "Automated Process Instruction",
                "Application Process Interface"
            ],
            correctAnswer: 0
        },
        {
            id: 4,
            question: "In programming, what is a variable?",
            options: [
                "A fixed value that never changes",
                "A container for storing data values",
                "A type of loop structure",
                "A debugging tool"
            ],
            correctAnswer: 1
        },
        {
            id: 5,
            question: "What is the World Wide Web?",
            options: [
                "A type of spider web",
                "A global information system",
                "A programming language",
                "A computer virus"
            ],
            correctAnswer: 1
        },
        {
            id: 6,
            question: "Which planet is known as the Red Planet?",
            options: ["Venus", "Jupiter", "Mars", "Saturn"],
            correctAnswer: 2
        },
        {
            id: 7,
            question: "What is the largest ocean on Earth?",
            options: ["Atlantic", "Pacific", "Indian", "Arctic"],
            correctAnswer: 1
        },
        {
            id: 8,
            question: "Who wrote 'Romeo and Juliet'?",
            options: ["Charles Dickens", "William Shakespeare", "Mark Twain", "Jane Austen"],
            correctAnswer: 1
        },
        {
            id: 9,
            question: "What is the chemical symbol for gold?",
            options: ["Go", "Gd", "Au", "Ag"],
            correctAnswer: 2
        },
        {
            id: 10,
            question: "Which year did World War II end?",
            options: ["1944", "1945", "1946", "1947"],
            correctAnswer: 1
        }
    ];

    QuizQuestion[] selectedQuestions = [];
    int questionsToTake = questionCount > fallbackQuestions.length() ? fallbackQuestions.length() : questionCount;

    int i = 0;
    while i < questionsToTake {
        selectedQuestions.push(fallbackQuestions[i]);
        i = i + 1;
    }

    return {questions: selectedQuestions};
}

// Backward-compatible alias
function generateQuizWithPerplexity(string topic, int questionCount) returns json|error {
    QuizResponse|error res = generateQuiz(topic, questionCount);
    if res is error {
        return res;
    }
    return res.toJson();
}
