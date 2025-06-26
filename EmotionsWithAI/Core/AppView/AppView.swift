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
        ZStack {
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
            
            LoaderOverlayView()
        }
        .onAppear {
            LoaderManager.shared.show(type: .analyzing)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                LoaderManager.shared.hide()
            }
        }
 
    }
}

#Preview {
    AppView()
        .previewEnvironmentObject()
}
