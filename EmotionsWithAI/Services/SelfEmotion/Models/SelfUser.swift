//
//  SelfUserDetail.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 12.06.2025.
//
import Foundation

struct SelfUser: Identifiable{
    var id: UUID
    
    let chartDatas: [ChartData]
    let mostEmotionLabel: SentimentLabel?
    let analysisDates: [Date]
    let countOfMessages: Int
    var lastSentimentLabel: SentimentLabel?
    

    
}
