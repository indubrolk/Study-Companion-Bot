import ballerina/http;

listener http:Listener summarizerListener = new (9090);

service /study on summarizerListener {
    
    // POST /study/summarize - Original summarization endpoint
    resource function post summarize(http:Request req) returns http:Response|error {
        http:Response res = new;
        
        // Set CORS headers
        res.setHeader("Access-Control-Allow-Origin", "http://localhost:3000");
        res.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        res.setHeader("Access-Control-Allow-Headers", "Content-Type");
        
        // Handle OPTIONS preflight
        string method = req.method;
        if method == "OPTIONS" {
            return res;
        }
        
        // Read plain text payload
        var body = req.getTextPayload();
        if body is error {
            res.setJsonPayload({"error": "Invalid text input"});
            res.statusCode = 400;
            return res;
        }
        
        string text = body.trim();
        if text == "" {
            res.setJsonPayload({"error": "Text cannot be empty"});
            res.statusCode = 400;
            return res;
        }
        
        // Simple word splitting by spaces
        string[] words = [];
        string currentWord = "";
        
        // Manual split by iterating through characters
        foreach int i in 0 ..< text.length() {
            string char = text.substring(i, i + 1);
            if char == " " || char == "\t" || char == "\n" || char == "\r" {
                if currentWord.trim() != "" {
                    words.push(currentWord.trim());
                    currentWord = "";
                }
            } else {
                currentWord += char;
            }
        }
        
        // Don't forget the last word
        if currentWord.trim() != "" {
            words.push(currentWord.trim());
        }
        
        // Create summary (first 20 words)
        string summary = "";
        int count = 0;
        foreach string w in words {
            summary += w + " ";
            count += 1;
            if count == 20 {
                summary += "...";
                break;
            }
        }
        
        // If we have 20 or fewer words, don't add ellipsis
        if count <= 20 {
            summary = text;
        }
        
        // Return JSON
        res.setJsonPayload({"summary": summary.trim()});
        return res;
    }

    // POST /study/analyze - Text analysis endpoint
    resource function post analyze(http:Request req) returns http:Response|error {
        http:Response res = new;
        
        // Set CORS headers
        res.setHeader("Access-Control-Allow-Origin", "http://localhost:3000");
        res.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        res.setHeader("Access-Control-Allow-Headers", "Content-Type");
        
        if req.method == "OPTIONS" {
            return res;
        }
        
        var body = req.getTextPayload();
        if body is error {
            res.setJsonPayload({"error": "Invalid text input"});
            res.statusCode = 400;
            return res;
        }
        
        string text = body.trim();
        if text == "" {
            res.setJsonPayload({"error": "Text cannot be empty"});
            res.statusCode = 400;
            return res;
        }
        
        // Analyze the text
        string[] words = getWords(text);
        string[] sentences = getSentences(text);
        string[] paragraphs = getParagraphs(text);
        
        // Calculate reading time (average 200 words per minute)
        int readingTimeMinutes = words.length() / 200;
        if readingTimeMinutes == 0 {
            readingTimeMinutes = 1;
        }
        
        res.setJsonPayload({
            "wordCount": words.length(),
            "sentenceCount": sentences.length(),
            "paragraphCount": paragraphs.length(),
            "characterCount": text.length(),
            "readingTimeMinutes": readingTimeMinutes
        });
        return res;
    }

    // POST /study/keywords - Extract key terms
    resource function post keywords(http:Request req) returns http:Response|error {
        http:Response res = new;
        
        // Set CORS headers
        res.setHeader("Access-Control-Allow-Origin", "http://localhost:3000");
        res.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        res.setHeader("Access-Control-Allow-Headers", "Content-Type");
        
        if req.method == "OPTIONS" {
            return res;
        }
        
        var body = req.getTextPayload();
        if body is error {
            res.setJsonPayload({"error": "Invalid text input"});
            res.statusCode = 400;
            return res;
        }
        
        string text = body.trim();
        if text == "" {
            res.setJsonPayload({"error": "Text cannot be empty"});
            res.statusCode = 400;
            return res;
        }
        
        // Extract keywords (words longer than 4 characters, excluding common words)
        string[] commonWords = ["this", "that", "with", "have", "will", "from", "they", "know", "want", "been", "good", "much", "some", "time", "very", "when", "come", "here", "just", "like", "long", "make", "many", "over", "such", "take", "than", "them", "well", "were"];
        string[] words = getWords(text);
        string[] keywords = [];
        
        foreach string word in words {
            string lowerWord = word.toLowerAscii();
            if word.length() > 4 && !isCommonWord(lowerWord, commonWords) && !containsWord(keywords, lowerWord) {
                keywords.push(word);
            }
        }
        
        res.setJsonPayload({"keywords": keywords});
        return res;
    }

    // POST /study/bullet-points - Convert to bullet points
    resource function post bulletPoints(http:Request req) returns http:Response|error {
        http:Response res = new;
        
        // Set CORS headers
        res.setHeader("Access-Control-Allow-Origin", "http://localhost:3000");
        res.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        res.setHeader("Access-Control-Allow-Headers", "Content-Type");
        
        if req.method == "OPTIONS" {
            return res;
        }
        
        var body = req.getTextPayload();
        if body is error {
            res.setJsonPayload({"error": "Invalid text input"});
            res.statusCode = 400;
            return res;
        }
        
        string text = body.trim();
        if text == "" {
            res.setJsonPayload({"error": "Text cannot be empty"});
            res.statusCode = 400;
            return res;
        }
        
        string[] sentences = getSentences(text);
        string[] bulletPoints = [];
        
        foreach string sentence in sentences {
            if sentence.trim() != "" {
                bulletPoints.push("• " + sentence.trim());
            }
        }
        
        res.setJsonPayload({"bulletPoints": bulletPoints});
        return res;
    }

    // GET /study/health - Health check endpoint
    resource function get health() returns json {
        return {"status": "healthy", "service": "study-summarizer", "timestamp": getCurrentTime()};
    }
}

// Helper function to split text into words
function getWords(string text) returns string[] {
    string[] words = [];
    string currentWord = "";
    
    foreach int i in 0 ..< text.length() {
        string char = text.substring(i, i + 1);
        if char == " " || char == "\t" || char == "\n" || char == "\r" || char == "," || char == "." || char == "!" || char == "?" || char == ";" || char == ":" {
            if currentWord.trim() != "" {
                words.push(currentWord.trim());
                currentWord = "";
            }
        } else {
            currentWord += char;
        }
    }
    
    if currentWord.trim() != "" {
        words.push(currentWord.trim());
    }
    
    return words;
}

// Helper function to split text into sentences
function getSentences(string text) returns string[] {
    string[] sentences = [];
    string currentSentence = "";
    
    foreach int i in 0 ..< text.length() {
        string char = text.substring(i, i + 1);
        currentSentence += char;
        
        if char == "." || char == "!" || char == "?" {
            if currentSentence.trim() != "" {
                sentences.push(currentSentence.trim());
                currentSentence = "";
            }
        }
    }
    
    if currentSentence.trim() != "" {
        sentences.push(currentSentence.trim());
    }
    
    return sentences;
}

// Helper function to split text into paragraphs
function getParagraphs(string text) returns string[] {
    string[] paragraphs = [];
    string currentParagraph = "";
    
    foreach int i in 0 ..< text.length() {
        string char = text.substring(i, i + 1);
        
        if char == "\n" {
            if i + 1 < text.length() && text.substring(i + 1, i + 2) == "\n" {
                // Double newline - end of paragraph
                if currentParagraph.trim() != "" {
                    paragraphs.push(currentParagraph.trim());
                    currentParagraph = "";
                }
            } else {
                currentParagraph += " ";
            }
        } else {
            currentParagraph += char;
        }
    }
    
    if currentParagraph.trim() != "" {
        paragraphs.push(currentParagraph.trim());
    }
    
    return paragraphs;
}

// Helper function to check if word is common
function isCommonWord(string word, string[] commonWords) returns boolean {
    foreach string commonWord in commonWords {
        if word == commonWord {
            return true;
        }
    }
    return false;
}

// Helper function to check if array contains word
function containsWord(string[] words, string word) returns boolean {
    foreach string w in words {
        if w.toLowerAscii() == word {
            return true;
        }
    }
    return false;
}

// Helper function to get current timestamp (simple implementation)
function getCurrentTime() returns string {
    return "2025-08-15T00:00:00Z"; // Placeholder - would use actual time in real implementation
}