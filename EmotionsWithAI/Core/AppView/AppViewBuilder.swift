//
//  AppViewBuilder.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 5.06.2025.
//

import SwiftUI

struct AppViewBuilder<OnboardingView: View, TabBarView: View>: View {

    @ViewBuilder var onboardingView: () -> OnboardingView
    @ViewBuilder var tabBarView: () -> TabBarView
    var showTabBarView: Bool = false
    var body: some View {
        ZStack {
            if showTabBarView {
                tabBarView()
            } else {
                onboardingView()
            }
        }
    }
}

#Preview("OnBoarding") {
    AppViewBuilder(onboardingView: {
        OnboardingView()
    }, tabBarView: {
        TabBarView()
    }, showTabBarView: false)
}

#Preview("TabBar") {
    AppViewBuilder(onboardingView: {
        OnboardingView()
    }, tabBarView: {
        TabBarView()
    }, showTabBarView: true)
}
