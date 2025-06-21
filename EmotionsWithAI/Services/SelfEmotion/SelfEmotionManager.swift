//
//  SelfEmotionManager.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 12.06.2025.
//

import Foundation
import SwiftData





@MainActor
final class SelfEmotionManager {
    let localSelfEmotionStorageService: LocalSelfEmotionStorageServiceProtocol
    
    init(
        localSelfEmotionStorageService: LocalSelfEmotionStorageServiceProtocol
    ) {
        self.localSelfEmotionStorageService = localSelfEmotionStorageService
    }
    
    func fetchSelfUser() async throws -> SelfUser {
        do {
            return try localSelfEmotionStorageService.fetchSelfUserEntity().convertToSelfUser()
        } catch  {
            print("Error loading SelfUser: \(error)")
            throw error
        }
    }
}


