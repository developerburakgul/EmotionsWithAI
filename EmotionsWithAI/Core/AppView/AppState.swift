//
//  AppState.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 5.06.2025.
//

import Foundation

@MainActor
final class AppState: ObservableObject {
    @Published private(set) var showTabbar: Bool {
        didSet {
            UserDefaults.showTabbar = showTabbar
        }
    }
    
    init(showTabbar: Bool = UserDefaults.showTabbar) {
        self.showTabbar = showTabbar
    }
    
    func updateShowTabBar(_ bool: Bool)  {
        showTabbar = bool
    }
}

extension UserDefaults {
    private enum Keys {
        static let showTabbar = "showTabbar"
    }
    static var showTabbar: Bool {
        get {
            return standard.bool(forKey: Keys.showTabbar)
        } set {
            standard.set(newValue, forKey: Keys.showTabbar)
        }
    }
}



