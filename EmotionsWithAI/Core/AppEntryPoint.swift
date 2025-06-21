//
//  EmotionsWithAIApp.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 1.06.2025.
//

import SwiftUI
import SwiftData
import MBWebService

@main
struct AppEntryPoint {
    static func main() {
        EmotionsWithAI.main()
    }
}


struct EmotionsWithAI: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            AppView()
        }
        .environmentObject(delegate.dependencies.container)

    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var dependencies: Dependencies!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        dependencies = Dependencies(container: .init())
        return true
    }
}


@MainActor
struct Dependencies {
    let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
        let localPersonStorageService = LocalPersonStorageService()
        
        let localSelfEmotionStorageService: LocalSelfEmotionStorageServiceProtocol = LocalSelfEmotionStorageService()
        let selfEmotionManager = SelfEmotionManager(localSelfEmotionStorageService: localSelfEmotionStorageService)
        container.register(LocalPersonStorageService.self, service: localPersonStorageService)
        container.register(PersonManager.self, service: PersonManager(localPersonStorage: localPersonStorageService))
        
        container.register(SelfEmotionManager.self, service: selfEmotionManager)
        
        let localUserStorageService: LocalUserStorageServiceProtocol = LocalUserStorageService()
        let userManager = UserManager(localUserStorageService: localUserStorageService)
        
        container.register(UserManager.self, service: userManager)
        let webService: MBWebServiceProtocol = MBWebService.shared
        container.register(MBWebServiceProtocol.self, service: webService)
        let analyzeManager = AnalyzeManager(webService: webService)
        container.register(AnalyzeManager.self, service: analyzeManager)
        
        container.register(AnalyzeManager.self, service: analyzeManager)
    }
    
}


@MainActor
class DependencyContainer: ObservableObject {
    private var services: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, service: T) {
        let key = "\(type)"
        services[key] = service
    }
    
    func register<T>(_ type: T.Type, service: () -> T) {
        let key = "\(type)"
        services[key] = service()
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        let key = "\(type)"
        return services[key] as? T
    }
}
