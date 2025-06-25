//
//  AnalysisResultViewModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 21.06.2025.
//
import Foundation
import Combine




@MainActor
final class AnalysisResultViewModel: ObservableObject {
    
    @Published var analysisResult: AnalysisResultModel?
    @Published var isLoading: Bool = false
    @Published var isSaved: Bool = false
    private var whatsappAnalysisResponseData: WhatsappAnalysisResponseModel
    private let personManager: PersonManager
    private let userManager: UserManager
    private let selfEmotionManager: SelfEmotionManager
    
    init(
        container: DependencyContainer,
        data: WhatsappAnalysisResponseModel
    ) {
        self.whatsappAnalysisResponseData = data
        self.personManager = container.resolve(PersonManager.self)!
        self.userManager = container.resolve(UserManager.self)!
        self.selfEmotionManager = container.resolve(SelfEmotionManager.self)!
    }
    
     var name: String {
        analysisResult?.name ?? ""
    }
    
    var mostEmotionImageName: String {
        analysisResult?.mostSentimentLabel.getImageName() ?? ""
    }
    
    var mostEmotion: String {
        analysisResult?.mostSentimentLabel.getStringValue ?? ""
    }
    
    var fromDate: String {
        analysisResult?.firstConversationDate.format(with: .yyyyMMM) ?? ""
    }
    
    var totalMessageCount: Int {
        analysisResult?.messageCount ?? 0
    }
    
    func loadData() async {
        isLoading = true
        do {
            let userName = try userManager.fetchUser()?.name
            guard let userName  else { return  }
            self.analysisResult =  AnalysisHelper.getAnalysisResult(userName: userName, data: whatsappAnalysisResponseData)
            isLoading = false
            LoaderManager.shared.hide()
        } catch  {
            
        }
        
        
    }
    
    func saveButtonPressed() {
        do {
            guard let userName = try userManager.fetchUser()?.name else {return}
            guard let personParticipantData = AnalysisHelper.getPersonParticipantData(userName: userName, participants: whatsappAnalysisResponseData.participants) else {return}
            guard let userParticipantData = AnalysisHelper.getUserParticipantData(userName: userName, participants: whatsappAnalysisResponseData.participants) else {return}
            let userLastConversationDate = userParticipantData.messages.sorted { $0.endTime > $1.endTime }[0].endTime
            
            personManager.save(participantData: personParticipantData, userLastMessageDate: userLastConversationDate)
            selfEmotionManager.save(participantData: userParticipantData)
            isSaved = true
        } catch  {
            
        }
      
    }
    
}
