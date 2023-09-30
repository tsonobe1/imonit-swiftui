//
//  CustomBackGround.swift
//  imonit
//
//  Created by tsonobe on 2023/09/23.
//

import SwiftUI

/// e,g,
/// .backgrount(Glassmorphism())
struct Glassmorphism: View {
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(.primary.opacity(0.1))
                .blur(radius: 1)
                .background{
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                }
        }
    }
}

/// e,g,
/// .backgrount(GradientBackground())
struct GradientBackground: View {
    var body: some View {
        LinearGradient(colors: [.blue.opacity(0.1), .purple.opacity(0.2), .orange.opacity(0.3), .secondary.opacity(0.1)],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea(.all)
    }
}

/// e,g,
/// .background(ScheduleBackground())
struct ScheduleBackground: View {
    let color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 5, style: .circular)
            .fill(color.gradient.opacity(0.6))
            .mask(
                HStack {
                    Rectangle()
                        .frame(width: 5)
                    Spacer()
                }
            )
            .background {
                RoundedRectangle(cornerRadius: 5, style: .circular)
                    .fill(color.gradient.opacity(0.2))
            }
    }
}
