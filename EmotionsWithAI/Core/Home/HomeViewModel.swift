//
//  HomeViewModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 7.06.2025.
//
import SwiftUI




@MainActor
final class HomeViewModel: ObservableObject {
    @Published var chartDatas: [ChartData] = []
    private var selfUser: SelfUser?
    private let selfEmotionManager: SelfEmotionManager
    private let analyzeManager: AnalyzeManager
    private let userManager: UserManager
    private let personManager: PersonManager
    
    init(container: DependencyContainer) {
        self.analyzeManager = container.resolve(AnalyzeManager.self)!
        self.selfEmotionManager = container.resolve(SelfEmotionManager.self)!
        self.userManager = container.resolve(UserManager.self)!
        self.personManager = container.resolve(PersonManager.self)!
    }
    
    //MARK: - Computed Properties
    var analysisDates: [Date] {
        selfUser?.analysisDates ?? []
    }
    
    var countOfMessages: Int {
        selfUser?.countOfMessages ?? 0
    }
    
    var localizedMostEmotion: String {
        String(localized: LocalizedStringResource(stringLiteral: selfUser?.mostEmotionLabel.getStringValue ?? ""))
    }
    
    func loadData() async{
        do {
            self.selfUser = try await selfEmotionManager.fetchSelfUser()
            self.chartDatas = selfUser?.chartDatas ?? []
        } catch  {
            
        }
    }
    
    func selectFile(selectedFileURL: URL) {
        Task {
            do {
                let messages = try WPMessageHelper.getStringFormat(from: selectedFileURL)
    //            let participants = WPMessageHelper.extractParticipants(from: messages)
    //            let personName = try extractUser(from: participants)
    //            if let person = personManager.fetchPerson(name: personName) {
    //                let personDetail = try personManager.fetchPersonDetail(person: person)
    //                let filteredMessages = WPMessageHelper.filterMessages(after: personDetail.lastDateForConversation, from: messages)
    //
    //                //MARK: - AnalyzeManager todo
    //            } else {
    //
    //                //MARK: - TODO CONVERT PERSON ENTİTY TO SİMPLE DATA FOR PERSON MANAGER
    //                try personManager.addPersonEntity(
    //                    PersonEntity(name: personName)
    //                )
    //            }
                let apiResponseModel = try await analyzeManager.analyzeWhatsappChat(text: messages)
                dump(apiResponseModel)
                
            } catch  {
                print("error: \(error)")
            }
        }


 
    }
    
    private func extractUser(from participants: [String]) throws -> String {
        do {
            guard  participants.count == 2 else { throw CustomError.userCountShouldBeTwo }
            let userName = try userManager.fetchUser().name
            return participants.first == userName ? participants[1] : participants[0]
        } catch  {
            throw  error
        }
        
    }
    
    
 
}


enum CustomError: String, LocalizedError {
    case userCountShouldBeTwo
    var localizedDescription: String {
        return self.rawValue
    }
}
