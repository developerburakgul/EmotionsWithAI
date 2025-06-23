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
    @Attribute(.unique)
    var id: UUID
    var name: String
    var messages: [SelfUserMessage]
    var analysisDates: [Date]
    var lastSentimentLabel: SentimentLabel?
    //MARK: - last sentimen label should be optional

    @Relationship(inverse: \UserEntity.selfUserEntity)
    var userEntity: UserEntity?

    init(
        id: UUID = UUID(),
        name: String,
        messages: [SelfUserMessage] = [],
        analysisDates: [Date] = [],
        lastSentimentLabel: SentimentLabel? = nil,
        userEntity: UserEntity? = nil
    ) {
        self.id = id
        self.name = name
        self.messages = messages
        self.analysisDates = analysisDates
        self.lastSentimentLabel = lastSentimentLabel
        self.userEntity = userEntity
    }
}

extension SelfUserEntity {
    func convertToSelfUser() -> SelfUser {
        SelfEmotionManagerHelper.convertSelfUserEntityToSelfUser(self) 
    }
}
