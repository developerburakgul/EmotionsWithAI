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
    let selfEmotionManager: SelfEmotionManager
    let userManager: UserManager
    let analyzeManager: AnalyzeManager
    let webService: MBWebServiceProtocol
    
    var container: DependencyContainer {
        let container = DependencyContainer()
        container.register(PersonManager.self, service: personManager)
        container.register(SelfEmotionManager.self, service: selfEmotionManager)
        container.register(UserManager.self, service: userManager)
        container.register(MBWebServiceProtocol.self, service: webService)
        container.register(AnalyzeManager.self, service: analyzeManager)
        
        return container
    }
        
    init() {
        let localPersonStorage = LocalPersonStorageService()
        self.personManager = PersonManager(localPersonStorage: localPersonStorage)
        
        let localSelfEmotionStorageService: LocalSelfEmotionStorageServiceProtocol = LocalSelfEmotionStorageService()
        self.selfEmotionManager = SelfEmotionManager(localSelfEmotionStorageService: localSelfEmotionStorageService)
        
        
        let localUserStorageService: LocalUserStorageServiceProtocol = LocalUserStorageService()
        self.userManager = UserManager(localUserStorageService: localUserStorageService)
        
        let webService: MBWebServiceProtocol = MBWebService.shared
        self.webService = webService
        
        self.analyzeManager = AnalyzeManager(webService: MBWebService.shared)

    }


}

