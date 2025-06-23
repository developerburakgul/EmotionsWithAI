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
    func fetchUser() throws(LocalUserStorageError) -> UserEntity?
    func createUser(_ user: UserEntity) throws(LocalUserStorageError)
    func deleteUser(_ user: UserEntity) throws(LocalUserStorageError)
    func updateUserEntity(_ user: UserEntity) throws(LocalUserStorageError)
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
    
    
    func createUser(_ user: UserEntity) throws(LocalUserStorageError) {
        mainContext.insert(user)
        do {
            try mainContext.save()
        } catch  {
            throw .notCreatedUserEntity
        }
    }
    
    func fetchUser() throws(LocalUserStorageError) -> UserEntity? {
        let descriptor = FetchDescriptor<UserEntity>()
        do {
            let userEntities: [UserEntity] = try mainContext.fetch(descriptor)
            if userEntities.count != 1 {
                return nil
            }
            let userEntity = userEntities[0]

            return userEntity
        } catch {
            throw LocalUserStorageError.userEntityNotFound
        }
    }
    
    func deleteUser(_ user: UserEntity) throws(LocalUserStorageError) {
        mainContext.delete(user)
        
        do {
            try mainContext.save()
        }catch {
            throw .notDeletedUserEntity
        }
    }
    
    func updateUserEntity(_ user: UserEntity) throws(LocalUserStorageError) {
        mainContext.insert(user)
        
        do {
            try mainContext.save()
        }catch {
            throw .notDeletedUserEntity
        }
    }
    

}

enum LocalUserStorageError: String, LocalizedError {
    case notFoundUserEntity
    case notCreatedUserEntity
    case notDeletedUserEntity
    case userEntityNotFound
    
    var localizedDescription: String {
        return self.rawValue
    }
}
