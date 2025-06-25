//
//  SelfUserMessage.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 22.06.2025.
//

import Foundation
import SwiftData

@Model
class SelfUserMessage {
    @Relationship(inverse: \SelfUserEntity.messages)
    var selfUser: SelfUserEntity?
    
    var startTime: Date
    var endTime: Date
    var emotion: Emotion
    var messageCount: Int

    init(startTime: Date, endTime: Date, emotion: Emotion, messageCount: Int) {
        self.startTime = startTime
        self.endTime = endTime
        self.emotion = emotion
        self.messageCount = messageCount
    }
}
