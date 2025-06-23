//
//  AnalysisResultView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 21.06.2025.
//

import SwiftUI


struct AnalysisResultView: View {
    @StateObject var viewModel: AnalysisResultViewModel
    @Environment(\.dismiss) var dismiss
    

    var body: some View {
        mainContent
    }
    
    var mainContent: some View {
        VStack(alignment: .center, spacing: 16) {
            if viewModel.isLoading {
                ProgressView()
            }else {
                
                circleImage
                    .padding(16)
                text
                VStack(alignment: .leading, spacing: 16) {
                    fromDateText
                    cards
                }
                Spacer()
                saveButton
                cancelButton
            }
        }
        .padding()
        .toolbarVisibility(.hidden, for: .navigationBar)
        .task {
            await viewModel.loadData()
        }
        .onChange(of: viewModel.isSaved) { oldValue, newValue in
            if newValue {
                dismiss()
            }
        }
    }
    
    var circleImage: some View {
//        Image("AngerRemovedBackground")
        Image(viewModel.mostEmotionImageName)
            .resizable()
            .aspectRatio(1.0, contentMode: .fit)
            .frame(width: 200, height: 200)
            .clipShape(Circle())
    }
    
    var text: some View {
        Text("Most Emotion is \(viewModel.mostEmotion) for \(viewModel.name)")
    }
    
    var fromDateText: some View {
        Text(viewModel.fromDate)
            .padding(.horizontal)
            .font(.title2)
            .bold()
    }
    
    var cards: some View {
    
        VStack(alignment: .center, spacing: 8) {
            NonExpandableCell {
                HStack {
                    Text("Message Count")
                    Spacer()
                    Text("\(viewModel.totalMessageCount)")
                        .foregroundStyle(UIColor.label.toColor)
                }
            } content: {
                
            }
            
            ExpandableCell {
                Text("Emotions")
                    .foregroundStyle(UIColor.label.toColor)
            } content: {
                ForEach(viewModel.analysisResult?.sentiments ?? []) { sentiment in
                    SentimentRow(sentiment: sentiment, showRightChevron: false)
                        .padding(4)
                }
            }


        }
    }
    
    var saveButton: some View {
        HStack {
            Image(systemName: "checkmark.circle")
            Text("Save")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundStyle(UIColor.white.toColor)
        .background(Color.green)
        .cornerRadius(8)
        .onTapGesture {
            viewModel.saveButtonPressed()
        }
    }
    
    var cancelButton: some View {
        HStack {
            Image(systemName: "xmark.circle")
            Text("Cancel")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundStyle(UIColor.white.toColor)
        .background(Color.red)
        .cornerRadius(8)
        .onTapGesture {
            dismiss()
        }
    }
}

#Preview {
    let container = DevPreview.shared.container
    let data = WhatsappAnalysisResponseModel.loadMockResponse() ?? WhatsappAnalysisResponseModel.mock()
    return AnalysisResultView(
        viewModel: .init(
            container: container,
            data: data
        )
    )
        .previewEnvironmentObject()
}
