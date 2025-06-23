//
//  ApiResponseModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 23.06.2025.
//

import Foundation
// MARK: - ApiResponseModel
struct ApiResponseModel<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let error: ErrorDetailModel?
    let timestamp: Date

    enum CodingKeys: String, CodingKey {
        case success
        case data
        case error
        case timestamp
    }
}



// MARK: - ErrorDetailModel
struct ErrorDetailModel: Codable {
    let code: String
    let message: String
    let details: String?

    enum CodingKeys: String, CodingKey {
        case code
        case message
        case details
    }
}
