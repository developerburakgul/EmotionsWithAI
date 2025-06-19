//
//  PreviewEnvironment.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 10.06.2025.
//

import Foundation
import SwiftUI

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
    var container: DependencyContainer {
        let container = DependencyContainer()
        container.register(PersonManager.self, service: personManager)
        return container
    }
        
    init() {
        let localPersonStorage = LocalPersonStorageService()
        personManager = PersonManager(localPersonStorage: localPersonStorage)
    }

}
