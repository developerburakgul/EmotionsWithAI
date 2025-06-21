//
//  LoaderManager.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 21.06.2025.
//

import Foundation
import Combine

final class LoaderManager: ObservableObject {
    static let shared = LoaderManager()

    @Published var currentLoader: LoaderType? = nil

    private init() {}

    func show(type: LoaderType) {
        currentLoader = type
    }

    func hide() {
        currentLoader = nil
    }

    var isLoading: Bool {
        currentLoader != nil
    }
}
