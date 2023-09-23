//
//  SubGoalDetail.swift
//  imonit
//
//  Created by tsonobe on 2023/09/23.
//

import SwiftUI
import SwiftData

@available(macOS 14.0, *)
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
    
    @State private var isExpanded = true
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                ScrollView{
                    if children.isEmpty {
                        ContentUnavailableView {
                            Label("No Sub Goal", systemImage: "")
                        }
                    }else{
                        ForEach(children){ child in
                            ChildRow(child: child, isLast: children.last?.id == child.id)
                        }
                    }
                }
            },
            label: {
                HStack(alignment: .lastTextBaseline){
                    Image(systemName: "figure.stairs")
                    Text("SubGoal")
                    
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
                .font(.headline)

            }
            
        )
        .foregroundStyle(.primary)
        
        // TODO: I will delete
        Button("add"){
            let new = Goal(id: UUID(), title: sampleTitle, detail: sampleDetail, startDate: Date(), endDate: Date(), createdData: Date(), parent: nil)
            new.parent = goal
            goal.children.append(new)
        }
        
        .sheet(isPresented: $isAddSheetPresented) {
            GoelAdd(parent: goal)
        }
        .sheet(isPresented: $isTimelinePresented) {
            GoalTimeline(goal: goal)
            let _ = print(goal.children)
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
                    DateProgressView(
                        goal: child,
                        dateStyle: DateFormatter.dayMonthForm,
                        imageFont: .caption2,
                        paddingV: 1,
                        paddingH: 5,
                        gradientOpacity: 0.3)
                }
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .padding(5)
            }
            nestedSubGoalExpand
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .background{
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
                .background{
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                }
        }
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
