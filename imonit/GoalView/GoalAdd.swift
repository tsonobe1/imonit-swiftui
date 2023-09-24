//
//  GoalAdd.swift
//  imonit
//
//  Created by tsonobe on 2023/09/15.
//

import SwiftUI

@available(macOS 14.0, *)
struct GoelAdd: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var detail: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    var parent: Goal?
    
    var bounds: ClosedRange<Date> {
        return (parent?.startDate ?? .distantPast)...(parent?.endDate ?? .distantFuture)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("parent")) {
                    if let parent2 = parent {
                        Text(parent2.title)
                    }
                }
                
                Section(header: Text("基本情報")) {
                    TextField("Title", text: $title)
                    TextField("Detail", text: $detail)
                }
                
                Section(header: Text("日付")) {
                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        in: bounds,
                        displayedComponents: .date
                    )
                    DatePicker(
                        "End Date", 
                        selection: $endDate,
                        in: bounds,
                        displayedComponents: .date
                    )
                }
                
                Section {
                    Button("add") {
                        let adjustedStartDate = Calendar.current.startOfDay(for: startDate)
                                       
                        let adjustedEndDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate
                        
                        if parent == nil {
                           
                                           
                            let newGoal = Goal(id: UUID(), title: title, detail: detail, startDate: adjustedStartDate, endDate: adjustedEndDate, createdData: Date(), parent: nil)
                            context.insert(newGoal)
                        }else{
                            let newGoal = Goal(id: UUID(), title: title, detail: detail, startDate: adjustedStartDate, endDate: adjustedEndDate, createdData: Date(), parent: parent)
                            
//                            context.insert(newGoal)
                            parent?.children.append(newGoal)

                        }
                        dismiss()
                    }
                }
            }
            .navigationTitle(parent == nil ? "New Goal" : "New Child Goal")
        }
    }
}


#Preview {
        GoelAdd()
}
