//
//  SelfEmotionManagerHelper.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 20.06.2025.
//

import Foundation
import ZIPFoundation


struct SelfEmotionManagerHelper {
    static func convertParticipantDataToSelfUserMessage(_ participantData: ParticipantDataModel) -> [SelfUserMessage] {
        return participantData.messages.map { $0.convertToSelfUserMessage() }
    }
    static func convertSelfUserEntityToSelfUser(_ selfUserEntity: SelfUserEntity) -> SelfUser {
        return SelfUser(
            id: selfUserEntity.id,
            chartDatas: Self.getChartDatas(from: selfUserEntity),
            mostEmotionLabel: Self.getMostEmotion(selfUserEntity.messages).label,
            analysisDates: Self.getAnalysisDates(from: selfUserEntity),
            countOfMessages: Self.getCountOfMessages(from: selfUserEntity)
        )
    }
    
    static func getChartDatas(from selfUserEntity: SelfUserEntity) -> [ChartData] {
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = TimeZone(identifier: "UTC")!

        let now = Date()
        let currentYear = utcCalendar.component(.year, from: now)
        let currentMonth = utcCalendar.component(.month, from: now)

        // Sadece şu anki yıl ve ay'a ait mesajları filtrele
        let currentMonthMessages = selfUserEntity.messages.filter {
            let messageYear = utcCalendar.component(.year, from: $0.startTime)
            let messageMonth = utcCalendar.component(.month, from: $0.startTime)
            return messageYear == currentYear && messageMonth == currentMonth
        }

        let groupedByDay = Dictionary(grouping: currentMonthMessages) { message in
            utcCalendar.startOfDay(for: message.startTime)
        }

        var returnArray: [ChartData] = []

        for (day, messages) in groupedByDay.sorted(by: { $0.key < $1.key }) {
            let sentiment = Self.getMostEmotion(messages)
            returnArray.append(ChartData(date: day, sentiment: sentiment))
        }

        return returnArray
    }
    
    static func getMostEmotion(_ messages: [SelfUserMessage]) -> Sentiment {
        let allSentiments = messages.flatMap { message in
            message.emotion.sentiments.map { sentiment in
                (label: sentiment.label, score: sentiment.score, count: message.messageCount)
            }
        }

        guard !allSentiments.isEmpty else {
            return Sentiment(label: .neutral, score: 0)
        }

        // Ağırlıklı ortalama hesapla
        var labelScores: [SentimentLabel: (total: Double, count: Int)] = [:]

        for sentiment in allSentiments {
            var current = labelScores[sentiment.label, default: (0.0, 0)]
            current.total += sentiment.score * Double(sentiment.count)
            current.count += sentiment.count
            labelScores[sentiment.label] = current
        }

        let labelAverages: [SentimentLabel: Double] = labelScores.mapValues {
            $0.count > 0 ? $0.total / Double($0.count) : 0
        }

        // En yüksek ortalama skoru seç
        guard let (bestLabel, bestAvg) = labelAverages.max(by: { $0.value < $1.value }) else {
            return Sentiment(label: .neutral, score: 0)
        }

        // Skoru 0...1 aralığında sabitle (gerekmese de güvenlik için)
        let clampedScore = min(max(bestAvg, 0), 1)

        return Sentiment(label: bestLabel, score: clampedScore)
    }
    
    static func getCountOfMessages(from selfUserEntity: SelfUserEntity) -> Int {
        //MARK: - TODO
        var countOfMessages = 0
        
        for message in selfUserEntity.messages {
            countOfMessages += message.messageCount
        }
        return countOfMessages
    }
    
    static func getAnalysisDates(from selfUserEntity: SelfUserEntity) -> [Date] {
        return selfUserEntity.analysisDates.sorted {
            $0 > $1
        }
    }
    
    static func getLastSentimentLabel(participantData: ParticipantDataModel) -> SentimentLabel? {
        let messages = participantData.messages.sorted {
            $0.endTime > $1.endTime
        }
        return messages.first?.emotion.convertToEmotion().getMainSentiment().label
    }
}




