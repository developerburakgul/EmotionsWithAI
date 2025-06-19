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
    
    init(container: DependencyContainer) {
        
        //MARK: - TODO REGİSTER
        self.analyzeManager = container.resolve(AnalyzeManager.self)!
        self.selfEmotionManager = container.resolve(SelfEmotionManager.self)!
    }
    
    var localizedMostEmotion: String {
        String(localized: LocalizedStringResource(stringLiteral: selfUser?.mostEmotionLabel.getStringValue ?? ""))
    }
    
    func loadData() async{
        self.selfUser =  selfEmotionManager.fetchSelfUser()
        self.chartDatas = selfUser?.chartDatas ?? []
    }
 
}
