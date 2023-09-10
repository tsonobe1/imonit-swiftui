//
//  GoalDetail.swift
//  imonit
//
//  Created by tsonobe on 2023/09/09.
//

import SwiftUI
import SwiftData

struct GoalDetail: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.modelContext) private var context
    let goal: Goal
 
    
    @State private var isExpandedDisclosure = true
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
                dateProgress
                
                // ℹ️MARK: Detail
                details
                
                // ⛳️MARK: Children = subGoal
                SubGoal(goal: goal)
            }
        }
        .padding(5)
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
        .alert("Delete", isPresented: $isDeleteSheetPresented) {
            Button("Delete") {
                context.delete(goal)
                self.presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel") {isDeleteSheetPresented.toggle()}
        }
    }
    
    private var dateProgress: some View {
        HStack {
            HStack(alignment: .lastTextBaseline){
                Image(systemName: "calendar.badge.clock")
                Text(DateFormatter.shortDateForm.string(from: goal.startDate))
                Text(" ~ ")
                Text(DateFormatter.shortDateForm.string(from: goal.endDate))
            }
            .foregroundStyle(.primary)
            .font(.footnote)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.thinMaterial)
                    .overlay(
                        GeometryReader { proxy in
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.green.gradient.opacity(0.6))
                                .frame(width: proxy.frame(in: .global).width / 100 * progress)
//                                .blendMode(.difference)
                        }
                    )
            )
            
            // MARK: progress & check mark
            HStack{
                Text("\(String(format: "%.1f", progress)) %")
                Image(systemName: "checkmark")
                    .opacity(progress == 100 ? 1 : 0)
            }
            .font(.footnote)
            .foregroundStyle(progress == 100 ? .green : .primary)
        }
    }
    private var details: some View {
        DisclosureGroup(
            isExpanded: $isExpandedDisclosure,
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
            },
            label: {
                HStack{
                    Text("About")
                        .font(isExpandedDisclosure ? .headline : .headline)
                        .foregroundStyle(.primary)
                }
            }
        )
        .padding(isExpandedDisclosure ? 10 : 0)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.thickMaterial)
                .opacity(isExpandedDisclosure ? 1 : 0)
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


struct SubGoal: View {
    @Environment(\.modelContext) private var context
    let goal: Goal
    
    @Query(sort: \Goal.startDate, order: .forward)
    var children: [Goal]
    
    init(goal: Goal) {
        self.goal = goal
        let goalID = goal.id
        let filter = #Predicate<Goal> { goal in
            goal.parent?.id == goalID
        }
        let query = Query(filter: filter, sort: \.startDate)
        _children = query
    }
    
    @State private var isTimelinePresented = false
    @State private var isAddSheetPresented = false
    
    var body: some View {
        VStack(alignment: .leading){
            // Headline
            HStack(alignment: .lastTextBaseline){
                Image(systemName: "figure.stairs")
                Text("SubGoal")
                    .font(.headline)
                
                Button {
                    isTimelinePresented.toggle()
                } label: {
                    Image(systemName: "calendar.day.timeline.left")
                }
                
                Button {
                    isAddSheetPresented.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            // SubGoals
            ScrollView{
                ForEach(children){ child in
                    ChildRow(child: child, isLast: children.last?.id == child.id)
                }
                Spacer(minLength: 10)
            }
            
            // TODO: I will delete
            Button("add"){
                let new = Goal(id: UUID(), title: sampleTitle, detail: sampleDetail, startDate: Date(), endDate: Date(), createdData: Date(), parent: nil)
                new.parent = goal
                goal.children.append(new)
            }
        }
        .sheet(isPresented: $isAddSheetPresented) {
            AddGoel(parent: goal)
        }
        .sheet(isPresented: $isTimelinePresented) {
            GoalTimeline(goal: goal)
        }
    }
    
    let sampleTitle = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt"
    let sampleDetail = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt."
}

struct ChildRow: View {
    @Environment(\.colorScheme) var colorScheme
    
    let child: Goal
    @Query(sort: \Goal.startDate, order: .forward)
    var grandChildren: [Goal]
    let isLast: Bool
    
    @State private var isExpanded: Bool = false
    private var progress: Double {
        calculateDateProgress(startDate: child.startDate, endDate: child.endDate, currentDate: Date())
    }
    
    init(child: Goal, isLast: Bool) {
        self.child = child
        let childID = child.id
        let filter = #Predicate<Goal> { grandChild in
            grandChild.parent?.id == childID
        }
        let query = Query(filter: filter, sort: \.startDate)
        _grandChildren = query
        
        self.isLast = isLast
    }
    
    var body: some View {
        VStack(alignment: .leading,  spacing: 0){
            subGoalRow
            parentChildConnector
            nestedSubGoal
        }
        .background(siblingConnector)
    }
    
    private var subGoalRow: some View {
        HStack{
            NavigationLink {
                GoalDetail(goal: child)
            } label: {
                VStack(alignment: .leading){
                    Text(child.title)
                        .font(.footnote)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    dateProgress
                }
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .padding(5)
            }
            nestedSubGoalExpand
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .background{
            RoundedRectangle(cornerRadius: 8)
                .fill(.regularMaterial)
        }
    }
    private var dateProgress: some View {
        HStack{
            HStack(alignment: .lastTextBaseline){
                Image(systemName: "calendar.badge.clock")
                Text(DateFormatter.dayMonthForm.string(from: child.startDate))
                Text("~")
                Text(DateFormatter.dayMonthForm.string(from: child.endDate))
            }
            .font(.caption2)
            .padding(.vertical, 1)
            .padding(.horizontal, 5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.thinMaterial)
                    .overlay(
                        GeometryReader { proxy in
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.green.gradient.opacity(0.3))
                                .frame(width: proxy.frame(in: .global).width / 100 * progress)
                        }
                    )
            )
            HStack{
                Text("\(String(format: "%.1f", progress)) %")
                Image(systemName: "checkmark")
                    .opacity(progress == 100 ? 1 : 0)
            }
            .foregroundStyle(progress == 100 ? .green : .primary)
        }
        .font(.caption2)
    }
    private var nestedSubGoalExpand: some View{
        Group{
            if !grandChildren.isEmpty {
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
                    .font(.system(size: 15))
                    .onTapGesture {
                        withAnimation {
                            isExpanded.toggle()
                        }
                        
                    }
                    .padding(.trailing)
            }
        }
    }
    private var parentChildConnector: some View {
           Rectangle()
               .frame(width: 3)
               .opacity(grandChildren.isEmpty || !isExpanded ? 0 : 0.8)
               .foregroundColor(Color.secondary)
               .opacity(0.6)
               .padding(.leading)
               .offset(x: 5)
       }
    private var nestedSubGoal: some View {
        VStack(spacing: 0){
            if isExpanded {
                ForEach(grandChildren) { grandChild in
                    ChildRow(child: grandChild, isLast: grandChildren.last?.id == grandChild.id)
                        .padding(.leading)
                }
            }
        }
    }
    private var siblingConnector: some View{
        return Rectangle()
            .fill(Color.secondary)
            .opacity(isLast ? 0 : 0.8)
            .mask(
                HStack {
                    Rectangle()
                        .frame(width: 3)
                        .offset(x: 5, y: 10)
                    Spacer()
                })
    }
}


#Preview {
    GoalList()
        .modelContainer(for: Goal.self)
}
