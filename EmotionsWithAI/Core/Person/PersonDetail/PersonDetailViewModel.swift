//
//  PersonDetailViewModel.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 8.06.2025.
//

import Foundation

final class PersonDetailViewModel: ObservableObject {
    @Published var personDetail: PersonDetail = PersonDetail.mock()
    
    
    var startConversationDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        return dateFormatter.string(from: personDetail.firstDateForConversation)
    }
    
    var messageCountString: String {
        "\(personDetail.messageCount)"
    }
    
    var mostSentimentImageName: String {
        personDetail.mostSentiment.getImageName()
    }
}
