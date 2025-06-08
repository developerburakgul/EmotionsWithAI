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
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                mainContent
                    .navigationTitle("Home")
                    .navigationBarTitleDisplayMode(.large)
                addButton
                    .fileImporter(
                        isPresented: $viewModel.showFileImporter,
                        allowedContentTypes: [.zip]) { result in
                            // todo
                        }
            }
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
        ChartWithTime()
            .frame(height: 250)
            .padding()
    }
    
    private var text: some View {
        Text("The Most Emotion On This Month is \(viewModel.localizedMostEmotion)")
        .font(.body)
        .multilineTextAlignment(.center)
    }
    
    private var cards: some View {
        HStack(spacing: 16) {
            VStack(spacing: 16) {
                CardView(title: "Home", description: "Analysis")
                    .frame(width: 110, height: 110)
                CardView(title: "Home", description: "Analysis")
                    .frame(width: 110, height: 110)
            }
            .padding()
            
            VStack(spacing: 16) {
                CardView(title: "Home", description: "Analysis")
                    .frame(width: 110, height: 110)
                CardView(title: "Home", description: "Analysis")
                    .frame(width: 110, height: 110)
            }
            
        }
        .padding()
        //        .background(Color.yellow)
        //        .frame(maxWidth: .greatestFiniteMagnitude)
        
    }
    
    private var addButton: some View {
        Button(action: {
            viewModel.clickAddButton()
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
}

#Preview {
    TabBarView()
}
