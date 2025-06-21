//
//  EndpointModels.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 21.06.2025.
//

import Foundation

// MARK: - ApiResponseModel
struct ApiResponseModel<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let error: ErrorDetailModel?
    let timestamp: Date

    enum CodingKeys: String, CodingKey {
        case success
        case data
        case error
        case timestamp
    }
}

// MARK: - ErrorDetailModel
struct ErrorDetailModel: Codable {
    let code: String
    let message: String
    let details: String?

    enum CodingKeys: String, CodingKey {
        case code
        case message
        case details
    }
}

// MARK: - WhatsappAnalysisResponseModel
struct WhatsappAnalysisResponseModel: Codable {
    let participants: [String: ParticipantDataModel]

    enum CodingKeys: String, CodingKey {
        case participants
    }
}

// MARK: - ParticipantDataModel
struct ParticipantDataModel: Codable {
    let userInfo: UserInfoModel
    let analysisSummary: AnalysisSummaryModel
    let messages: [ClientMessageModel]

    enum CodingKeys: String, CodingKey {
        case userInfo = "user_info"
        case analysisSummary = "analysis_summary"
        case messages
    }
}

// MARK: - UserInfoModel
struct UserInfoModel: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}

// MARK: - AnalysisSummaryModel
struct AnalysisSummaryModel: Codable {
    let totalMessages: Int

    enum CodingKeys: String, CodingKey {
        case totalMessages = "total_messages"
    }
}

// MARK: - ClientMessageModel
struct ClientMessageModel: Codable {
    let sender: String
    let startTime: Date
    let endTime: Date
    let emotion: EmotionModel
    let messageCount: Int

    enum CodingKeys: String, CodingKey {
        case sender
        case startTime = "start_time"
        case endTime = "end_time"
        case emotion
        case messageCount
    }
}

// MARK: - EmotionModel
struct EmotionModel: Codable {
    let sentiments: [SentimentModel]

    enum CodingKeys: String, CodingKey {
        case sentiments
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

// MARK: - WhatsappTextRequestModel
struct WhatsappTextRequestModel: Codable {
    let text: String

    enum CodingKeys: String, CodingKey {
        case text
    }
}

// MARK: - Request Model
struct WhatsappTextRequest: Codable {
    let text: String

    enum CodingKeys: String, CodingKey {
        case text
    }
}



