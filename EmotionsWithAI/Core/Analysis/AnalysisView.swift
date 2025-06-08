//
//  AnalysisView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 3.06.2025.
//

import SwiftUI

struct AnalysisView: View {
    @StateObject var viewModel: AnalysisViewModel
    
    var body: some View {
        NavigationStack {
            mainContent
                .navigationTitle("Analysis")
                .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var mainContent: some View {
        VStack(alignment: .center, spacing: 16) {
            textEditor
            Spacer()
            analyzeButton
        }
        .padding()
    }
    

    
    private var textEditor: some View {
        VStack(alignment: .trailing, spacing: 4) {
            ZStack(alignment: .topLeading) {
                // Placeholder
                TextEditor(text: $viewModel.text)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .background(Color(red: 1.0, green: 0.95, blue: 0.95)) // Açık pembe
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black.opacity(0.5), lineWidth: 1)
                    )
                    .frame(maxHeight: .infinity)
                    .onChange(of: viewModel.text) {
                        viewModel.didChangeText()
                    }
                
                if viewModel.text.isEmpty {
                    Text("Enter your text here...")
                        .padding(14)
                        .foregroundStyle(.secondary)
                }
   
  
            }
            
            Text(viewModel.textSizeInKBString + "/\(viewModel.maxInputSizeInKBString)")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
    
    
    private var analyzeButton: some View {
        
        Button {
            // todo
        } label: {
            Text("Start Analyze")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(16)
                .foregroundStyle(UIColor.label.toColor)
        }
        .disabled(viewModel.text.isEmpty)
        .opacity(viewModel.text.isEmpty ? 0.5 : 1.0) // Optional: visually indicate 


        
    }
}

//#Preview {
//    AnalysisView()
//}
