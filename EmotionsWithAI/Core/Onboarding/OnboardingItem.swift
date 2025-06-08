//
//  OnboardingItem.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 5.06.2025.
//

import Foundation

struct OnboardingItem: Hashable {
    let title: String
    let description: String
    let imageName: String
}

extension OnboardingItem {
    static let mockData: [OnboardingItem] = [
        .init(title: "Emotions With AI 1", description: "Lorem ipsum dolor sit amet 1", imageName: "squareImage"),
        .init(title: "Emotions With AI 2", description: "Lorem ipsum dolor sit amet 2", imageName: "squareImage"),
        .init(title: "Emotions With AI 3", description: "Lorem ipsum dolor sit amet 3", imageName: "squareImage"),
    ]
}
