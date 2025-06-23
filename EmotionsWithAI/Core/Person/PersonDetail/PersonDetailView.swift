//
//  PersonDetailListView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 7.06.2025.
//

import SwiftUI
import Charts



struct PersonDetailView: View {
    @EnvironmentObject var container: DependencyContainer
    @StateObject var viewModel: PersonDetailViewModel
    @State var selectedCount: Double?
    @State var selectedSector: String?
    @State var selectedCalendarView: Bool = false
    @State var calendarFilter = CalendarFilter.none
    
    let person: Person
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                progressView
            case .loaded:
                
                mainContent
                    .navigationTitle(navigationBarTitle)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(isPresented: $selectedCalendarView) {
                        let calendarViewModel = CalendarViewModel(
                            container: container,
                            personDetail: viewModel.personDetail!)
                        calendarViewModel.filter = calendarFilter
                        return CalendarView(viewModel: calendarViewModel)
                        .toolbarVisibility(.hidden, for: .tabBar)
                    }
                
            case .failed(let string):
                errorView(errorMessage: string)
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .task {
            await viewModel.load(person: person)
        }
        
    }
    
    private var navigationBarTitle: String {
        switch viewModel.state {
        case .loaded:
            return viewModel.personDetail?.name ?? "NOT FOUND"
        default :
            return ""
        }
    }
    
    private var progressView: some View {
        ProgressView("Loading...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(errorMessage: String) -> some View {
        VStack(spacing: 16) {
            Text("Failed to load data")
                .font(.headline)
            Text(errorMessage)
                .foregroundStyle(.red)
            Button("Retry") {
                Task {
                    await viewModel.load(person: person)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            ForEach(viewModel.personDetail!.sentiments, id: \.label) { sentiment in
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
        
        let sentiment = viewModel.personDetail?.sentiments.first { sentiment in
            accumulatedScore += sentiment.score
            return value <= accumulatedScore
        }
        
        return sentiment?.label.getStringValue
    }
    
    private var chartDetail: some View {
        
        ExpandableCell {
            Text("Detail")
                .foregroundStyle(UIColor.label.toColor)
        } content: {
            VStack {
                ForEach(viewModel.personDetail!.sentiments, id: \.label) { sentiment in
                    SentimentRow(sentiment: sentiment)
                        .padding(.vertical)
                        .onTapGesture {
                            calendarFilter = .sentimentLabel(sentiment.label)
                            selectedCalendarView = true
                        }
                }
            }
        }
    }
    
    private var showInCalendar: some View {
        NonExpandableCell {
            HStack {
                Text("Show in Calendar")
                    .foregroundStyle(UIColor.label.toColor)
                Spacer()
                Image(systemName: "calendar")
                    .foregroundStyle(UIColor.systemRed.toColor)
            }
        } content: {
            
        }
        .onTapGesture {
            calendarFilter = .none
            selectedCalendarView = true
        }
    }
    
    private var lastSentiment: some View {
        NonExpandableCell {
            HStack {
                Text("Last Feeling For You")
                    .foregroundStyle(UIColor.label.toColor)
                Spacer()
                Text(viewModel.personDetail!.lastSentimentLabel?.getStringValue ?? "NOT FOUND")
                    .foregroundStyle(UIColor.label.toColor)
                    .bold()
            }
        } content: {
            
        }
    }
    
    private var startConversationDateView: some View {
        NonExpandableCell {
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
        NonExpandableCell {
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



#Preview("Non Empty Data") {
    let container = DevPreview.shared.container
    let mockStorage = MockLocalPersonStorageService()
    container.register(PersonManager.self, service: PersonManager(localPersonStorage: mockStorage))
    return PersonDetailView(
        viewModel: PersonDetailViewModel(container: container),
        person: Person(
            name: "Burak",
            mostSentiment: .init(
                label: .joy,
                score: 0.8
            )
        )
    )
    .previewEnvironmentObject()
    
}
