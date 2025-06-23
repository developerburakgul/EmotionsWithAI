//
//  LoaderType.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 21.06.2025.
//

import Foundation

enum LoaderType: String, Identifiable, CaseIterable, Equatable {
    case analyzing
    case oneTimeAnalyzing


    var id: String { rawValue }

    var animationName: String {
        switch self {
        case .analyzing: return "Analyze"
        case .oneTimeAnalyzing : return "Analyze-OneTime"
        }
    }

    var title: String {
        switch self {
        case .analyzing: return "Analyzing Emotions..."

        case .oneTimeAnalyzing: return "Analyzing Message..."
        }
    }
}
