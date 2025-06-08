//
//  AnalysisViewViewModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 7.06.2025.
//

import Foundation

final class AnalysisViewViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var maxInputSizeInKBString: String = "\(5) KB"
    @Published var textSizeInKBString: String = "\(0) KB"
    
    private var maxInputSizeInKB: Int = 0 {
        didSet {
            maxInputSizeInKBString = "\(maxInputSizeInKB) KB"
        }
    }
    
    private func calculateTextSizeInKB() {
        let byteCount = text.lengthOfBytes(using: .utf8)
        if byteCount < 1024 {
            textSizeInKBString = "\(byteCount) B"
        } else if byteCount < 1024 * 1024 {
            textSizeInKBString = String(format: "%.2f KB", Double(byteCount) / 1024.0)
        } else {
            textSizeInKBString =  String(format: "%.2f MB", Double(byteCount) / 1024.0 / 1024.0)
        }
    }
    
    func didChangeText() {
        calculateTextSizeInKB()
    }
    
}
