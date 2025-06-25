//
//  WhatsappAnalysisResponseModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 23.06.2025.
//

import Foundation

struct WhatsappAnalysisResponseModel: Codable {
    let participants: [String: ParticipantDataModel]

    enum CodingKeys: String, CodingKey {
        case participants
    }
}

extension WhatsappAnalysisResponseModel {
    static func loadMockResponse() -> WhatsappAnalysisResponseModel? {
        guard let url = Bundle.main.url(forResource: "Mock", withExtension: "json") else {
            print("❌ Dosya bulunamadı")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let response = try decoder.decode(ApiResponseModel<WhatsappAnalysisResponseModel>.self, from: data)
            return response.data
        } catch {
            print("❌ JSON decode hatası:", error)
            return nil
        }
    }
    
    static func mock() -> Self {
        .init(
            participants: [
                "Burak Gül" : .init(
                userInfo: .init(name: "Burak Gül"),
                analysisSummary: .init(totalMessages: 200),
                messages: []),
                "Batuhan Gül" : .init(
                userInfo: .init(name: "Batuhan Gül"),
                analysisSummary: .init(totalMessages: 200),
                messages: []),
            ]
        )
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

extension ClientMessageModel {
    func convertToPersonMessage() -> PersonMessage {
        PersonMessage(
            startTime: self.startTime,
            endTime: self.endTime,
            emotion: self.emotion.convertToEmotion(),
            messageCount: self.messageCount
        )
    }
    
    func convertToSelfUserMessage() -> SelfUserMessage {
        SelfUserMessage(
            startTime: self.startTime,
            endTime: self.endTime,
            emotion: self.emotion.convertToEmotion(),
            messageCount: self.messageCount
        )
    }
}
