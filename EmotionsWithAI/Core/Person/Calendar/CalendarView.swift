//
//  CalendarView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 8.06.2025.
//

import SwiftUI



import ObiletCalendar
struct CalendarView: View {
    @StateObject var viewModel: CalendarViewModel
    var body: some View {
        Group {
            VStack {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .loaded:
                    ScrollViewReader { scrollProxy in
                        VStack(spacing: 0) {
                            Spacer()
                            weekdaysView
                                .padding(.vertical,8)
                                .padding(.horizontal,16)
                                .background(
                                    Color.gray.opacity(0.4)
                                )
                                .cornerRadius(4)
                            calendar
                        }
                        .onAppear{
                            viewModel.scrollSwitch?.date = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                viewModel.scrollSwitch?.date = viewModel.todayDate
                                performScrollRequest(scrollProxy: scrollProxy)
                            }
                        }
                    }
                case .failed(let string):
                    Text(string)
                }

            }
            

        }
        .padding()
        .task {
            await viewModel.loadData()
        }


    }
    
    var weekdaysView: some View {
        let weekdays = getShortLocalizedWeekdays(for: Calendar.current)
        return HStack {
            ForEach(weekdays.indices, id: \.self) { index in
                Text(weekdays[index])
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    func getShortLocalizedWeekdays(
        for calendar: Calendar
    ) -> [String] {
        let firstWeekday = calendar.firstWeekday
        let shortWeekdays = calendar.shortWeekdaySymbols
        let firstWeekdayIndex = firstWeekday - 1
        let reorderedShortWeekdays = Array(shortWeekdays[firstWeekdayIndex...])
        + Array(shortWeekdays[..<firstWeekdayIndex])
        return reorderedShortWeekdays
    }
    
    var calendar: some View {
        OBCalendar(
            startDate: viewModel.startDate,
            drawingRange: viewModel.calendarRange,
            lazyYears: false,
            lazyMonths: true,
            lazyDays: true
        )
            .dayModifier { baseView, model in
                
                    modifyDayView(model: model, content: {
                        baseView
                            .font(.system(size: 24))
                    })
                    .padding(4)
    
                    
                
            }
            .monthModifier { baseView, daysView, model in
                baseView
                    .id(CalendarMonthScrollTrigger(month: model.month, year: model.year, calendar: Calendar.current))
            }
            
    }
    

    func modifyDayView<Content: View>(model: OBCalendar.DayModel, @ViewBuilder content: () -> Content) -> some View {
        let sentiment = viewModel.getSentiment(for: model)
        return VStack(spacing: 4) {
            if let sentiment = sentiment {
                Image(sentiment.getImageNameRemoveBacgkround())
                    .resizable()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                
            } else {
                Spacer()
                    .frame(width: 32, height: 32)
            }

            content()

           
        }
        .padding(4)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(4)
        
    }
    
    func performScrollRequest(
        scrollProxy: ScrollViewProxy
    ) {
        guard let scrollTrigger = viewModel.scrollSwitch else {
            print("🚫 Scroll trigger ID yok")
            return
        }
        scrollProxy.scrollTo(scrollTrigger,anchor: .bottom)
    }
}



#Preview {
    let container = DevPreview.shared.container
    let mockStorage = MockLocalPersonStorageService()
    container.register(PersonManager.self, service: PersonManager(localPersonStorage: mockStorage))
    return CalendarView(
        viewModel: CalendarViewModel(
            container: container,
            personDetail: .mock()
        )
    )
        .previewEnvironmentObject()
}
