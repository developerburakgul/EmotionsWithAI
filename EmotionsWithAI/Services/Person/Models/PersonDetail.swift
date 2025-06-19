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
    let lastSentimentLabel: SentimentLabel
    let firstDateForConversation: Date
    let analysisCount: Int
    let messageCount: Int
    let mostSentiment: Sentiment
    
    init(
        id: UUID = UUID(),
        name: String,
        sentiments: [Sentiment],
        lastSentimentLabel: SentimentLabel,
        firstDateForConversation: Date,
        analysisCount: Int,
        messageCount: Int,
        mostSentiment: Sentiment
    ) {
        self.id = id
        self.name = name
        self.sentiments = sentiments
        self.lastSentimentLabel = lastSentimentLabel
        self.firstDateForConversation = firstDateForConversation
        self.analysisCount = analysisCount
        self.messageCount = messageCount
        self.mostSentiment = mostSentiment
    }
    
}

extension PersonDetail {
    static func mock() -> PersonDetail {
        PersonDetail(
            name: "Mock Person Detail",
            sentiments: Sentiment.simpleSetSentiment(), // Add mock Sentiment objects if needed
            lastSentimentLabel: SentimentLabel.allCases.randomElement() ?? .neutral,
            firstDateForConversation: Date().addingTimeInterval(-Double.random(in: 0...1000000)),
            analysisCount: Int.random(in: 1...5),
            messageCount: Int.random(in: 0...1000),
            mostSentiment: Sentiment.getRandom()
        )
    }
}
