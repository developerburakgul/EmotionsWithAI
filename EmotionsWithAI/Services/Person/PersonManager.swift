//
//  PersonManager.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 9.06.2025.
//

import Foundation




protocol PersonManagerProtocol {
    
}

@MainActor
final class PersonManager: PersonManagerProtocol {
    
    private let localStorageService: LocalPersonStorageServiceProtocol
    
    
    init(localPersonStorage: LocalPersonStorageServiceProtocol) {
        self.localStorageService = localPersonStorage
    }
    
    func save(participantData: ParticipantDataModel, userLastMessageDate: Date)  {
        do {
            let person = fetchPerson(name: participantData.userInfo.name)
            
            if let person = person,
               let personEntity = try localStorageService.findPersonEntity(from: person) {
                
                let newMessages = participantData.messages.map { $0.convertToPersonMessage() }

                // Burada yeni mesajlara parent'larını atıyoruz
                for message in newMessages {
                    message.person = personEntity
                }
                let personLastDateForConversation = PersonHelper.getLastDateOfMessage(from: participantData.messages)
                let dateForLastMessageForAnalysis: Date = userLastMessageDate > personLastDateForConversation ? userLastMessageDate : personLastDateForConversation
                let updatedPersonEntity = PersonEntity(
                    id: personEntity.id,
                    name: personEntity.name,
                    messages: personEntity.messages + newMessages,
                    analysisDates: personEntity.analysisDates + [.now],
                    lastSentimentLabel: PersonHelper.getLastSentimentLabel(from: participantData.messages),
                    firstDateForConversation: personEntity.firstDateForConversation,
                    lastDateForConversation: personLastDateForConversation,
                    dateForLastMessageForAnalysis: dateForLastMessageForAnalysis
                )

                try localStorageService.updatePersonEntity(updatedPersonEntity)
            }else {
                let personLastDateForConversation = PersonHelper.getLastDateOfMessage(from: participantData.messages)
                let dateForLastMessageForAnalysis: Date = userLastMessageDate > personLastDateForConversation ? userLastMessageDate : personLastDateForConversation
                let personEntity = PersonEntity(
                    id: .init(),
                    name: participantData.userInfo.name,
                    analysisDates: [.now],
                    lastSentimentLabel: PersonHelper.getLastSentimentLabel(from: participantData.messages),
                    firstDateForConversation: PersonHelper.getFirstDateOfMessage(from: participantData.messages),
                    lastDateForConversation: personLastDateForConversation,
                    dateForLastMessageForAnalysis: dateForLastMessageForAnalysis
                )

                let messages = participantData.messages.map { $0.convertToPersonMessage() }
                for message in messages {
                    message.person = personEntity
                }
                personEntity.messages = messages

                try localStorageService.createPersonEntity(personEntity)
            }
        } catch  {
            
        }
        
    }
    
    func fetchAllPersons() throws -> [Person] {
        do {
            return try localStorageService.fetchAllPersons().map { $0.convertToPerson() }
        } catch  {
            print("Error loading persons \(error)")
            throw error
        }
    }
    
    func fetchPerson(name: String) -> Person? {
        return try? fetchAllPersons().first { person in
            person.name == name
        }
    }
    
    
    
    func addPersonEntity(_ personEntity: PersonEntity) throws(LocalPersonStorageError) {
        
        do {
            try localStorageService.createPersonEntity(personEntity)
        } catch {
            throw error
        }
    }
    
    func deletePerson(_ person: Person) throws(LocalPersonStorageError){
        do {
            guard let personEntity = try localStorageService.findPersonEntity(from: person) else {
                throw LocalUserStorageError.notFoundUserEntity
            }
            try localStorageService.deletePersonEntity(personEntity)
        } catch  {
            throw LocalPersonStorageError.notDeletedPersonEntity
        }
    }
    
    func updatePersonEntity(_ personEntity: PersonEntity) throws(LocalPersonStorageError) {
        do {
            try localStorageService.updatePersonEntity(personEntity)
        } catch {
            throw error
        }
    }
    
    
    func fetchPersonDetail(person: Person) throws(LocalPersonStorageError) -> PersonDetail? {
        
        do {
            guard let personEntity = try localStorageService.findPersonEntity(from: person) else {
                return nil
            }
            return PersonHelper.convertPersonEntityToPersonDetail(personEntity)
        } catch  {
            throw LocalPersonStorageError.couldntFetchPersonDetails
        }
    }
    
    func fetchCalendarModels(for personDetail: PersonDetail) async throws -> [CalendarModels] {
    
        do {
            guard let personEntity = try localStorageService.findPersonEntity(from: personDetail) else {
                throw LocalUserStorageError.notFoundUserEntity
            }
            return PersonHelper.getCalendarModels(from: personEntity)
        } catch  {
            throw LocalPersonStorageError.couldntFetchCalendarModels
        }
    }
    
}


