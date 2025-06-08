//
//  SettingsViewModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 7.06.2025.
//

import Foundation
final class SettingsViewModel: ObservableObject {
    @Published var selectedLanguage: Language = .turkish
    @Published var allLanguages: [Language] = Language.allCases
    
    init(container: DependencyContainer) {
        
    }
    
}
