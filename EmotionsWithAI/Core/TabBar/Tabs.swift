//
//  Tabs.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 3.06.2025.
//

import Foundation
import SwiftUI

enum Tabs: String, CaseIterable, Hashable {
    case home, analysis, person, settings
    
    var systemImageName: String {
        switch self {
        case .home:
            return "house"
        case .analysis:
            return "chart.line.uptrend.xyaxis"
        case .person:
            return "person.3"
        case .settings:
            return "gearshape"
        }
    }
    
    var title: LocalizedStringKey {
        switch self {
        case .home:
            return "Home"
        case .analysis:
            return "Analysis"
        case .person:
            return "Person"
        case .settings:
            return  "Settings"
        }
    }
}
