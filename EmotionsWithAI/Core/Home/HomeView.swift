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
                            do {
                                let selectedFileURL = try result.get()
                                viewModel.selectFile(selectedFileURL: selectedFileURL)
                            } catch {
                                print(error)
                            }
                            
                        }
            }
        }
        .task {
            await viewModel.loadData()
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
        Text("The Most Emotion On This Month is \(viewModel.localizedMostEmotion)")
        .font(.body)
        .multilineTextAlignment(.center)
    }
    
    private var cards: some View {
        VStack(alignment: .center, spacing: 4) {
            NonExpandableCell {
                HStack {
                    Text("Analysis Count")
                    Spacer()
                    Text("\(viewModel.analysisDates.count)")
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
                        Text(date.format(with: .yyyyMMMM))
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

#Preview {
    let container = DevPreview.shared.container
    return TabBarView()
        .previewEnvironmentObject()
}
