//
//  AnalysisDateRow.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 22.06.2025.
//

import Foundation
import SwiftUI

struct AnalysisDateRow: View {
    let date: Date
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Circle()
                .fill(Color(UIColor.label.toColor))
                .frame(width: 8, height: 8)
            Text(date.format(with: .ddMMMMyyyyHHmm))
            Spacer()
        }
    }
}

#Preview {
    SentimentRow(sentiment: Sentiment.getRandom())
        .padding()
}
