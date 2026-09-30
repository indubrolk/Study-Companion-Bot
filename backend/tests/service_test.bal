import ballerina/http;
import ballerina/test;

final http:Client testClient = check new ("http://localhost:9090/study");

@test:Config {}
function testHealth() returns error? {
    json response = check testClient->get("/health");
    test:assertEquals(check response.status, "healthy");
    test:assertEquals(check response.'service, "study-companion-bot");
}

@test:Config {}
function testSummarizeLogic() {
    string sampleText = "Ballerina is an open source programming language for the cloud that makes it easier to use combine and create network services";
    SummaryResponse summary = summarizeText(sampleText);
    test:assertTrue(summary.summary.length() > 0);
}

@test:Config {}
function testAnalyzeLogic() {
    string sampleText = "Ballerina is a programming language. It simplifies cloud integration.";
    TextAnalysisResponse analysis = analyzeText(sampleText);
    test:assertTrue(analysis.wordCount > 0);
    test:assertEquals(analysis.sentenceCount, 2);
}
