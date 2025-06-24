//
//  Double+Extension.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 6.06.2025.
//

import Foundation

extension Double {
    func convertToPercentage() -> Double {
        let percentage = self * 100
        return percentage
    }
    
    func getPercentageString() -> String {
        let value = convertToPercentage()
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            // Tam sayıysa ondalık gösterme
            return String(format: "%.0f%%", value)
        } else {
            // Ondalık varsa bir basamak göster
            return String(format: "%.1f%%", value)
        }
    }
}
