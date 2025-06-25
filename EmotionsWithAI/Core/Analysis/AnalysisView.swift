//
//  AnalysisView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 3.06.2025.


import SwiftUI

struct AnalysisView: View {
    @StateObject var viewModel: AnalysisViewModel
    
    var body: some View {
        NavigationStack {
            mainContent
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                )
                .navigationTitle("Analysis")
                .navigationBarTitleDisplayMode(.large)
                .alert("Error", isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { _ in viewModel.errorMessage = nil }
                )) {
                    Button("OK") { }
                } message: {
                    Text(viewModel.errorMessage ?? "Unknown error")
                }
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else {
                VStack(alignment: .center, spacing: 16) {
                    textEditor
                    Spacer()
                    analyzeButton
                }
                .padding()
            }
        }
        .task {
            await viewModel.loadData()
        }
        .navigationDestination(item: $viewModel.result) { emotion in
            OneTimeAnalysisResultView(emotion: emotion)
                .toolbarVisibility(.hidden, for: .tabBar)
        }
    }
    
    private var textEditor: some View {
        VStack(alignment: .trailing, spacing: 4) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $viewModel.text)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .background(Color(red: 1.0, green: 0.95, blue: 0.95))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black.opacity(0.5), lineWidth: 1)
                    )
                    .frame(maxHeight: .infinity)
                    .onChange(of: viewModel.text) {
                        viewModel.didChangeText()
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }
                    }
                
                if viewModel.text.isEmpty {
                    Text("Enter your text here...")
                        .padding(14)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("\(viewModel.textSizeInKBString)/\(viewModel.maxInputSizeInKBString)")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
    
    private var analyzeButton: some View {
        Button {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            Task {
                await viewModel.startAnalysis()
            }
        } label: {
            Text("Start Analyze")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(16)
                .foregroundStyle(UIColor.label.toColor)
        }
        .disabled(viewModel.text.isEmpty)
        .opacity(viewModel.text.isEmpty ? 0.5 : 1.0)
    }
}

#Preview {
    let container = DevPreview.shared.container
    AnalysisView(viewModel: .init(container: container))
        .previewEnvironmentObject()
}
