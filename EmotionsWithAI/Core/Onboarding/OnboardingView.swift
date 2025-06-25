////
////  OnboardingView.swift
////  EmotionsWithAI
////
////  Created by Burak Gül on 5.06.2025.
////
//
//import SwiftUI
//
//
//struct OnboardingView: View {
//    @EnvironmentObject var container: DependencyContainer
//    var onboardingItems: [OnboardingItem] = OnboardingItem.mockData
//    @State var showUserInfoEntryView: Bool = false
//    @State var currentOnboardingItem = OnboardingItem.mockData.first!
//    var body: some View {
//        
//        NavigationStack {
//            VStack {
//                imageSection
//                VStack {
//                    titleAndDescription
//                    Spacer()
//                    nextButton
//                }
//                .padding()
//            }
//            .navigationDestination(isPresented: $showUserInfoEntryView) {
//                UserInfoEntryView(viewModel: UserInfoEntryViewModel(container: container))
//            }
//        }
//        
//    }
//    
//    private var imageSection: some View {
//        TabView(selection: $currentOnboardingItem) {
//            ForEach(onboardingItems, id: \.self) { item in
//                Image(item.imageName)
//                    .tag(item)
//            }
//            
//        }
//        .tabViewStyle(.page)
//        .background(Color.red)
//        .frame(maxWidth: .infinity)
//        .padding(.bottom, 32)
//    }
//    
//    @ViewBuilder
//    private var titleAndDescription: some View {
//        Text(currentOnboardingItem.title)
//            .font(.title)
//            .fontDesign(.serif)
//            .fontWeight(.semibold)
//            .multilineTextAlignment(.center)
//            .padding()
//        
//        
//        Text(currentOnboardingItem.description)
//            .font(.caption)
//            .fontDesign(.serif)
//            .fontWeight(.semibold)
//            .multilineTextAlignment(.center)
//            .padding()
//    }
//    
//    private var nextButton: some View {
//        Button {
//            nextButtonTapped()
//        } label: {
//            Text("Next")
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.green)
//                .cornerRadius(16)
//                .foregroundStyle(UIColor.label.toColor)
//        }
//        
//    }
//    
//    private func nextButtonTapped() {
//        guard let index = onboardingItems.firstIndex(of: currentOnboardingItem) else { return }
//        
//        if index + 1 < onboardingItems.count {
//            currentOnboardingItem = onboardingItems[index + 1]
//        } else {
//            showUserInfoEntryView = true
//        }
//    }
//    
//}
//
//#Preview {
//    OnboardingView()
//        .previewEnvironmentObject()
//}


import SwiftUI
import UIKit // Haptic feedback için

struct OnboardingView: View {
    @EnvironmentObject var container: DependencyContainer
    var onboardingItems: [OnboardingItem] = OnboardingItem.data
    @State private var showUserInfoEntryView: Bool = false
    @State private var currentOnboardingItem = OnboardingItem.data.first!
    
    var body: some View {
        NavigationStack {
            VStack {
                imageSection
                VStack(spacing: 16) {
                    pageControl
                    titleAndDescription
                    Spacer()
                    nextButton
                    skipButton
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .background(AppStyles.backgroundGradient.ignoresSafeArea())
            .navigationDestination(isPresented: $showUserInfoEntryView) {
                UserInfoEntryView(viewModel: UserInfoEntryViewModel(container: container))
            }
        }
    }
    
    private var imageSection: some View {
        TabView(selection: $currentOnboardingItem) {
            ForEach(onboardingItems, id: \.self) { item in
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .padding(.vertical, 32)
                    .tag(item)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 350)
        .animation(.easeInOut, value: currentOnboardingItem)
    }
    
    private var pageControl: some View {
        HStack(spacing: 8) {
            ForEach(onboardingItems, id: \.self) { item in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(item == currentOnboardingItem ? AppStyles.primaryColor : AppStyles.secondaryColor)
                    .animation(.easeInOut, value: currentOnboardingItem)
            }
        }
        .padding(.top, 8)
    }
    
    private var titleAndDescription: some View {
        VStack(spacing: 12) {
            Text(currentOnboardingItem.title)
                .font(AppStyles.titleFont)
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
            
            Text(currentOnboardingItem.description)
                .font(AppStyles.descriptionFont)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .animation(.easeInOut, value: currentOnboardingItem)
    }
    
    private var nextButton: some View {
        Button(action: nextButtonTapped) {
            Text(isLastPage ? "Get Started" : "Next")
                .font(AppStyles.buttonFont)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [AppStyles.primaryColor, AppStyles.primaryColor.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .foregroundStyle(.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
        .scaleEffect(isLastPage ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isLastPage)
        .accessibilityLabel(isLastPage ? "Get Started" : "Next Page")
    }
    
    private var skipButton: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            showUserInfoEntryView = true
        }) {
            Text("Skip")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(AppStyles.primaryColor)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.9))
                        .overlay(
                            Capsule()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [AppStyles.primaryColor, AppStyles.primaryColor.opacity(0.6)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                )
        }
        .opacity(isLastPage ? 0 : 1)
        .scaleEffect(isLastPage ? 0.8 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isLastPage)
        .accessibilityLabel("Skip Onboarding")
    }
    
    private var isLastPage: Bool {
        onboardingItems.last == currentOnboardingItem
    }
    
    private func nextButtonTapped() {
        guard let index = onboardingItems.firstIndex(of: currentOnboardingItem) else { return }
        if index + 1 < onboardingItems.count {
            currentOnboardingItem = onboardingItems[index + 1]
        } else {
            showUserInfoEntryView = true
        }
    }
}


#Preview {
    OnboardingView()
        .previewEnvironmentObject()
}
