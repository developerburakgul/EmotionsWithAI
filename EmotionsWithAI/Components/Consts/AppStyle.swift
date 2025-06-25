//
//  AppStyle.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 22.06.2025.
//

import Foundation
import SwiftUI

struct AppStyles {
    static let primaryColor = Color.green
    static let secondaryColor = Color.gray.opacity(0.3)
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [.white, Color.green.opacity(0.1)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let titleFont = Font.system(size: 34, weight: .semibold, design: .serif)
    static let descriptionFont = Font.system(size: 12, weight: .semibold, design: .serif)
    static let buttonFont = Font.system(size: 18, weight: .semibold)
}
