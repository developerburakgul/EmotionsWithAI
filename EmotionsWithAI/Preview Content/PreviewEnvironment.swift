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
    let storeKitService: StoreKitService
    
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
        
        
        let localUserStorageService: LocalUserStorageServiceProtocol = LocalUserStorageService()
        let localSelfEmotionStorageService: LocalSelfEmotionStorageServiceProtocol = LocalSelfEmotionStorageService()
        self.selfEmotionManager = SelfEmotionManager(localSelfEmotionStorageService: localSelfEmotionStorageService, localUserStorageService: localUserStorageService)
        self.storeKitService = StoreKitService()
        self.userManager = UserManager(localUserStorageService: localUserStorageService, localSelfEmotionStorageService: localSelfEmotionStorageService, storeKitService: storeKitService)
        
  

        
        

        
        let webService: MBWebServiceProtocol = MBWebService.shared
        self.webService = webService
        
        self.analyzeManager = AnalyzeManager(webService: MBWebService.shared, userManager: userManager)

    }


//    let localPersonStorageService = LocalPersonStorageService()
//    container.register(LocalPersonStorageService.self, service: localPersonStorageService)
//    container.register(PersonManager.self, service: PersonManager(localPersonStorage: localPersonStorageService))
    
//    let localSelfEmotionStorageService: LocalSelfEmotionStorageServiceProtocol = LocalSelfEmotionStorageService()
//    let selfEmotionManager = SelfEmotionManager(localSelfEmotionStorageService: localSelfEmotionStorageService)
//    container.register(SelfEmotionManager.self, service: selfEmotionManager)
//    
//    let localUserStorageService: LocalUserStorageServiceProtocol = LocalUserStorageService()
//    let userManager = UserManager(localUserStorageService: localUserStorageService)
//    container.register(UserManager.self, service: userManager)
    
//    let webService: MBWebServiceProtocol = MBWebService.shared
//    container.register(MBWebServiceProtocol.self, service: webService)
//    
//    let analyzeManager = AnalyzeManager(webService: webService, userManager: userManager)
//    container.register(AnalyzeManager.self, service: analyzeManager)
}

