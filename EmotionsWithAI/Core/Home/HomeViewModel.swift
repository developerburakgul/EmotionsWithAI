//
//  HomeViewModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 7.06.2025.
//
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var showFileImporter: Bool = false
    init(container: DependencyContainer) {
        
    }
    var localizedMostEmotion: String {
        String(localized: LocalizedStringResource(stringLiteral: SentimentLabel.anger.getStringValue))
    }
    
    func clickAddButton() {
        showFileImporter = true
    }
}
