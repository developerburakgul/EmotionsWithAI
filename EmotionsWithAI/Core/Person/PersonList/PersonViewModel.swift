//
//  PersonViewModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 7.06.2025.
//

import Foundation

@MainActor
final class PersonViewModel: ObservableObject {
    private var persons: [Person]
    @Published var shownPersons: [Person]
    @Published var selectedPerson: Person? = nil
    @Published var isLoadingPersons: Bool = true
    
    let personManager: PersonManager
    
    init(container: DependencyContainer) {
        self.personManager = container.resolve(PersonManager.self)!
        self.persons = []
        self.shownPersons = persons
    }
    
    func userDidSearch(_ searchQuery: String) {
        guard !searchQuery.isEmpty else {
            resetSearch()
            return
        }
        shownPersons = persons.filter { person in
            return person.name.contains(searchQuery)
        }
    }
    
    func userClick(to person: Person) {
        selectedPerson = person
        print(person.name)
    }
    private func resetSearch() {
        shownPersons = persons
    }
    
    func loadPersons() async {
        isLoadingPersons = true
        do {
            persons = try personManager.fetchAllPersons()
            self.shownPersons = persons
            isLoadingPersons = false
        } catch  {
            print("Error: \(error)")
        }
    }
    
}
