//
//  DateProgress.swift
//  imonit
//
//  Created by tsonobe on 2023/09/23.
//

import SwiftUI


struct DateProgressView: View {
    let goal: Goal
    var dateStyle: DateFormatter
    var imageFont: Font
    var paddingV: CGFloat
    var paddingH: CGFloat
    var gradientOpacity: Double
    
    private var progress: Double {
        calculateDateProgress(
            startDate: goal.startDate,
            endDate: goal.endDate,
            currentDate: Date()
        )
    }
    
    var body: some View {
        HStack {
            HStack(alignment: .lastTextBaseline){
                Image(systemName: progress <= 0 ? "hourglass" : progress >= 1 ? "hourglass.bottomhalf.filled" : "hourglass")
                Text(dateStyle.string(from: goal.startDate))
                Text(" ~ ")
                Text(dateStyle.string(from: goal.endDate))
            }
            .font(imageFont)
            .foregroundStyle(.primary)
            .padding(.vertical, paddingV)
            .padding(.horizontal, paddingH)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.thinMaterial)
                    .overlay(
                        GeometryReader { proxy in
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.green.opacity(gradientOpacity))
                                .frame(width: proxy.frame(in: .global).width / 100 * progress)
                        }
                    )
            )
            
            HStack{
                Text("\(String(format: "%.1f", progress)) %")
            }
            .font(imageFont)
            .foregroundStyle(progress == 100 ? .green : .primary)
        }
    }
}

