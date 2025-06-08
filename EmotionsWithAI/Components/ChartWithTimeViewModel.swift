import Foundation
import SwiftUI

final class ChartWithTimeViewModel: ObservableObject {
    @Published var chartDatas: [ChartData] = ChartData.getMockData(for: .month)
    private(set) var chartDataType: ChartDataType = .month

    var thisMonthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMMM"
        return formatter.string(from: Date())
    }
    var daysInCurrentMonth: Int {
        let now = Date()
        let range = Calendar.current.range(of: .day, in: .month, for: now)
        return range?.count ?? 30
    }

    var chartXAxisValues: [Int] {
        switch chartDataType {

        case .month:
            let days = daysInCurrentMonth
            var values = Array(stride(from: 1, through: days, by: 5))
            if values.last != days {
                values.append(days)
            }
            return values
        }
    }

    var chartXAxisVisibleDomainLength: Int {
        switch chartDataType {
        case .month:
            return daysInCurrentMonth
        }
    }

    func getSentimentLabelValue(_ chartData: ChartData) -> Int {
        switch chartDataType {
        case .month:
            return chartData.date.getDay()
        }
    }
}

