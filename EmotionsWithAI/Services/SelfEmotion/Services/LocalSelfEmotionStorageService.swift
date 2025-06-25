//
//  LocalSelfEmotionStorageService.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 19.06.2025.
//
import Foundation
import SwiftData



@MainActor
protocol LocalSelfEmotionStorageServiceProtocol {
    func fetchSelfUserEntity(id: UUID) throws(LocalSelfEmotionStorageError) -> SelfUserEntity
    func createSelfUserEntity(_ selfUserEntity: SelfUserEntity) throws(LocalSelfEmotionStorageError)
    func deleteSelfUserEntity(_ selfUserEntity: SelfUserEntity) throws(LocalSelfEmotionStorageError)
    
    func updateSelfUserEntity(_ selfUserEntity: SelfUserEntity) throws(LocalSelfEmotionStorageError)
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
    
    func fetchSelfUserEntity(id: UUID) throws(LocalSelfEmotionStorageError) -> SelfUserEntity {
        let localID = id
        let descriptor = FetchDescriptor<SelfUserEntity>(
            predicate: #Predicate { $0.id == localID }
        )
        
        do {
            let results = try mainContext.fetch(descriptor)
            guard let entity = results.first else {
                throw LocalSelfEmotionStorageError.notFoundSelfUserEntity
            }
            return entity
        } catch {
            throw LocalSelfEmotionStorageError.notFoundSelfUserEntity
        }
    }
    
    func createSelfUserEntity(_ selfUserEntity: SelfUserEntity) throws(LocalSelfEmotionStorageError) {
        mainContext.insert(selfUserEntity)
        
        do {
            try mainContext.save()
        }catch {
            throw .notCreatedSelfUserEntity
        }
    }
    
    func deleteSelfUserEntity(_ selfUserEntity: SelfUserEntity) throws(LocalSelfEmotionStorageError) {
        mainContext.delete(selfUserEntity)
        
        do {
            try mainContext.save()
        }catch {
            throw .notDeletedSelfUserEntity
        }
    }
    
    func updateSelfUserEntity(_ selfUserEntity: SelfUserEntity) throws(LocalSelfEmotionStorageError) {
        do {
            try mainContext.save()
        }catch {
            throw .notUpdatedSelfUserEntity
        }
    }
}

enum LocalSelfEmotionStorageError: String, LocalizedError {
    case notFoundSelfUserEntity
    case notCreatedSelfUserEntity
    case notDeletedSelfUserEntity
    case notUpdatedSelfUserEntity
    
    var localizedDescription: String {
        return self.rawValue
    }
}
