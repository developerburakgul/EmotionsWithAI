//
//  LocalPersonStorageService.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 9.06.2025.
//

import Foundation
import SwiftData

@MainActor
struct LocalPersonStorageService: LocalPersonStorageServiceProtocol {
    private let container: ModelContainer
    
    private var mainContext: ModelContext {
        container.mainContext
    }
    
    init() {
        self.container = SwiftDataManager.shared.container
    }
    
    func fetchAllPersons() throws -> [PersonEntity] {
        let descriptor = FetchDescriptor<PersonEntity>()
        let personEntities: [PersonEntity] = try mainContext.fetch(descriptor)
        return personEntities

    }
    
    func createPersonEntity(_ personEntity: PersonEntity) throws(LocalPersonStorageError) {
        mainContext.insert(personEntity)
        do {
            try mainContext.save()
        }catch {
            throw .notCreatedPersonEntity
        }
    }
    
    func deletePersonEntity(_ personEntity: PersonEntity) throws(LocalPersonStorageError) {
        mainContext.delete(personEntity)
        
        do {
            try mainContext.save()
        }catch {
            throw .notDeletedPersonEntity
        }
    }
    
    func findPersonEntity(from person: Person) throws(LocalPersonStorageError) -> PersonEntity {
        let descriptor = FetchDescriptor<PersonEntity>()
        do {
            let personEntities: [PersonEntity] = try mainContext.fetch(descriptor)
            let personEntity = personEntities.first { $0.id == person.id }
            
            guard let personEntity = personEntity else {
                throw LocalPersonStorageError.notFoundPersonEntity
            }
            return personEntity
        } catch {
            throw LocalPersonStorageError.notFoundPersonEntity
        }
    }
    func findPersonEntity(from personDetail: PersonDetail) throws(LocalPersonStorageError) -> PersonEntity {
        let descriptor = FetchDescriptor<PersonEntity>()
        do {
            let personEntities: [PersonEntity] = try mainContext.fetch(descriptor)
            let personEntity = personEntities.first { $0.id == personDetail.id }
            
            guard let personEntity = personEntity else {
                throw LocalPersonStorageError.notFoundPersonEntity
            }
            return personEntity
        } catch {
            throw LocalPersonStorageError.notFoundPersonEntity
        }
    }
    
    
    func updatePersonEntity(_ personEntity: PersonEntity) throws(LocalPersonStorageError) {
        //MARK: - TODO
    }
        
    
}



@MainActor
protocol LocalPersonStorageServiceProtocol {
    func fetchAllPersons() throws -> [PersonEntity]
    func createPersonEntity(_ personEntity: PersonEntity) throws(LocalPersonStorageError)
    func deletePersonEntity(_ personEntity: PersonEntity) throws(LocalPersonStorageError)
    func findPersonEntity(from person: Person) throws(LocalPersonStorageError) -> PersonEntity
    func findPersonEntity(from personDetail: PersonDetail) throws(LocalPersonStorageError) -> PersonEntity
    func updatePersonEntity(_ personEntity: PersonEntity) throws(LocalPersonStorageError)
}

enum LocalPersonStorageError: String, LocalizedError {
    case failedToCreatePersonEntity
    case alreadyTherePersonEntity
    case notFoundPersonEntity
    case notCreatedPersonEntity
    case notDeletedPersonEntity
    case couldntFetchPersonDetails
    case couldntFetchCalendarModels
    
    var localizedDescription: String {
        return self.rawValue
    }
}
