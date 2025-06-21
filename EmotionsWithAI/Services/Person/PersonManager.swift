//
//  PersonManager.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 9.06.2025.
//

import Foundation


struct PersonHelper {

    
    static func convertPersonEntityToPerson(_ personEntity: PersonEntity) -> Person {
        let person = Person(
            id: personEntity.id,
            name: personEntity.name,
            mostSentiment: Self.findMostSentiment(personEntity.messages)
        )
        
        return person
        
    }
    
    static func convertPersonEntityToPersonDetail(_ personEntity: PersonEntity) -> PersonDetail {
        let personDetail = PersonDetail(
            id: personEntity.id,
            name: personEntity.name,
            sentiments: Self.getSentiments(from: personEntity),
            lastSentimentLabel: Self.getLastSentimentLabel(from: personEntity),
            firstDateForConversation: Self.getFirstDateForConversation(from: personEntity),
            lastDateForConversation: personEntity.lastDateForConversation,
            analysisCount: Self.getAnalysisCount(from: personEntity),
            messageCount: 12,
            mostSentiment: Self.findMostSentiment(personEntity.messages)
        )
        return personDetail
    }
    
//    static func getCalendarModels(from personEntity: PersonEntity) -> [CalendarModels] {
//        let groupedByDay = Dictionary(grouping: personEntity.messages) { (message) -> Date in
//            return Calendar.current.startOfDay(for: message.startTime)
//        }
//        
//        var returnArray: [CalendarModels] = []
//        
//        for (day, messages) in groupedByDay {
//            let calendarModel = CalendarModels(date: day, sentiment: Self.findMostSentiment(messages))
//            returnArray.append(calendarModel)
//        }
//        return returnArray
//    }
    
    static func getCalendarModels(from personEntity: PersonEntity) -> [CalendarModels] {
        var utcCalendar = Calendar.current // Kopya oluştur
        utcCalendar.timeZone = TimeZone(identifier: "UTC")!
        
        let groupedByDay = Dictionary(grouping: personEntity.messages) { (message) -> Date in
            let normalizedDate = utcCalendar.startOfDay(for: message.startTime)
            print("Normalized date for \(message.startTime): \(normalizedDate)")
            return normalizedDate
        }
        
        var returnArray: [CalendarModels] = []
        
        for (day, messages) in groupedByDay {
            let calendarModel = CalendarModels(date: day, sentiment: Self.findMostSentiment(messages))
            returnArray.append(calendarModel)
        }
        return returnArray
    }
    
    //MARK: - Private functions
    
    private static func findMostSentiment(_ messages: [Message]) -> Sentiment {
        // TODO
        Sentiment.mock().first!
    }
    
    private static func getSentiments(from personEntity: PersonEntity) -> [Sentiment] {
        struct SentimentCount {
            var sentimentScore: Double = 0.0
            var count: Int = 0
        }
        
        func createSentiment(label: SentimentLabel) -> Sentiment {
            let sentimentCount = sentimentsDictionary[label]!
            guard sentimentCount.count > 0 else {
                return Sentiment(label: label, score: 0)
            }
            return Sentiment(
                label: label,
                score: sentimentCount.sentimentScore / Double(sentimentCount.count)
            )
        }
        var sentimentsDictionary: [SentimentLabel: SentimentCount] = [
            .anger: SentimentCount(),
            .disgust: SentimentCount(),
            .fear: SentimentCount(),
            .joy: SentimentCount(),
            .sadness: SentimentCount(),
            .neutral: SentimentCount(),
            .suprise: SentimentCount()
        ]
        for message in personEntity.messages {
            let sentiment = message.emotion.getMainSentiment()
            sentimentsDictionary[sentiment.label]!.count += 1
            sentimentsDictionary[sentiment.label]!.sentimentScore += sentiment.score
        }
        
        return [
            createSentiment(label: .anger),
            createSentiment(label: .disgust),
            createSentiment(label: .fear),
            createSentiment(label: .joy),
            createSentiment(label: .neutral),
            createSentiment(label: .sadness),
            createSentiment(label: .suprise)
        ]
        
        
        
    }
    
    private static func getLastSentimentLabel(from personEntity: PersonEntity ) -> SentimentLabel {
        let messages = personEntity.messages.sorted {
            $0.endTime < $1.endTime
        }
        let lastMessage = messages.last!
        return lastMessage.emotion.sentiments.sorted {
            $0.score > $1.score
        }.first!.label
    }
    
    private static func getFirstDateForConversation(from personEntity: PersonEntity) -> Date {
        let messages = personEntity.messages.sorted {
            $0.endTime < $1.endTime
        }
        return messages.first!.startTime
    }
    
    private static func getAllMessageCount(from personEntity: PersonEntity) -> Int {
        return personEntity.messages.reduce(into: 0) { partialResult, message in
            partialResult = partialResult + message.messageCount
        }
    }
    
    private static func getAnalysisCount(from personEntity: PersonEntity) -> Int {
        return personEntity.analysisDates.count
    }
}

protocol PersonManagerProtocol {
    
}

@MainActor
final class PersonManager: PersonManagerProtocol {
    
    private let localStorageService: LocalPersonStorageServiceProtocol
    
    
    init(localPersonStorage: LocalPersonStorageServiceProtocol) {
        self.localStorageService = localPersonStorage
    }
    
    func fetchAllPersons() throws -> [Person] {
        do {
            return try localStorageService.fetchAllPersons().map { $0.convertToPerson() }
        } catch  {
            print("Error loading persons \(error)")
            throw error
        }
    }
    
    func fetchPerson(name: String) -> Person? {
        return try? fetchAllPersons().first { person in
            person.name == name
        }
    }
    
    
    
    func addPersonEntity(_ personEntity: PersonEntity) throws(LocalPersonStorageError) {
        
        do {
            try localStorageService.createPersonEntity(personEntity)
        } catch {
            throw error
        }
    }
    
    func deletePerson(_ person: Person) throws(LocalPersonStorageError){
        do {
            let personEntity = try localStorageService.findPersonEntity(from: person)
            try localStorageService.deletePersonEntity(personEntity)
        } catch  {
            throw error
        }
    }
    
    func updatePersonEntity(_ personEntity: PersonEntity) throws(LocalPersonStorageError) {
        do {
            try localStorageService.updatePersonEntity(personEntity)
        } catch {
            throw error
        }
    }
    
    
    func fetchPersonDetail(person: Person) throws(LocalPersonStorageError) -> PersonDetail {
        
        do {
            let personEntity = try localStorageService.findPersonEntity(from: person)
            return PersonHelper.convertPersonEntityToPersonDetail(personEntity)
        } catch  {
            throw LocalPersonStorageError.couldntFetchPersonDetails
        }
    }
    
    func fetchCalendarModels(for personDetail: PersonDetail) async throws -> [CalendarModels] {
    
        do {
            let personEntity = try localStorageService.findPersonEntity(from: personDetail)
            return PersonHelper.getCalendarModels(from: personEntity)
        } catch  {
            throw LocalPersonStorageError.couldntFetchCalendarModels
        }
    }
    
}


