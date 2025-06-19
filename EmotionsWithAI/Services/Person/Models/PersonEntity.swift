//
//  PersonEntity.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 9.06.2025.
//
import Foundation
import SwiftData

@Model
final class PersonEntity {
    @Attribute(.unique) var id: UUID
    var name: String
    var messages: [Message] = []
    var analysisDates: [Date] = []
    var lastSentimentLabel: SentimentLabel
    var firstDateForConversation: Date
    var lastDateForConversation: Date
    init(
        id: UUID = .init(),
        name: String,
        messages: [Message] = [],
        analysisDates: [Date] = [],
        lastSentimentLabel: SentimentLabel = .neutral,
        firstDateForConversation: Date = Date(),
        lastDateForConversation: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.messages = messages
        self.analysisDates = analysisDates
        self.lastSentimentLabel = lastSentimentLabel
        self.firstDateForConversation = firstDateForConversation
        self.lastDateForConversation = lastDateForConversation
    }
    


}

extension PersonEntity {
    public func convertToPerson() -> Person {
        PersonHelper.convertPersonEntityToPerson(self)
    }
    
    public func convertToPersonDetail() -> PersonDetail {
        return PersonHelper.convertPersonEntityToPersonDetail(self)
    }
}
