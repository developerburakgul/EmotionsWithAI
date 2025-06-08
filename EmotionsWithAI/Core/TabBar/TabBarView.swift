//
//  MainView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 3.06.2025.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Tabs = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(Tabs.home.title, systemImage: Tabs.home.systemImageName)
                }
                .tag(Tabs.home)

            AnalysisView()
                .tabItem {
                    Label(Tabs.analysis.title, systemImage: Tabs.analysis.systemImageName)
                }
                .tag(Tabs.analysis)

            PersonView()
                .tabItem {
                    Label(Tabs.person.title, systemImage: Tabs.person.systemImageName)
                }
                .tag(Tabs.person)

            SettingsView()
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
}
