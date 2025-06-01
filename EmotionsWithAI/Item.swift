//
//  Item.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 1.06.2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
