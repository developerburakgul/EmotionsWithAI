//
//  WhatsappTextRequestModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 23.06.2025.
//


// MARK: - WhatsappTextRequestModel
struct WhatsappTextRequestModel: Codable {
    let text: String

    enum CodingKeys: String, CodingKey {
        case text
    }
}