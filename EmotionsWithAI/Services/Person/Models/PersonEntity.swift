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
    @Attribute(.unique) public var id: UUID
    var name: String
    var messages: [PersonMessage] = []
    var analysisDates: [Date] = []
    var lastSentimentLabel: SentimentLabel? = nil
    var firstDateForConversation: Date? = nil
    var lastDateForConversation: Date? = nil
    var dateForLastMessageForAnalysis: Date? = nil
    init(
        id: UUID = .init(),
        name: String,
        messages: [PersonMessage] = [],
        analysisDates: [Date] = [],
        lastSentimentLabel: SentimentLabel? = nil,
        firstDateForConversation: Date? = nil,
        lastDateForConversation: Date? = nil,
        dateForLastMessageForAnalysis: Date? = nil
        
    ) {
        self.id = id
        self.name = name
        self.messages = messages
        self.analysisDates = analysisDates
        self.lastSentimentLabel = lastSentimentLabel
        self.firstDateForConversation = firstDateForConversation
        self.lastDateForConversation = lastDateForConversation
        self.dateForLastMessageForAnalysis = dateForLastMessageForAnalysis
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
