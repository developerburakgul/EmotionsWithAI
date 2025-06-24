//
//  SettingsViewModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 7.06.2025.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var selectedLanguage: Language = .english
    @Published var allLanguages: [Language] = Language.allCases
    @Published var username: String = "Yükleniyor..."
    @Published var totalRequests: Int = 0
    @Published var usedRequests: Int = 0
    @Published var remainingRequests: Int = 0
    @Published var isPremium: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showFileImporterForImport: Bool = false
    @Published var showFileImporterForExport: Bool = false
    @Published var shouldNavigateToPremium: Bool = false

    private let userManager: UserManager

    init(container: DependencyContainer) {
        self.userManager = container.resolve(UserManager.self)!
        fetchUserData()
    }

    func fetchUserData() {
        isLoading = true
        errorMessage = nil
        do {
            let userData = try userManager.fetchUser()
            username = userData?.name ?? ""
            totalRequests = userData?.totalRequestCount ?? 10
            usedRequests = userData?.requestCount ?? 0
            remainingRequests = totalRequests-usedRequests
            isPremium = userData?.isPremium ?? false
        } catch {
            errorMessage = "Veriler yüklenemedi: \(error.localizedDescription)"
        }
        isLoading = false
    }

    @MainActor
    func goToPremiumPage() {
        isLoading = true
        errorMessage = nil
        shouldNavigateToPremium = true
        isLoading = false
    }


    func restorePurchases() async {
        isLoading = true
        errorMessage = nil
        do {
            try await userManager.restorePurchases()
            fetchUserData()
        } catch {
            errorMessage = "Satın almalar geri yüklenemedi: \(error.localizedDescription)"
        }
        isLoading = false
    }

    
    func incrementRequestCount() async {
        do {
            try userManager.increaseRequestCount()
            fetchUserData()
        } catch {
            errorMessage = "Request güncellenemedi: \(error.localizedDescription)"
        }
    }

    @MainActor
    func exportData(to url: URL) async {
        isLoading = true
        errorMessage = nil
        do {
            try await userManager.exportUserData(to: url)
        } catch {
            errorMessage = "Veri dışa aktarımı başarısız: \(error.localizedDescription)"
        }
        isLoading = false
    }

    @MainActor
    func importData(from url: URL) async {
        isLoading = true
        errorMessage = nil
        do {
            try await userManager.importUserData(from: url)
            fetchUserData()
        } catch {
            errorMessage = "Veri içe aktarımı başarısız: \(error.localizedDescription)"
        }
        isLoading = false
    }
    

}
