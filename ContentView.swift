//
//  ContentView.swift
//  imonit
//
//  Created by 薗部拓人 on 2023/08/14.
//

import SwiftUI
import SwiftData

struct ContentView: View {  
    @Environment(\.modelContext) private var context
    @Query var scheduleCategories: [ScheduleCategory]
    
    func existsScheduleCategory() {
        if scheduleCategories.isEmpty {
            let a = ScheduleCategory(
                id: UUID(),
                title: "Important×Urgent",
                createdData: Date(),
                order: 0,
                color_: "#df0000"
            )
            
            let b = ScheduleCategory(
                id: UUID(),
                title: "Important×NotUrgent",
                createdData: Date(),
                order: 1,
                color_: "#ff7700"
            )
            
            
            let c = ScheduleCategory(
                id: UUID(),
                title: "NotImportant×Urgent",
                createdData: Date(),
                order: 2,
                color_: "#ffff7f"
            )
            
            let d = ScheduleCategory(
                id: UUID(),
                title: "NotImportant×NotUrgent",
                createdData: Date(),
                order: 3,
                color_: "#a4895e"
            )
            
            context.insert(a)
            context.insert(b)
            context.insert(c)
            context.insert(d)
        }
    }
    
    var body: some View {
        TopTabView()
            .onAppear{
                existsScheduleCategory()
            }
    }
}


#Preview {
    ContentView()
}
