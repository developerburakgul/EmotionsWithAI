//
//  Message.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 18.06.2025.
//

import Foundation
import SwiftData

@Model
class PersonMessage {
    @Relationship(inverse: \PersonEntity.messages)
    var person: PersonEntity?
    
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

extension PersonMessage {
    static func mock(startingFrom baseDate: Date, count: Int) -> [PersonMessage] {
        var messages: [PersonMessage] = []
        var currentStartDate = baseDate


        for _ in 0..<count {
            // Rastgele 1-5 dakika arası süre
            let durationMinutes = Int.random(in: 1...5)
            guard let endDate = Calendar.current.date(byAdding: .minute, value: durationMinutes, to: currentStartDate) else {
                break  // Tarih oluşmazsa döngüyü kır
            }

            let messageCount = Int.random(in: 1...10)

            // Mesaj oluştur
            let message = PersonMessage(
                startTime: currentStartDate,
                endTime: endDate,
                emotion: Emotion(sentiments: Sentiment.mock(7)),
                messageCount: messageCount
            )

            messages.append(message)

            // Sonraki mesajın başlangıcı, bu mesajın bitişi olacak
            currentStartDate = endDate
        }

        return messages
    }
}


