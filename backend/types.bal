// Data transfer objects and domain records for the Study Companion Bot

// Service health response
public type HealthResponse record {|
    string status;
    string 'service;
    string timestamp?;
|};

// Quiz domain types
public type QuizRequest record {|
    string topic = "programming";
    int count = 5;
|};

public type QuizQuestion record {|
    int id;
    string question;
    string[] options;
    int correctAnswer;
|};

public type QuizResponse record {|
    QuizQuestion[] questions;
|};

// Text processing types
public type TextRequest record {|
    string text;
|};

public type SummaryResponse record {|
    string summary;
|};

public type TextAnalysisResponse record {|
    int wordCount;
    int sentenceCount;
    int paragraphCount;
    int characterCount;
    int readingTimeMinutes;
|};

public type KeywordsResponse record {|
    string[] keywords;
|};

public type BulletPointsResponse record {|
    string[] bulletPoints;
|};

// Common error response
public type ErrorResponse record {|
    string 'error;
    string message?;
|};
