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
    
    @Relationship(deleteRule:.cascade) var schedules: [Schedule] = []
    
    
    init(id: UUID, title: String, detail: String, startDate: Date, endDate: Date, createdData: Date, parent: Goal?) {
        self.id = id
        self.title = title
        self.detail = detail
        self.startDate = startDate
        self.endDate = endDate
        self.createdData = createdData
        self.parent = parent
    }
    
}

@Model
final class Schedule {
    @Attribute(.unique) var id: UUID
    var title: String
    var detail: String
    var startDate: Date
    var endDate: Date
    var createdData: Date
    var goal: Goal?
    
    @Relationship var categories: [ScheduleCategory]

    
    init(
        id: UUID, 
        title: String,
        detail: String, 
        startDate: Date,
        endDate: Date,
        createdData: Date,
        // Relationship
        goal: Goal? = nil,
        categories: [ScheduleCategory] = []
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.startDate = startDate
        self.endDate = endDate
        self.createdData = createdData
        // Relationship
        self.goal = goal
        self.categories = categories
    }
}

// Add ScheduleCategory Model
@Model
final class ScheduleCategory {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdData: Date
    var color_: String?
    var color: Color {
        get {
            if let colorHexValue = color_,
               let color = Color(hex: colorHexValue) {
               return color
            } else {
               return Color.black
            }
        }
        set {
           color_ = newValue.toHex()
        }
    }
    var schedules: [Schedule] = []

    
    init(
        id: UUID,
        title: String,
        createdData: Date,
        color_: String? = nil,
        schedules: [Schedule] = []
        
    ) {
        self.id = id
        self.name = title
        self.createdData = createdData
        self.color_ = color_
        self.schedules = schedules
        
    }
}


struct ColorData: Codable {
    var red: Double = 1
    var green: Double = 1
    var blue: Double = 1
    var opacity: Double = 1
    
    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
    
    init(red: Double, green: Double, blue: Double, opacity: Double) {
        self.red = red
        self.green = green
        self.blue = blue
        self.opacity = opacity
    }
    
    init(color: Color)  {
        let components = color.cgColor?.components ?? []
  
        if components.count > 0 {
            self.red  = Double(components[0])
        }
        
        if components.count > 1 {
            self.green = Double(components[1])
        }
        
        if components.count > 2 {
            self.blue = Double(components[2])
        }
        
        if components.count > 3 {
            self.opacity = Double(components[3])
        }
    }
}

extension Color {
    
    init?(hex: String) {
        var hexNormalized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexNormalized = hexNormalized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        var r: Double = 0.0
        var g: Double = 0.0
        var b: Double = 0.0
        var a: Double = 1.0
        let length = hexNormalized.count

        Scanner(string: hexNormalized).scanHexInt64(&rgb)

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
    
    
    func toHex() -> String? {
        
        guard let components = cgColor?.components, components.count > 2 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a: Float = 1
        
        if components.count == 4 {
            a = Float(components[3])
        }
        
        let hex = String(format: "%02lX%02lX%02lX%02lX",
                         lroundf(r * 255),
                         lroundf(g * 255),
                         lroundf(b * 255),
                         lroundf(a * 255))
        
        return hex
    }
}
