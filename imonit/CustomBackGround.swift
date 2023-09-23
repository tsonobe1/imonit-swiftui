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
        LinearGradient(colors: [.blue.opacity(0.1), .purple.opacity(0.3)],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea(.all)
    }
}
