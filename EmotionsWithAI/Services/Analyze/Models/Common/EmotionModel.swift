//
//  EmotionModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 23.06.2025.
//

import Foundation
// MARK: - EmotionModel
struct EmotionModel: Codable {
    let sentiments: [SentimentModel]

    enum CodingKeys: String, CodingKey {
        case sentiments
    }
}

extension EmotionModel {
    func convertToEmotion() -> Emotion {
        let sentiments = self.sentiments.map { $0.convertToSentiment() }
        let Emotion = Emotion(sentiments: sentiments)
        return Emotion
    }
}

// MARK: - SentimentModel
struct SentimentModel: Codable {
    let label: String
    let score: Double

    enum CodingKeys: String, CodingKey {
        case label
        case score
    }
}

extension SentimentModel {
    func convertToSentiment() -> Sentiment {
        let label = SentimentLabel(rawValue: label) ?? SentimentLabel.anger
        return Sentiment(label: label, score: score)
    }
}
