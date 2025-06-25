//
//  AnalysisHelper.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 22.06.2025.
//
import Foundation

struct AnalysisHelper {
    
    
    static func getUserParticipantData(userName: String, participants: [String: ParticipantDataModel]) -> ParticipantDataModel? {
        for (_, value) in participants {
            if value.userInfo.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == userName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
                return value
            }
        }
        return nil

    }
    
    static func getPersonParticipantData(userName: String, participants: [String: ParticipantDataModel]) -> ParticipantDataModel? {
        for (_, value) in participants {
            if value.userInfo.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) != userName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
                return value
            }
        }
        return nil

    }
    
    private static func getFirstConversationDate(conversations: [ClientMessageModel]) -> Date {
        let sortedConversations = conversations.sorted { $0.startTime < $1.startTime }
        return sortedConversations[0].startTime
    }
    
    private static func getMessageCount(_ messages: [ClientMessageModel]) -> Int {
        var count = 0
        for message in messages {
            count += message.messageCount
        }
        return count
    }
    
    private static func getMostSentimentLabel(_ messages: [ClientMessageModel]) -> SentimentLabel {
        let messages = messages.map { $0.convertToPersonMessage() }
        return PersonHelper.findMostSentiment(messages).label
        
    }
    
    private static func getLastSentimentLabel(_ messages: [ClientMessageModel]) -> SentimentLabel {
        let sortedMessages = messages.sorted { $0.endTime > $1.endTime }
        let sentiments = sortedMessages[0].emotion.sentiments.map { $0.convertToSentiment()}
        let emotion = Emotion(sentiments: sentiments)
        return emotion.getMainSentiment().label
        
    }
    
    private static func getSentiments(_ messages: [ClientMessageModel]) -> [Sentiment] {
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = TimeZone(identifier: "UTC")!
        
        // Mesajları günlere göre grupla
        let groupedByDay = Dictionary(grouping: messages) { message in
            utcCalendar.startOfDay(for: message.startTime)
        }
        
        // Her günün baskın duygusunu bul
        var dominantCounts: [SentimentLabel: Int] = [
            .anger: 0,
            .disgust: 0,
            .fear: 0,
            .joy: 0,
            .sadness: 0,
            .neutral: 0,
            .suprise: 0
        ]
        
        for (_, dayMessages) in groupedByDay {
            let personMessages = dayMessages.map { $0.convertToPersonMessage() }
            let dominant = PersonHelper.findMostSentiment(personMessages)
            dominantCounts[dominant.label, default: 0] += 1
        }
        
        let totalDays = groupedByDay.count
        guard totalDays > 0 else {
            return dominantCounts.map { Sentiment(label: $0.key, score: 0) }
        }
        
        // Oranları hesapla
        return dominantCounts.map { (label, count) in
            Sentiment(label: label, score: Double(count) / Double(totalDays))
        }
    }
    
    static func getAnalysisResult(userName: String, data: WhatsappAnalysisResponseModel) -> AnalysisResultModel? {
        guard let personParticipantData = Self.getPersonParticipantData(userName: userName, participants: data.participants) else { return nil }
        
        return AnalysisResultModel(
            name: personParticipantData.userInfo.name,
            firstConversationDate: Self.getFirstConversationDate(conversations: personParticipantData.messages),
            messageCount: Self.getMessageCount(personParticipantData.messages),
            mostSentimentLabel: Self.getMostSentimentLabel(personParticipantData.messages),
            lastSentimentLabel: Self.getLastSentimentLabel(personParticipantData.messages),
            sentiments: Self.getSentiments(personParticipantData.messages)
        )
    }
}
