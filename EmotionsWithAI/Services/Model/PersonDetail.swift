//
//  PersonDetail.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 8.06.2025.
//
import Foundation

struct PersonDetail {
    let name: String
    let sentiments: [Sentiment]
    let lastSentimentLabel: SentimentLabel
    let firstDateForConversation: Date
    let conversationDateCount: Int
    let analysisCount: Int
    let messageCount: Int
    let mostSentiment: Sentiment
    
}

extension PersonDetail {
    static func mock() -> PersonDetail {
        PersonDetail(
            name: "Mock Person Detail",
            sentiments: Sentiment.simpleSetSentiment(), // Add mock Sentiment objects if needed
            lastSentimentLabel: SentimentLabel.allCases.randomElement() ?? .neutral,
            firstDateForConversation: Date().addingTimeInterval(-Double.random(in: 0...1000000)),
            conversationDateCount: Int.random(in: 1...10),
            analysisCount: Int.random(in: 1...5),
            messageCount: Int.random(in: 0...1000),
            mostSentiment: Sentiment.getRandom()
        )
    }
}
