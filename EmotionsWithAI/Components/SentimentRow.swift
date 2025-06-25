//
//  SentimentRow.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 8.06.2025.
//

import SwiftUI

struct SentimentRow: View {
    
    let sentiment: Sentiment
    let showRightChevron: Bool
    
    init(sentiment: Sentiment, showRightChevron: Bool = true) {
        self.sentiment = sentiment
        self.showRightChevron = showRightChevron
    }
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Circle()
                .fill(Color(sentiment.label.color))
                .frame(width: 12, height: 12)
            Text(sentiment.label.getStringValue)
            Text(sentiment.score.getPercentageString())
            Spacer()
            if showRightChevron {
                Image(systemName: "chevron.right")
            }
        }
    }
}

#Preview {
    SentimentRow(sentiment: Sentiment.getRandom())
        .padding()
}
