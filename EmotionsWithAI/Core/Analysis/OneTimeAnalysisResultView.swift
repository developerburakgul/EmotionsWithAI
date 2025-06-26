//
//  OneTimeAnalysisResultView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 23.06.2025.
//

import SwiftUI

struct OneTimeAnalysisResultView: View {
    let emotion: Emotion
    @Environment(\.dismiss) var dismiss
    
    // Get the dominant sentiment (highest score)
    private var dominantSentiment: Sentiment? {
        emotion.sentiments.max(by: { $0.score < $1.score })
    }
    
    // Image name for the dominant sentiment
    private var emotionImageName: String {
        dominantSentiment?.label.getImageNameRemoveBacgkround() ?? "Joy"
    }
    
    // Debug: Print sentiments to check for duplicates
    private func logSentiments() {
        print("Sentiments in Emotion: \(emotion.sentiments.map { "\($0.label.getStringValue): \($0.score)" })")
    }
    
    // Merge duplicate sentiments by label (optional, uncomment if needed)
    private var mergedSentiments: [Sentiment] {
        var sentimentDict: [SentimentLabel: (score: Double, count: Int)] = [:]
        
        for sentiment in emotion.sentiments {
            let current = sentimentDict[sentiment.label, default: (score: 0.0, count: 0)]
            sentimentDict[sentiment.label] = (score: current.score + sentiment.score, count: current.count + 1)
        }
        
        return sentimentDict.map { label, data in
            Sentiment(
                id: UUID(),
                label: label,
                score: data.score / Double(data.count) // Average score
            )
        }.sorted(by: { $0.score > $1.score }) // Sort by score descending
    }
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                colors: [.init(red: 0.95, green: 0.975, blue: 1.0), .init(red: 0.95, green: 0.95, blue: 0.95)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            mainContent
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            logSentiments() // Debug: Print sentiments on view appearance
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 20) {
            // Header
            headerView
                .padding(.top, 40)
            
            // Scrollable Details
            ScrollView {
                VStack(spacing: 16) {
                    dominantEmotionCard
                    sentimentsBreakdownCard
                }
                .padding(.horizontal)
            }
            
            // Action Button
            actionButton
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Image(emotionImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .shadow(radius: 8)
                )
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: emotionImageName)
            
            Text("Feeling \(dominantSentiment?.label.getStringValue ?? "Unknown")")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Analysis Complete")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var dominantEmotionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Dominant Emotion")
                .font(.headline)
                .foregroundColor(.primary)
            
            if let sentiment = dominantSentiment {
                HStack {
                    Text(sentiment.label.getStringValue)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(sentiment.label.color)
                    Spacer()
                    Text(String(format: "%.1f%%", sentiment.score * 100))
                        .font(.body)
                        .fontWeight(.semibold)
                }
                
                ProgressView(value: sentiment.score)
                    .progressViewStyle(.linear)
                    .tint(sentiment.label.color)
            } else {
                Text("No emotion data available")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var sentimentsBreakdownCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sentiments Breakdown")
                .font(.headline)
                .foregroundColor(.primary)
            
            if emotion.sentiments.isEmpty {
                Text("No sentiments detected")
                    .font(.body)
                    .foregroundColor(.secondary)
            } else {
                // Use mergedSentiments to combine duplicates (uncomment to enable)
                // ForEach(mergedSentiments, id: \.id) { sentiment in
                ForEach(emotion.sentiments, id: \.label) { sentiment in
                    HStack {
                        Text(sentiment.label.getStringValue)
                            .font(.body)
                            .foregroundColor(sentiment.label.color)
                        Spacer()
                        Text(String(format: "%.1f%%", sentiment.score * 100))
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 4)
                    
                    ProgressView(value: sentiment.score)
                        .progressViewStyle(.linear)
                        .tint(sentiment.label.color)
                        .frame(height: 8)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var actionButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Done")
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.8))
                )
                .foregroundColor(.white)
                .font(.headline)
        }
    }
}

#Preview {
    let emotion = Emotion(sentiments: [
        Sentiment(label: .anger, score: 0.5),
        Sentiment(label: .joy, score: 0.15),
        Sentiment(label:  SentimentLabel.disgust, score: 0.05),
        Sentiment(label: SentimentLabel.fear, score: 0.20),
        Sentiment(label: SentimentLabel.sadness, score: 0.60),
        Sentiment(label: SentimentLabel.neutral, score: 0.10),
        
    ])
    return OneTimeAnalysisResultView(emotion: emotion)
}
