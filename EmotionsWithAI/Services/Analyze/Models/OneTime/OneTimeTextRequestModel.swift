//
//  OneTimeTextRequestModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 23.06.2025.
//

import Foundation
struct OneTimeTextRequestModel: Codable {
    let text: String

    enum CodingKeys: String, CodingKey {
        case text
    }
}
