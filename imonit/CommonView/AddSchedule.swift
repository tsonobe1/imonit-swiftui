//
//  ScheduleAdd.swift
//  imonit
//
//  Created by tsonobe on 2023/09/23.
//

import SwiftUI
import SwiftData

struct AddSchedule: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Query(sort: \ScheduleCategory.order, order: .forward)
    private var scheduleCategories: [ScheduleCategory]
    
    
    @State private var title: String = ""
    @State private var detail: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    @State private var dates: Set<DateComponents> = []
    @State private var selectedCategory: ScheduleCategory?
    
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
                
                Section(header: Text("Category")){
                    Picker(selection: $selectedCategory) {
                        Text("none").tag(ScheduleCategory?(nil))
                        ForEach(scheduleCategories, id: \.self) { category in
                            Text(category.name).tag(category as ScheduleCategory?)
                        }
                    } label: {
                        Capsule()
                            .fill(selectedCategory?.color ?? .gray)
                            .frame(width: 15)
                    }
                }
                
                Section(header: Text("Basic")) {
                    TextField("Title", text: $title)
                    TextField("Detail", text: $detail)
                }
                
                Section {
                    DatePicker(
                        "Start",
                        selection: $startDate,
                        in: bounds
                    )
                    .foregroundStyle(startDate > endDate ? .red : .primary)
                    
                    DatePicker(
                        "End",
                        selection: $endDate,
                        in: bounds
                    )
                    .foregroundStyle(startDate > endDate ? .red : .primary)
                } header: {
                    Text("Start Date ~ End Date")
                } footer: {
                    Text("Start date should be before end date.")
                        .foregroundColor(.red)
                        .font(.caption2)
                        .opacity(startDate > endDate ? 1 : 0)
                }
                
                
                
                
                
                
                Section {
                    Button("add") {
                        if goal == nil {
                            let newSchedule = Schedule(id: UUID(), title: title, detail: detail, startDate: startDate, endDate: endDate, createdData: Date(), category: selectedCategory)
                            context.insert(newSchedule)
                            
                        }else{
                            let newSchedule = Schedule(id: UUID(), title: title, detail: detail, startDate: startDate, endDate: endDate, createdData: Date(), category: selectedCategory)
                            goal?.schedules.append(newSchedule)
                        }
                        dismiss()
                    }
                }
            }
        }
        .navigationBarHidden(true)
//        .navigationTitle("New Schedule")
    }
}

