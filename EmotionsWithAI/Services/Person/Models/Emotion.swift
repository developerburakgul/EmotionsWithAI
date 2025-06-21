//
//  Emotion.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 20.06.2025.
//

import Foundation

struct Emotion: Codable {
    let sentiments: [Sentiment]
}
extension Emotion {
    func getMainSentiment() -> Sentiment {
         
        var highScoreSentiment = sentiments[0]
        for sentiment in sentiments {
            if sentiment.score > highScoreSentiment.score {
                highScoreSentiment = sentiment
            }
        }
        return highScoreSentiment
    }
}
