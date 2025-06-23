//
//  CalendarViewModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 8.06.2025.
//

import Foundation
import ObiletCalendar

struct CalendarModels {
    let date: Date
    let sentiment: Sentiment
}

enum CalendarDetailState {
    case loading
    case loaded
    case failed(String)
}

extension CalendarModels {
    static func mockData() -> [CalendarModels] {
        var models: [CalendarModels] = []
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2024, month: 6, day: 1))!
        let endDate = calendar.date(from: DateComponents(year: 2025, month: 7, day: 31))!

        var currentDate = startDate
        while currentDate <= endDate {
            let normalizedDate = Calendar.current.startOfDay(for: currentDate)
            models.append(CalendarModels(date: normalizedDate, sentiment: Sentiment.getRandom()))
            currentDate = calendar.date(byAdding: .day, value: 2, to: currentDate)!
        }

        return models
    }
}


enum CalendarFilter{
    case none
    case sentimentLabel(SentimentLabel)
}


@MainActor
final class CalendarViewModel: ObservableObject {
    @Published var scrollSwitch: CalendarMonthScrollTrigger? = CalendarMonthScrollTrigger(date: .now, calendar: Calendar.current)
    @Published var startDate: Date = .distantPast
    @Published var calendarRange: CalendarDrawRange = .year(1)
    private var calendarModels: [CalendarModels] = []
    private let personManager: PersonManager
    @Published var state: CalendarDetailState = .loading
    @Published var filter: CalendarFilter = .none
    private let personDetail: PersonDetail
    var todayDate: Date = .now
    
    init(container: DependencyContainer, personDetail: PersonDetail) {
        self.personManager = container.resolve(PersonManager.self)!
        self.personDetail = personDetail
        self.startDate = personDetail.firstDateForConversation ?? Date()
    }
    
    func getSentiment(for model: OBCalendar.DayModel) -> Sentiment? {
        let date = createDate(for: model)
        return getSentiment(at: date)
    }
    
    private func createDate(for dayModel: OBCalendar.DayModel) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = dayModel.year.year
        dateComponents.month = dayModel.month.month
        dateComponents.day = dayModel.day.day
        return Calendar.current.date(from: dateComponents)!
    }
    
    private func getSentiment(at date: Date) -> Sentiment? {
        for model in calendarModels {
            if Calendar.current.isDate(model.date, inSameDayAs: date) {
                print("✅ Eşleşti: \(model.date) == \(date)")
                return model.sentiment
            } else {
                print("❌ Uyuşmadı: \(model.date) != \(date)")
            }
        }
        return nil
    }
    
//    func loadData() async  {
//        state = .loading
//        do {
//            let calendarModels = try  await personManager.fetchCalendarModels(for: personDetail)
//            self.calendarModels = filter(calendarModels: calendarModels)
//            self.state = .loaded
//            self.startDate = calendarModels.first!.date
//        } catch  {
//            state = .failed(error.localizedDescription)
//        }
//       
//    }
    func loadData() async {
        state = .loading
        do {
            let calendarModels = try await personManager.fetchCalendarModels(for: personDetail)
            print("Fetched calendarModels: \(calendarModels)") // Veriyi kontrol et
            self.calendarModels = filter(calendarModels: calendarModels)
            print("Filtered calendarModels: \(self.calendarModels)") // Filtrelenmiş veriyi kontrol et
            self.state = .loaded
            self.startDate = calendarModels.first?.date ?? .now // Güvenli unwrap
            self.calendarRange = getCalendarDrawRange(from: self.startDate, to: .now )
        } catch {
            state = .failed(error.localizedDescription)
            print("Error: \(error)") // Hata detayını kontrol et
        }
    }
    
    private func filter(calendarModels: [CalendarModels]) -> [CalendarModels]{
        switch filter {
        case .none:
            return calendarModels.sorted(by: { $0.date < $1.date })
        case .sentimentLabel(let sentimentLabel):
            return calendarModels.filter { calendarModel in
                calendarModel.sentiment.label == sentimentLabel
            }.sorted(by: { $0.date < $1.date })
        }
    }
    
    func getCalendarDrawRange(from start: Date, to end: Date) -> CalendarDrawRange {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: start, to: end)
        
        let years = components.year ?? 0
        let months = components.month ?? 0
        let days = components.day ?? 0

        let totalMonths = years * 12 + months + (days > 0 ? 1 : 0)

        return .month(totalMonths)
    }

}
