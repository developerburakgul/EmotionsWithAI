//
//  Date+Extension.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 6.06.2025.
//

import Foundation


extension Date {
    func getHour() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: self)
        return components.hour ?? 0
    }
    
    func getDay() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self)
        return components.day ?? 0
    }
    
    func format(with format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    static func mock(count: Int) -> [Date] {
        var returnDates = [Date]()
        for _ in 0..<count {
            returnDates.append(Date.random())
        }
        return returnDates
    }
    
    static func random() -> Date {
        let randomTime = TimeInterval(Int32.random(in: 0...Int32.max))
        return Date(timeIntervalSince1970: randomTime)
    }
}



enum DateFormat: String {
    case yyyyMMM = "yyyy MMM"
    case yyyyMMMM = "yyyy MMMM"
    case ddMMMMyyyyHHmm = "dd MMMM yyyy HH:mm"
    case ddMMMMyyyy = "dd MMMM yyyy"
}
