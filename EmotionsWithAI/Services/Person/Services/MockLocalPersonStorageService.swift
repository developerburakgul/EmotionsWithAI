//
//  MockLocalPersonStorageService.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 19.06.2025.
//

import Foundation

@MainActor
struct MockLocalPersonStorageService: LocalPersonStorageServiceProtocol {
    func fetchAllPersons() throws -> [PersonEntity] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        
        return [
            PersonEntity(
                name: "Person 1",
                messages: PersonMessage.mock(startingFrom: formatter.date(from: "2025-01-01 08:00") ?? .now, count: 10),
                analysisDates: Date.mock(count: 3),
                lastSentimentLabel: SentimentLabel.getRandom(),
                firstDateForConversation: Date.random(),
                lastDateForConversation: Date.random()
            ),
            PersonEntity(
                name: "Person 2",
                messages: PersonMessage.mock(startingFrom: formatter.date(from: "2025-01-10 08:00") ?? .now, count: 10),
                analysisDates: Date.mock(count: 3),
                lastSentimentLabel: SentimentLabel.getRandom(),
                firstDateForConversation: Date.random(),
                lastDateForConversation: Date.random()
            ),
            
            PersonEntity(
                name: "Person 3",
                messages: PersonMessage.mock(startingFrom: formatter.date(from: "2025-01-15 08:00") ?? .now, count: 10),
                analysisDates: Date.mock(count: 3),
                lastSentimentLabel: SentimentLabel.getRandom(),
                firstDateForConversation: Date.random(),
                lastDateForConversation: Date.random()
            )
            
        ]
    }
    
    func createPersonEntity(_ personEntity: PersonEntity) throws(LocalPersonStorageError) {
            
    }
    
    func deletePersonEntity(_ personEntity: PersonEntity) throws(LocalPersonStorageError) {
        
    }
    
    func findPersonEntity(from person: Person) throws(LocalPersonStorageError) -> PersonEntity? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return PersonEntity(
            name: "Person 1",
            messages: PersonMessage.mock(startingFrom: formatter.date(from: "2025-01-01 08:00") ?? .now, count: 10),
            analysisDates: Date.mock(count: 3),
            lastSentimentLabel: SentimentLabel.getRandom(),
            firstDateForConversation: Date.random(),
            lastDateForConversation: Date.random()
        )
    }
    
    func findPersonEntity(from personDetail: PersonDetail) throws(LocalPersonStorageError) -> PersonEntity? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return PersonEntity(
            name: "Person 1",
            messages: PersonMessage.mock(startingFrom: formatter.date(from: "2025-01-01 08:00") ?? .now, count: 10),
            analysisDates: Date.mock(count: 3),
            lastSentimentLabel: SentimentLabel.getRandom(),
            firstDateForConversation: Date.random(),
            lastDateForConversation: Date.random()
        )
    }
    
    func updatePersonEntity(_ personEntity: PersonEntity) throws(LocalPersonStorageError) {
        
    }
    
    
}
