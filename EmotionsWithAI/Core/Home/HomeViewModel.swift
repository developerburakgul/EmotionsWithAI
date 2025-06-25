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
    @Published var selfUser: SelfUser?
    @Published var analysisDates: [Date] = []
    @Published var countOfMessages: Int = 0
    private let selfEmotionManager: SelfEmotionManager
//    private let analyzeManager: AnalyzeManager
//    private let userManager: UserManager
//    private let personManager: PersonManager
    
    init(container: DependencyContainer) {
//        self.analyzeManager = container.resolve(AnalyzeManager.self)!
//        
//        self.userManager = container.resolve(UserManager.self)!
//        self.personManager = container.resolve(PersonManager.self)!
        self.selfEmotionManager = container.resolve(SelfEmotionManager.self)!
    }
    
    //MARK: - Computed Properties

    
    @MainActor
    func loadData() async{
        do {
            self.selfUser = try await selfEmotionManager.fetchSelfUser()
            self.chartDatas = selfUser?.chartDatas ?? []
            self.countOfMessages = selfUser?.countOfMessages ?? 0
            self.analysisDates = selfUser?.analysisDates ?? []
        } catch  {
            
        }
    }
    
//    func selectFile(selectedFileURL: URL) {
//        LoaderManager.shared.show(type: .analyzing)
//        Task {
//            do {
//                let messages = try WPMessageHelper.getStringFormat(from: selectedFileURL)
//                let participants = WPMessageHelper.extractParticipants(from: messages)
//                guard let personName = try extractUser(from: participants) else {
//                    throw CustomError.couldntExtractOtherPerson
//                }
//                
//                if let person = personManager.fetchPerson(name: personName),
//                    let personDetail = try personManager.fetchPersonDetail(person: person) {
//                    let filteredMessages = WPMessageHelper.filterMessages(after: personDetail.lastDateForConversation, from: messages)
//                    //MARK: - TODO CONVERT PERSON ENTİTY TO SİMPLE DATA FOR PERSON MANAGER
//                    let apiResponseModel = try await analyzeManager.analyzeWhatsappChat(text: filteredMessages)
//                    dump(apiResponseModel)
//                    LoaderManager.shared.hide()
//                    self.analyzedPersonName = apiResponseModel.data?.participants.keys.first ?? ""
//                    self.shouldNavigateToDetail = true
//                } else {
//                    let apiResponseModel = try await analyzeManager.analyzeWhatsappChat(text: messages)
//                    try personManager.addPersonEntity(PersonEntity(name: personName))
//                }
//                
//                
//                    
//
//
//                
//            
//            } catch  {
//                print("error: \(error)")
//            }
//        }


 
    }
    
//    private func extractUser(from participants: [String]) throws -> String? {
//        do {
//            guard  participants.count == 2 else { throw CustomError.userCountShouldBeTwo }
//            let userName = try userManager.fetchUser()?.name
////            return participants.first == userName ? participants[1] : participants[0]
//            let result =  participants.first { name in
//                name != userName
//            }
//            
//            if let result = result {
//                return result
//            }
//            throw CustomError.couldntFindUser
//        } catch  {
//            throw  error
//        }
//        
//    }
    
//    private func extractUser(from participants: [String]) throws -> String? {
//        guard participants.count == 2 else { throw CustomError.userCountShouldBeTwo }
//        guard let userName = try userManager.fetchUser()?.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
//        else {
//            throw CustomError.couldntFindUser
//        }
//
//        let result = participants.first { name in
//            name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() != userName
//        }
//
//        if let result = result {
//            return result
//        }
//
//        throw CustomError.couldntFindUser
//    }

    
    



enum CustomError: String, LocalizedError {
    case userCountShouldBeTwo
    case couldntFindUser
    case couldntExtractOtherPerson
    case couldntFindPerson
    var localizedDescription: String {
        return self.rawValue
    }
}
