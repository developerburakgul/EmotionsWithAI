//
//  SettingsView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 3.06.2025.
//

import SwiftUI





struct SettingsView: View {
    
    @StateObject var viewModel: SettingsViewModel
    @State var selectedLanguage: String = "en"
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                mainContent
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.large)
            
            }
            
        }
    }
    
    private var mainContent: some View {
        Form {
            Section("App Settings") {
                notification
                darkMode
                language
            }
            
            Section("Data") {
                importSection
                exportSection
            }
        }

    }
    
    //MARK: - App Settings
    private var notification: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: "heart.fill")
            Toggle(isOn: .constant(false)) {
                Text("Notifications")
            }
        }
    }
    
    private var darkMode: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: "moon.fill")
                .foregroundStyle(Color.yellow)
            Toggle(isOn: .constant(true)) {
                Text("Dark Mode")
            }
        }
    }
    
    private var language: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: "globe")
                .foregroundStyle(Color.blue)
            Text("Language")
            Spacer()
            
            
            Menu {
                Picker("", selection: $viewModel.selectedLanguage) {
                    ForEach(viewModel.allLanguages) { language in
                        Text(language.languageModel.name)
                            .tag(language)
                    }
                }
            } label: {
                Text(viewModel.selectedLanguage.languageModel.name)
            }
        }

    }
    
    //MARK: - Data
    private var importSection: some View {
        HStack(alignment: .center, spacing: 8) {
            Text("Import")
            Spacer()
            Image(systemName: "square.and.arrow.down.on.square.fill")
                .foregroundStyle(Color.blue)
        }
    }
    private var exportSection: some View {
        HStack(alignment: .center, spacing: 8) {
            Text("Export")
            Spacer()
            Image(systemName: "square.and.arrow.up.on.square.fill")
                .foregroundStyle(Color.blue)
        }
    }

}

//#Preview {
//    SettingsView()
//}
