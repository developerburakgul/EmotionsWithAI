//
//  Person.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 7.06.2025.
//

import Foundation

struct Person: Identifiable, Hashable {
    let id: UUID
    let name: String
    let mostSentiment: Sentiment
    
    init(
        id: UUID = .init(),
        name: String,
        mostSentiment: Sentiment
    ) {
        self.id = id
        self.name = name
        self.mostSentiment = mostSentiment
    }
}

extension Person {
    public static func getMockData(_ count: Int = 100) -> [Person] {
        var returnArray: [Person] = []
        for item in 0..<count {
            returnArray.append(Person(name: "Name \(item)", mostSentiment: .getRandom()))
        }
        return returnArray
    }
}
