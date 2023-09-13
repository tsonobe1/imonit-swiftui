//
//  GoalTimeline.swift
//  imonit
//
//  Created by tsonobe on 2023/09/10.
//

import SwiftUI

struct GoalTimeline: View {
    let goal: Goal
    @State private var showChildren: Bool = false
    @State private var textHeight: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0){
            
            GeometryReader { geometry in
                ScrollView{
                    
                    HStack(spacing: 0){
                        VStack(alignment: .trailing){
                            Text(DateFormatter.shortDateForm.string(from: goal.endDate))
                            Spacer()
                            Text(DateFormatter.shortDateForm.string(from: goal.startDate))
                                .background(
                                    GeometryReader { geometry in
                                        Color.clear
                                            .preference(key: SizePreferenceKey.self, value: geometry.size)
                                    }
                                        .onPreferenceChange(SizePreferenceKey.self) { size in
                                            self.textHeight = size.height
                                        }
                                )
                        }
                        .font(.caption)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.thinMaterial)
                            .border(.cyan)
                            .frame(height: geometry.frame(in: .global).height - textHeight)
                            .onTapGesture {
                                showChildren.toggle()
//                                print(showChildren)
                            }
                            .background(
                                VStack(spacing: 0){
                                    Rectangle().frame(height: 1)
                                    Spacer()
                                    Rectangle().frame(height: 1)
                                }
                                    .foregroundStyle(.cyan)
                                    .offset(x: -10)
                            )
                            .overlay {
                                Text(goal.title)
                                    .font(.title)
                            }
//                        let _ = print(goal.children)
                        
                    }
                    .containerRelativeFrame(.vertical, count: 10, span: 10, spacing: 0)
//                    .padding(.leading)
                }
                .overlay{
                    if showChildren {
                        VStack(spacing: 0){
                            ForEach(goal.children) { child in
                                GoalTimeline(goal: child)
                                    .padding(.leading)
                            }
                        }
                    }
                }
            }
            
            
        }
    }
}



struct SubGoalTimeline: View {
    let child: Goal
    @State private var showChildren: Bool = false
    @State private var textHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView{
                HStack(spacing: 0){
                    VStack(alignment: .trailing){
                        Text(DateFormatter.shortDateForm.string(from: child.endDate))
                        Spacer()
                        Text(DateFormatter.shortDateForm.string(from: child.startDate))
                            .background(
                                GeometryReader { geometry in
                                    Color.clear
                                        .preference(key: SizePreferenceKey.self, value: geometry.size)
                                }
                                    .onPreferenceChange(SizePreferenceKey.self) { size in
                                        self.textHeight = size.height
                                    }
                            )
                    }
                    .font(.caption)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.thinMaterial)
                        .border(.cyan)
                        .frame(height: geometry.frame(in: .global).height - textHeight)
                        .onTapGesture {
                            showChildren.toggle()
//                                print(showChildren)
                        }
                        .background(
                            VStack(spacing: 0){
                                Rectangle().frame(height: 1)
                                Spacer()
                                Rectangle().frame(height: 1)
                            }
                                .foregroundStyle(.cyan)
                                .offset(x: -10)
                        )
                        .overlay {
                            Text(child.title)
                                .font(.title)
                        }
//                        let _ = print(goal.children)
                    
                }
                .containerRelativeFrame(.vertical, count: 10, span: 10, spacing: 0)
//                    .padding(.leading)
            }
//                .overlay{
//                    if showChildren {
//                        ForEach(goal.children) { childGoal in
//                            GoalTimeline(goal: childGoal)
//                                .padding(.leading)
//                        }
//                    }
//                }
        }
    }
}








//#Preview {
//    GoalTimeline()
//        .modelContainer(for: Goal.self)
//}



struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
