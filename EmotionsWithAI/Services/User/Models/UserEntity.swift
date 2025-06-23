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

    @Relationship
    var selfUserEntity: SelfUserEntity?

    init(id: UUID = UUID(), name: String, requestCount: Int = 0, selfUserEntity: SelfUserEntity? = nil) {
        self.id = id
        self.name = name
        self.requestCount = requestCount
        self.selfUserEntity = selfUserEntity
    }
}

extension UserEntity {
    func convertToUser() -> User {
        User(id: self.id, name: self.name)
    }
}

struct User {
    let id: UUID
    let name: String
}
