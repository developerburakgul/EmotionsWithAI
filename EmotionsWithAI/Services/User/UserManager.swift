//
//  UserManager.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 20.06.2025.
//

import Foundation

@MainActor
final class UserManager {
    private let localUserStorageService: LocalUserStorageServiceProtocol
    
    init(localUserStorageService: LocalUserStorageServiceProtocol) {
        self.localUserStorageService = localUserStorageService
    }
    
    func fetchUser() throws -> User {
        do {
            return try localUserStorageService.fetchUser().convertToUser()
        } catch  {
            print("Error loading User: \(error)")
            throw error
        }
    }
}
