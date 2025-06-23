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
    private let localSelfEmotionStorageService: LocalSelfEmotionStorageServiceProtocol
    init(
        localUserStorageService: LocalUserStorageServiceProtocol,
        localSelfEmotionStorageService: LocalSelfEmotionStorageServiceProtocol
    ) {
        self.localUserStorageService = localUserStorageService
        self.localSelfEmotionStorageService = localSelfEmotionStorageService
    }
    
    func fetchUser() throws -> User? {
        do {
            print("\(#function) is executed")
            return try localUserStorageService.fetchUser()?.convertToUser()
            
        } catch  {
            print("Error loading User: \(error)")
            throw error
        }
    }
    
    func isUser(name: String) -> Bool {
        false
        //MARK: - todo
    }
    
    func increaseRequestCount() {
        do {
            let user = try localUserStorageService.fetchUser()
            guard let user else { return  }
            
           try localUserStorageService.updateUserEntity(
                UserEntity(
                    id: user.id,
                    name: user.name,
                    requestCount: user.requestCount + 1,
                    selfUserEntity: user.selfUserEntity
                )
            )
            
        } catch  {
            
        }
        
    }
    
  

    
    func createUser(name: String) {
        do {
            let sharedID = UUID()  // Common ID

            let user = UserEntity(id: sharedID, name: name,requestCount: 0, selfUserEntity: nil)
            let selfUser = SelfUserEntity(
                id: sharedID,
                name: user.name,
                messages: [],
                analysisDates: [],
                lastSentimentLabel: nil
            )

            // İlişkileri kur
            user.selfUserEntity = selfUser
            selfUser.userEntity = user

            // Veritabanına kaydet
            try localUserStorageService.createUser(user)
            try localSelfEmotionStorageService.createSelfUserEntity(selfUser)

        } catch {
            print("Kullanıcı oluşturma hatası: \(error)")
        }
    }
}
