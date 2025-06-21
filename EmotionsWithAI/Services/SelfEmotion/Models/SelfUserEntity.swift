//
//  SelfUserEntity.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 19.06.2025.
//
import Foundation
import SwiftData

@Model
class SelfUserEntity {
    @Attribute(.unique) var id: UUID
    var name: String
    var messages: [Message] = []
    var analysisDates: [Date] = []
    var lastSentimentLabel: SentimentLabel
    
    init(
        id: UUID = .init(),
        name: String,
        messages: [Message] = [],
        analysisDates: [Date] = [],
        lastSentimentLabel: SentimentLabel
    ) {
        self.id = id
        self.name = name
        self.messages = messages
        self.analysisDates = analysisDates
        self.lastSentimentLabel = lastSentimentLabel
    }
}

extension SelfUserEntity {
    func convertToSelfUser() -> SelfUser {
        SelfEmotionHelper.convertSelfUserEntityToSelfUser(self) 
    }
}
