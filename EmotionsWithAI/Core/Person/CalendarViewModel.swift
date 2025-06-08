//
//  CalendarViewModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 8.06.2025.
//

import Foundation
import ObiletCalendar

final class CalendarViewModel: ObservableObject {
    
    @Published var startDate: Date
    
    
    init() {
        self.startDate = DateComponents(year: 2025, month: 1, day: 1).date ?? Date()
    }
    
    func getSentiment(for model: OBCalendar.DayModel) -> Sentiment {
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
    
    private func getSentiment(at date: Date) -> Sentiment {
        Sentiment.getRandom()
    }
}
