//
//  MaxInputSizeData.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 23.06.2025.
//

import Foundation
struct MaxInputSizeData: Codable {
    let model: String
    let task: String
    let max_tokens: Int
    let approx_size_kb: Double
    let approx_size_bytes: Int
    let status: String
}
