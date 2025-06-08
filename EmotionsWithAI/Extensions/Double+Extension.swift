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
        return String(format: "%.1f", convertToPercentage()) + "%"
    }
}
