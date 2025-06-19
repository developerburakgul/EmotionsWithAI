//
//  HomeView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 3.06.2025.
//

import SwiftUI
import Charts

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State var showFileImporter: Bool = false
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
                            // todo
                        }
            }
        }
        .task {
            await viewModel.loadData()
        }
        
        
    }
    
    private var mainContent: some View {
        VStack(alignment: .center, spacing: 8) {
            chart
            text
            Spacer()
            cards
        }
    }
    
    private var chart: some View {
        ChartWithTime(chartDatas: $viewModel.chartDatas)
            .frame(height: 250)
            .padding()
        
    }
    
    private var text: some View {
        Text("The Most Emotion On This Month is \(viewModel.localizedMostEmotion)")
        .font(.body)
        .multilineTextAlignment(.center)
    }
    
    private var cards: some View {
        Text("Burak")
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

#Preview {
    TabBarView()
        .previewEnvironmentObject()
}
