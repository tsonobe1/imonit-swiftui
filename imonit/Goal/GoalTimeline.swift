//
//  GoalTimeline.swift
//  imonit
//
//  Created by tsonobe on 2023/09/10.
//

import SwiftUI

struct GoalTimeline: View {
    let goal: Goal
    @State private var textHeight: CGFloat = 0

    
    var body: some View {
        GeometryReader { geometry in
            ScrollView{
                HStack{
                    VStack{
                        Text(DateFormatter.shortDateForm.string(from: goal.endDate))
                        Spacer()
                        Text(DateFormatter.shortDateForm.string(from: goal.startDate))
                            .background(GeometryGetter(rect: $textHeight))
                    }
                    .font(.footnote)
                    
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.clear)
                        .border(.cyan)
                        .frame(height: geometry.frame(in: .global).height - textHeight)
                        .overlay {
                            Text(goal.title)
                                .font(.title)
                        }
                }
                .containerRelativeFrame(.vertical, count: 10, span: 10, spacing: 0)
                .padding(.leading)
                .overlay{
                    HStack{
                        VStack{
                            Text(DateFormatter.shortDateForm.string(from: goal.endDate))
                            Spacer()
                            Text(DateFormatter.shortDateForm.string(from: goal.startDate))
                                .background(GeometryGetter(rect: $textHeight))
                        }
                        .font(.footnote)
                        
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.clear)
                            .border(.cyan)
                            .frame(height: geometry.frame(in: .global).height - textHeight)
                            .overlay {
                                Text(goal.title)
                                    .font(.title)
                            }
                    }
                    .containerRelativeFrame(.vertical, count: 10, span: 10, spacing: 0)
                }
            }
        }
        .padding()
    }
}

//#Preview {
//    GoalTimeline()
//        .modelContainer(for: Goal.self)
//}



struct GeometryGetter: View {
    @Binding var rect: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
        .onPreferenceChange(SizePreferenceKey.self) { size in
            self.rect = size.height
        }
    }
}


struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
