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
        for message in messages {
            let sentiment = message.convertToPersonMessage().emotion.getMainSentiment()
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
