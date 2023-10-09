//
//  ScheduleList.swift
//  imonit
//
//  Created by tsonobe on 2023/09/23.
//

import SwiftUI
import SwiftData

struct GoalScheduleList: View {
    @Environment(\.modelContext) private var context
    @State private var isExpandedScheduleDisclosure = true
    @State private var isAddScheduleSheetPresented = false
    
    var goal: Goal?
    var selectedDate: Date?
    
    @Query(sort: \Schedule.startDate, order: .forward)
    var schedules: [Schedule]
    
    init(goal: Goal){
        self.goal = goal
        let goalID = goal.id
        let filter = #Predicate<Schedule> { $0.goal?.id == goalID }
        let query = Query(filter: filter, sort: \.startDate)
        _schedules = query
    }
    
    init(selectedDate: Date){
        self.selectedDate = selectedDate
        let filter = #Predicate<Schedule> { $0.startDate > selectedDate && $0.endDate < selectedDate }
        let query = Query(filter: filter, sort: \.startDate)
        _schedules = query
    }

    var body: some View {
        let _ = print(selectedDate)
        let _ = print(schedules)
        DisclosureGroup(
            isExpanded: $isExpandedScheduleDisclosure,
            content: {
                if schedules.isEmpty {
                    ContentUnavailableView {
                        Label("No Schedule", systemImage: "plus")
                    }.opacity(0.5)
                }
                ForEach(schedules) { schedule in
                    ScheduleRow(schedule: schedule)
                }
            },
            label: {
                HStack(alignment: .lastTextBaseline){
                    Image(systemName: "calendar")
                    Text("Schedule")
                    // print messsage button
                    Button{
                        isAddScheduleSheetPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
        //            Button{
        //                let newSchedule = Schedule(id: UUID(), title: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum", detail: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum", startDate: Date(), endDate: Date(), createdData: Date())
        //                goal.schedules.append(newSchedule)
        //
        //            } label: {
        //                Text("Add")
        //            }
                }
                .font(.headline)
            }
        )
        .foregroundStyle(.primary)
        .sheet(isPresented: $isAddScheduleSheetPresented) {
            AddSchedule(goal: goal)
        }
    }
}

struct ScheduleRow: View {
    let schedule: Schedule
    
    private var dateView: some View {
        Group{
            Text(DateFormatter.nonZeroDayMonthForm.string(from: schedule.startDate))
                .font(.footnote)
            
            
            VStack(alignment: .center) {
                Text(DateFormatter.shortTimeForm.string(from: schedule.startDate))
//                                Spacer(minLength: 2)
                Image(systemName: "chevron.down")
                    .padding(.vertical, 1)
//                                Spacer(minLength: 2)
                Text(DateFormatter.shortTimeForm.string(from: schedule.endDate))
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
            
        }
    }

    var body: some View {
        NavigationStack{
            NavigationLink {
                Text("TSET")
            } label: {
                HStack(alignment: .center, spacing: 1) {
                    
                    dateView
                        .containerRelativeFrame(.horizontal, count: 10, span: 1, spacing: 0)
                    
                    Text(schedule.title)
                        .font(.callout)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background{
                            ScheduleBackground(color: schedule.category?.color ?? .gray)
                        }
                }
                .padding(.vertical, 5)
            }
            .foregroundStyle(.primary)
        }
    }
}

