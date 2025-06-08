import SwiftUI
import Charts

struct ChartData: Identifiable {
    let id: UUID = UUID()
    let date: Date
    let sentiment: Sentiment
}

struct ChartWithTime: View {
    @StateObject var viewModel: ChartWithTimeViewModel = ChartWithTimeViewModel()
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
            VStack(alignment: .center, spacing: 4) {
                timeText
                chart
            }
            .padding()
        }
        .cornerRadius(16)
        .padding(.vertical, 6)
        .padding(.horizontal)
    }

    private var timeText: some View {
        Text(viewModel.thisMonthString)
            .padding()
            .font(.title)
    }

    private var chart: some View {
        Chart {
            ForEach(viewModel.chartDatas) { item in
                BarMark(
                    x: .value("", viewModel.getSentimentLabelValue(item)),
                    y: .value("", item.sentiment.score.convertToPercentage())
                )
                .foregroundStyle(by: .value("Sentiment label", item.sentiment.label.getStringValue))
            }
        }
        .chartForegroundStyleScale([
            "Anger": .red,
            "Disgust": .green,
            "Fear": .blue,
            "Joy": .yellow,
            "Neutral": .gray,
            "Sadness": .purple,
            "Suprise": .brown
        ])
        .chartXScale(range: .plotDimension(startPadding: 8, endPadding: 16))
        .chartXAxis {
            AxisMarks(values: viewModel.chartXAxisValues) { value in
                AxisValueLabel() {
                    if let intValue = value.as(Int.self) {
                        Text("\(intValue)")
                            .offset(x: -8) // Adjust this value if needed
                    }
                }
            }
        }
        .chartScrollPosition(initialX: 1)
        .chartXVisibleDomain(length: viewModel.chartXAxisVisibleDomainLength)
        .chartYAxis {
            AxisMarks(values: [0, 50, 100]) {
                AxisValueLabel(format: Decimal.FormatStyle.Percent.percent.scale(1))
            }
            AxisMarks(values: [0, 25, 50, 75, 100]) {
                AxisGridLine()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ChartWithTime()
        .frame(height: 300)
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
