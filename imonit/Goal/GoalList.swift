//
//  GoalListView.swift
//  imonit
//
//  Created by 薗部拓人 on 2023/08/15.
//

import SwiftUI
import SwiftData

@available(macOS 14, *)
struct GoalList: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Goal> { $0.parent == nil },
           sort: [SortDescriptor(\.createdData)] )
    var noParentGoals: [Goal]
    
    let sampleTitle = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt"
    let sampleDetail = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt."
    
    @State private var isSheetPresented: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                ScrollView {
                    ForEach(noParentGoals){ goal in
                        NavigationLink {
                            GoalDetail(goal: goal)
                        } label: {
                            HStack{
                                Image(systemName: "flag")
                                Text(goal.title)
                            }
                            .foregroundStyle(.blue.gradient)
                            .frame(maxWidth: .infinity)
                            .border(.blue)
                        }
                    }
                }
                Button("add"){
                    let new = Goal(id: UUID(), title: sampleTitle, detail: sampleDetail, startDate: Date(), endDate: Date(), createdData: Date(), parent: nil)
                    context.insert(new)
                }
                Button("All Delete"){
                    try?context.delete(model: Goal.self, includeSubclasses: false)
                }
            }
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isSheetPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
            
        }
        
        .sheet(isPresented: $isSheetPresented) {
            GoelAdd()
        }
    }
}


#Preview {
        GoalList()
            .modelContainer(for: Goal.self)
    
}
