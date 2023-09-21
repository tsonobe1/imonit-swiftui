//
//  scroll7.swift
//  imonit
//
//  Created by 薗部拓人 on 2023/08/26.
//

import SwiftUI

struct CalendarWeeklyView: View {
    let events = createEvents()
    
    var hourHeight: CGFloat = 60
    var headerHeight: CGFloat = 60

    @State private var offset = CGPoint.zero
    
    let currentDate: Date // 現在の日付を取得
    @Binding var selectedMonth: Date
    var dateOfMonth: [Date]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            MonthSelector(selectedMonth: $selectedMonth)
                .padding(.horizontal)
            
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Color.clear.frame(height: headerHeight)
                    ScrollView([.vertical]) {
                        TimeColumnHeader(
                            currentDate: currentDate,
                            hourHeight: hourHeight
                        )
                        .offset(y: offset.y)
                    }
                    .disabled(true)
                    .offset(y: -hourHeight/4)
                    .scrollIndicators(.hidden)
                }
                .containerRelativeFrame(.horizontal, count: 10, span: 1, spacing: 0)
                
                VStack(alignment: .leading, spacing: 0) {
                    ScrollView([.horizontal]) {
                        DateRowHeader(
                            dateOfMonth: dateOfMonth,
                            headerHeight: headerHeight,
                            currentDate: currentDate
                        )
                        .offset(x: offset.x)
                    }
                    .disabled(true)
                    ScheduleTable(
                        dateOfMonth: dateOfMonth,
                        offset: $offset,
                        headerHeight: headerHeight,
                        hourHeight: hourHeight,
                        currentDate: currentDate,
                        selectedMonth: $selectedMonth
                    )
                    .coordinateSpace(.named("scroll"))
                }
                .containerRelativeFrame(.horizontal, count: 10, span: 9, spacing: 0)
            }
        }
    }
}

struct MonthSelector: View {
    @Binding var selectedMonth: Date
    
    var body: some View {
        HStack(alignment: .center) {
            monthButton(direction: .backward)
            Spacer()
            currentMonthAndYear
            Spacer()
            monthButton(direction: .forward)
        }
    }
    
    // 現在の月と年を表示するサブビュー
    private var currentMonthAndYear: some View {
        HStack {
            Text(DateFormatter.monthFormatter.string(from: selectedMonth))
                .foregroundStyle(isSameMonthAsToday ? .cyan : .primary)
                .font(.title2)
            
            Text(DateFormatter.yearFormatter.string(from: selectedMonth))
                .foregroundStyle(isSameYearAsToday ? .cyan : .primary)
                .font(.title)
                .bold()
        }
        .transition(.slide)
    }
    
    // 今日とselectedMonthが同じかどうか
    private var isSameMonthAsToday: Bool {
        Calendar.current.isDate(Date(), equalTo: selectedMonth, toGranularity: .month)
    }
    
    // 今日とselectedMonthが同じかどうか
    private var isSameYearAsToday: Bool {
        Calendar.current.isDate(Date(), equalTo: selectedMonth, toGranularity: .year)
    }
    
    // 前月または次月に移動するボタンのサブビュー
    private func monthButton(direction: MonthDirection) -> some View {
        let value = direction == .forward ? 1 : -1
        let symbol = direction == .forward ? "chevron.right" : "chevron.left"
        
        return Button(action: {
            adjustMonth(by: value)
        }) {
            HStack(alignment: .center) {
                if direction == .backward { Image(systemName: symbol) }
                Text(DateFormatter.monthFormatter.string(from: monthAdjusted(by: value)))
                if direction == .forward { Image(systemName: symbol) }
            }
            .font(.title3)
        }
    }
    
    // selectedMonthを加算または減算する関数
    private func adjustMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: selectedMonth) {
            selectedMonth = newMonth
        }
    }
    
    // 与えられた値で月を調整した後の日付を返す関数
    private func monthAdjusted(by value: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: value, to: selectedMonth) ?? selectedMonth
    }
    
    private enum MonthDirection {
        case forward
        case backward
    }
}


struct DateRowHeader: View {
    var dateOfMonth: [Date]
    var headerHeight: CGFloat
    let currentDate: Date
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(dateOfMonth, id: \.self) { day in
                // Daily
                dateHeaderText(day: day)
                    .overlay(alignment: .bottomLeading){
                        dateHeaderBorder
                    }
            }
        }
    }
    
    func dateHeaderText(day: Date) -> some View {
            VStack{
                Text(DateFormatter.weekdayFormatter.string(from: day))
                    .font(.caption)
                Text(DateFormatter.dayFormatter.string(from: day))
                    .font(.title3)
                    .bold()
            }
        
        .foregroundStyle(Calendar.current.isDate(day, equalTo: currentDate, toGranularity: .day) ? .cyan : .primary)
        .frame(height: headerHeight)
        .containerRelativeFrame(.horizontal, count: 7, span: 2, spacing: 0)
    }
    
    var dateHeaderBorder: some View{
        VStack(alignment: .leading, spacing: 0){
            Rectangle()
                .frame(width: 1)
                .opacity(0.2)
            Rectangle()
                .frame(height: 1)
                .opacity(0.2)
        }
    }
}

struct TimeColumnHeader: View {
    var currentDate: Date
    var hourHeight: CGFloat
    
    var body: some View {
        timeColumn24Label
            .overlay(alignment: .topLeading){
                currentTime
            }
    }
    
    var timeColumn24Label: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0...23, id: \.self) { hour in
                Color.clear
                    .frame(height: hourHeight)
                    .overlay(alignment: .center){
                        Text("\(String(format: "%02d", hour)):00")
                            .font(.caption2)
                            .offset(y: -hourHeight/4)
                            .opacity(0.8)
                    }
            }
        }
    }
    
    var currentTime: some View {
        GeometryReader { proxy in
            HStack(alignment: .center, spacing: 0){
                Text("\(formatTime(from: currentDate))")
                    .font(.caption2)
                    .foregroundStyle(.cyan)
                Spacer()
            }
            .offset(y: hourHeight/4 + (proxy.frame(in: .global).height / 1440 * dateToMinute(date: currentDate)) - 7)
            .frame(width: 100)
        }
    }
}

struct ScheduleTable: View {
    
    var dateOfMonth: [Date]
    @Binding var offset: CGPoint
    
    var headerHeight: CGFloat
    var hourHeight: CGFloat
    let currentDate: Date
    @Binding var selectedMonth: Date
    @State var scrollPosition: Date?
    
    var positionInCurrentMonth: CGFloat? {
        if let datePosition = currentDate.positionInCurrentMonth() {
            datePosition
        } else {
            nil
        }
    }
    var positionInCurrentDay: CGFloat?{
        if let position = currentDate.positionInCurrentDay() {
            position
        } else {
            nil
        }
    }
    
    
    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            LazyHStack(alignment: .top, spacing: 0) {
                ForEach(dateOfMonth, id: \.self) { day in
                    TableView(dateOfMonth: dateOfMonth, day: day, hourHeight: hourHeight)
                }
            }
            .overlay(alignment: .topLeading){
                currentTimeDivider
            }
            .scrollTargetLayout()
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: ViewOffsetKey.self, value: geo.frame(in: .named("scroll")).origin)
                }
            )
            .onPreferenceChange(ViewOffsetKey.self) { value in
                offset = value
            }
        }
        // 起動時のスクロールポジション
        .defaultScrollAnchor(.some(UnitPoint(x: positionInCurrentMonth ?? 0, y: positionInCurrentDay ?? 0)))
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        // 表示月が変わったとき、翌月に移動したら初日にスクロールして、前月に移動異したら末日に移動
        .scrollPosition(id: $scrollPosition)
        .onChange(of: dateOfMonth) { oldValue, newValue in
            if oldValue[10] > newValue[10] {
                scrollPosition = dateOfMonth.last
            }else {
                scrollPosition = dateOfMonth.first
            }
        }
}
    
    var currentTimeDivider: some View{
        GeometryReader { proxy in
            HStack(spacing: 0){
                Text("00:00 ")
                    .font(.caption2)
                    .foregroundStyle(.cyan)
                    .opacity(0.0)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.cyan)
            }
            .offset(y: (proxy.frame(in: .global).height / 1440 * dateToMinute(date: currentDate) - 7))
        }
    }
}

struct TableView: View {
    @State private var isLoading: Bool = false
    let events = createEvents()
    
    var dateOfMonth: [Date]
    var day: Date
    var hourHeight: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0...23, id: \.self) { hour in
                tableCell(hour: hour, day: day)
            }
        }
        .overlay(alignment: .topLeading){
            scheduleBoxes()
        }
    }
    
    func tableCell(hour: Int, day: Date) -> some View{
        Group{
            ZStack(alignment: .topLeading){
                Rectangle()
                    .frame(height: 1)
                Rectangle()
                    .frame(width: 1)
            }
            .opacity(0.2)
        }
        .frame(height: hourHeight)
        .containerRelativeFrame(.horizontal, count: 7, span: 2, spacing: 0)
        .id("\(hour)_\(day)")
    }
    
    func scheduleBoxes() -> some View {
        let matchingSchedules = getMatchingSchedules(for: day, from: events)
        
        return GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                ForEach(matchingSchedules, id: \.title) { event in
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.blue.gradient)
                        .opacity(0.4)
                        .overlay {
                            Text(event.title)
                                .bold()
                        }
                        .frame(height: proxy.frame(in: .global).height / 1440 * caluculateTimeInterval(startDate: event.startDate, endDate: event.endDate))
                        .offset(y: proxy.frame(in: .global).height / 1440 * dateToMinute(date: event.startDate))
                        .onTapGesture {
                            print(event.title)
                        }
                }
            }
        }
    }
    
    /// Filters and returns schedules that occur on a given day.
    /// - Parameters:
    ///   - day: The day for which to find schedules.
    ///   - schedules: The list of all schedules.
    /// - Returns: An array of schedules that occur on the given day.
    private func getMatchingSchedules(for day: Date, from schedules: [Schedule]) -> [Schedule] {
        let calendar = Calendar.current
        let currentDay = calendar.startOfDay(for: day)
        return schedules.filter { schedule in
            scheduleMatchesDay(schedule, on: currentDay, using: calendar)
        }
    }
    
    /// Checks if a schedule occurs on a given day.
    /// - Parameters:
    ///   - schedule: The schedule to check.
    ///   - day: The day to check against.
    ///   - calendar: The calendar to use for date calculations.
    /// - Returns: A Boolean value indicating whether the schedule occurs on the given day.
    private func scheduleMatchesDay(_ schedule: Schedule, on day: Date, using calendar: Calendar) -> Bool {
        let startDay = calendar.startOfDay(for: schedule.startDate)
        let endDay = calendar.startOfDay(for: schedule.endDate)
        return startDay <= day && day <= endDay
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGPoint
    static var defaultValue = CGPoint.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.x += nextValue().x
        value.y += nextValue().y
    }
}
//
//#Preview {
//    CalendarWeeklyView()
//}
//
