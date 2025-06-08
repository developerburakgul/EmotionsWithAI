//
//  AppView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 5.06.2025.
//

import SwiftUI

struct AppView: View {
    @StateObject var appState = AppState()
    var body: some View {
        AppViewBuilder(
            onboardingView: {
                OnboardingView()
                    
            },
            tabBarView: {
                TabBarView()
            },
            showTabBarView: appState.showTabbar
        )
        .environmentObject(appState)
    }
}

#Preview {
    AppView()
}
