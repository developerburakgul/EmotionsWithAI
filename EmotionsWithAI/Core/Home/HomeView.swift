//
//  HomeView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 3.06.2025.
//

import SwiftUI
import Charts

struct DetailView: View {
    let personName: String
    var body: some View {
        Text("Detail for \(personName)")
            .navigationTitle("Person Detail")
    }
}

struct HomeView: View {
    @EnvironmentObject var container: DependencyContainer
    @StateObject var viewModel: HomeViewModel
    @StateObject var coordinator: FileAnalysisCoordinator
    @State var showFileImporter: Bool = false
    @State var showErrorAlert: Bool = false // New state for alert
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                mainContent
                    .navigationTitle("Home")
                    .navigationBarTitleDisplayMode(.large)
                
                addButton
                    .fileImporter(
                        isPresented: $showFileImporter,
                        allowedContentTypes: [.zip]) { result in
                            do {
                                let selectedFileURL = try result.get()
                                coordinator.analyzeSelectedFile(selectedFileURL)
                            } catch {
                                print(error)
                            }
                            
                        }
            }
            .navigationDestination(isPresented: $coordinator.shouldNavigateResult) {
//                if let vm = coordinator.analysisResultViewModel {
//                       AnalysisResultView(viewModel: vm)
//                           .toolbarVisibility(.hidden, for: .tabBar)
//                   }
                AnalysisResultView(
                    viewModel: AnalysisResultViewModel(
                        container: container,
                        data: coordinator.analysisResult!
                    )
                )
                .toolbarVisibility(.hidden, for: .tabBar)                
            }
            .navigationDestination(item: $coordinator.emptyAnalysisModel) { model in
                EmptyAnalysisResultView(name: model.name, sinceDate: model.date) {
                    coordinator.emptyAnalysisModel = nil
                }
                .toolbarVisibility(.hidden, for: .tabBar)   
            }
            .sheet(isPresented: $coordinator.shouldShowPremium) {
                PremiumUpgradeView(
                    viewModel: .init(container: container)
                )
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK") {
                    coordinator.errorMessage = nil
                }
            } message: {
                Text(coordinator.errorMessage ?? "An unknown error occurred.")
            }
        }
        .task {

            await viewModel.loadData()
        }
        .onChange(of: coordinator.shouldNavigateResult) { oldValue, newValue in
            if !newValue {
                Task {
                    await viewModel.loadData()
                }
            }
        }
        .onChange(of: coordinator.errorMessage) { oldValue, newValue in
            if newValue != nil {
                showErrorAlert = true
            }
        }
        
        
        
    }
    
    private var mainContent: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 8) {
                chart
                text
                Spacer()
                cards
            }
        }

    }
    
    @ViewBuilder
    private var chart: some View {
        ChartWithTime(chartDatas: $viewModel.chartDatas)
        .frame(height: 250)
        .padding()
        
    }
    
    private var text: some View {
        Text("The Most Emotion On This Month \(viewModel.selfUser?.mostEmotionLabel?.getStringValue ?? "")")
        .font(.body)
        .multilineTextAlignment(.center)
    }
    
    private var cards: some View {
        VStack(alignment: .center, spacing: 4) {
            NonExpandableCell {
                HStack {
                    Text("Analysis Count")
                    Spacer()
                    Text("\(viewModel.selfUser?.analysisDates.count ?? 0)")
                }
            } content: {
            }
            
            ExpandableCell {
                HStack {
                    Text("Analysis Dates")
                        .foregroundStyle(UIColor.label.toColor)
                    Spacer()
                }
            } content: {
                VStack(alignment: .center, spacing: 4) {
                    ForEach(viewModel.analysisDates, id: \.self) { date in
                        AnalysisDateRow(date: date)
                            .padding(4)
                    }
                }
            }
            
            NonExpandableCell {
                HStack {
                    Text("Message Count")
                        .foregroundStyle(UIColor.label.toColor)
                    Spacer()
                    Text("\(viewModel.countOfMessages)")
                }
            } content: {
                
            }



        }
        .padding()
    }
    
    private var addButton: some View {
        Button(action: {
            clickAddButton()
        }) {
            Image(systemName: "plus")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
        }
        .padding(.trailing, 16)
        .padding(.bottom, 16)
        
    }
    
    func clickAddButton() {
        showFileImporter = true
    }
}

//#Preview {
//    TabBarView()
//        .previewEnvironmentObject()
//}

#Preview("Empty Data") {
    let container = DevPreview.shared.container
    return TabBarView()
        .previewEnvironmentObject()
}
