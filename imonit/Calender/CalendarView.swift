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


    
    enum CalendarOption: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        case yearly = "Yearly"
    }
    var body: some View {
        
        VStack{
            Group {
                HStack(spacing: 0){
                    // Switch CalenderViews
                    Picker("Select a time interval", selection: $selectedOption) {
                        ForEach(CalendarOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.trailing)
                    
                    // Search Schedules
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                            .padding(.horizontal,10)
                    }
                    
                    
                    // Add New Schedules
                    Button(action: {}) {
                        Image(systemName: "plus.circle")
                            .padding(.horizontal,10)
                    }
                    
                }
                .padding(.horizontal)
            }
            
            switch selectedOption {
            case .daily:
                CalendarDailyView(selectedDate: $selectedDate)
            case .weekly:
                CalendarWeeklyView()
            case .monthly:
                Text("Monthly View")
            case .yearly:
                Text("Yearly View")
            }
            
            Spacer()
            
        }
    }
}

#Preview {
    CalendarView()
}

