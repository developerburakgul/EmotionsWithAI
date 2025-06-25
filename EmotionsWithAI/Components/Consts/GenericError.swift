//
//  GenericError.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 23.06.2025.
//

import Foundation
public protocol GenericErrorProtocol: LocalizedError {
    var description: String { get }
}

public enum GenericError: GenericErrorProtocol {
    case detail(String)

    public var description: String {
        switch self {
        case .detail(let message):
            return message
        }
    }
}
