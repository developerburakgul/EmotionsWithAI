//
//  PersonHelper.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 22.06.2025.
//

import Foundation

public struct PersonHelper {

    
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
            messageCount: Self.getAllMessageCount(from: personEntity),
            mostSentiment: Self.findMostSentiment(personEntity.messages),
            dateForLastMessageForAnalysis: personEntity.dateForLastMessageForAnalysis
        )
        return personDetail
    }
    
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
        return returnArray.sorted {
            $0.date < $1.date
        }
    }
    
    //MARK: - Private functions
    
    static func findMostSentiment(_ messages: [PersonMessage]) -> Sentiment {
        // Tüm sentiment'leri tek bir dizide topluyoruz
        let allSentiments = messages.flatMap { $0.emotion.sentiments }
        
        // Aynı label'ları gruplayıp score'ları topluyoruz
        var sentimentScores: [SentimentLabel: Double] = [:]
        
        for sentiment in allSentiments {
            sentimentScores[sentiment.label, default: 0.0] += sentiment.score
        }
        
        // En yüksek skor hangi label'a aitse onu bul
        guard let (mostCommonLabel, _) = sentimentScores.max(by: { $0.value < $1.value }) else {
            // Fallback: hiç mesaj yoksa mock bir değer döndür
            return Sentiment(label: .neutral, score: 0)
        }
        
        // Bu label'a ait sentiment'lerden ortalamasını döndür (ya da ilkini)
        let matchingSentiments = allSentiments.filter { $0.label == mostCommonLabel }
        let averageScore = matchingSentiments.map(\.score).reduce(0, +) / Double(matchingSentiments.count)
        
        return Sentiment(label: mostCommonLabel, score: averageScore)
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
    
    private static func getLastSentimentLabel(from personEntity: PersonEntity ) -> SentimentLabel? {
        let messages = personEntity.messages.sorted {
            $0.endTime < $1.endTime
        }
        guard let lastMessage = messages.last else {return nil}
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
    
    
    //MARK: - Participant Data Section
    
    static func getLastSentimentLabel(from clientMessageModels: [ClientMessageModel]) -> SentimentLabel {
        let messages = clientMessageModels.sorted {
            $0.endTime > $1.endTime
        }
        let message = messages[0]
        return message.emotion.convertToEmotion().getMainSentiment().label
    }
    
    static func getLastDateOfMessage(from clientMessageModels: [ClientMessageModel]) -> Date {
        let messages = clientMessageModels.sorted {
            $0.endTime > $1.endTime
        }
        return messages[0].endTime
    }
    
    static func getFirstDateOfMessage(from clientMessageModels: [ClientMessageModel]) -> Date {
        let messages = clientMessageModels.sorted {
            $0.startTime < $1.startTime
        }
        return messages[0].startTime
    }
}
