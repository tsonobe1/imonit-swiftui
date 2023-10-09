//
//  CalendatMonthly.swift
//  imonit
//
//  Created by tsonobe on 2023/10/07.
//

import SwiftUI
import SwiftData

struct CalendatMonthly: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Schedule.startDate, order: .forward)
    var schedules: [Schedule]
    
    @Binding var selectedMonth: Date
    var dateOfMonth: [Date]
    
    let week = ["Sum", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        
        NavigationStack{
            ScrollView {
                HStack {
                    ForEach(week, id: \.self) { i in
                        Text(i)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) { // カラム数の指定
                    let start = dateOfMonth[0].getWeekDay()
                    let end = start + dateOfMonth.count
                    
                    ForEach(0...41, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.clear)
                            .frame(width: 60, height: 60)
                            .overlay {
                                if (index >= start && index < end){
                                    let i = index - start
                                    NavigationLink {
                                        CalendarScheduleList(selectedDate: dateOfMonth[i])
                                    } label: {
                                        Text(DateFormatter.dayFormatter.string(from: dateOfMonth[i]))
                                            .foregroundStyle(Calendar.current.isDate(dateOfMonth[i], equalTo: Date(), toGranularity: .day) ? Color.cyan : Color.primary)
                                    }
                                }else {
                                    Text("")
                                }
                            }
                    }
                }
            }
        }
    }
}
//
//#Preview {
//    CalendatMonthly(selectedMonth: .constant(Date()), dateOfMonth: .constant(Date()))
//}
