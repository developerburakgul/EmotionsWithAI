//
//  LoaderType.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 21.06.2025.
//

import Foundation

enum LoaderType: String, Identifiable, CaseIterable, Equatable {
    case analyzing


    var id: String { rawValue }

    var animationName: String {
        switch self {
        case .analyzing: return "Analyze"
        }
    }

    var title: String {
        switch self {
        case .analyzing: return "Analiz ediliyor..."

        }
    }
}
