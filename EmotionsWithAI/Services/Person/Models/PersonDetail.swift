//
//  PersonDetail.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 8.06.2025.
//
import Foundation

struct PersonDetail {
    let id: UUID
    let name: String
    let sentiments: [Sentiment] // TODO : Convert to Emotion
    let lastSentimentLabel: SentimentLabel?
    let firstDateForConversation: Date?
    let lastDateForConversation: Date?
    let analysisCount: Int
    let messageCount: Int
    let mostSentiment: Sentiment?
    let dateForLastMessageForAnalysis: Date?
    
    init(
        id: UUID,
        name: String,
        sentiments: [Sentiment],
        lastSentimentLabel: SentimentLabel? = nil,
        firstDateForConversation: Date? = nil,
        lastDateForConversation: Date? = nil,
        analysisCount: Int = 0,
        messageCount: Int = 0,
        mostSentiment: Sentiment? = nil,
        dateForLastMessageForAnalysis: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.sentiments = sentiments
        self.lastSentimentLabel = lastSentimentLabel
        self.firstDateForConversation = firstDateForConversation
        self.lastDateForConversation = lastDateForConversation
        self.analysisCount = analysisCount
        self.messageCount = messageCount
        self.mostSentiment = mostSentiment
        self.dateForLastMessageForAnalysis = dateForLastMessageForAnalysis
    }
    
}

extension PersonDetail {
    static func mock() -> PersonDetail {
        PersonDetail(
            id: .init(),
            name: "Mock Person Detail",
            sentiments: Sentiment.simpleSetSentiment(), // Add mock Sentiment objects if needed
            lastSentimentLabel: SentimentLabel.allCases.randomElement() ?? .neutral,
            firstDateForConversation: Date().addingTimeInterval(-Double.random(in: 0...1000000)),
            lastDateForConversation: Date.random(),
            analysisCount: Int.random(in: 1...5),
            messageCount: Int.random(in: 0...1000),
            mostSentiment: Sentiment.getRandom()
        )
    }
}
