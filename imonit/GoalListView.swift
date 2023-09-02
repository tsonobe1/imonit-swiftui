//
//  GoalListView.swift
//  imonit
//
//  Created by 薗部拓人 on 2023/08/15.
//

import SwiftUI

struct GoalListView: View {
    @StateObject private var goalsData: GoalsData
    
    init() {
        let topLevelGoals = createTopLevelGoals(count: 4, maxDepth: 5, maxPerLevel: 3)
        _goalsData = StateObject(wrappedValue: GoalsData(goals: topLevelGoals))
    }
    
    var body: some View {
        ScrollView {
            ForEach(goalsData.goals) { goal in
                GoalView(goal: goal)
                    .padding(.bottom)
            }
        }
    }
}

struct GoalView: View {
    @ObservedObject var goal: Goal
    @State private var isExpanded: Bool = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(goal.title)
                        .font(.headline)
                        .bold()
                    Text(goal.description)
                        .font(.caption)
                        .lineLimit(3)
                        .truncationMode(.middle)
                    Text("\(dateFormatter.string(from: goal.startDate)) ~ \(dateFormatter.string(from: goal.endDate))")
                        .font(.caption)
                        .lineLimit(2)
                        .truncationMode(.middle)
                }
                .padding(16)
                .background(.thickMaterial)
                .cornerRadius(12)
                
                
                Spacer()
                
                if !goal.childGoals.isEmpty {
                    Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 20))
                        .padding(.trailing, 20)
                        .onTapGesture {
                            isExpanded.toggle()
                        }
                }
            }
            
            if isExpanded {
                ForEach(goal.childGoals) { childGoal in
                    GoalView(goal: childGoal)
                        .padding(.leading)
                }
            }
        }
    }
}


#Preview {
    GoalListView()
}
