//
//  SwiftDataManager.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 9.06.2025.
//


import Foundation
import SwiftData

@MainActor
final class SwiftDataManager: ObservableObject {
    
    static let shared = SwiftDataManager()

    let container: ModelContainer
    var context: ModelContext { container.mainContext }

    private init() {
        do {
            let schema = Schema([
                PersonEntity.self,
                // buraya başka modelleri de eklersin
            ])

 

            self.container = try ModelContainer(for: schema, configurations: [])
        } catch {
            fatalError("❌ SwiftData başlatılamadı: \(error)")
        }
    }

    // Özel test/mock initializer da istersen:
    init(forTestingWith models: [any PersistentModel.Type]) {
        do {
            self.container = try ModelContainer(for: Schema(models))
        } catch {
            fatalError("❌ Test için SwiftData başlatılamadı: \(error)")
        }
    }
}
