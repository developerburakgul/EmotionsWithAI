////
////  UserInfoEntryView.swift
////  EmotionsWithAI
////
////  Created by Burak Gül on 22.06.2025.
////
//
//import SwiftUI
//
//@MainActor
//final class UserInfoEntryViewModel: ObservableObject {
//    
//    @Published var userName: String = ""
//    private let userManager: UserManager
//    
//    init(container: DependencyContainer) {
//        self.userManager = container.resolve(UserManager.self)!
//    }
//    
//    func saveUserName(_ completion: () -> ()) {
//        guard !userName.isEmpty else { return }
//        LoaderManager.shared.show(type: .analyzing)
//        userManager.createUser(name: userName)
//        
//        LoaderManager.shared.hide()
//        completion()
//        
//    }
//}
//
//import SwiftUI
//
//struct UserInfoEntryView: View {
//    @StateObject var viewModel: UserInfoEntryViewModel
//    @EnvironmentObject var appState: AppState
//
//    var body: some View {
//        VStack(spacing: 32) {
//            Spacer()
//
//            VStack(spacing: 16) {
//                Text("Let's Get Started!")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.center)
//
//                Text("Before we begin, please enter your name.")
//                    .font(.body)
//                    .foregroundStyle(.secondary)
//                    .multilineTextAlignment(.center)
//            }
//            .padding(.horizontal)
//
//            TextFieldView
//
//            Spacer()
//
//            nextButton
//        }
//        .padding()
//        .background(
//            LinearGradient(
//                gradient: Gradient(colors: [.white, .green.opacity(0.1)]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()
//        )
//    }
//
//    private var TextFieldView: some View {
//        TextField("Your name", text: $viewModel.userName)
//            .textFieldStyle(.roundedBorder)
//            .padding(.horizontal)
//            .autocapitalization(.words)
//            .disableAutocorrection(true)
//    }
//
//    private var nextButton: some View {
//        Button(action: nextButtonTapped) {
//            Text("Continue")
//                .fontWeight(.semibold)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(viewModel.userName.isEmpty ? Color.gray.opacity(0.3) : Color.green)
//                .foregroundStyle(.white)
//                .cornerRadius(16)
//                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
//        }
//        .padding(.horizontal)
//        .disabled(viewModel.userName.isEmpty)
//    }
//
//    private func nextButtonTapped() {
//        viewModel.saveUserName {
//            appState.updateShowTabBar(true)
//        }
//    }
//}
//
//#Preview {
//    let container = DevPreview.shared.container
//    UserInfoEntryView(viewModel: .init(container: container))
//        .previewEnvironmentObject()
//}
import SwiftUI
import UIKit // Haptic feedback için

@MainActor
final class UserInfoEntryViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var showError: Bool = false
    private let userManager: UserManager
    
    init(container: DependencyContainer) {
        self.userManager = container.resolve(UserManager.self)!
    }
    
    func saveUserName(_ completion: @escaping () -> Void) {
        guard !userName.isEmpty else {
            showError = true
            return
        }
        LoaderManager.shared.show(type: .analyzing)
        userManager.createUser(name: userName)
        LoaderManager.shared.hide()
        completion()
    }
}

struct UserInfoEntryView: View {
    @StateObject var viewModel: UserInfoEntryViewModel
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 32) {
            imageSection // Yeni: Görsel alanı eklendi
            VStack(spacing: 16) {
                Text("Let's Get Started!")
                    .font(AppStyles.titleFont)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Before we begin, please enter your name.")
                    .font(AppStyles.descriptionFont)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
            
            TextFieldView
            
            if viewModel.showError {
                Text("Please enter a valid name.")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .transition(.opacity)
            }
            
            Spacer()
            
            nextButton
            backButton
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .background(AppStyles.backgroundGradient.ignoresSafeArea())
        .animation(.easeInOut, value: viewModel.showError)
        .navigationBarHidden(true)
    }
    
    private var imageSection: some View {
        Image(OnboardingItem.mockData.last?.imageName ?? "onboarding3") // Son onboarding görseli veya varsayılan
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: 300)
            .padding(.vertical, 32)
    }
    
    private var TextFieldView: some View {
        TextField("Your name", text: $viewModel.userName)
            .font(.body)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(viewModel.showError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal)
            .autocapitalization(.words)
            .disableAutocorrection(true)
    }
    
    private var nextButton: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            nextButtonTapped()
        }) {
            Text("Continue")
                .font(AppStyles.buttonFont)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [viewModel.userName.isEmpty ? AppStyles.secondaryColor : AppStyles.primaryColor, viewModel.userName.isEmpty ? AppStyles.secondaryColor : AppStyles.primaryColor.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .foregroundStyle(.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
        .disabled(viewModel.userName.isEmpty)
        .scaleEffect(viewModel.userName.isEmpty ? 1.0 : 1.05)
        .animation(.easeInOut(duration: 0.3), value: viewModel.userName.isEmpty)
        .accessibilityLabel("Continue to main app")
    }
    
    private var backButton: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            dismiss()
        }) {
            Text("Back")
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
        .accessibilityLabel("Back to Onboarding")
    }
    
    private func nextButtonTapped() {
        viewModel.saveUserName {
            appState.updateShowTabBar(true)
        }
    }
}

#Preview {
    let container = DevPreview.shared.container
    UserInfoEntryView(viewModel: .init(container: container))
        .previewEnvironmentObject()
}
