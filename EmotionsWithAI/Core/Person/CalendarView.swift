//
//  CalendarView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 8.06.2025.
//

import SwiftUI



import ObiletCalendar
struct CalendarView: View {
    @StateObject var viewModel: CalendarViewModel = .init()
    var body: some View {
        VStack {
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
        .padding()

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
            
    }
    

    func modifyDayView<Content: View>(model: OBCalendar.DayModel, @ViewBuilder content: () -> Content) -> some View {
        let sentiment = viewModel.getSentiment(for: model)
        let image = Image(sentiment.getImageNameRemoveBacgkround())
        
        return VStack(spacing: 4) {
            content()
            image
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
        }
        .padding(4)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(4)
        
    
        
    }
}

#Preview {
    CalendarView()
}
