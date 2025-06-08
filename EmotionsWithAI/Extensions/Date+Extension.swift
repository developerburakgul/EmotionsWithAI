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
}
