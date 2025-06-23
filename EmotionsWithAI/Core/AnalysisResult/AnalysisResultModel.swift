//
//  AnalysisResultModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 22.06.2025.
//

import Foundation
struct AnalysisResultModel {
    var name: String
    var firstConversationDate: Date
    var messageCount: Int
    var mostSentimentLabel: SentimentLabel
    var lastSentimentLabel: SentimentLabel
    var sentiments: [Sentiment]

}
