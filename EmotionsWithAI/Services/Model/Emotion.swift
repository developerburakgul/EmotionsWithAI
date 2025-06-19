////
////  Emotion.swift
////  EmotionsWithAI
////
////  Created by Burak Gül on 6.06.2025.
////
//
//import Foundation
//struct EmotionResponse: Codable {
//    let success: Bool
//    let data: EmotionData
//    let timestamp: String
//}
//
//struct EmotionData: Codable {
//    let participants: [String: Participant]
//}
//struct Participant: Codable {
//    let userInfo: UserInfo
//    let analysisSummary: AnalysisSummary
//    let messages: [Message]
//
//    enum CodingKeys: String, CodingKey {
//        case userInfo = "user_info"
//        case analysisSummary = "analysis_summary"
//        case messages
//    }
//}
//
//struct Message: Codable {
//    let sender: String
//    let startTime: String
//    let endTime: String
//    let emotion: Emotion
//    let count: Int
//
//    enum CodingKeys: String, CodingKey {
//        case sender
//        case startTime = "start_time"
//        case endTime = "end_time"
//        case emotion
//        case count
//    }
//}

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
//
//
//
//
//
//struct UserInfo: Codable {
//    let name: String
//}
//
//struct AnalysisSummary: Codable {
//    let totalMessages: Int
//
//    enum CodingKeys: String, CodingKey {
//        case totalMessages = "total_messages"
//    }
//}
//
