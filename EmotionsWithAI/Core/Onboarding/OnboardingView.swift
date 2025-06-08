//
//  OnboardingView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 5.06.2025.
//

import SwiftUI


struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    var onboardingItems: [OnboardingItem] = OnboardingItem.mockData
    @State var currentOnboardingItem = OnboardingItem.mockData.first!
    var body: some View {
        
        NavigationStack {
            VStack {
                imageSection
                VStack {
                    titleAndDescription
                    Spacer()
                    nextButton
                }
                .padding()
            }
        }
        
    }
    
    private var imageSection: some View {
        TabView(selection: $currentOnboardingItem) {
            ForEach(onboardingItems, id: \.self) { item in
                Image(item.imageName)
                    .tag(item)
            }
            
        }
        .tabViewStyle(.page)
        .background(Color.red)
        .frame(maxWidth: .infinity)
        .padding(.bottom, 32)
    }
    
    @ViewBuilder
    private var titleAndDescription: some View {
        Text(currentOnboardingItem.title)
            .font(.title)
            .fontDesign(.serif)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .padding()
        
        
        Text(currentOnboardingItem.description)
            .font(.caption)
            .fontDesign(.serif)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    private var nextButton: some View {
        Button {
            nextButtonTapped()
        } label: {
            Text("Next")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(16)
                .foregroundStyle(UIColor.label.toColor)
        }
        
    }
    
    private func nextButtonTapped() {
        guard let index = onboardingItems.firstIndex(of: currentOnboardingItem) else { return }
        
        if index + 1 < onboardingItems.count {
            currentOnboardingItem = onboardingItems[index + 1]
        } else {
            appState.updateShowTabBar(true)
        }
    }
    
}

#Preview {
    OnboardingView()
        .previewEnvironmentObject()
}
