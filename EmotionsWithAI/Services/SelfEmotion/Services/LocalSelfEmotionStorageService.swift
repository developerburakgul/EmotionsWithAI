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
    func fetchSelfUserEntity() throws(LocalSelfEmotionStorageError) -> SelfUserEntity
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
    
    func fetchSelfUserEntity() throws(LocalSelfEmotionStorageError) -> SelfUserEntity {
        do {
            //MARK: - TODO
            return SelfUserEntity(name: "Burak", lastSentimentLabel: .anger)
        } catch  {
            throw .notFoundSelfUserEntity
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
        //MARK: - TODO
    }
}

enum LocalSelfEmotionStorageError: String, LocalizedError {
    case notFoundSelfUserEntity
    case notCreatedSelfUserEntity
    case notDeletedSelfUserEntity
    
    var localizedDescription: String {
        return self.rawValue
    }
}
