//
//  DailyCalenderView.swift
//  imonit
//
//  Created by 薗部拓人 on 2023/08/16.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedOption: CalendarOption = .daily
    @State private var selectedDate: Date = Date() // Current date by default

    let currentDate: Date = Date()
    @State var selectedMonth: Date = Date()
    var dateOfMonth: [Date] {
        generateDatesOfMonth(selectedMonth: selectedMonth)!
    }
    
    enum CalendarOption: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        case yearly = "Yearly"
    }
    @State private var selectedCalender: CalendarOption = .weekly

    var body: some View {
        
        VStack(alignment: .trailing){
            Group {
                HStack(alignment: .center, spacing: 0){
                    Spacer()
                    
                    Picker("Select a time interval", selection: $selectedCalender) {
                        ForEach(CalendarOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .containerRelativeFrame(.horizontal, count: 10, span: 5, spacing: 0)
                    .pickerStyle(.menu)
                    
                    HStack{
                        // Search Schedules
                        Button(action: {}) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .padding(.horizontal,10)
                        }
                        
                        // Add New Schedules
                        Button(action: {}) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .padding(.horizontal,10)
                        }
                    }
                    .containerRelativeFrame(.horizontal, count: 10, span: 2, spacing: 0)
                }
                .padding(.horizontal)
            }
            
            switch selectedCalender {
            case .daily:
                CalendarDailyView(selectedDate: $selectedDate)
            case .weekly:
                CalendarWeeklyView(currentDate: currentDate, selectedMonth: $selectedMonth, dateOfMonth: dateOfMonth)
            case .monthly:
                Text("Monthly View")
            case .yearly:
                Text("Yearly View")
            }
        }
    }
}

#Preview {
    CalendarView()
}

