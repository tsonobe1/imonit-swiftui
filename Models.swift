//
//  Models.swift
//  imonit
//
//  Created by tsonobe on 2023/09/09.
//

import SwiftUI
import SwiftData


@Model
final class Goal {
    @Attribute(.unique) var id: UUID
    var title: String
    var detail: String
    var startDate: Date
    var endDate: Date
    var createdData: Date
    
    var parent: Goal?
    @Relationship(deleteRule:.cascade) var children: [Goal] = []
    
    init(id: UUID, title: String, detail: String, startDate: Date, endDate: Date, createdData: Date) {
        self.id = id
        self.title = title
        self.detail = detail
        self.startDate = startDate
        self.endDate = endDate
        self.createdData = createdData
    }
}
