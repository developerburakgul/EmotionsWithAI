//
//  AnalysisViewModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 7.06.2025.


import Foundation

@MainActor
final class AnalysisViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var maxInputSizeInKBString: String = ""
    @Published var textSizeInKBString: String = "0 KB"
    @Published var isLoading: Bool = false
    @Published var result: Emotion?
    @Published var errorMessage: String? // For UI error display
    
    let analyzeManager: AnalyzeManager
    
    init(container: DependencyContainer) {
        self.analyzeManager = container.resolve(AnalyzeManager.self)!
    }
    
    private var maxInputSizeInKB: Int = 0 {
        didSet {
            maxInputSizeInKBString = "\(maxInputSizeInKB) KB"
            print("Updated maxInputSizeInKB: \(maxInputSizeInKB), maxInputSizeInKBString: \(maxInputSizeInKBString)") // Debug
        }
    }
    
    private func calculateTextSizeInKB() {
        let byteCount = text.lengthOfBytes(using: .utf8)
        if byteCount < 1024 {
            textSizeInKBString = "\(byteCount) B"
        } else if byteCount < 1024 * 1024 {
            textSizeInKBString = String(format: "%.2f KB", Double(byteCount) / 1024.0)
        } else {
            textSizeInKBString = String(format: "%.2f MB", Double(byteCount) / 1024.0 / 1024.0)
        }
        print("Text size calculated: \(textSizeInKBString)") // Debug
    }
    
    func didChangeText() {
        calculateTextSizeInKB()
    }
    
    func loadData() async {
        isLoading = true
        do {
            let maxSize = try await analyzeManager.getMaxInputSize()
            print("Endpoint returned maxInputSize: \(maxSize)") // Debug
            self.maxInputSizeInKB = maxSize
        } catch {
            print("Error loading max input size: \(error)")
            errorMessage = "Failed to load max input size. Please try again."
            maxInputSizeInKBString = "N/A" // Fallback display
        }
        isLoading = false
    }
    
    func startAnalysis() async {
        LoaderManager.shared.show(type: .oneTimeAnalyzing)
        defer {
            LoaderManager.shared.hide()
        }
        
        do {
            self.result = try await analyzeManager.analyzeOneTime(text: text)
            print("Analysis result: \(String(describing: result))") // Debug
        } catch {
            print("Error analyzing text: \(error)")
            errorMessage = "Analysis failed. Please try again."
        }
    }
}
