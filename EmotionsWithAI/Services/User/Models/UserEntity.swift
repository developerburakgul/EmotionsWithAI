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
    
    init(
        id: UUID = .init(),
        name: String
    ) {
        self.id = id
        self.name = name
    }
}

extension UserEntity {
    func convertToUser() -> User {
        return User(name: self.name)
    }
}


struct User {
    let name: String
}
