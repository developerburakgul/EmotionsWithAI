//
//  PremiumUpgradeView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 24.06.2025.
//


import SwiftUI

@MainActor
final class PremiumUpgradeViewModel: ObservableObject {
    @Published var isLoading = false
    let userManager: UserManager
    
    init(container: DependencyContainer) {
        self.userManager = container.resolve(UserManager.self)!
    }
    
    func upgradeToPremium() async {
        isLoading = true
        isLoading = false
    }
}


struct PremiumUpgradeView: View {
    @StateObject var viewModel: PremiumUpgradeViewModel
    @State private var selectedPlan: String = "Monthly" // Tracks selected plan
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.1), .white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    // Header Section
                    VStack(spacing: 12) {
                        Image(systemName: "crown.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.yellow)
                            .shadow(radius: 4)
                        
                        Text("Unlock Premium")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)
                        
                        Text("Get the full EmotionsWithAI experience")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 40)
                    
                    // Benefits Section
                    VStack(spacing: 16) {
                        FeatureRow(
                            icon: "bolt.fill",
                            title: "AI Request Quota",
                            description: selectedPlan == "Monthly" ? "100 AI requests/month" : "1500 AI requests/year"
                        )
                        FeatureRow(
                            icon: "star.circle.fill",
                            title: "Exclusive AI Insights",
                            description: "Access advanced emotional analysis powered by AI."
                        )
                        FeatureRow(
                            icon: "lock.open.fill",
                            title: "Unlimited Access",
                            description: "Use all premium features without restrictions."
                        )
                        FeatureRow(
                            icon: "chart.bar.fill",
                            title: "Detailed Reports",
                            description: "Get in-depth analytics and personalized reports."
                        )
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    // Pricing Section
                    VStack(spacing: 12) {
                        Text("Choose Your Plan")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        HStack(spacing: 12) {
                            PlanCard(
                                title: "Monthly",
                                price: "$4.99",
                                description: "Billed monthly",
                                isSelected: selectedPlan == "Monthly",
                                action: { selectedPlan = "Monthly" }
                            )
                            PlanCard(
                                title: "Yearly",
                                price: "$49.99",
                                description: "Save 20%",
                                isSelected: selectedPlan == "Yearly",
                                action: { selectedPlan = "Yearly" }
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Call to Action
                    Button(action: {
                        Task { await viewModel.upgradeToPremium() }
                    }) {
                        Text(viewModel.isLoading ? "Processing..." : "Confirm Upgrade")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.isLoading ? .gray : .blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                            .disabled(viewModel.isLoading)
                    }
                    .padding(.top, 20)
                    
                    // Restore Purchases and Terms
                    VStack(spacing: 8) {
                        Button("Restore Purchases") {
                            // Add restore purchase logic
                        }
                        .font(.caption)
                        .foregroundStyle(.blue)
                        
                        Text("By upgrading, you agree to our [Terms of Service](https://example.com/terms) and [Privacy Policy](https://example.com/privacy).")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding(.bottom, 40)
            }
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
}

// Reusable Feature Row
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.blue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

// Reusable Plan Card
struct PlanCard: View {
    let title: String
    let price: String
    let description: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
            
            Text(price)
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)
            
            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
        )
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    let container = DevPreview.shared.container
    PremiumUpgradeView(viewModel: PremiumUpgradeViewModel(container: container))
        .previewEnvironmentObject()
}
