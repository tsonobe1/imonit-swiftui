//
//  ScheduleAdd.swift
//  imonit
//
//  Created by tsonobe on 2023/09/23.
//

import SwiftUI

struct AddSchedule: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var detail: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    @State private var dates: Set<DateComponents> = []
    
    var goal: Goal?
    
    var bounds: ClosedRange<Date> {
        return (goal?.startDate ?? .distantPast)...(goal?.endDate ?? .distantFuture)
    }
    
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Goal")) {
                    if let parent2 = goal {
                        Text(parent2.title)
                    }else{
                        Text("No Goal")
                    }
                }
                
                Section(header: Text("Basic")) {
                    TextField("Title", text: $title)
                    TextField("Detail", text: $detail)
                }
                
                Section(header: Text("Start Date ~ End Date")) {
                    DatePicker(
                        "Start",
                        selection: $startDate,
                        in: bounds
                    )
                    DatePicker(
                        "End",
                        selection: $endDate,
                        in: bounds
                    )
                }
                
                Section {
                    Button("add") {
                        if goal == nil {
                            let newSchedule = Schedule(id: UUID(), title: title, detail: detail, startDate: startDate, endDate: endDate, createdData: Date())
                            context.insert(newSchedule)
                            
                        }else{
                            let newSchedule = Schedule(id: UUID(), title: title, detail: detail, startDate: startDate, endDate: endDate, createdData: Date())
                            goal?.schedules.append(newSchedule)
                        }
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("New Schedule")
    }
}

