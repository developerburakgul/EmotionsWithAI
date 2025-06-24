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
    static let data: [OnboardingItem] = [
        .init(title: "Step 1", description: "Open Whatsapp", imageName: "Onboarding1"),
        .init(title: "Step 2", description: "Select Conversation", imageName: "Onboarding2"),
        .init(title: "Step 3", description: "Click Name Of Person", imageName: "Onboarding3"),
        .init(title: "Step 4", description: "Scroll Down", imageName: "Onboarding4"),
        .init(title: "Step 5", description: "Click Export Chat", imageName: "Onboarding5"),
        .init(title: "Step 6", description: "Select Without media", imageName: "Onboarding6"),
        .init(title: "Step 7", description: "Select Save to Files", imageName: "Onboarding7"),
        .init(title: "Step 8", description: "Click Green Circle", imageName: "Onboarding8")
    ]
    
    static let Onboarding9: OnboardingItem = .init(title: "Last Step", description: "Enter yourself username", imageName: "Onboarding9")
}
