//
//  LocalUserStorageServiceProtocol.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 20.06.2025.
//

import Foundation
import SwiftData

@MainActor
protocol LocalUserStorageServiceProtocol {
    func fetchUser() throws(LocalUserStorageError) -> UserEntity
}

@MainActor
struct LocalUserStorageService: LocalUserStorageServiceProtocol {

    
    private let container: ModelContainer
    
    private var mainContext: ModelContext {
        container.mainContext
    }
    
    init() {
        self.container = SwiftDataManager.shared.container
    }
    
    func fetchUser() throws(LocalUserStorageError) -> UserEntity {
        return UserEntity(name: "burak")
    }
}

enum LocalUserStorageError: String, LocalizedError {
    case notFoundUserEntity
    case notCreatedUserEntity
    case notDeletedUserEntity
    
    var localizedDescription: String {
        return self.rawValue
    }
}
