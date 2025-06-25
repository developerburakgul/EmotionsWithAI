//
//  Sentiment.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 6.06.2025.
//

import Foundation
import SwiftUICore

struct Sentiment: Identifiable, Codable, Equatable, Hashable{
    var id: UUID = UUID()
    
    let label: SentimentLabel
    let score: Double
    
    enum CodingKeys:String, CodingKey {
        case label
        case score
    }
}




enum SentimentLabel: String,Codable, CaseIterable, Equatable {
    case anger = "anger"
    case disgust = "disgust"
    case fear = "fear"
    case joy = "joy"
    case neutral = "neutral"
    case sadness =  "sadness"
    case suprise = "surprise"
    
    var getStringValue: String {
        switch self {
        case .anger:
            "Anger"
        case .disgust:
            "Disgust"
        case .fear:
            "Fear"
        case .joy:
            "Joy"
        case .neutral:
            "Neutral"
        case .sadness:
            "Sadness"
        case .suprise:
            "Surprise"
        }
    }
    
    var color: Color {
        switch self {
        case .anger:
                .red
        case .disgust:
                .green
        case .fear:
                .purple
        case .joy:
                .yellow
        case .neutral:
                .gray
        case .sadness:
                .blue
        case .suprise:
                .orange
        }
    }
    
    func getImageName() -> String {
        switch self {
        case .anger:
            "Anger"
        case .disgust:
            "Disgust"
        case .fear:
            "Fear"
        case .joy:
            "Joy"
        case .neutral:
            "Neutral"
        case .sadness:
            "Sadness"
        case .suprise:
            "Surprise"
        }
    }
    
    func getImageNameRemoveBacgkround() -> String {
        switch self {
        case .anger:
            "AngerRemovedBackground"
        case .disgust:
            "DisgustRemovedBackground"
        case .fear:
            "FearRemovedBackground"
        case .joy:
            "JoyRemovedBackground"
        case .neutral:
            "NeutralRemovedBackground"
        case .sadness:
            "SadnessRemovedBackground"
        case .suprise:
            "Surprise"
        }
    }
    
}


extension SentimentLabel {
    static func getRandom() -> SentimentLabel {
        allCases.randomElement() ?? .neutral
    }
}

extension Sentiment {
    static func getRandom() -> Sentiment {

        let item = SentimentLabel.allCases.randomElement()
        return .init(
            label: item ?? .joy,
            score: Double.random(in: 0...1)
        )
    }
    
    static func mock(_ count: Int = 10) -> [Sentiment] {
        return (0..<count).map { _ in
            Sentiment.getRandom()
        }
    }
    
    static func simpleSetSentiment() -> [Sentiment] {
        var returnArray: [Sentiment] = []
        
        for sentimentLabel in SentimentLabel.allCases {
            returnArray.append(
                Sentiment(
                    label: sentimentLabel,
                    score: Double.random(in: 0...1)
                )
            )
        }
        return returnArray
    }
    
//    func getImageName() -> String {
//        switch self.label {
//        case .anger:
//            "Anger"
//        case .disgust:
//            "Disgust"
//        case .fear:
//            "Fear"
//        case .joy:
//            "Joy"
//        case .neutral:
//            "Neutrall"
//        case .sadness:
//            "Sadness"
//        case .suprise:
//            "Surprise"
//        }
//    }
//    
//    func getImageNameRemoveBacgkround() -> String {
//        switch self.label {
//        case .anger:
//            "AngerRemovedBackground"
//        case .disgust:
//            "DisgustRemovedBackground"
//        case .fear:
//            "FearRemovedBackground"
//        case .joy:
//            "JoyRemovedBackground"
//        case .neutral:
//            "Neutrall"
//        case .sadness:
//            "SadnessRemovedBackground"
//        case .suprise:
//            "Surprise"
//        }
//    }
}

