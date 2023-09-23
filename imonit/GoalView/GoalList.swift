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
    
    enum FilterType: String, CaseIterable {
        case all = "All"
        case now = "Now"
        case pre = "Pre"
    }
    @State var selectedFilter: FilterType = .all
    
    
    @State private var isSheetPresented: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                ScrollView(showsIndicators: false) {
                    ForEach(noParentGoals){ goal in
                        NavigationLink {
                            GoalDetail(goal: goal)
                        } label: {
                            VStack(alignment:.leading) {
                                Text(goal.title)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(3)
                                
                                DateProgressView(
                                    goal: goal,
                                    dateStyle: DateFormatter.shortDateForm,
                                    imageFont: .caption2,
                                    paddingV: 1,
                                    paddingH: 5,
                                    gradientOpacity: 0.3
                                )
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background{Glassmorphism()}
                        }
                        .foregroundStyle(.primary)
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
            
            .background{GradientBackground()}
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                ToolbarItem {
                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(FilterType.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("search")
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isSheetPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            
        }
        .scrollContentBackground(.hidden)
        .sheet(isPresented: $isSheetPresented) {
            GoelAdd()
        }
    }
}


#Preview {
    GoalList()
        .modelContainer(for: Goal.self)
    
}

