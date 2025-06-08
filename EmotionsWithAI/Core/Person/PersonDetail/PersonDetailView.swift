//
//  PersonDetailListView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 7.06.2025.
//

import SwiftUI
import Charts



struct PersonDetailView: View {
    @StateObject var viewModel: PersonDetailViewModel = .init()
    @State var selectedCount: Double?
    @State var selectedSector: String?
    var body: some View {
        NavigationStack {
            mainContent
                .navigationTitle(viewModel.personDetail.name)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var mainContent: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 8) {
                chart
                    .frame(height: 300)
                    .padding(.vertical)
                chartDetail
                showInCalendar
                lastSentiment
                startConversationDateView
                messageCountView
            }

        }
        .padding()
    }
    
    
    
    private var chart: some View {
        Chart {
            ForEach(viewModel.personDetail.sentiments, id: \.label) { sentiment in
                sectorMark(for: sentiment)
            }
        }
        .chartBackground { proxy in
            Image(viewModel.mostSentimentImageName)
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                
        }
        .chartAngleSelection(value: $selectedCount)
        .onChange(of: selectedCount) { oldValue, newValue in
            if let new = newValue {
                selectedSector = findSelectedSector(value: new)
            } else {
                selectedSector = nil
            }
        }
        .chartLegend(.hidden)
    }
    
    private func sectorMark(for sentiment: Sentiment) -> some ChartContent {
        SectorMark(
            angle: .value("Sentiment", sentiment.score),
            innerRadius: .ratio(0.75),
            angularInset: 2
        )
        .foregroundStyle(by: .value("Sentiment Label", sentiment.label.getStringValue))
        .cornerRadius(8)
        .opacity(selectedSector == nil ? 1.0 : (selectedSector == sentiment.label.getStringValue ? 1.0 : 0.5))
    }
    private func findSelectedSector(value: Double) -> String? {
        var accumulatedScore = 0.0
        
        let sentiment = viewModel.personDetail.sentiments.first { sentiment in
            accumulatedScore += sentiment.score
            return value <= accumulatedScore
        }
        
        return sentiment?.label.getStringValue
    }
    
    private var chartDetail: some View {

        ExpandableCell(isExpanded: false) {
                Text("Detail")
                .foregroundStyle(UIColor.label.toColor)
        } content: {
            VStack {
                ForEach(viewModel.personDetail.sentiments, id: \.label) { sentiment in
                    SentimentRow(sentiment: sentiment)
                        .padding(.vertical)
                        .onTapGesture {
                            // todo
                        }
                }
            }
            
            
        }
    }
    
    private var showInCalendar: some View {
        ExpandableCell(isExpandable: false) {
            HStack {
                Text("Show in Calendar")
                    .foregroundStyle(UIColor.label.toColor)
                Spacer()
                Image(systemName: "calendar")
                    .foregroundStyle(UIColor.systemRed.toColor)
            }
        } content: {
            
        }

    }
    
    private var lastSentiment: some View {
        ExpandableCell(isExpandable: false) {
            HStack {
                Text("Last Feeling For You")
                    .foregroundStyle(UIColor.label.toColor)
                Spacer()
                Text(viewModel.personDetail.lastSentimentLabel.getStringValue)
                    .foregroundStyle(UIColor.label.toColor)
                    .bold()
                    
            }
        } content: {
            
        }
    }
    
    private var startConversationDateView: some View {
        ExpandableCell(isExpandable: false) {
            HStack {
                Text("Conversation Start Date ")
                    .foregroundStyle(UIColor.label.toColor)
                Spacer()
                Text(viewModel.startConversationDateString)
                    .foregroundStyle(UIColor.label.toColor)
                    .bold()
                    
            }
        } content: {
            
        }
    }
    
    private var messageCountView: some View {
        ExpandableCell(isExpandable: false) {
            HStack {
                Text("Message Count ")
                    .foregroundStyle(UIColor.label.toColor)
                Spacer()
                Text(viewModel.messageCountString)
                    .foregroundStyle(UIColor.label.toColor)
                    .bold()
                    
            }
        } content: {
            
        }
    }
}

#Preview {
    PersonDetailView()
}
