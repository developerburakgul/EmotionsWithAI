//
//  CalendarMonthScrollTrigger.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 19.06.2025.
//

import Foundation
import ObiletCalendar

struct CalendarMonthScrollTrigger: Hashable {
    var date: Date?
    var calendar: Calendar
    var id: String? {
        guard let date = date else { return nil }
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        return "\(month)\(year)"
    }
    
    init(date: Date? = nil, calendar: Calendar) {
        self.date = date
        self.calendar = calendar
    }
    
    init(
        month: CalendarModel.Month,
        year: CalendarModel.Year,
        calendar: Calendar
    ) {
        let dc = DateComponents(year: year.year, month: month.month, day: 1)
        self.date = calendar.date(from: dc)!
        self.calendar = calendar
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: CalendarMonthScrollTrigger, rhs: CalendarMonthScrollTrigger) -> Bool {
        return lhs.id == rhs.id
    }
}
