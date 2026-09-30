// Text summarization, analysis, keyword extraction, and bullet point generation logic

// Summarize text: returns first 20 words or full text if <= 20 words
function summarizeText(string text) returns SummaryResponse {
    string[] words = getWords(text);

    if words.length() <= 20 {
        return {summary: text};
    }

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

    return {summary: summary.trim()};
}

// Analyze text statistics: word count, sentence count, reading time, character count
function analyzeText(string text) returns TextAnalysisResponse {
    string[] words = getWords(text);
    string[] sentences = getSentences(text);
    string[] paragraphs = getParagraphs(text);

    // Calculate reading time (average 200 words per minute)
    int readingTimeMinutes = words.length() / 200;
    if readingTimeMinutes == 0 {
        readingTimeMinutes = 1;
    }

    return {
        wordCount: words.length(),
        sentenceCount: sentences.length(),
        paragraphCount: paragraphs.length(),
        characterCount: text.length(),
        readingTimeMinutes: readingTimeMinutes
    };
}

// Extract keywords: words longer than 4 chars, excluding common words and duplicates
function extractKeywords(string text) returns KeywordsResponse {
    string[] commonWords = [
        "this", "that", "with", "have", "will", "from", "they", "know", "want", "been",
        "good", "much", "some", "time", "very", "when", "come", "here", "just", "like",
        "long", "make", "many", "over", "such", "take", "than", "them", "well", "were"
    ];

    string[] words = getWords(text);
    string[] keywords = [];

    foreach string word in words {
        string lowerWord = word.toLowerAscii();
        if word.length() > 4 && !isCommonWord(lowerWord, commonWords) && !containsWord(keywords, lowerWord) {
            keywords.push(word);
        }
    }

    return {keywords: keywords};
}

// Convert text sentences to bullet points
function convertToBulletPoints(string text) returns BulletPointsResponse {
    string[] sentences = getSentences(text);
    string[] bulletPoints = [];

    foreach string sentence in sentences {
        if sentence.trim() != "" {
            bulletPoints.push("• " + sentence.trim());
        }
    }

    return {bulletPoints: bulletPoints};
}

// Backward-compatible alias
function summarizeTextWithPerplexity(string text) returns json|error {
    return summarizeText(text).toJson();
}