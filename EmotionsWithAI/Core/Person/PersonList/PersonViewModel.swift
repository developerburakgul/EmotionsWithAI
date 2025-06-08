//
//  PersonViewModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 7.06.2025.
//

import Foundation

@MainActor
final class PersonViewModel: ObservableObject {
    var persons: [Person] = Person.getMockData()
    @Published var shownPersons: [Person] = Person.getMockData()
    @Published var selectedPerson: Person? = nil
    
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
}
