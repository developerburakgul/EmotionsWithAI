//
//  FileAnalysisCoordinator.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 21.06.2025.
//

import Foundation
import SwiftUI

struct EmptyAnalysisModel: Hashable{
    let name: String
    let date: Date?
}

@MainActor
final class FileAnalysisCoordinator: ObservableObject {
    @Published var analysisResult: WhatsappAnalysisResponseModel? = nil
    @Published var shouldNavigateResult = false
    @Published var emptyAnalysisModel: EmptyAnalysisModel?
    @Published var analysisResultViewModel: AnalysisResultViewModel?
    private let container: DependencyContainer

    private let userManager: UserManager
    private let personManager: PersonManager
    private let analyzeManager: AnalyzeManager
    
    init(container: DependencyContainer) {
        self.userManager = container.resolve(UserManager.self)!
        self.personManager = container.resolve(PersonManager.self)!
        self.analyzeManager = container.resolve(AnalyzeManager.self)!
        self.container = container
    }

    func analyzeSelectedFile(_ url: URL) {
        LoaderManager.shared.show(type: .analyzing)
        Task {
            do {
                let messages = try WPMessageHelper.getStringFormat(from: url)
                let participants = WPMessageHelper.extractParticipants(from: messages)
                guard let personName = try extractOtherParticipant(from: participants) else {
                    throw CustomError.couldntExtractOtherPerson
                }

                let person = personManager.fetchPerson(name: personName)
                let filteredMessages: String

                if let person = person,
                   let detail = try personManager.fetchPersonDetail(person: person) {
                    filteredMessages = WPMessageHelper.filterMessages(after: detail.dateForLastMessageForAnalysis, from: messages)
                    if filteredMessages == "" {
                        emptyAnalysisModel = EmptyAnalysisModel(name: detail.name, date: detail.lastDateForConversation)
                        LoaderManager.shared.hide()
                        return
                    }
                } else {
                    filteredMessages = messages
                }

                let result = try await analyzeManager.analyzeWhatsappChat(text: filteredMessages)
                
                self.analysisResult = result
                self.shouldNavigateResult = true

            } catch {
                print("FileAnalysisCoordinator error: \(error)")
            }
        }
    }

    private func extractOtherParticipant(from participants: [String]) throws -> String? {
        guard participants.count == 2 else { throw CustomError.userCountShouldBeTwo }
        guard let userName = try userManager.fetchUser()?.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        else { throw CustomError.couldntFindUser }

        return participants.first(where: {
            $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() != userName
        })
    }

    
//    func prepareForNavigation() async {
//        guard let result = analysisResult else { return }
//        let vm = AnalysisResultViewModel(container: container, data: result)
//        await vm.loadData()
//        analysisResultViewModel = vm
//        shouldNavigateResult = true
//    }
}
