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

/// 使用例
//if let date = Date().positionInCurrentMonth() {
//    print(String(format: "%.2f", date))
//} else {
//    print("日付の情報を取得できませんでした。")
//}
extension Date {
    func positionInCurrentMonth() -> CGFloat? {
        let calendar = Calendar.current

        // 現在の日付が月の何日目にあるのかを取得
        guard let dayOfCurrentDate = calendar.dateComponents([.day], from: self).day else {
            return nil // 何らかの理由で日付が取得できなかった場合
        }

        // 月の総日数を取得
        guard let range = calendar.range(of: .day, in: .month, for: self) else {
            return nil // 何らかの理由で範囲が取得できなかった場合
        }
        let totalDaysInMonth = range.count

        // 現在の日付が月の何割に位置するのかを計算
        return CGFloat(dayOfCurrentDate) / CGFloat(totalDaysInMonth)
    }
}

//// 使用例
//if let position = Date().positionInCurrentDay() {
//    print("Current position in day: \(position)")
//} else {
//    print("Could not retrieve the time information.")
//}
extension Date {
    func positionInCurrentDay() -> CGFloat? {
        let calendar = Calendar.current

        // 現在の日付から、時、分、秒を取得
        let components = calendar.dateComponents([.hour, .minute, .second], from: self)
        guard let hour = components.hour, let minute = components.minute, let second = components.second else {
            return nil // 何らかの理由で時間情報が取得できなかった場合
        }

        // 1日は24時間なので、その中で現在の時刻が何割か計算
        let totalSecondsInDay: CGFloat = 24 * 60 * 60
        let currentSeconds: CGFloat = CGFloat(hour * 3600 + minute * 60 + second)
        
        return currentSeconds / totalSecondsInDay
    }
}


// 月の初日から末日までのDateを生成する関数
func generateDatesOfMonth(selectedMonth: Date) -> [Date]? {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current // または任意のタイムゾーン
    
    // 月の初日を取得
    var components = calendar.dateComponents([.year, .month], from: selectedMonth)
    guard let firstDayOfMonth = calendar.date(from: components) else {
        return nil
    }
    
    // 月の末日を取得
    components.month! += 1
    components.day = 0
    guard let lastDayOfMonth = calendar.date(from: components) else {
        return nil
    }
    
    // 生成したDateオブジェクトを格納するための配列
    var dates = [Date]()
    
    var date = firstDayOfMonth
    while date <= lastDayOfMonth {
        dates.append(date)
        if let nextDate = calendar.date(byAdding: .day, value: 1, to: date) {
            date = nextDate
        } else {
            break
        }
    }
    
    return dates
}
