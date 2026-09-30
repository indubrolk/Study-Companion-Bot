import ballerina/regex;
import ballerina/time;

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

    int i = 0;
    while i < length {
        int j = (shuffled[i].length() * (i + 1)) % length;
        string temp = shuffled[i];
        shuffled[i] = shuffled[j];
        shuffled[j] = temp;
        i = i + 1;
    }

    return shuffled;
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

// Helper function to get current ISO timestamp
function getCurrentTimestamp() returns string {
    return time:utcToString(time:utcNow());
}
