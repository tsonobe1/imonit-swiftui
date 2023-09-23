//
//  imonitApp.swift
//  imonit
//
//  Created by 薗部拓人 on 2023/08/14.
//

import SwiftUI

@main
struct imonitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Goal.self, Schedule.self])
    }
}
