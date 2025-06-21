//
//  PreviewEnvironment.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 10.06.2025.
//

import Foundation
import SwiftUI
import MBWebService

extension View {
    func previewEnvironmentObject() -> some View {
        self
            .environmentObject(DevPreview.shared.container)
    }
}

@MainActor
class DevPreview {
    static let shared = DevPreview()
    
    let personManager: PersonManager
    let analyzeManager: AnalyzeManager
    let selfEmotionManager: SelfEmotionManager
    var container: DependencyContainer {
        let container = DependencyContainer()
        container.register(PersonManager.self, service: personManager)
        container.register(AnalyzeManager.self, service: analyzeManager)
        container.register(SelfEmotionManager.self, service: selfEmotionManager)
        return container
    }
        
    init() {
        let localPersonStorage = LocalPersonStorageService()
        self.personManager = PersonManager(localPersonStorage: localPersonStorage)
    
        self.analyzeManager = AnalyzeManager(webService: MBWebService.shared)
        
        let localSelfEmotionStorageService: LocalSelfEmotionStorageServiceProtocol = LocalSelfEmotionStorageService()
        self.selfEmotionManager = SelfEmotionManager(localSelfEmotionStorageService: localSelfEmotionStorageService)
    }

}

