//
//  TabView.swift
//  imonit
//
//  Created by 薗部拓人 on 2023/08/16.
//

import SwiftUI

struct TopTabView: View {
    var body: some View {
        //        VStack {
        TabView() {
            GoalListView()
                .tag(1)
                .tabItem {
                    Label("Goals", systemImage: "flag")
                }
            CalendarView()
                .tag(2)
                .tabItem {
                    Label("Schedules", systemImage: "calendar")
                }
        }
    }
    //    }
}

#Preview {
    TopTabView()
}
