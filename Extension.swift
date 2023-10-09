//
//  Extension.swift
//  imonit
//
//  Created by 薗部拓人 on 2023/08/22.
//

import Foundation

// Text(DateFormatter.dayFormatter.string(from: currentDate))
extension DateFormatter {
    // 1
    static var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    // 2023
    static var yearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }
    
    // Jan
    static var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }
    
    // Tue
    static var weekdayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }
    
    // 12/31/23
    static var shortDateForm: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    // 12:00
    static var shortTimeForm: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
     
    // 02/28
    static var nonZeroDayMonthForm: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter
    }
    
    // 02/28
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
func generateDatesOfMonth(for selectedMonth: Date) -> [Date]? {
    let calendar = Calendar.current
    
    guard
        // selectedMonthの年と月のうちの、初日を取得
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedMonth)),
        // startOfMonthの1ヶ月後の1秒前を取得
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)?.addingTimeInterval(-1)
    else {
        return nil
    }
    
    var dates: [Date] = []
    var currentDate = startOfMonth
    // currentDateがendOfMonthに追いつくまで、currentDateを加算しながら配列に追加する
    while currentDate <= endOfMonth {
        dates.append(currentDate)
        
        if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
            currentDate = nextDate
        } else {
            break
        }
    }
    
    return dates
}


extension Date {
    // 曜日を数値で返す 日:1 ... 土:6
    func getWeekDay() -> Int {
        return Calendar.current.component(.weekday, from: self) - 1
    }
    
    var firstDayOfNextMonth: Date? {
        let calendar = Calendar.current
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: self) {
            return calendar.date(from: calendar.dateComponents([.year, .month], from: nextMonth))
        }
        return nil
    }
    
    var lastDayOfPreviousMonth: Date? {
        let calendar = Calendar.current
        if let firstDayOfCurrentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: self)),
           let lastDayOfPreviousMonth = calendar.date(byAdding: .day, value: -1, to: firstDayOfCurrentMonth) {
            return lastDayOfPreviousMonth
        }
        return nil
    }
}
