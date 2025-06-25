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
    private let storeKitService: StoreKitService
    init(
        localUserStorageService: LocalUserStorageServiceProtocol,
        localSelfEmotionStorageService: LocalSelfEmotionStorageServiceProtocol,
        storeKitService: StoreKitService
    ) {
        self.localUserStorageService = localUserStorageService
        self.localSelfEmotionStorageService = localSelfEmotionStorageService
        self.storeKitService = storeKitService
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
    
    func canAnalyzeMessage() -> Bool {
        do {
            let user = try localUserStorageService.fetchUser()
            guard let user else { throw GenericError.detail("Couldn't fetch user") }
            if user.isPremium || user.requestCount < user.totalRequestCount {
                return true
            }else {
                return false
            }
        } catch  {
            print("Error \(error)")
            return false
        }
    }
    
    func increaseRequestCount() throws {
            let user = try localUserStorageService.fetchUser()
            guard let user else { return  }
            user.requestCount += 1
    }
    
    func upgradeToPremium() async throws {
        // Simulate: In-app purchase
        try await Task.sleep(for: .seconds(1))

    }
    
  

    
    func createUser(name: String) {
        do {
            let sharedID = UUID()  // Common ID

            let user = UserEntity(
                id: sharedID,
                name: name,
                requestCount: 0,
                selfUserEntity: nil,
                totalRequestCount: 3
            )
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
    
    func exportUserData(to url: URL) async throws {
        do {
   
        } catch {
            print("Error exporting user data: \(error)")
            throw error
        }
    }

    func importUserData(from url: URL) async throws {
        do {

        } catch {
            print("Error importing user data: \(error)")
            throw error
        }
    }
    
    func restorePurchases() async throws {
        
    }
}
