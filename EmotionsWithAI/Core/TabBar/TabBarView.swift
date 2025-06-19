//
//  MainView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 3.06.2025.
//

import SwiftUI

struct TabBarView: View {
    
    @EnvironmentObject var container: DependencyContainer
    @State private var selectedTab: Tabs = .home
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: HomeViewModel(container: container))
                .tabItem {
                    Label(Tabs.home.title, systemImage: Tabs.home.systemImageName)
                }
                .tag(Tabs.home)

            AnalysisView(viewModel: AnalysisViewModel(container: container))
                .tabItem {
                    Label(Tabs.analysis.title, systemImage: Tabs.analysis.systemImageName)
                }
                .tag(Tabs.analysis)

            PersonView(viewModel: PersonViewModel(container: container))
                .tabItem {
                    Label(Tabs.person.title, systemImage: Tabs.person.systemImageName)
                }
                .tag(Tabs.person)

            SettingsView(viewModel: SettingsViewModel(container: container))
                .tabItem {
                    Label(Tabs.settings.title, systemImage: Tabs.settings.systemImageName)
                }
                .tag(Tabs.settings)
        }
        .tint(.red)
    }
}

#Preview {
    TabBarView()
        .previewEnvironmentObject()
}
