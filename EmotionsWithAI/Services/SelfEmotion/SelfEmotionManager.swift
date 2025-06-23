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
    let localUserStorageService: LocalUserStorageServiceProtocol
    
    init(
        localSelfEmotionStorageService: LocalSelfEmotionStorageServiceProtocol,
        localUserStorageService: LocalUserStorageServiceProtocol
    ) {
        self.localSelfEmotionStorageService = localSelfEmotionStorageService
        self.localUserStorageService = localUserStorageService
    }
    
    func fetchSelfUser() async throws -> SelfUser {
        do {
            let id = try localUserStorageService.fetchUser()?.id
            guard let id else {
                throw SelfEmotionError.couldntFindUserID
            }
            
            return try localSelfEmotionStorageService.fetchSelfUserEntity(id: id).convertToSelfUser()
        } catch  {
            print("Error loading SelfUser: \(error)")
            throw error
        }
    }
    
    func save(participantData: ParticipantDataModel) {
        do {
            guard let id = try localUserStorageService.fetchUser()?.id else { return }

            let selfUserEntity = try localSelfEmotionStorageService.fetchSelfUserEntity(id: id)


            selfUserEntity.messages += SelfEmotionManagerHelper.convertParticipantDataToSelfUserMessage(participantData)
            selfUserEntity.analysisDates.append(.now)
            selfUserEntity.lastSentimentLabel = SelfEmotionManagerHelper.getLastSentimentLabel(participantData: participantData)
            try localSelfEmotionStorageService.updateSelfUserEntity(selfUserEntity)
            
        } catch {
            print("error : \(error)")
        }
    }
}


enum SelfEmotionError: String, LocalizedError {
    case couldntFindUserID
    
    
    var localizedDescription: String {
        return self.rawValue
    }
}
