//
//  SelfEmotionManager.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 12.06.2025.
//

import Foundation
import SwiftData

@Model
class SelfUserEntity {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

@MainActor
protocol LocalSelfEmotionStorageServiceProtocol {
    func fetchSelfUserEntity() -> SelfUserEntity?
}

@MainActor
final class SelfEmotionManager {
    let localSelfEmotionStorageService: LocalSelfEmotionStorageServiceProtocol
    
    init(localSelfEmotionStorageService: LocalSelfEmotionStorageServiceProtocol) {
        self.localSelfEmotionStorageService = localSelfEmotionStorageService
    }
    
    func fetchSelfUser() -> SelfUser? {
        return nil
    }
}

@MainActor
struct LocalSelfEmotionStorageService: LocalSelfEmotionStorageServiceProtocol {
    
    private let container: ModelContainer
    
    private var mainContext: ModelContext {
        container.mainContext
    }
    
    init() {
        self.container = SwiftDataManager.shared.container
    }
    
    func fetchSelfUserEntity() -> SelfUserEntity? {
        nil
    }
}
