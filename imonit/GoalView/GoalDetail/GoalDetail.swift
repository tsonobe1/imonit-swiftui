//
//  GoalDetail.swift
//  imonit
//
//  Created by tsonobe on 2023/09/09.
//

import SwiftUI
import SwiftData

@available(macOS 14.0, *)
struct GoalDetail: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.modelContext) private var context
    let goal: Goal
    
    
    @State private var isExpandedAbountDisclosure = true
    @State private var isEditSheetPresented = false
    @State private var isDeleteSheetPresented = false
    private var progress: Double {
        calculateDateProgress(startDate: goal.startDate, endDate: goal.endDate, currentDate: Date())
    }
    
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                // 👩‍👧MARK: ParentPath
                if goal.parent != nil {
                    ScrollView(.horizontal, showsIndicators: false){
                        parentPath
                    }
                }
                
                // 😀MARK: title
                Text(goal.title)
                    .font(.title3)
                
                // 📈MARK: StartDate ~ EndDate % progress
                DateProgressView(
                    goal: goal,
                    dateStyle: DateFormatter.shortDateForm,
                    imageFont: .footnote,
                    paddingV: 5,
                    paddingH: 10,
                    gradientOpacity: 0.6
                )
                
                // ℹ️MARK: Detail
                details
                
                // 📆MARK: Schedule
                ScheduleList(goal: goal)
                
                // ⛳️MARK: Children = subGoal
                SubGoal(goal: goal)
            }
        }
        .padding(5)
        .background(GradientBackground())
        .navigationBarTitleDisplayMode(.inline)
        // MARK: Edit, Delete
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isEditSheetPresented.toggle()
                } label: {
                    Image(systemName: "pencil")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isDeleteSheetPresented.toggle()
                } label: {
                    Image(systemName: "trash")
                }
                
            }
        }
        // TODO: edit
        .sheet(isPresented: $isEditSheetPresented) {
            Text("EDIT")
        }
        .alert("\(goal.title)を削除しますか？", isPresented: $isDeleteSheetPresented) {
            //            Button("Cancel") {isDeleteSheetPresented.toggle()}
            Button("Delete", role: .destructive) {
                context.delete(goal)
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    
    private var details: some View {
        DisclosureGroup(
            isExpanded: $isExpandedAbountDisclosure,
            content: {
                VStack(alignment: .leading){
                    HStack(alignment: .lastTextBaseline){
                        Text("Created Date: ")
                        Text(goal.createdData, style: .date)
                    }
                    .foregroundStyle(.secondary)
                    .font(.caption2)
                    
                    Text(goal.detail)
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            },
            label: {
                HStack{
                    Text("About")
                        .font(isExpandedAbountDisclosure ? .headline : .headline)
                        .foregroundStyle(.primary)
                }
            }
        )
        .foregroundStyle(.primary)
        .padding(isExpandedAbountDisclosure ? 10 : 0)
        .background(
            Glassmorphism()
                .opacity(isExpandedAbountDisclosure ? 0.5 : 0)
        )
    }
    private var parentPath: some View {
        Text(generateParentPath(for: goal))
            .font(.footnote)
            .foregroundStyle(.secondary)
            .bold()
    }
    private func generateParentPath(for goal: Goal) -> String {
        var path = ""
        var currentGoal: Goal? = goal.parent  // 最初に親に移動
        while let goal = currentGoal {
            if !path.isEmpty {
                path = " > " + path
            }
            path = goal.title + path
            currentGoal = goal.parent
        }
        if !path.isEmpty {
            path += " > "
        }
        return path
    }
}



#Preview {
    GoalList()
        .modelContainer(for: Goal.self)
}
