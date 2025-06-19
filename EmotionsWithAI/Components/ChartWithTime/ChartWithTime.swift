import SwiftUI
import Charts



struct ChartWithTime: View {
    @Binding var chartDatas: [ChartData]
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
        Text(Date().format(with: .yyyyMMMM))
            .padding()
            .font(.title)
    }

    private var chart: some View {
        Chart {
            ForEach(chartDatas) { item in
                BarMark(
                    x: .value("", item.date.getDay()),
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
            AxisMarks(values: [1,6,11,16,21,26]) { value in
                AxisValueLabel() {
                    if let intValue = value.as(Int.self) {
                        Text("\(intValue)")
                            .offset(x: -8) // Adjust this value if needed
                    }
                }
            }
        }
        .chartScrollPosition(initialX: 1)
        .chartXVisibleDomain(length: daysInCurrentMonth)
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
    
    var daysInCurrentMonth: Int {
        let now = Date()
        let range = Calendar.current.range(of: .day, in: .month, for: now)
        return range?.count ?? 30
    }
}

#Preview {
    @Previewable @State var mock = ChartData.getMockData(for: .month)
    ChartWithTime(chartDatas: $mock)
        .frame(height: 300)
}


