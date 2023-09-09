//
//  Extension.swift
//  imonit
//
//  Created by 薗部拓人 on 2023/08/22.
//

import Foundation

extension DateFormatter {
    static var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    static var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }
    
    static var weekdayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }
    
    static var shortDateForm: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    static var dayMonthForm: DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MM/dd")
        return formatter
    }
}

func caluculateTimeInterval(startDate: Date, endDate: Date) -> CGFloat {
    let timeInterval = endDate.timeIntervalSince(startDate)
    return CGFloat(timeInterval / 60)
}

func dateToMinute(date: Date) -> CGFloat {
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: date)
    let minute = calendar.component(.minute, from: date)
    return CGFloat((hour * 60) + minute)
}

func formatTime(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm" // 24時間形式
    // formatter.dateFormat = "hh:mm a" // 12時間形式（AM/PM）も可能
    return formatter.string(from: date)
}


func calculateDateProgress(startDate: Date, endDate: Date, currentDate: Date) -> Double {
    
    if currentDate <= startDate {
        return 0.0
    }
    
    if currentDate >= endDate {
        return 100.0
    }
    
    let totalDuration = endDate.timeIntervalSince(startDate)
    let elapsedDuration = currentDate.timeIntervalSince(startDate)
    
    return (elapsedDuration / totalDuration) * 100.0
}
