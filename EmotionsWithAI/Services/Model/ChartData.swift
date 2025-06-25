//
//  ChartData .swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 9.06.2025.
//
import Foundation

struct ChartData: Identifiable {
    let id: UUID = UUID()
    let date: Date
    let sentiment: Sentiment
}

enum ChartDataType {
    case month
}

extension ChartData {
    public static func getMockData(for chartDataType: ChartDataType) -> [ChartData] {
        var returnArray: [ChartData] = []
        let now = Date()
        let chartRange: (upper: Int, calendarAddType: Calendar.Component)

        switch chartDataType {
        case .month:
            let days = Calendar.current.range(of: .day, in: .month, for: now)?.count ?? 30
            chartRange = (days, .day)
        }

        for i in 1...chartRange.upper {
            let tempDate = Calendar.current.date(byAdding: chartRange.calendarAddType, value: i, to: now)!
            returnArray.append(
                ChartData(
                    date: tempDate,
                    sentiment: Sentiment.getRandom()
                )
            )
        }
        return returnArray
    }
}
