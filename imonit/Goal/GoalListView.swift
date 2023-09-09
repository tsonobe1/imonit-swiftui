//
//  GoalListView.swift
//  imonit
//
//  Created by 薗部拓人 on 2023/08/15.
//

import SwiftUI
import SwiftData

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
                    let new = Goal(id: UUID(), title: sampleTitle, detail: sampleDetail, startDate: Date(), endDate: Date(), createdData: Date())
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
            AddGoel()
        }
    }
}

struct AddGoel: View {
        @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss

        @State private var title: String = ""
        @State private var detail: String = ""
        @State private var startDate: Date = Date()
        @State private var endDate: Date = Date()
        
        var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("基本情報")) {
                        TextField("Title", text: $title)
                        TextField("Detail", text: $detail)
                    }
                    
                    Section(header: Text("日付")) {
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                    }
                    
                    Section {
                        Button("add") {
                            let newGoal = Goal(id: UUID(), title: title, detail: detail, startDate: startDate, endDate: endDate, createdData: Date())
                            context.insert(newGoal)
                            dismiss()
                        }
                    }
                }
                .navigationTitle("新しい目標")
            }
        }
    }








#Preview {
    GoalList()
        .modelContainer(for: Goal.self)
}
