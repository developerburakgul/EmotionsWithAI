//
//  UserEntity.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 20.06.2025.
//

import Foundation
import SwiftData

@Model
class UserEntity {
    @Attribute(.unique)
    var id: UUID
    var name: String
    var requestCount: Int
    var isPremium: Bool = false
    var totalRequestCount: Int = 10

    @Relationship
    var selfUserEntity: SelfUserEntity?

    init(
        id: UUID = UUID(),
        name: String,
        requestCount: Int = 0,
        selfUserEntity: SelfUserEntity? = nil,
        isPremium: Bool = false,
        totalRequestCount: Int = 10
    ) {
        self.id = id
        self.name = name
        self.requestCount = requestCount
        self.selfUserEntity = selfUserEntity
        self.isPremium = isPremium
        self.totalRequestCount = totalRequestCount
    }
}

extension UserEntity {
    func convertToUser() -> User {
        User(
            id: self.id,
            name: self.name,
            requestCount: self.requestCount,
            isPremium: self.isPremium,
            totalRequestCount: self.totalRequestCount
            
        )
    }
}

struct User {
    let id: UUID
    let name: String
    let requestCount: Int
    let isPremium: Bool
    let totalRequestCount: Int
}
