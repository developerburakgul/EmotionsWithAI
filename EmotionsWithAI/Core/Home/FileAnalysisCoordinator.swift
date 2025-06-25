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
    @Published var shouldShowPremium: Bool = false
    @Published var errorMessage: String? = nil // New property for error messages
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

//    func analyzeSelectedFile(_ url: URL) {
//        LoaderManager.shared.show(type: .analyzing)
//        Task {
//            guard url.startAccessingSecurityScopedResource() else {
//                    print("Couldn't access security-scoped URL")
//                    LoaderManager.shared.hide()
//                    return
//                }
//                
//                defer {
//                    url.stopAccessingSecurityScopedResource()
//                }
//            
//            do {
//                guard userManager.canAnalyzeMessage() else {
//                    shouldShowPremium = true
//                    return
//                }
//                let messages = try WPMessageHelper.getStringFormat(from: url)
//                let participants = WPMessageHelper.extractParticipants(from: messages)
//                guard let personName = try extractOtherParticipant(from: participants) else {
//                    throw CustomError.couldntExtractOtherPerson
//                }
//
//                let person = personManager.fetchPerson(name: personName)
//                let filteredMessages: String
//
//                if let person = person,
//                   let detail = try personManager.fetchPersonDetail(person: person) {
//                    filteredMessages = WPMessageHelper.filterMessages(after: detail.dateForLastMessageForAnalysis, from: messages)
//                    if filteredMessages == "" {
//                        emptyAnalysisModel = EmptyAnalysisModel(name: detail.name, date: detail.lastDateForConversation)
//                        LoaderManager.shared.hide()
//                        return
//                    }
//                } else {
//                    filteredMessages = messages
//                }
//                
//
//                let result = try await analyzeManager.analyzeWhatsappChat(text: filteredMessages)
//                
//                self.analysisResult = result
//                self.shouldNavigateResult = true
//
//            } catch {
//                print("FileAnalysisCoordinator error: \(error)")
//            }
//        }
//    }
    
    func analyzeSelectedFile(_ url: URL) {
         LoaderManager.shared.show(type: .analyzing)
         Task {
             do {
                 // Add timeout (e.g., 30 seconds)
                 try await withTimeout(seconds: 120) { [weak self] in
                     guard let self else { return }
                     
                     guard self.userManager.canAnalyzeMessage() else {
                         self.shouldShowPremium = true
                         LoaderManager.shared.hide()
                         return
                     }
                     
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
                             self.emptyAnalysisModel = EmptyAnalysisModel(name: detail.name, date: detail.lastDateForConversation)
                             LoaderManager.shared.hide()
                             return
                         }
                     } else {
                         filteredMessages = messages
                     }
                     
                     let result = try await analyzeManager.analyzeWhatsappChat(text: filteredMessages)
                     
                     self.analysisResult = result
                     self.shouldNavigateResult = true
                     LoaderManager.shared.hide()
                 }
             } catch {
                 // Handle all errors, including timeout
                 let errorDescription = error is TimeoutError ? "Analysis timed out. Please try again later." : error.localizedDescription
                 self.errorMessage = errorDescription
                 print("FileAnalysisCoordinator error: \(error)")
                 LoaderManager.shared.hide()
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

    

}
struct TimeoutError: Error {}
func withTimeout<T>(seconds: TimeInterval, operation: @escaping () async throws -> T) async throws -> T {
    return try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask {
            return try await operation()
        }
        group.addTask {
            try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            throw TimeoutError()
        }
        let result = try await group.next()!
        group.cancelAll()
        return result
    }
}
