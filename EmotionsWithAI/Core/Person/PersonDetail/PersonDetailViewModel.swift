//
//  PersonDetailViewModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 8.06.2025.
//

import Foundation

enum PersonDetailState {
    case loading
    case loaded
    case failed(String)
}

@MainActor
final class PersonDetailViewModel: ObservableObject {
    @Published var state: PersonDetailState = .loading
    @Published var personDetail: PersonDetail?
    private let personManager: PersonManager

    init(container: DependencyContainer) {
        self.personManager = container.resolve(PersonManager.self)!
    }

    func load(person: Person) async {
        print("Loading detail for person: \(person.id)")
        state = .loading
        do {
            let detail = try await personManager.fetchPersonDetail(person: person)
            print("Detail fetched: \(detail)")
            personDetail = detail
            state = .loaded
        } catch {
            print("Error: \(error.localizedDescription)")
            state = .failed(error.localizedDescription)
        }
    }
    
    var mostSentimentImageName: String {
        guard let detail = personDetail else { return "" }
        return detail.mostSentiment.getImageName()
    }
    
    var startConversationDateString: String {
        personDetail?.firstDateForConversation.format(with: .yyyyMMM) ?? ""
    }
    
    var messageCountString: String {
        "\(personDetail?.messageCount ?? 0)"
    }
    
    
}
