//
//  CalendarScheduleList.swift
//  imonit
//
//  Created by tsonobe on 2023/10/09.
//

import SwiftUI
import SwiftData

struct CalendarScheduleList: View {
    @Environment(\.modelContext) private var context
    @State private var isAddScheduleSheetPresented: Bool = false

    var selectedDate: Date?
    
    @Query(sort: \Schedule.startDate, order: .forward)
    var schedules: [Schedule]
    
    var filterdSchedule: [Schedule] {
        return schedules.filter({
            dateIsInRange(selectedDate!, startDate: $0.startDate, endDate: $0.endDate)
        })
    }

    var body: some View {
        ScrollView{
            ForEach(filterdSchedule) { schedule in
                ScheduleRow(schedule: schedule)
            }
        }
        .toolbar{
            ToolbarItemGroup {
                // Add New Schedules
                Button(action: {isAddScheduleSheetPresented.toggle()}) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isAddScheduleSheetPresented) {
            AddSchedule()
        }
        .navigationTitle(Text(DateFormatter.shortDateForm.string(from: selectedDate!)))
        
    }
    
    func dateIsInRange(_ dateC: Date, startDate: Date, endDate: Date) -> Bool {
        let calendar = Calendar.current
        
        // 日付のみを取得
        let componentsC = calendar.dateComponents([.year, .month, .day], from: dateC)
        let dateOnlyC = calendar.date(from: componentsC)!
        
        let componentsStart = calendar.dateComponents([.year, .month, .day], from: startDate)
        let dateOnlyStart = calendar.date(from: componentsStart)!
        
        let componentsEnd = calendar.dateComponents([.year, .month, .day], from: endDate)
        let dateOnlyEnd = calendar.date(from: componentsEnd)!
        
        // 日付の範囲内にあるかどうかを判断
        return dateOnlyC >= dateOnlyStart && dateOnlyC <= dateOnlyEnd
    }
}

