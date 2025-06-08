//
//  Settings.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 7.06.2025.
//

import Foundation

struct LanguageModel {
    let name: String
    let code: String
}

enum Language: Identifiable, CaseIterable{
    var id: String {
        self.languageModel.name
    }
    
    case english
    case turkish
    
    var languageModel: LanguageModel {
        switch self {
        case .english:
            return LanguageModel(name: "English", code: "en")
        case .turkish:
            return LanguageModel(name: "Türkçe", code: "tr")
        }
    }
}
